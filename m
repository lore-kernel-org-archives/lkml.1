Return-Path: <linux-kernel-owner+w=401wt.eu-S1761259AbXF0RP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbXF0RP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXF0RPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:15:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35291 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbXF0RPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:15:14 -0400
Date: Wed, 27 Jun 2007 12:15:06 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] file capabilities: introduce cap_setfcap
Message-ID: <20070627171506.GA16764@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the first patch (of several or many to come) to address some of
Andrew's comments.

Kaigai, IIUC cap_names.h will eventually be automatically updated?  (I
had to manually tweak it for testing as the new kernel sources were not
located on the test system)

thanks,
-serge

>From fefcd341e478bd9e490d34abe9efd3c3c4f0b8a0 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 27 Jun 2007 13:09:20 -0400
Subject: [PATCH 1/1] file capabilities: introduce cap_setfcap

Setting file capabilities previously required the
cap_sys_admin capability, since they are stored as
extended attributes in the security.* namespace.

Introduce CAP_SETFCAP (to mirror CAP_SETPCAP), and
require it for setting file capabilities instead of
CAP_SYS_ADMIN.

Quoting Andrew Morgan,

"CAP_SYS_ADMIN is way too overloaded and this
functionality is special."

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |    4 +++-
 security/commoncap.c       |   12 ++++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 89125df..cdfaa10 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -324,7 +324,9 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_AUDIT_CONTROL    30
 
-#define CAP_NUMCAPS	     31
+#define CAP_SETFCAP	     31
+
+#define CAP_NUMCAPS	     32
 
 #ifdef __KERNEL__
 /* 
diff --git a/security/commoncap.c b/security/commoncap.c
index 4e9ff02..24de4fa 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -290,7 +290,11 @@ int cap_bprm_secureexec (struct linux_binprm *bprm)
 int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
 		       size_t size, int flags)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -299,7 +303,11 @@ int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
 
 int cap_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
-- 
1.5.1.1.GIT

