Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbYH0OD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbYH0OD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYH0NwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:52:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbYH0NwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:52:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 58/59] CRED: Wrap task credential accesses in the capabilities
	code
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, "Andrew G. Morgan" <morgan@kernel.org>
Date: Wed, 27 Aug 2008 14:50:41 +0100
Message-ID: <20080827135041.19980.81278.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Andrew G. Morgan <morgan@kernel.org>
---

 security/commoncap.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)


diff --git a/security/commoncap.c b/security/commoncap.c
index e4c4b3f..583cfc3 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -345,7 +345,7 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 		 * If only the real uid is 0, we do not set the effective
 		 * bit.
 		 */
-		if (bprm->e_uid == 0 || current->uid == 0) {
+		if (bprm->e_uid == 0 || current_uid() == 0) {
 			/* pP' = (cap_bset & ~0) | (pI & ~0) */
 			bprm->cap_post_exec_permitted = cap_combine(
 				current->cap_bset, current->cap_inheritable
@@ -360,7 +360,12 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
-	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
+	uid_t uid;
+	gid_t gid;
+
+	current_uid_gid(&uid, &gid);
+
+	if (bprm->e_uid != uid || bprm->e_gid != gid ||
 	    !cap_issubset(bprm->cap_post_exec_permitted,
 			  current->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
@@ -368,8 +373,8 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
-				bprm->e_uid = current->uid;
-				bprm->e_gid = current->gid;
+				bprm->e_uid = uid;
+				bprm->e_gid = gid;
 			}
 			if (cap_limit_ptraced_target()) {
 				bprm->cap_post_exec_permitted = cap_intersect(
@@ -400,15 +405,15 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	if (current->uid != 0) {
+	if (current_uid() != 0) {
 		if (bprm->cap_effective)
 			return 1;
 		if (!cap_isclear(bprm->cap_post_exec_permitted))
 			return 1;
 	}
 
-	return (current->euid != current->uid ||
-		current->egid != current->gid);
+	return (current_euid() != current_uid() ||
+		current_egid() != current_gid());
 }
 
 int cap_inode_setxattr(struct dentry *dentry, const char *name,
@@ -471,16 +476,18 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
 static inline void cap_emulate_setxuid (int old_ruid, int old_euid,
 					int old_suid)
 {
+	uid_t euid = current_euid();
+
 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
-	    (current->uid != 0 && current->euid != 0 && current->suid != 0) &&
+	    (current_uid()  != 0 && euid != 0 && current_suid() != 0) &&
 	    !issecure(SECURE_KEEP_CAPS)) {
 		cap_clear (current->cap_permitted);
 		cap_clear (current->cap_effective);
 	}
-	if (old_euid == 0 && current->euid != 0) {
+	if (old_euid == 0 && euid != 0) {
 		cap_clear (current->cap_effective);
 	}
-	if (old_euid != 0 && current->euid == 0) {
+	if (old_euid != 0 && euid == 0) {
 		current->cap_effective = current->cap_permitted;
 	}
 }
@@ -509,12 +516,12 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			 */
 
 			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-				if (old_fsuid == 0 && current->fsuid != 0) {
+				if (old_fsuid == 0 && current_fsuid() != 0) {
 					current->cap_effective =
 						cap_drop_fs_set(
 						    current->cap_effective);
 				}
-				if (old_fsuid != 0 && current->fsuid == 0) {
+				if (old_fsuid != 0 && current_fsuid() == 0) {
 					current->cap_effective =
 						cap_raise_fs_set(
 						    current->cap_effective,

