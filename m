Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbXGKHVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbXGKHVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXGKHVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:21:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:33263 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXGKHVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=PaY7gW23aQ6tYqHbqFF06P7nd8P4fRGkSr4IHXDStab9y9k0O0nrHEUMQfwNvKY8w7olawRC8SDrmBZQ21pr8VAwR+HIJezxbmua+C8qjWDxnRrDCoE2r++JbdKRsNzdb79tHS54WxWrSAa9q62WTtJNdlyEerdFkbHpZIIm/Dg=
Message-ID: <469484E1.6040000@gmail.com>
Date: Wed, 11 Jul 2007 16:21:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226
 SS:ESP 0068:c5ff9db8
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>	 <20070703094916.e60d4df7.akpm@linux-foundation.org>	 <468B3CFF.7020903@gmail.com>	 <a44ae5cd0707040036x74c82dcci12b0a3f83a27af56@mail.gmail.com>	 <468C9E74.4080606@gmail.com>	 <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>	 <468F36F5.4010803@gmail.com>	 <a44ae5cd0707071753g6dd4445bsaac2e2296327e510@mail.gmail.com>	 <469038EF.7040709@gmail.com> <a44ae5cd0707072156y7d0c9e5am2ded3efdc036bcf7@mail.gmail.com>
In-Reply-To: <a44ae5cd0707072156y7d0c9e5am2ded3efdc036bcf7@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------090402070301080605090603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090402070301080605090603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Miles Lane wrote:
>> Thanks a lot.  Just in case, if you remove the patch (patch -R -p1), the
>> oops goes away, right?
> 
> I double-checked.  I can boot fine after building without your patch.
> Also, I reproduced the initial BUG I reported (triggered by
> "modprobe -r ipw2200").

This is creepy.  I was able to reproduce the oops here with your
configuration file and making buffers for kallsyms static solved the
problem.  It isn't stack overflow.  At maximum those arrays added 254
bytes to the stack and when the oops occurs stack area was left more
than enough.  I'll keep looking into why that happened but the attached
patch should get us going on the original subject.

Thanks.

-- 
tejun

--------------090402070301080605090603
Content-Type: text/plain;
 name="debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug"

---
 fs/sysfs/dir.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h      |   16 ++--------------
 include/linux/sysfs.h |    3 +++
 net/core/net-sysfs.c  |    6 +++++-
 4 files changed, 53 insertions(+), 15 deletions(-)

Index: tree0/fs/sysfs/dir.c
===================================================================
--- tree0.orig/fs/sysfs/dir.c
+++ tree0/fs/sysfs/dir.c
@@ -11,15 +11,52 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <linux/completion.h>
+#include <linux/kallsyms.h>
 #include <asm/semaphore.h>
 #include "sysfs.h"
 
+struct kobject *sysfs_debug_me;
+
 DEFINE_MUTEX(sysfs_mutex);
 spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
 static DEFINE_IDA(sysfs_ino_ida);
 
+struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
+{
+	if (sd) {
+		if (sd->s_flags & SYSFS_FLAG_XXX) {
+			static char c0[KSYM_NAME_LEN], c1[KSYM_NAME_LEN];
+
+			lookup_symbol_name((unsigned long)__builtin_return_address(0), c0);
+			lookup_symbol_name((unsigned long)__builtin_return_address(1), c1);
+
+			printk("sysfs_get(%s): cnt=%d++ called from %s:%s\n",
+			       sd->s_name, atomic_read(&sd->s_count), c0, c1);
+		}
+		WARN_ON(!atomic_read(&sd->s_count));
+		atomic_inc(&sd->s_count);
+	}
+	return sd;
+}
+
+void sysfs_put(struct sysfs_dirent * sd)
+{
+	if (sd && sd->s_flags & SYSFS_FLAG_XXX) {
+		static char c0[KSYM_NAME_LEN], c1[KSYM_NAME_LEN];
+
+		lookup_symbol_name((unsigned long)__builtin_return_address(0), c0);
+		lookup_symbol_name((unsigned long)__builtin_return_address(1), c1);
+
+		printk("sysfs_put(%s): cnt=%d-- called from %s:%s\n",
+		       sd->s_name, atomic_read(&sd->s_count), c0, c1);
+	}
+
+	if (sd && atomic_dec_and_test(&sd->s_count))
+		release_sysfs_dirent(sd);
+}
+
 /**
  *	sysfs_link_sibling - link sysfs_dirent into sibling list
  *	@sd: sysfs_dirent of interest
@@ -317,6 +354,10 @@ void release_sysfs_dirent(struct sysfs_d
 	 * sd->s_parent won't change beneath us.
 	 */
 	parent_sd = sd->s_parent;
+	if (parent_sd->s_flags & SYSFS_FLAG_XXX)
+		printk("put from release(%s): cnt=%d-- (rel=%s)\n",
+		       parent_sd->s_name, atomic_read(&parent_sd->s_count),
+		       sd->s_name);
 
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
 		sysfs_put(sd->s_elem.symlink.target_sd);
@@ -695,6 +736,8 @@ static int create_dir(struct kobject *ko
 	if (!sd)
 		return -ENOMEM;
 	sd->s_elem.dir.kobj = kobj;
+	if (sysfs_debug_me && sysfs_debug_me == kobj)
+		sd->s_flags |= SYSFS_FLAG_XXX;
 
 	/* link in */
 	sysfs_addrm_start(&acxt, parent_sd);
Index: tree0/fs/sysfs/sysfs.h
===================================================================
--- tree0.orig/fs/sysfs/sysfs.h
+++ tree0/fs/sysfs/sysfs.h
@@ -108,20 +108,8 @@ static inline unsigned int sysfs_type(st
 	return sd->s_flags & SYSFS_TYPE_MASK;
 }
 
-static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
-{
-	if (sd) {
-		WARN_ON(!atomic_read(&sd->s_count));
-		atomic_inc(&sd->s_count);
-	}
-	return sd;
-}
-
-static inline void sysfs_put(struct sysfs_dirent * sd)
-{
-	if (sd && atomic_dec_and_test(&sd->s_count))
-		release_sysfs_dirent(sd);
-}
+struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd);
+void sysfs_put(struct sysfs_dirent * sd);
 
 static inline int sysfs_is_shadowed_inode(struct inode *inode)
 {
Index: tree0/include/linux/sysfs.h
===================================================================
--- tree0.orig/include/linux/sysfs.h
+++ tree0/include/linux/sysfs.h
@@ -87,9 +87,12 @@ struct sysfs_ops {
 
 #define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_REMOVED	0x0100
+#define SYSFS_FLAG_XXX		0x0200
 
 #ifdef CONFIG_SYSFS
 
+extern struct kobject *sysfs_debug_me;
+
 extern int sysfs_schedule_callback(struct kobject *kobj,
 		void (*func)(void *), void *data, struct module *owner);
 
Index: tree0/net/core/net-sysfs.c
===================================================================
--- tree0.orig/net/core/net-sysfs.c
+++ tree0/net/core/net-sysfs.c
@@ -472,6 +472,7 @@ int netdev_register_sysfs(struct net_dev
 {
 	struct device *dev = &(net->dev);
 	struct attribute_group **groups = net->sysfs_groups;
+	int rc;
 
 	device_initialize(dev);
 	dev->class = &net_class;
@@ -489,7 +490,10 @@ int netdev_register_sysfs(struct net_dev
 		*groups++ = &wireless_group;
 #endif
 
-	return device_add(dev);
+	sysfs_debug_me = &dev->kobj;
+	rc = device_add(dev);
+	sysfs_debug_me = NULL;
+	return rc;
 }
 
 int netdev_sysfs_init(void)

--------------090402070301080605090603--
