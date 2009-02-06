Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZBFMoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZBFMoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 07:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZBFMn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 07:43:57 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50017 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZBFMn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 07:43:56 -0500
Subject: integrity: audit
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Steve Grubb <sgrubb@redhat.com>, Linux Audit <linux-audit@redhat.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 07:43:50 -0500
Message-Id: <1233924230.3135.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

integrity: audit

This patch adds support to auditd for integrity messages, which are 
issued as a result of the integrity patchset that was applied to the 
security-testing-2.6/#next tree.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Index: audit-1.7.11/src/ausearch-parse.c
===================================================================
--- audit-1.7.11.orig/src/ausearch-parse.c
+++ audit-1.7.11/src/ausearch-parse.c
@@ -49,6 +49,7 @@ static int parse_login(const lnode *n, s
 static int parse_daemon(const lnode *n, search_items *s);
 static int parse_sockaddr(const lnode *n, search_items *s);
 static int parse_avc(const lnode *n, search_items *s);
+static int parse_integrity(const lnode *n, search_items *s);
 static int parse_kernel_anom(const lnode *n, search_items *s);
 static int parse_simple_message(const lnode *n, search_items *s);
 static int parse_tty(const lnode *n, search_items *s);
@@ -123,6 +124,9 @@ int extract_search_items(llist *l)
 			case AUDIT_MAC_POLICY_LOAD...AUDIT_MAC_UNLBL_STCDEL:
 				ret = parse_simple_message(n, s);
 				break;
+			case AUDIT_INTEGRITY_DATA...AUDIT_INTEGRITY_PCR:
+				ret = parse_integrity(n, s);
+				break;
 			case AUDIT_KERNEL:
 			case AUDIT_IPC:
 			case AUDIT_SELINUX_ERR:
@@ -1150,6 +1154,105 @@ static int parse_sockaddr(const lnode *n
 	return 0;
 }
 
+
+static int parse_integrity(const lnode *n, search_items *s)
+{
+	char *ptr, *str, *term;
+	int rc=0;
+
+	term = n->message;
+	// get integrity:
+	str = strstr(term, "integrity: ");
+	if (str) {
+		ptr = str + 11;
+	}
+
+	// get pid
+	str = strstr(term, "pid=");
+	if (str) {
+		ptr = str + 4;
+		term = strchr(ptr, ' ');
+		if (term == NULL)
+			return 2;
+		*term = 0;
+		errno = 0;
+		s->pid = strtoul(ptr, NULL, 10);
+		if (errno)
+			return 3;
+		*term = ' ';
+	}
+
+	// get uid
+	str = strstr(term, " uid=");
+	if (str) {
+		ptr = str + 4;
+		term = strchr(ptr, ' ');
+		if (term == NULL)
+			return 4;
+		*term = 0;
+		errno = 0;
+		s->uid = strtoul(ptr, NULL, 10);
+		if (errno)
+			return 5;
+		*term = ' ';
+	}
+
+	// get loginuid
+	str = strstr(n->message, "auid=");
+	if (str) {
+		ptr = str + 5;
+		term = strchr(ptr, ' ');
+		if (term == NULL)
+			return 6;
+		*term = 0;
+		errno = 0;
+		s->loginuid = strtoul(ptr, NULL, 10);
+		if (errno)
+			return 7;
+		*term = ' ';
+	}
+
+	str = strstr(term, "comm=");
+	if (str) {
+		str += 5;
+		if (*str == '"') {
+			str++;
+			term = strchr(str, '"');
+			if (term == NULL)
+				return 8;
+			*term = 0;
+			s->comm = strdup(str);
+			*term = '"';
+		} else
+			s->comm = unescape(str);
+	}
+
+	str = strstr(term, " name=");
+	if (str) {
+		str += 6;
+		if (common_path_parser(s, str))
+			return 9;
+	}
+
+	// and results (usually last)
+	str = strstr(term, "res=");
+	if (str != NULL) {
+		ptr = str + 4;
+		term = strchr(ptr, ' ');
+		if (term)
+			*term = 0;
+		errno = 0;
+		s->success = strtoul(ptr, NULL, 10);
+		if (errno)
+			return 10;
+		if (term)
+			*term = ' ';
+	}
+
+	return 0;
+}
+
+
 /* FIXME: If they are in permissive mode or hit an auditallow, there can 
  * be more that 1 avc in the same syscall. For now, we pickup just the first.
  */
Index: audit-1.7.11/lib/libaudit.h
===================================================================
--- audit-1.7.11.orig/lib/libaudit.h
+++ audit-1.7.11/lib/libaudit.h
@@ -174,6 +174,11 @@ extern "C" {
 #ifndef AUDIT_ANOM_ABEND
 #define AUDIT_ANOM_ABEND		1701 /* Process ended abnormally */
 #endif
+#define AUDIT_INTEGRITY_DATA	    1800 /* Data integrity verification */
+#define AUDIT_INTEGRITY_METADATA    1801 /* Metadata integrity verification */
+#define AUDIT_INTEGRITY_STATUS	    1802 /* Integrity enable status */
+#define AUDIT_INTEGRITY_HASH	    1803 /* Integrity HASH type */
+#define AUDIT_INTEGRITY_PCR	    1804 /* PCR invalidation msgs */
 #define AUDIT_FIRST_ANOM_MSG		2100
 #define AUDIT_LAST_ANOM_MSG		2199
 #define AUDIT_ANOM_LOGIN_FAILURES	2100 // Failed login limit reached
Index: audit-1.7.11/lib/msg_typetab.h
===================================================================
--- audit-1.7.11.orig/lib/msg_typetab.h
+++ audit-1.7.11/lib/msg_typetab.h
@@ -122,6 +122,12 @@ _S(AUDIT_MAC_UNLBL_STCADD,           "MA
 _S(AUDIT_MAC_UNLBL_STCDEL,           "MAC_UNLBL_STCDEL"              )
 _S(AUDIT_ANOM_PROMISCUOUS,           "ANOM_PROMISCUOUS"              )
 _S(AUDIT_ANOM_ABEND,                 "ANOM_ABEND"                    )
+_S(AUDIT_INTEGRITY_DATA,             "INTEGRITY_DATA"                )
+_S(AUDIT_INTEGRITY_METADATA,         "INTEGRITY_METADATA"            )
+_S(AUDIT_INTEGRITY_STATUS,           "INTEGRITY_STATUS"              )
+_S(AUDIT_INTEGRITY_HASH,             "INTEGRITY_HASH"                )
+_S(AUDIT_INTEGRITY_PCR,              "INTEGRITY_PCR"                 )
+
 #ifdef WITH_APPARMOR
 _S(AUDIT_AA,                         "APPARMOR"                      )
 _S(AUDIT_APPARMOR_AUDIT,             "APPARMOR_AUDIT"                )
Index: audit-1.7.11/system-config-audit/src/lists.py
===================================================================
--- audit-1.7.11.orig/system-config-audit/src/lists.py
+++ audit-1.7.11/system-config-audit/src/lists.py
@@ -160,6 +160,11 @@ audit.AUDIT_LAST_KERN_ANOM_MSG,
 audit.AUDIT_ANOM_PROMISCUOUS,
 audit.AUDIT_ANOM_ABEND,
 audit.AUDIT_KERNEL,
+audit.AUDIT_INTEGRITY_DATA,
+audit.AUDIT_INTEGRITY_METADATA,
+audit.AUDIT_INTEGRITY_STATUS,
+audit.AUDIT_INTEGRITY_HASH,
+audit.AUDIT_INTEGRITY_PCR,
 )
 
 # From code in src/auditctl.c
Index: audit-1.7.11/lib/netlink.c
===================================================================
--- audit-1.7.11.orig/lib/netlink.c
+++ audit-1.7.11/lib/netlink.c
@@ -182,7 +182,8 @@ static int adjust_reply(struct audit_rep
 		case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
 		case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
 		case AUDIT_FIRST_EVENT...AUDIT_LAST_KERN_ANOM_MSG:
-			rep->message = NLMSG_DATA(rep->nlh); 
+		case AUDIT_INTEGRITY_DATA...AUDIT_INTEGRITY_PCR:
+			rep->message = NLMSG_DATA(rep->nlh);
 			break;
 		case AUDIT_SIGNAL_INFO:
 			rep->signal_info = NLMSG_DATA(rep->nlh);


