Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbXHXM4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbXHXM4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765411AbXHXM4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:56:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:13652 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497AbXHXM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hsN2oO1vjP+jy/ycchnnkl5s/bl/OZDQfPoo9frDAoFoJOcCVTmSCjy9yCSndPdp00Nkx2iEZ/CDQbr5xLvf2ElKlld81GrmxYNUn7bOkpNCZex1NYNePtJj96H4CZD8wfNWIrhIQlLaqI1DhNVCb+aCKAtkKlpYLbTAauwqM3A=
Message-ID: <46CED56E.1030608@gmail.com>
Date: Fri, 24 Aug 2007 21:56:14 +0900
From: Kentaro Takeda <k.takeda26@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: [TOMOYO 12/15] Signal transmission control functions.
References: <46CED214.6050505@gmail.com>
In-Reply-To: <46CED214.6050505@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signal control functions for TOMOYO Linux.
TOMOYO Linux checks sending signal by signal number and
the domain of target process.In order to check signal
permission, LSM expantion patch [TOMOYO /] is needed.

Each permission can be automatically accumulated into
the policy of each domain using 'learning mode'.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/signal.c |  238 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 238 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/security/tomoyo/signal.c	2007-08-24 15:51:38.000000000 +0900
@@ -0,0 +1,238 @@
+/*
+ * security/tomoyo/signal.c
+ *
+ * Signal access contol functions for TOMOYO Linux.
+ */
+
+#include "tomoyo.h"
+#include "realpath.h"
+
+/*************************  AUDIT FUNCTIONS  *************************/
+
+static int tmy_audit_signal_log(const int signal,
+				const struct path_info *dest_domain,
+				const int is_granted,
+				const int is_enforce)
+{
+	char *buf;
+	int len;
+
+	if (is_granted) {
+		if (!tmy_audit_grant())
+			return 0;
+	} else {
+		if (!tmy_audit_reject())
+			return 0;
+	}
+
+	len = dest_domain->total_len;
+	buf = tmy_init_audit_log(&len);
+
+	if (!buf)
+		return -ENOMEM;
+
+	snprintf(buf + strlen(buf),
+		 len - strlen(buf) - 1,
+		 "%s%d %s",
+		 TMY_ALLOW_SIGNAL, signal, dest_domain->name);
+
+	return tmy_write_audit_log(buf, is_granted, is_enforce);
+}
+
+/*************************  SIGNAL ACL HANDLER  *************************/
+
+/*
+ * @is_add:   1  add this entry if not quota exceeded
+ *           -1  always add this entry
+ *            0  remove this entry
+ */
+static int tmy_add_signal_entry(const u16 sig, const char *dest_pattern,
+				struct domain_info *domain,
+				const struct condition_list *cond,
+				const u8 is_add)
+{
+	struct acl_info *ptr;
+	const struct path_info *saved_dest_pattern;
+	int error = -ENOMEM;
+
+	if (!domain)
+		return -EINVAL;
+	if (!dest_pattern ||
+	    !tmy_is_correct_domain(dest_pattern, __FUNCTION__))
+		return -EINVAL;
+
+	saved_dest_pattern = tmy_save_name(dest_pattern);
+	if (!saved_dest_pattern)
+		return -ENOMEM;
+
+	down(&domain_acl_lock);
+
+	if (!is_add)
+		goto remove;
+
+	ptr = domain->first_acl_ptr;
+	if (!ptr)
+		goto first_entry;
+
+	while (1) {
+		struct signal_acl *acl = (struct signal_acl *) ptr;
+
+		if (ptr->type == TMY_TYPE_SIGNAL_ACL && acl->sig == sig
+		    && ptr->cond == cond
+		    && !tmy_pathcmp(acl->domainname, saved_dest_pattern)) {
+			ptr->is_deleted = 0;
+			/* Found. Nothing to do. */
+			error = 0;
+			break;
+		}
+
+		if (ptr->next) {
+			ptr = ptr->next;
+			continue;
+		}
+
+first_entry: ;
+		if (is_add == 1 && tmy_too_many_acl(domain))
+			break;
+		/* Not found. Append it to the tail. */
+		acl = tmy_alloc_element(sizeof(*acl));
+		if (!acl)
+			break;
+
+		acl->head.type = TMY_TYPE_SIGNAL_ACL;
+		acl->head.cond = cond;
+		acl->sig = sig;
+		acl->domainname = saved_dest_pattern;
+		error = tmy_add_acl(ptr, domain, (struct acl_info *) acl);
+		break;
+	}
+
+	goto ok;
+
+remove: ;
+	error = -ENOENT;
+	for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+		struct signal_acl *acl = (struct signal_acl *) ptr;
+		if (ptr->type != TMY_TYPE_SIGNAL_ACL || ptr->cond != cond ||
+		    ptr->is_deleted || acl->sig != sig ||
+		    tmy_pathcmp(acl->domainname, saved_dest_pattern))
+			continue;
+		error = tmy_del_acl(ptr);
+		break;
+	}
+
+ok: ;
+	up(&domain_acl_lock);
+
+	return error;
+}
+
+/**
+ * tmy_signal_acl - check permission for kill(2)/tkill(2)/tgkill(2).
+ * @sig:  signal number.
+ * @pid:  pid of destination process.
+ *
+ * Returns zero if permission granted.
+ * Returns nonzero if permission denied.
+ */
+int tmy_signal_acl(const int sig, const int pid)
+{
+	struct domain_info *domain = TMY_SECURITY->domain;
+	struct domain_info *dest = NULL;
+	const char *dest_pattern;
+	struct acl_info *ptr;
+	const u16 hash = sig;
+	const int is_enforce = tmy_enforce(TMY_MAC_FOR_SIGNAL);
+
+	if (!tmy_flags(TMY_MAC_FOR_SIGNAL))
+		return 0;
+	if (!sig)
+		return 0; /* No check for NULL signal. */
+	if (current->pid == pid) {
+		tmy_audit_signal_log(sig, domain->domainname, 1, is_enforce);
+		return 0; /* No check for self. */
+	}
+
+	{ /* Simplified checking. */
+		struct task_struct *p = NULL;
+		read_lock(&tasklist_lock);
+		if (pid > 0)
+			p = find_task_by_pid((pid_t) pid);
+		else if (pid == 0)
+			p = current;
+		else if (pid == -1)
+			dest = &KERNEL_DOMAIN;
+		else
+			p = find_task_by_pid((pid_t) -pid);
+		if (p)
+			/* "struct task_struct"->security is not NULL. */
+			dest = ((struct tmy_security *) p->security)->domain;
+		read_unlock(&tasklist_lock);
+		if (!dest)
+			return 0; /* I can't find destinatioin. */
+	}
+
+	if (domain == dest) {
+		tmy_audit_signal_log(sig, dest->domainname, 1, is_enforce);
+		return 0;
+	}
+
+	dest_pattern = dest->domainname->name;
+	for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+		struct signal_acl *acl = (struct signal_acl *) ptr;
+
+		if (ptr->type == TMY_TYPE_SIGNAL_ACL && ptr->is_deleted == 0
+		    && acl->sig == hash &&
+		    tmy_check_condition(ptr->cond, NULL) == 0) {
+			const int len = acl->domainname->total_len;
+
+			if (strncmp(acl->domainname->name,
+				    dest_pattern, len) == 0
+			    && (dest_pattern[len] == ' ' ||
+				dest_pattern[len] == '\0'))
+				break;
+
+		}
+	}
+
+	if (ptr) {
+		tmy_audit_signal_log(sig, dest->domainname, 1, is_enforce);
+		return 0;
+	}
+
+	tmy_audit_signal_log(sig, dest->domainname, 0, is_enforce);
+	if (is_enforce)
+		return tmy_supervisor("%s\n" TMY_ALLOW_SIGNAL "%d %s\n",
+				      domain->domainname->name,
+				      sig, dest_pattern);
+	if (tmy_accept(TMY_MAC_FOR_SIGNAL))
+		tmy_add_signal_entry(sig, dest_pattern, domain, NULL, 1);
+
+	return 0;
+}
+
+/**
+ * tmy_add_signal_policy - add or delete signal policy.
+ * @data:      a line to parse.
+ * @domain:    pointer to "struct domain_info".
+ * @cond:      pointer to "struct condition_list". May be NULL.
+ * @is_delete: is this delete request?
+ *
+ * Returns zero on success.
+ * Returns nonzero on failure.
+ */
+int tmy_add_signal_policy(char *data,
+			  struct domain_info *domain,
+			  const struct condition_list *cond,
+			  const int is_delete)
+{
+	int sig;
+	char *domainname = strchr(data, ' ');
+
+	if (sscanf(data, "%d", &sig) == 1 && domainname &&
+	    tmy_is_domain_def(domainname + 1))
+		return tmy_add_signal_entry(sig, domainname + 1, domain,
+					    cond, is_delete ? 0 : -1);
+
+	return -EINVAL;
+}

