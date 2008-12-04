Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYLDMAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYLDMAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYLDMAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:00:23 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54066 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYLDMAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:00:21 -0500
To: sds@tycho.nsa.gov, serue@us.ibm.com, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       takedakn@nttdata.co.jp, haradats@nttdata.co.jp
Subject: Re: [PATCH (mmotm-2008-12-02-17-08)] Introduce security_path_set/clear() hooks.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200812021939.FFC05200.OVQJSOMtFFHLFO@I-love.SAKURA.ne.jp>
	<1228225719.26101.52.camel@moss-spartans.epoch.ncsc.mil>
	<49364808.1070907@nttdata.co.jp>
	<493649C5.2060402@nttdata.co.jp>
	<1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil>
Message-Id: <200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 4 Dec 2008 21:00:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Stephen Smalley wrote:
> On Wed, 2008-12-03 at 17:56 +0900, Kentaro Takeda wrote:
> > Stephen, Serge,
> > Here is the patch for introducing new security_path_set()/clear() hooks.
> > 
> > This patch enables LSM module to remember vfsmount's pathname so that it can 
> > calculate absolute pathname in security_inode_*(). Since actual MAC can be 
> > performed after DAC, there will not be any noise in auditing and learning 
> > features. This patch currently assumes that the vfsmount's pathname is stored in 
> > hash table in LSM module. (Should I use stack memory?)
> > 
> > Since security_inode_*() are not always called after security_path_set(), 
> > security_path_clear() hook is needed to free the remembered pathname.
> 
> Your security_path_set()/security_path_clear() pairs look rather similar
> to mnt_want_write()/mnt_drop_write() pairs.  What if you were to call
> your hooks from those functions, and then you would only need to add
> further hook calls in the case of read-only and execute/search checks?

Right. Locations of inserting security_path_set()/security_path_clear() pairs
are subset of mnt_want_write()/mnt_drop_write() pairs. Thus, we can insert
security_path_set()/security_path_clear() pairs into
mnt_want_write()/mnt_drop_write() pairs, if we can tolerate performance
regression. According to our rough measurement, there is about 8 - 22% of
performance regression. But this approach needs minimum modification to the
existing kernel (only two hooks to be inserted).

The attached patch embeds security_path_set()/security_path_clear() into
mnt_want_write()/mnt_drop_write() and adds an example LSM module which
calculates vfsmount's pathname.
If LSM and FS people can accept this approach, we want to use it.

(----- When below patch is enabled -----)
# time dd status=noxfer if=/dev/zero of=/tmp/file bs=1 count=10485760
10485760+0 records in
10485760+0 records out

real    0m32.139s
user    0m2.303s
sys     0m29.756s
# time dd status=noxfer if=/dev/zero of=/tmp/file bs=512 count=20480
20480+0 records in
20480+0 records out

real    0m0.087s
user    0m0.002s
sys     0m0.085s
# time dd status=noxfer if=/dev/zero of=/tmp/file bs=4096 count=2560
2560+0 records in
2560+0 records out

real    0m0.028s
user    0m0.001s
sys     0m0.027s

(----- When below patch is disbled -----)
# time dd status=noxfer if=/dev/zero of=/tmp/file bs=1 count=10485760
10485760+0 records in
10485760+0 records out

real    0m26.776s
user    0m2.281s
sys     0m24.373s
# time dd status=noxfer if=/dev/zero of=/tmp/file bs=512 count=20480
20480+0 records in
20480+0 records out

real    0m0.077s
user    0m0.002s
sys     0m0.073s
# time dd status=noxfer if=/dev/zero of=/tmp/file bs=4096 count=2560
2560+0 records in
2560+0 records out

real    0m0.025s
user    0m0.001s
sys     0m0.024s


Regards.

--------------------
Subject: Embed security_path_set()/security_path_clear() into mnt_want_write()/mnt_drop_write().

This is a LSM version of http://lkml.org/lkml/2008/8/19/16 . 

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---

 fs/namespace.c           |   11 +++++
 include/linux/security.h |   24 +++++++++++
 security/Kconfig         |   10 ++++
 security/Makefile        |    1 
 security/capability.c    |   17 +++++++
 security/mnt_path.c      |  100 +++++++++++++++++++++++++++++++++++++++++++++++
 security/security.c      |   14 ++++++
 7 files changed, 177 insertions(+)

--- linux-2.6.28-rc7-mm1.orig/fs/namespace.c
+++ linux-2.6.28-rc7-mm1/fs/namespace.c
@@ -254,6 +254,10 @@ int mnt_want_write(struct vfsmount *mnt)
 	int ret = 0;
 	struct mnt_writer *cpu_writer;
 
+#ifdef CONFIG_SECURITY_PATH
+	if (security_path_set(mnt) < 0)
+		return -ENOMEM;
+#endif
 	cpu_writer = &get_cpu_var(mnt_writers);
 	spin_lock(&cpu_writer->lock);
 	if (__mnt_is_readonly(mnt)) {
@@ -265,6 +269,10 @@ int mnt_want_write(struct vfsmount *mnt)
 out:
 	spin_unlock(&cpu_writer->lock);
 	put_cpu_var(mnt_writers);
+#ifdef CONFIG_SECURITY_PATH
+	if (ret)
+		security_path_clear();
+#endif
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
@@ -362,6 +370,9 @@ void mnt_drop_write(struct vfsmount *mnt
 	 * we could theoretically wrap __mnt_writers.
 	 */
 	put_cpu_var(mnt_writers);
+#ifdef CONFIG_SECURITY_PATH
+	security_path_clear();
+#endif
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
--- linux-2.6.28-rc7-mm1.orig/include/linux/security.h
+++ linux-2.6.28-rc7-mm1/include/linux/security.h
@@ -470,6 +470,12 @@ static inline void security_free_mnt_opt
  *	@inode contains a pointer to the inode.
  *	@secid contains a pointer to the location where result will be saved.
  *	In case of failure, @secid will be set to zero.
+ * @path_set:
+ *	Calculate pathname of vfsmount for subsequent vfs operation.
+ *	@vfsmnt contains the vfsmount structure.
+ *	Return 0 on success, negative value otherwise.
+ * @path_clear:
+ *	Clear pathname of vfsmount calculated by @path_set.
  *
  * Security hooks for file operations
  *
@@ -1331,6 +1337,11 @@ struct security_operations {
 				   struct super_block *newsb);
 	int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
 
+#ifdef CONFIG_SECURITY_PATH
+	int (*path_set) (struct vfsmount *vfsmnt);
+	void (*path_clear) (void);
+#endif
+
 	int (*inode_alloc_security) (struct inode *inode);
 	void (*inode_free_security) (struct inode *inode);
 	int (*inode_init_security) (struct inode *inode, struct inode *dir,
@@ -2705,6 +2716,19 @@ static inline void security_skb_classify
 
 #endif	/* CONFIG_SECURITY_NETWORK_XFRM */
 
+#ifdef CONFIG_SECURITY_PATH
+int security_path_set(struct vfsmount *vfsmnt);
+void security_path_clear(void);
+#else	/* CONFIG_SECURITY_PATH */
+static inline int security_path_set(struct vfsmount *vfsmnt)
+{
+	return 0;
+}
+static inline void security_path_clear(void)
+{
+}
+#endif	/* CONFIG_SECURITY_PATH */
+
 #ifdef CONFIG_KEYS
 #ifdef CONFIG_SECURITY
 
--- linux-2.6.28-rc7-mm1.orig/security/Kconfig
+++ linux-2.6.28-rc7-mm1/security/Kconfig
@@ -81,6 +81,16 @@ config SECURITY_NETWORK_XFRM
 	  IPSec.
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_PATH
+	bool "Security hooks for pathname based access control"
+	depends on SECURITY
+	help
+	  This adds security_path_set() and security_path_clear()
+	  hooks for pathname based access control.
+	  If enabled, a security module can use these hooks to
+	  implement pathname based access controls.
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_FILE_CAPABILITIES
 	bool "File POSIX Capabilities"
 	default n
--- linux-2.6.28-rc7-mm1.orig/security/Makefile
+++ linux-2.6.28-rc7-mm1/security/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selin
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+obj-$(CONFIG_SECURITY_PATH)             += mnt_path.o
--- linux-2.6.28-rc7-mm1.orig/security/capability.c
+++ linux-2.6.28-rc7-mm1/security/capability.c
@@ -263,6 +263,19 @@ static void cap_inode_getsecid(const str
 	*secid = 0;
 }
 
+#ifdef CONFIG_SECURITY_PATH
+
+static int cap_path_set(struct vfsmount *vfsmnt)
+{
+	return 0;
+}
+
+static void cap_path_clear(void)
+{
+}
+
+#endif
+
 static int cap_file_permission(struct file *file, int mask)
 {
 	return 0;
@@ -883,6 +896,10 @@ void security_fixup_ops(struct security_
 	set_to_cap_if_null(ops, inode_setsecurity);
 	set_to_cap_if_null(ops, inode_listsecurity);
 	set_to_cap_if_null(ops, inode_getsecid);
+#ifdef CONFIG_SECURITY_PATH
+	set_to_cap_if_null(ops, path_set);
+	set_to_cap_if_null(ops, path_clear);
+#endif
 	set_to_cap_if_null(ops, file_permission);
 	set_to_cap_if_null(ops, file_alloc_security);
 	set_to_cap_if_null(ops, file_free_security);
--- /dev/null
+++ linux-2.6.28-rc7-mm1/security/mnt_path.c
@@ -0,0 +1,100 @@
+/* mnt_path tracker */
+#include <linux/security.h>
+#include <linux/mount.h>
+
+/**
+ * mp_update_mnt_path - Update list of pathname of vfsmount.
+ *
+ * @mnt_path: Pointer to "const char *" or NULL.
+ *
+ * Returns @mnt_path on success, NULL otherwise if @mnt_path != NULL.
+ * Returns previously saved "const char *" and clears it if @mnt_path == NULL.
+ */
+static const char *mp_update_mnt_path(const char *mnt_path)
+{
+	struct mnt_path_entry {
+		struct list_head list;
+		struct task_struct *task; /* = current */
+		const char *mnt_path;
+	};
+	static LIST_HEAD(list);
+	static DEFINE_SPINLOCK(lock);
+	struct task_struct *task = current;
+	struct mnt_path_entry *entry;
+	if (!mnt_path) {
+		if (!list_empty(&list)) {
+			struct mnt_path_entry *p;
+			entry = NULL;
+			/***** CRITICAL SECTION START *****/
+			spin_lock(&lock);
+			list_for_each_entry(p, &list, list) {
+				if (p->task != task)
+					continue;
+				list_del(&p->list);
+				entry = p;
+				break;
+			}
+			spin_unlock(&lock);
+			/***** CRITICAL SECTION END *****/
+			if (entry) {
+				mnt_path = entry->mnt_path;
+				kfree(entry);
+			}
+		}
+		return mnt_path;
+	}
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return NULL;
+	entry->task = task;
+	entry->mnt_path = mnt_path;
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&lock);
+	list_add(&entry->list, &list);
+	spin_unlock(&lock);
+	/***** CRITICAL SECTION END *****/
+	return mnt_path;
+}
+
+static void mp_path_clear(void)
+{
+	kfree(mp_update_mnt_path(NULL));
+}
+
+static int mp_path_set(struct vfsmount *vfsmnt)
+{
+	char *sp;
+	struct path path = { vfsmnt, vfsmnt->mnt_root };
+	char *mnt_path = kmalloc(PATH_MAX, GFP_KERNEL);
+	mp_path_clear();
+	if (!mnt_path)
+		return -ENOMEM;
+	sp = d_path(&path, mnt_path, PATH_MAX - 1);
+	if (IS_ERR(sp)) {
+		kfree(mnt_path);
+		return -ENOMEM;
+	}
+	sp = kstrdup(sp, GFP_KERNEL);
+	kfree(mnt_path);
+	if (!sp)
+		return -ENOMEM;
+	return mp_update_mnt_path(sp) ? 0 : -ENOMEM;
+}
+
+static struct security_operations mp_security_ops = {
+	.name                = "mnt_path",
+	.path_set            = mp_path_set,
+	.path_clear          = mp_path_clear,
+};
+
+static int __init mp_init(void)
+{
+	if (!security_module_enable(&mp_security_ops))
+		return 0;
+	if (register_security(&mp_security_ops))
+		panic("Failure registering mnt_path tracker");
+	printk(KERN_INFO "mnt_path tracker enabled.\n");
+	return 0;
+}
+
+security_initcall(mp_init);
--- linux-2.6.28-rc7-mm1.orig/security/security.c
+++ linux-2.6.28-rc7-mm1/security/security.c
@@ -355,6 +355,20 @@ int security_inode_init_security(struct 
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
+#ifdef CONFIG_SECURITY_PATH
+
+int security_path_set(struct vfsmount *vfsmnt)
+{
+	return security_ops->path_set(vfsmnt);
+}
+
+void security_path_clear(void)
+{
+	return security_ops->path_clear();
+}
+
+#endif
+
 int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
