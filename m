Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0BJGzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 01:55:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0BJGza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 01:55:30 -0500
Date: Wed, 10 Feb 2010 01:54:27 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Miles Lane <miles.lane@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Amerigo Wang <amwang@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, akpm@linux-foundation.org
Message-Id: <20100210065754.3713.8997.sendpatchset@localhost.localdomain>
Subject: [RFC Patch] sysfs: add marks for mutable sysfs files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: This patch is only a draft, not ready to be taken.

This fixes all the s_active related bogus lockdep warnings that I received,
I already tested it, it works fine for cpu hotplug, I/O scheduler switch,
and suspend.

This patch introduces sever sysfs/kobject interfaces to add mutable
sysfs files or kobjects, those files could be removed by the kernel
during some event, e.g. cpu hotplug. All of this kind of sysfs files
should use these API's, to avoid the deadlock warnings.

I am still not sure if this is the best fix.

Please comment.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fc6c8ef..133345f 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -914,7 +914,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	if (unlikely(retval < 0))
 		return retval;
 
-	retval = kobject_init_and_add(per_cpu(ici_cache_kobject, cpu),
+	retval = kobject_init_and_add_mutable(per_cpu(ici_cache_kobject, cpu),
 				      &ktype_percpu_entry,
 				      &sys_dev->kobj, "%s", "cache");
 	if (retval < 0) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a8aacd4..245a83b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1906,7 +1906,7 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 	per_cpu(mce_dev, cpu).id	= cpu;
 	per_cpu(mce_dev, cpu).cls	= &mce_sysclass;
 
-	err = sysdev_register(&per_cpu(mce_dev, cpu));
+	err = sysdev_register_mutable(&per_cpu(mce_dev, cpu));
 	if (err)
 		return err;
 
diff --git a/block/elevator.c b/block/elevator.c
index 9ad5ccc..63238b6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -210,7 +210,7 @@ static struct elevator_queue *elevator_alloc(struct request_queue *q,
 
 	eq->ops = &e->ops;
 	eq->elevator_type = e;
-	kobject_init(&eq->kobj, &elv_ktype);
+	kobject_init_mutable(&eq->kobj, &elv_ktype);
 	mutex_init(&eq->sysfs_lock);
 
 	eq->hash = kmalloc_node(sizeof(struct hlist_head) * ELV_HASH_ENTRIES,
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 0d90390..60a6490 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -231,12 +231,7 @@ EXPORT_SYMBOL_GPL(sysdev_driver_unregister);
 
 
 
-/**
- *	sysdev_register - add a system device to the tree
- *	@sysdev:	device in question
- *
- */
-int sysdev_register(struct sys_device *sysdev)
+static int _sysdev_register(struct sys_device *sysdev, int mutable)
 {
 	int error;
 	struct sysdev_class *cls = sysdev->cls;
@@ -254,7 +249,12 @@ int sysdev_register(struct sys_device *sysdev)
 	sysdev->kobj.kset = &cls->kset;
 
 	/* Register the object */
-	error = kobject_init_and_add(&sysdev->kobj, &ktype_sysdev, NULL,
+	if (mutable)
+		error = kobject_init_and_add_mutable(&sysdev->kobj, &ktype_sysdev,
+				     NULL, "%s%d", kobject_name(&cls->kset.kobj),
+				     sysdev->id);
+	else
+		error = kobject_init_and_add(&sysdev->kobj, &ktype_sysdev, NULL,
 				     "%s%d", kobject_name(&cls->kset.kobj),
 				     sysdev->id);
 
@@ -281,6 +281,22 @@ int sysdev_register(struct sys_device *sysdev)
 	return error;
 }
 
+/**
+ *	sysdev_register - add a system device to the tree
+ *	@sysdev:	device in question
+ *
+ */
+
+int sysdev_register(struct sys_device *sysdev)
+{
+	return _sysdev_register(sysdev, 0);
+}
+
+int sysdev_register_mutable(struct sys_device *sysdev)
+{
+	return _sysdev_register(sysdev, 1);
+}
+
 void sysdev_unregister(struct sys_device *sysdev)
 {
 	struct sysdev_driver *drv;
@@ -501,6 +517,7 @@ int __init system_bus_init(void)
 }
 
 EXPORT_SYMBOL_GPL(sysdev_register);
+EXPORT_SYMBOL_GPL(sysdev_register_mutable);
 EXPORT_SYMBOL_GPL(sysdev_unregister);
 
 #define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index bf6b132..9ed6171 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -134,7 +134,7 @@ static int __cpuinit topology_add_dev(unsigned int cpu)
 {
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
-	return sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
+	return sysfs_create_group_mutable(&sys_dev->kobj, &topology_attr_group);
 }
 
 static void __cpuinit topology_remove_dev(unsigned int cpu)
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 67bc2ec..e40d55f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2006,7 +2006,7 @@ static int __init cpufreq_core_init(void)
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
 	}
 
-	cpufreq_global_kobject = kobject_create_and_add("cpufreq",
+	cpufreq_global_kobject = kobject_create_and_add_mutable("cpufreq",
 						&cpu_sysdev_class.kset.kobj);
 	BUG_ON(!cpufreq_global_kobject);
 
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 97b0038..7242379 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -360,8 +360,8 @@ int cpuidle_add_sysfs(struct sys_device *sysdev)
 	int error;
 
 	dev = per_cpu(cpuidle_devices, cpu);
-	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &sysdev->kobj,
-				     "cpuidle");
+	error = kobject_init_and_add_mutable(&dev->kobj, &ktype_cpuidle,
+					     &sysdev->kobj, "cpuidle");
 	if (!error)
 		kobject_uevent(&dev->kobj, KOBJ_ADD);
 	return error;
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 699f371..0a27d32 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -27,6 +27,7 @@
 DEFINE_MUTEX(sysfs_mutex);
 DEFINE_SPINLOCK(sysfs_assoc_lock);
 
+static struct lock_class_key sysfs_lock_classes[SYSFS_NR_LOCK_CLASSES];
 static DEFINE_SPINLOCK(sysfs_ino_lock);
 static DEFINE_IDA(sysfs_ino_ida);
 
@@ -338,6 +339,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 {
 	char *dup_name = NULL;
 	struct sysfs_dirent *sd;
+	int class = SYSFS_LOCK_CLASS_NORMAL;
 
 	if (type & SYSFS_COPY_NAME) {
 		name = dup_name = kstrdup(name, GFP_KERNEL);
@@ -354,7 +356,9 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
-	sysfs_dirent_init_lockdep(sd);
+	if (type & SYSFS_FLAG_MUTABLE)
+		class = SYSFS_LOCK_CLASS_MUTABLE;
+	lockdep_set_class_and_name(sd, &sysfs_lock_classes[class], "s_active");
 
 	sd->s_name = name;
 	sd->s_mode = mode;
@@ -608,15 +612,18 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 EXPORT_SYMBOL_GPL(sysfs_get_dirent);
 
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
-		      const char *name, struct sysfs_dirent **p_sd)
+		      const char *name, struct sysfs_dirent **p_sd, int mutable)
 {
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	int rc;
+	int type = SYSFS_DIR;
 
+	if (mutable || kobj->mutable || (parent_sd->s_flags & SYSFS_FLAG_MUTABLE))
+		type |= SYSFS_FLAG_MUTABLE;
 	/* allocate */
-	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
+	sd = sysfs_new_dirent(name, mode, type);
 	if (!sd)
 		return -ENOMEM;
 	sd->s_dir.kobj = kobj;
@@ -637,7 +644,13 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd)
 {
-	return create_dir(kobj, kobj->sd, name, p_sd);
+	return create_dir(kobj, kobj->sd, name, p_sd, 0);
+}
+
+int sysfs_create_subdir_mutable(struct kobject *kobj, const char *name,
+			struct sysfs_dirent **p_sd)
+{
+	return create_dir(kobj, kobj->sd, name, p_sd, 1);
 }
 
 /**
@@ -656,7 +669,7 @@ int sysfs_create_dir(struct kobject * kobj)
 	else
 		parent_sd = &sysfs_root;
 
-	error = create_dir(kobj, parent_sd, kobject_name(kobj), &sd);
+	error = create_dir(kobj, parent_sd, kobject_name(kobj), &sd, 0);
 	if (!error)
 		kobj->sd = sd;
 	return error;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index dc30d9e..b507a89 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -505,6 +505,9 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
 	struct sysfs_dirent *sd;
 	int rc;
 
+	if (dir_sd->s_flags & SYSFS_FLAG_MUTABLE)
+		type |= SYSFS_FLAG_MUTABLE;
+
 	sd = sysfs_new_dirent(attr->name, mode, type);
 	if (!sd)
 		return -ENOMEM;
@@ -536,9 +539,12 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 
 int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
 {
+	int type = SYSFS_KOBJ_ATTR;
 	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
+	if (kobj->mutable)
+		type |= SYSFS_FLAG_MUTABLE;
+	return sysfs_add_file(kobj->sd, attr, type);
 
 }
 
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index fe61194..67858d9 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -56,7 +56,7 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 }
 
 
-static int internal_create_group(struct kobject *kobj, int update,
+static int internal_create_group(struct kobject *kobj, int update, int mutable,
 				 const struct attribute_group *grp)
 {
 	struct sysfs_dirent *sd;
@@ -69,7 +69,10 @@ static int internal_create_group(struct kobject *kobj, int update,
 		return -EINVAL;
 
 	if (grp->name) {
-		error = sysfs_create_subdir(kobj, grp->name, &sd);
+		if (mutable)
+			error = sysfs_create_subdir_mutable(kobj, grp->name, &sd);
+		else
+			error = sysfs_create_subdir(kobj, grp->name, &sd);
 		if (error)
 			return error;
 	} else
@@ -97,9 +100,16 @@ static int internal_create_group(struct kobject *kobj, int update,
 int sysfs_create_group(struct kobject *kobj,
 		       const struct attribute_group *grp)
 {
-	return internal_create_group(kobj, 0, grp);
+	return internal_create_group(kobj, 0, 0, grp);
 }
 
+int sysfs_create_group_mutable(struct kobject *kobj,
+		       const struct attribute_group *grp)
+{
+	return internal_create_group(kobj, 0, 1, grp);
+}
+EXPORT_SYMBOL_GPL(sysfs_create_group_mutable);
+
 /**
  * sysfs_update_group - given a directory kobject, create an attribute group
  * @kobj:	The kobject to create the group on
@@ -120,7 +130,7 @@ int sysfs_create_group(struct kobject *kobj,
 int sysfs_update_group(struct kobject *kobj,
 		       const struct attribute_group *grp)
 {
-	return internal_create_group(kobj, 1, grp);
+	return internal_create_group(kobj, 1, 0, grp);
 }
 
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index c5eff49..062ba8d 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -87,6 +87,8 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 int sysfs_create_link(struct kobject *kobj, struct kobject *target,
 		      const char *name)
 {
+	if (target->mutable)
+		kobject_set_mutable(kobj);
 	return sysfs_do_create_link(kobj, target, name, 1);
 }
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index cdd9377..24df378 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -71,6 +71,12 @@ struct sysfs_dirent {
 	struct sysfs_inode_attrs *s_iattr;
 };
 
+enum sysfs_lock_classes {
+	SYSFS_LOCK_CLASS_NORMAL,
+	SYSFS_LOCK_CLASS_MUTABLE,
+	SYSFS_NR_LOCK_CLASSES,
+};
+
 #define SD_DEACTIVATED_BIAS		INT_MIN
 
 #define SYSFS_TYPE_MASK			0x00ff
@@ -82,23 +88,13 @@ struct sysfs_dirent {
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_REMOVED		0x0200
+#define SYSFS_FLAG_MUTABLE		0x0400
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
 	return sd->s_flags & SYSFS_TYPE_MASK;
 }
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define sysfs_dirent_init_lockdep(sd)				\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
-} while(0)
-#else
-#define sysfs_dirent_init_lockdep(sd) do {} while(0)
-#endif
-
 /*
  * Context structure to be used while adding/removing nodes.
  */
@@ -143,6 +139,8 @@ void release_sysfs_dirent(struct sysfs_dirent *sd);
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
+int sysfs_create_subdir_mutable(struct kobject *kobj, const char *name,
+				struct sysfs_dirent **p_sd);
 void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
 int sysfs_rename(struct sysfs_dirent *sd,
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 58ae8e0..ecf7f3c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -69,6 +69,7 @@ struct kobject {
 	unsigned int state_add_uevent_sent:1;
 	unsigned int state_remove_uevent_sent:1;
 	unsigned int uevent_suppress:1;
+	unsigned int mutable:1;
 };
 
 extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
@@ -76,12 +77,15 @@ extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
 extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs);
 
+extern void kobject_set_mutable(struct kobject *kobj);
+
 static inline const char *kobject_name(const struct kobject *kobj)
 {
 	return kobj->name;
 }
 
 extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
+extern void kobject_init_mutable(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *kobj,
 				    struct kobject *parent,
 				    const char *fmt, ...);
@@ -89,12 +93,18 @@ extern int __must_check kobject_init_and_add(struct kobject *kobj,
 					     struct kobj_type *ktype,
 					     struct kobject *parent,
 					     const char *fmt, ...);
+extern int __must_check kobject_init_and_add_mutable(struct kobject *kobj,
+						     struct kobj_type *ktype,
+						     struct kobject *parent,
+						     const char *fmt, ...);
 
 extern void kobject_del(struct kobject *kobj);
 
 extern struct kobject * __must_check kobject_create(void);
 extern struct kobject * __must_check kobject_create_and_add(const char *name,
 						struct kobject *parent);
+extern struct kobject * __must_check kobject_create_and_add_mutable(const char *name,
+						struct kobject *parent);
 
 extern int __must_check kobject_rename(struct kobject *, const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
index f395bb3..f868a10 100644
--- a/include/linux/sysdev.h
+++ b/include/linux/sysdev.h
@@ -94,6 +94,7 @@ struct sys_device {
 };
 
 extern int sysdev_register(struct sys_device *);
+extern int sysdev_register_mutable(struct sys_device *);
 extern void sysdev_unregister(struct sys_device *);
 
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index cfa8308..93ed3c8 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -112,6 +112,8 @@ void sysfs_remove_link(struct kobject *kobj, const char *name);
 
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
+int __must_check sysfs_create_group_mutable(struct kobject *kobj,
+					    const struct attribute_group *grp);
 int sysfs_update_group(struct kobject *kobj,
 		       const struct attribute_group *grp);
 void sysfs_remove_group(struct kobject *kobj,
diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..3ba6163 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -152,6 +152,7 @@ static void kobject_init_internal(struct kobject *kobj)
 	kobj->state_add_uevent_sent = 0;
 	kobj->state_remove_uevent_sent = 0;
 	kobj->state_initialized = 1;
+	kobj->mutable = 0;
 }
 
 
@@ -256,6 +257,19 @@ int kobject_set_name(struct kobject *kobj, const char *fmt, ...)
 EXPORT_SYMBOL(kobject_set_name);
 
 /**
+ * kobject_set_mutable - Mark a kobject as mutable
+ * @kobj: struct kobject to mark
+ *
+ * This marks a kobject as mutable, this means this kobject
+ * and its children could be removed by kernel during hotplug etc..
+ * Normally you don't need to set this.
+ */
+void kobject_set_mutable(struct kobject *kobj)
+{
+	kobj->mutable = 1;
+}
+
+/**
  * kobject_init - initialize a kobject structure
  * @kobj: pointer to the kobject to initialize
  * @ktype: pointer to the ktype for this kobject.
@@ -296,6 +310,13 @@ error:
 }
 EXPORT_SYMBOL(kobject_init);
 
+void kobject_init_mutable(struct kobject *kobj, struct kobj_type *ktype)
+{
+	kobject_init(kobj, ktype);
+	kobject_set_mutable(kobj);
+}
+EXPORT_SYMBOL(kobject_init_mutable);
+
 static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
 			    const char *fmt, va_list vargs)
 {
@@ -386,6 +407,23 @@ int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
 }
 EXPORT_SYMBOL_GPL(kobject_init_and_add);
 
+int kobject_init_and_add_mutable(struct kobject *kobj, struct kobj_type *ktype,
+			 struct kobject *parent, const char *fmt, ...)
+{
+	va_list args;
+	int retval;
+
+	kobject_init_mutable(kobj, ktype);
+
+	va_start(args, fmt);
+	retval = kobject_add_varg(kobj, parent, fmt, args);
+	va_end(args);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(kobject_init_and_add_mutable);
+
+
 /**
  * kobject_rename - change the name of an object
  * @kobj: object in question.
@@ -664,6 +702,29 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
 }
 EXPORT_SYMBOL_GPL(kobject_create_and_add);
 
+struct kobject *kobject_create_and_add_mutable(const char *name,
+						struct kobject *parent)
+{
+	struct kobject *kobj;
+	int retval;
+
+	kobj = kobject_create();
+	if (!kobj)
+		return NULL;
+
+	kobject_set_mutable(kobj);
+	retval = kobject_add(kobj, parent, "%s", name);
+	if (retval) {
+		printk(KERN_WARNING "%s: kobject_add error: %d\n",
+		       __func__, retval);
+		kobject_put(kobj);
+		kobj = NULL;
+	}
+	return kobj;
+}
+EXPORT_SYMBOL_GPL(kobject_create_and_add_mutable);
+
+
 /**
  * kset_init - initialize a kset for use
  * @k: kset
