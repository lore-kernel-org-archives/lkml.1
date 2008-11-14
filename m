Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYKNWl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYKNWl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYKNWlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:41:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42214 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbYKNWlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:41:21 -0500
Subject: [PATCH -v2] capabilities: define get_vfs_caps_from_disk when file
 caps are not enabled
From: Eric Paris <eparis@redhat.com>
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com, morgan@kernel.org
Content-Type: text/plain
Date: Fri, 14 Nov 2008 17:40:34 -0500
Message-Id: <1226702434.3353.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_SECURITY_FILE_CAPABILITIES is not set the audit system may
try to call into the capabilities function vfs_cap_from_file.  This
patch defines that function so kernels can build and work.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

james morris didn't like the fact I was clearing the cpu_caps struct.
So this patch makes the error handling better so I don't need to.
(actually I didn't need to fix the error handling since this audit
function is only called when fcaps are enabled and we already got the
xattr data once, but still, this is the right fix)

 kernel/auditsc.c     |   11 +++++++----
 security/commoncap.c |    5 +++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index cef3423..90b0544 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2556,6 +2556,13 @@ void __audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_
 	struct audit_context *context = current->audit_context;
 	struct cpu_vfs_cap_data vcaps;
 	struct dentry *dentry;
+	int ret;
+
+	dentry = dget(bprm->file->f_dentry);
+	ret = get_vfs_caps_from_disk(dentry, &vcaps);
+	dput(dentry);
+	if (ret)
+		return;
 
 	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
 	if (!ax)
@@ -2565,10 +2572,6 @@ void __audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_
 	ax->d.next = context->aux;
 	context->aux = (void *)ax;
 
-	dentry = dget(bprm->file->f_dentry);
-	get_vfs_caps_from_disk(dentry, &vcaps);
-	dput(dentry);
-
 	ax->fcap.permitted = vcaps.permitted;
 	ax->fcap.inheritable = vcaps.inheritable;
 	ax->fcap.fE = !!(vcaps.magic_etc & VFS_CAP_FLAGS_EFFECTIVE);
diff --git a/security/commoncap.c b/security/commoncap.c
index 0b88160..22b9270 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -337,6 +337,11 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return 0;
 }
 
+int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
+{
+	return -ENODATA;
+}
+
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
 	bprm_clear_caps(bprm);


