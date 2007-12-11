Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbXLKQoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbXLKQoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXLKQoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:44:01 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:43235 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751962AbXLKQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:43:59 -0500
Date: Tue, 11 Dec 2007 22:13:19 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       kay.sievers@vrfy.org, gregkh@suse.de
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071211164319.GA14783@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071207151113.e9841341.akpm@linux-foundation.org> <20071207171455.b2eecb60.randy.dunlap@oracle.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca> <F1D642E5A91BC94D9504EC83AE19E6B0015201B1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071210091501.deed38fa.randy.dunlap@oracle.com> <20071211145437.GA15617@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211145437.GA15617@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 08:24:37PM +0530, Dhaval Giani wrote:
> On Mon, Dec 10, 2007 at 09:15:01AM -0800, Randy Dunlap wrote:
> > On Mon, 10 Dec 2007 09:03:17 -0500 Fortier,Vincent [Montreal] wrote:
> > 
> > Ingo, can you look at this, please?
> > Vincent is getting oopses on 2.6.22.14-cfs-etch.
> > 
> 
> Hi,
> 
> We are looking into this bug now. I believe that the patch at
> http://marc.info/?l=linux-kernel&m=119404922603293 should help.
> 
> I am working with Kay to get this ported.
> 

Hi Vincent,

Does the following patch help?

Kay/Greg, could you please review and add your Signed-off-by(s) as
required?

This is basically a port of the patch at
http://marc.info/?l=linux-kernel&m=119404922603293

Thanks,
--

The sysfs interface for the Fair User Interface hits upon the bug
reported at http://lkml.org/lkml/2007/12/10/113.

Kay Sievers and Greg K H had posted some sysfs cleanup patches sometime
back at http://marc.info/?l=linux-kernel&m=119404922603293 .

This patch has been ported to 2.6.22.14 + CFS v24 backport.

Cc: Ingo Molnar <mingo@elte.hu>
Not-yet-Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Not-yet-Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 include/linux/sched.h |    9 ---
 kernel/ksysfs.c       |    7 --
 kernel/user.c         |  129 +++++++++++++++++++++++++++++---------------------
 3 files changed, 80 insertions(+), 65 deletions(-)

Index: current/include/linux/sched.h
===================================================================
--- current.orig/include/linux/sched.h
+++ current/include/linux/sched.h
@@ -586,18 +586,13 @@ struct user_struct {
 #ifdef CONFIG_FAIR_USER_SCHED
 	struct task_group *tg;
 #ifdef CONFIG_SYSFS
-	struct kset kset;
-	struct subsys_attribute user_attr;
+	struct kobject kobj;
 	struct work_struct work;
 #endif
 #endif
 };
 
-#ifdef CONFIG_FAIR_USER_SCHED
-extern int uids_kobject_init(void);
-#else
-static inline int uids_kobject_init(void) { return 0; }
-#endif
+extern int uids_sysfs_init(void);
 
 extern struct user_struct *find_user(uid_t);
 
Index: current/kernel/ksysfs.c
===================================================================
--- current.orig/kernel/ksysfs.c
+++ current/kernel/ksysfs.c
@@ -89,12 +89,9 @@ static int __init ksysfs_init(void)
 		error = sysfs_create_group(&kernel_subsys.kobj,
 					   &kernel_attr_group);
 
-	/*
-	 * Create "/sys/kernel/uids" directory and corresponding root user's
-	 * directory under it.
-	 */
+	/* create the /sys/kernel/uids/ directory */
 	if (!error)
-		error = uids_kobject_init();
+		error = uids_sysfs_init();
 
 	return error;
 }
Index: current/kernel/user.c
===================================================================
--- current.orig/kernel/user.c
+++ current/kernel/user.c
@@ -118,7 +118,6 @@ static void sched_switch_user(struct tas
 
 #if defined(CONFIG_FAIR_USER_SCHED) && defined(CONFIG_SYSFS)
 
-static struct kobject uids_kobject; /* represents /sys/kernel/uids directory */
 static DEFINE_MUTEX(uids_mutex);
 
 static inline void uids_mutex_lock(void)
@@ -131,83 +130,104 @@ static inline void uids_mutex_unlock(voi
 	mutex_unlock(&uids_mutex);
 }
 
-/* return cpu shares held by the user */
-ssize_t cpu_shares_show(struct kset *kset, char *buffer)
+/* uid directory attributes */
+static ssize_t cpu_shares_show(struct kobject *kobj,
+			       struct attribute *attr,
+			       char *buf)
 {
-	struct user_struct *up = container_of(kset, struct user_struct, kset);
+	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
 
-	return sprintf(buffer, "%lu\n", sched_group_shares(up->tg));
+	return sprintf(buf, "%lu\n", sched_group_shares(up->tg));
 }
 
-/* modify cpu shares held by the user */
-ssize_t cpu_shares_store(struct kset *kset, const char *buffer, size_t size)
+static ssize_t cpu_shares_store(struct kobject *kobj,
+				struct attribute *attr,
+				const char *buf, size_t size)
 {
-	struct user_struct *up = container_of(kset, struct user_struct, kset);
+	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
 	unsigned long shares;
 	int rc;
 
-	sscanf(buffer, "%lu", &shares);
+	sscanf(buf, "%lu", &shares);
 
 	rc = sched_group_set_shares(up->tg, shares);
 
 	return (rc ? rc : size);
 }
 
-static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
-{
-	sa->attr.name = name;
-	sa->attr.mode = mode;
-	sa->show = cpu_shares_show;
-	sa->store = cpu_shares_store;
-}
-
-/* Create "/sys/kernel/uids/<uid>" directory and
- *  "/sys/kernel/uids/<uid>/cpu_share" file for this user.
- */
-static int user_kobject_create(struct user_struct *up)
-{
-	struct kset *kset = &up->kset;
-	struct kobject *kobj = &kset->kobj;
-	int error;
-
-	memset(kset, 0, sizeof(struct kset));
-	kobj->parent = &uids_kobject;	/* create under /sys/kernel/uids dir */
-	kobject_set_name(kobj, "%d", up->uid);
-	kset_init(kset);
-	user_attr_init(&up->user_attr, "cpu_share", 0644);
-
+static struct attribute cpu_share_attr = {
+			.name = "cpu_share",
+			.mode = 0644
+				};
+
+/* default attributes per uid directory */
+static struct attribute *uids_attributes[] = {
+	&cpu_share_attr,
+	NULL
+};
+
+/* the lifetime of user_struct is not managed by the core (now) */
+static void uids_release(struct kobject *kobj)
+{
+	return;
+}
+
+static struct sysfs_ops uids_attributes_ops = {
+	.show  = cpu_shares_show,
+	.store = cpu_shares_store,
+};
+
+static struct kobj_type uids_ktype = {
+	.sysfs_ops = &uids_attributes_ops,
+	.release = uids_release,
+};
+
+/* represents the /sys/kernel/uids/ directory */
+static struct kset uids_kset = {
+		.kobj   = {.ktype = &uids_ktype},
+};
+
+/* create /sys/kernel/uids/<uid>/cpu_share file for this user */
+static int uids_user_create(struct user_struct *up)
+{
+	struct kobject *kobj = &up->kobj;
+	int error, i = 0;
+
+	memset(kobj, 0, sizeof(struct kobject));
+	kobject_init(kobj);
+	kobj->ktype = &uids_ktype;
+	kobj->kset = &uids_kset;
+	kobject_set_name(&up->kobj, "%d", up->uid);
 	error = kobject_add(kobj);
 	if (error)
 		goto done;
 
-	error = sysfs_create_file(kobj, &up->user_attr.attr);
-	if (error)
-		kobject_del(kobj);
+	while (uids_attributes[i]) {
+		error = sysfs_create_file(kobj, uids_attributes[i++]);
+		if (error)
+			goto done;
+	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
-
 done:
 	return error;
 }
 
-/* create these in sysfs filesystem:
+/* create these entries in sysfs:
  * 	"/sys/kernel/uids" directory
  * 	"/sys/kernel/uids/0" directory (for root user)
  * 	"/sys/kernel/uids/0/cpu_share" file (for root user)
  */
-int __init uids_kobject_init(void)
+int __init uids_sysfs_init(void)
 {
 	int error;
 
-	/* create under /sys/kernel dir */
-	uids_kobject.parent = &kernel_subsys.kobj;
-	uids_kobject.kset = &kernel_subsys;
-	kobject_set_name(&uids_kobject, "uids");
-	kobject_init(&uids_kobject);
+	kobject_set_name(&uids_kset.kobj, "uids");
+	kobj_set_kset_s(&uids_kset, kernel_subsys);
 
-	error = kobject_add(&uids_kobject);
+	error = kset_register(&uids_kset);
 	if (!error)
-		error = user_kobject_create(&root_user);
+		error = uids_user_create(&root_user);
 
 	return error;
 }
@@ -218,9 +238,8 @@ int __init uids_kobject_init(void)
 static void remove_user_sysfs_dir(struct work_struct *w)
 {
 	struct user_struct *up = container_of(w, struct user_struct, work);
-	struct kobject *kobj = &up->kset.kobj;
 	unsigned long flags;
-	int remove_user = 0;
+	int remove_user = 0, i = 0;
 
 	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
 	 * atomic.
@@ -240,9 +259,12 @@ static void remove_user_sysfs_dir(struct
 	if (!remove_user)
 		goto done;
 
-	sysfs_remove_file(kobj, &up->user_attr.attr);
-	kobject_uevent(kobj, KOBJ_REMOVE);
-	kobject_del(kobj);
+	while (uids_attributes[i])
+		sysfs_remove_file(&up->kobj, uids_attributes[i++]);
+
+	kobject_uevent(&up->kobj, KOBJ_REMOVE);
+	kobject_del(&up->kobj);
+	kobject_put(&up->kobj);
 
 	sched_destroy_user(up);
 	key_put(up->uid_keyring);
@@ -269,7 +291,8 @@ static inline void free_user(struct user
 
 #else	/* CONFIG_FAIR_USER_SCHED && CONFIG_SYSFS */
 
-static inline int user_kobject_create(struct user_struct *up) { return 0; }
+int uids_sysfs_init(void) { return 0; }
+static inline int uids_user_create(struct user_struct *up) { return 0; }
 static inline void uids_mutex_lock(void) { }
 static inline void uids_mutex_unlock(void) { }
 
@@ -326,7 +349,7 @@ struct user_struct * alloc_uid(struct us
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up;
 
-	/* Make uid_hash_find() + user_kobject_create() + uid_hash_insert()
+	/* Make uid_hash_find() + uids_user_create() + uid_hash_insert()
 	 * atomic.
 	 */
 	uids_mutex_lock();
@@ -366,7 +389,7 @@ struct user_struct * alloc_uid(struct us
 			return NULL;
 		}
 
-		if (user_kobject_create(new)) {
+		if (uids_user_create(new)) {
 			sched_destroy_user(new);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
-- 
regards,
Dhaval
