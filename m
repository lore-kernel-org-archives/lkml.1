Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYKYVmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYKYVmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYKYVgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:52278 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYKYVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=FoW1N7xD3+oWHCPi91hh09GDX6kIdIqHWeMKxxZq6v3bWdUTI/UiFZOdfP0tMBuUeU
         bSCbgVkFY652I04oh/ADl4Mhrk4YMjEBstHR418cjSvxSqasM2roIDph/33Zn/tdUyhe
         pWnu+mASOmTU73vsBk2EDiKaHemmFhQcHxjmg=
To: linux-kernel@vger.kernel.org
Subject: [patch 15/24] perfmon: context creation
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:28 -0800 (PST)
Message-ID: <492c6fdc.0c58560a.6a14.0cb8@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds perfmon context management functions to create
and destroy a perfmon context which encapsulates the entire PMU
state.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/perfmon/perfmon_ctx.c
===================================================================
--- o3.orig/perfmon/perfmon_ctx.c	2008-11-25 18:56:15.000000000 +0100
+++ o3/perfmon/perfmon_ctx.c	2008-11-25 19:00:38.000000000 +0100
@@ -38,6 +38,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/fdtable.h>
 #include <linux/perfmon_kern.h>
 #include "perfmon_priv.h"
 
@@ -162,3 +163,238 @@
 	}
 	return 0;
 }
+
+/**
+ * pfm_ctx_permissions - check authorization to create new context
+ * @ctx_flags: context flags passed by user
+ *
+ * check for permissions to create a context.
+ *
+ * A sysadmin may decide to restrict creation of per-thread
+ * context to a group of users using the group id via
+ * /sys/kernel/perfmon/task_group
+ *
+ * Once we identify a user level package which can be used
+ * to grant/revoke Linux capabilites at login via PAM, we will
+ * be able to use capabilities. We would also need to increase
+ * the size of cap_t to support more than 32 capabilities (it
+ * is currently defined as u32 and 32 capabilities are alrady
+ * defined).
+ */
+static inline int pfm_ctx_permissions(u32 ctx_flags)
+{
+	if (pfm_controls.task_group != PFM_GROUP_PERM_ANY
+		   && !in_group_p(pfm_controls.task_group)) {
+		PFM_DBG("user group not allowed to create a task context");
+		return -EPERM;
+	}
+	return 0;
+}
+
+/**
+ * pfm_create_initial_set - create initial set from __pfm_c reate_context
+ * @ctx: context to atatched the set to
+ */
+static void pfm_create_initial_set(struct pfm_context *ctx)
+{
+	struct pfm_event_set *set;
+	u64 *impl_pmcs;
+	u16 i, max_pmc;
+
+	set = ctx->active_set;
+	max_pmc = ctx->regs.max_pmc;
+	impl_pmcs =  ctx->regs.pmcs;
+
+	/*
+	 * install default values for all PMC  registers
+	 */
+	for (i = 0; i < max_pmc; i++) {
+		if (pfm_arch_bv_test_bit(i, impl_pmcs)) {
+			set->pmcs[i] = pfm_pmu_conf->pmc_desc[i].dfl_val;
+			PFM_DBG("pmc%u=0x%llx",
+				i,
+				(unsigned long long)set->pmcs[i]);
+		}
+	}
+	/*
+	 * PMD registers are set to 0 when the event set is allocated,
+	 * hence we do not need to explicitly initialize them.
+	 *
+	 * For virtual PMD registers (i.e., those tied to a SW resource)
+	 * their value becomes meaningful once the context is attached.
+	 */
+}
+
+/**
+ * __pfm_create_context - allocate and initialize a perfmon context
+ * @ctx_flags : user context flags
+ * @sif: pointer to pfarg_sinfo to be updated
+ * @new_ctx: will contain new context address on return
+ *
+ * function used to allocate a new context. A context is allocated along
+ * with the default event set. If a sampling format is used, the buffer
+ * may be allocated and initialized.
+ *
+ * The file descriptor identifying the context is allocated and returned
+ * to caller.
+ *
+ * This function operates with no locks and interrupts are enabled.
+ * return:
+ * 	>=0: the file descriptor to identify the context
+ * 	<0 : the error code
+ */
+int __pfm_create_context(__u32 ctx_flags,
+			 struct pfarg_sinfo *sif,
+			 struct pfm_context **new_ctx)
+{
+	struct pfm_context *ctx;
+	struct file *filp = NULL;
+	int fd = 0, ret = -EINVAL;
+
+	if (!pfm_pmu_conf)
+		return -ENOSYS;
+
+	/* no context flags supported yet */
+	if (ctx_flags)
+		goto error_alloc;
+
+	ret = pfm_ctx_permissions(ctx_flags);
+	if (ret < 0)
+		goto error_alloc;
+
+	/*
+	 * we can use GFP_KERNEL and potentially sleep because we do
+	 * not hold any lock at this point.
+	 */
+	might_sleep();
+	ret = -ENOMEM;
+	ctx = kmem_cache_zalloc(pfm_ctx_cachep, GFP_KERNEL);
+	if (!ctx)
+		goto error_alloc;
+
+	PFM_DBG("alloc ctx @0x%p", ctx);
+
+	ctx->active_set = &ctx->_set0;
+
+	spin_lock_init(&ctx->lock);
+
+	/*
+	 * context is unloaded
+	 */
+	ctx->state = PFM_CTX_UNLOADED;
+
+
+	ret = pfm_pmu_acquire(ctx);
+	if (ret)
+		goto error_file;
+	/*
+	 * check if PMU is usable
+	 */
+	if (!(ctx->regs.num_pmcs && ctx->regs.num_pmcs)) {
+		PFM_DBG("no usable PMU registers");
+		ret = -EBUSY;
+		goto error_file;
+	}
+
+	ret = -ENFILE;
+	fd = pfm_alloc_fd(&filp);
+	if (fd < 0)
+		goto error_file;
+
+	/*
+	 * initialize arch-specific section
+	 * must be done before fmt_init()
+	 */
+	ret = pfm_arch_context_create(ctx, ctx_flags);
+	if (ret)
+		goto error_set;
+
+	ret = -ENOMEM;
+
+	/*
+	 * add initial set
+	 */
+	pfm_create_initial_set(ctx);
+
+	filp->private_data = ctx;
+
+	ctx->last_act = PFM_INVALID_ACTIVATION;
+	ctx->last_cpu = -1;
+
+	PFM_DBG("flags=0x%x fd=%d", ctx_flags, fd);
+
+	if (new_ctx)
+		*new_ctx = ctx;
+
+	/*
+	 * copy bitmask of available PMU registers
+	 *
+	 * must copy over the entire vector to avoid
+	 * returning bogus upper bits pass by user
+	 */
+	pfm_arch_bv_copy(sif->sif_avail_pmcs,
+			 ctx->regs.pmcs,
+			 PFM_MAX_PMCS);
+
+	pfm_arch_bv_copy(sif->sif_avail_pmds,
+			 ctx->regs.pmds,
+			 PFM_MAX_PMDS);
+
+	/*
+	 * we defer the fd_install until we are certain the call succeeded
+	 * to ensure we do not have to undo its effect. Neither put_filp()
+	 * nor put_unused_fd() undoes the effect of fd_install().
+	 */
+	fd_install(fd, filp);
+
+	return fd;
+
+error_set:
+	put_filp(filp);
+	put_unused_fd(fd);
+error_file:
+	/*
+	 * calls the right *_put() functions
+	 * calls pfm_release_pmu()
+	 */
+	pfm_free_context(ctx);
+	return ret;
+error_alloc:
+	return ret;
+}
+
+/**
+ * pfm_undo_create -- undo context creation
+ * @fd: file descriptor to close
+ * @ctx: newly created context
+ *
+ * upon return neither fd nor ctx are useable
+ */
+void pfm_undo_create(int fd, struct pfm_context *ctx)
+{
+       struct files_struct *files = current->files;
+       struct file *file;
+       int fput_needed;
+
+       file = fget_light(fd, &fput_needed);
+       /*
+	* there is no fd_uninstall(), so we do it
+	* here. put_unused_fd() does not remove the
+	* effect of fd_install().
+	*/
+
+       spin_lock(&files->file_lock);
+       files->fd_array[fd] = NULL;
+       spin_unlock(&files->file_lock);
+
+       fput_light(file, fput_needed);
+
+       /*
+	* decrement ref count and kill file
+	*/
+       put_filp(file);
+
+       put_unused_fd(fd);
+
+       pfm_free_context(ctx);
+}
Index: o3/perfmon/perfmon_priv.h
===================================================================
--- o3.orig/perfmon/perfmon_priv.h	2008-11-25 19:00:11.000000000 +0100
+++ o3/perfmon/perfmon_priv.h	2008-11-25 19:00:18.000000000 +0100
@@ -55,7 +55,10 @@
 
 int  pfm_init_sysfs(void);
 
+int __pfm_create_context(__u32 ctx_flags, struct pfarg_sinfo *sif,
+			 struct pfm_context **new_ctx);
 void pfm_free_context(struct pfm_context *ctx);
+void pfm_undo_create(int fd, struct pfm_context *ctx);
 
 int __pfm_stop(struct pfm_context *ctx);
 int __pfm_start(struct pfm_context *ctx);
@@ -63,6 +66,8 @@
 int __pfm_load_context(struct pfm_context *ctx, struct task_struct *task);
 int __pfm_unload_context(struct pfm_context *ctx);
 
+int pfm_alloc_fd(struct file **cfile);
+
 ssize_t pfm_sysfs_res_show(char *buf, size_t sz, int what);
 
 int pfm_pmu_acquire(struct pfm_context *ctx);
Index: o3/perfmon/perfmon_file.c
===================================================================
--- o3.orig/perfmon/perfmon_file.c	2008-11-25 18:56:15.000000000 +0100
+++ o3/perfmon/perfmon_file.c	2008-11-25 19:00:18.000000000 +0100
@@ -37,6 +37,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/poll.h>
 #include <linux/file.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
@@ -92,3 +93,214 @@
 	}
 	return err;
 }
+
+/*
+ * called either on explicit close() or from exit_files().
+ * Only the LAST user of the file gets to this point, i.e., it is
+ * called only ONCE.
+ *
+ * IMPORTANT: we get called ONLY when the refcnt on the file gets to zero
+ * (fput()),i.e, last task to access the file. Nobody else can access the
+ * file at this point.
+ *
+ * When called from exit_files(), the VMA has been freed because exit_mm()
+ * is executed before exit_files().
+ *
+ * When called from exit_files(), the current task is not yet ZOMBIE but we
+ * flush the PMU state to the context.
+ */
+static int __pfm_close(struct pfm_context *ctx, struct file *filp)
+{
+	unsigned long flags;
+	int state;
+	int can_free = 1, can_unload = 1;
+	int can_release = 0;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	state = ctx->state;
+
+	PFM_DBG("state=%d", state);
+
+	/*
+	 * check if unload is needed
+	 */
+	if (state == PFM_CTX_UNLOADED)
+		goto doit;
+
+#ifdef CONFIG_SMP
+	if (ctx->task != current) {
+		/*
+		 * switch context to zombie state
+		 */
+		ctx->state = PFM_CTX_ZOMBIE;
+
+		PFM_DBG("zombie ctx for [%d]", ctx->task->pid);
+		/*
+		 * PMU session will be released by monitored task when
+		 * it notices ZOMBIE state as part of pfm_unload_context()
+		 */
+		can_unload = can_free = 0;
+	}
+#endif
+	if (can_unload)
+		can_release  = !__pfm_unload_context(ctx);
+doit:
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	if (can_release)
+		pfm_session_release();
+
+	if (can_free)
+		pfm_free_context(ctx);
+
+	return 0;
+}
+
+/*
+ * called either on explicit close() or from exit_files().
+ * Only the LAST user of the file gets to this point, i.e., it is
+ * called only ONCE.
+ *
+ * IMPORTANT: we get called ONLY when the refcnt on the file gets to zero
+ * (fput()),i.e, last task to access the file. Nobody else can access the
+ * file at this point.
+ *
+ * When called from exit_files(), the VMA has been freed because exit_mm()
+ * is executed before exit_files().
+ *
+ * When called from exit_files(), the current task is not yet ZOMBIE but we
+ * flush the PMU state to the context.
+ */
+static int pfm_close(struct inode *inode, struct file *filp)
+{
+	struct pfm_context *ctx;
+
+	PFM_DBG("called filp=%p", filp);
+
+	ctx = filp->private_data;
+	if (ctx == NULL) {
+		PFM_ERR("no ctx");
+		return -EBADF;
+	}
+	return __pfm_close(ctx, filp);
+}
+
+static int pfm_no_open(struct inode *irrelevant, struct file *dontcare)
+{
+	PFM_DBG("pfm_file_ops");
+
+	return -ENXIO;
+}
+
+static unsigned int pfm_no_poll(struct file *filp, poll_table *wait)
+{
+	return 0;
+}
+
+static ssize_t pfm_read(struct file *filp, char __user *buf, size_t size,
+			loff_t *ppos)
+{
+	PFM_DBG("pfm_read called");
+	return -EINVAL;
+}
+
+static ssize_t pfm_write(struct file *file, const char __user *ubuf,
+			  size_t size, loff_t *ppos)
+{
+	PFM_DBG("pfm_write called");
+	return -EINVAL;
+}
+
+static int pfm_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		     unsigned long arg)
+{
+	PFM_DBG("pfm_ioctl called");
+	return -EINVAL;
+}
+
+const struct file_operations pfm_file_ops = {
+	.llseek = no_llseek,
+	.read = pfm_read,
+	.write = pfm_write,
+	.ioctl = pfm_ioctl,
+	.open = pfm_no_open, /* special open to disallow open via /proc */
+	.release = pfm_close,
+	.poll = pfm_no_poll,
+};
+
+static int pfmfs_delete_dentry(struct dentry *dentry)
+{
+	return 1;
+}
+
+static struct dentry_operations pfmfs_dentry_operations = {
+	.d_delete = pfmfs_delete_dentry,
+};
+
+int pfm_alloc_fd(struct file **cfile)
+{
+	int fd, ret = 0;
+	struct file *file = NULL;
+	struct inode * inode;
+	char name[32];
+	struct qstr this;
+
+	fd = get_unused_fd();
+	if (fd < 0)
+		return -ENFILE;
+
+	ret = -ENFILE;
+
+	file = get_empty_filp();
+	if (!file)
+		goto out;
+
+	/*
+	 * allocate a new inode
+	 */
+	inode = new_inode(pfmfs_mnt->mnt_sb);
+	if (!inode)
+		goto out;
+
+	PFM_DBG("new inode ino=%ld @%p", inode->i_ino, inode);
+
+	inode->i_sb = pfmfs_mnt->mnt_sb;
+	inode->i_mode = S_IFCHR|S_IRUGO;
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+
+	sprintf(name, "[%lu]", inode->i_ino);
+	this.name = name;
+	this.hash = inode->i_ino;
+	this.len = strlen(name);
+
+	ret = -ENOMEM;
+
+	/*
+	 * allocate a new dcache entry
+	 */
+	file->f_dentry = d_alloc(pfmfs_mnt->mnt_sb->s_root, &this);
+	if (!file->f_dentry)
+		goto out;
+
+	file->f_dentry->d_op = &pfmfs_dentry_operations;
+
+	d_add(file->f_dentry, inode);
+	file->f_vfsmnt = mntget(pfmfs_mnt);
+	file->f_mapping = inode->i_mapping;
+
+	file->f_op = &pfm_file_ops;
+	file->f_mode = FMODE_READ;
+	file->f_flags = O_RDONLY;
+	file->f_pos  = 0;
+
+	*cfile = file;
+
+	return fd;
+out:
+	if (file)
+		put_filp(file);
+	put_unused_fd(fd);
+	return ret;
+}
Index: o3/include/linux/perfmon.h
===================================================================
--- o3.orig/include/linux/perfmon.h	2008-11-25 18:58:39.000000000 +0100
+++ o3/include/linux/perfmon.h	2008-11-25 19:00:18.000000000 +0100
@@ -46,6 +46,16 @@
 #define PFM_PMC_BV	PFM_BVSIZE(PFM_MAX_PMCS)
 
 /*
+ * argument to pfm_create
+ * populated on return
+ */
+struct pfarg_sinfo {
+	__u64 sif_avail_pmcs[PFM_PMC_BV];/* out: available PMCs */
+	__u64 sif_avail_pmds[PFM_PMD_BV];/* out: available PMDs */
+	__u64 sif_reserved1[4];		 /* for future use */
+};
+
+/*
  * PMC and PMD generic register description
  */
 struct pfarg_pmr {

-- 

