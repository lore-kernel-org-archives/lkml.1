Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZIXK0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZIXK0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZIXK0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:26:46 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:35879 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZIXK0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MA8I5hIWwVyq/EyiC0bNc15ycGnP7g/lA+5LeyGbdo0K5beqaI4EvUfgLAQ31rn8FG
         ybUsI8p+ly+TbIFy0YAeemYdXNqICoCPXE6BL4FWfLp0bghKzuZsq81YySoEYGEp+JXC
         4az6D+Nx4f1VcgNeSn5mizTBBE7qIFO5vgkxI=
MIME-Version: 1.0
In-Reply-To: <4ABAC663.60906@cn.fujitsu.com>
References: <c4e36d110909210307m6579807ehe4d659053c4dc696@mail.gmail.com>
	 <4AB86A03.7060207@cn.fujitsu.com>
	 <c4e36d110909220057q6d9ce816yfcec7de4849c1969@mail.gmail.com>
	 <4ABAC663.60906@cn.fujitsu.com>
Date: Thu, 24 Sep 2009 12:26:47 +0200
Message-ID: <c4e36d110909240326k16bf40cdpfa4b818d1a24a25f@mail.gmail.com>
Subject: Re: [PATCH] Add missing blk_trace_remove_sysfs to be in pair with 
	blk_trace_init_sysfs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mbroz@redhat.com,
       tytso@mit.edu, jens.axboe@oracle.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/24 Li Zefan <lizf@cn.fujitsu.com>:
>>>> Subject: [PATCH] Add missing blk_trace_remove_sysfs to be in pair with
>>>> blk_trace_init_sysfs
>>>> From: Zdenek Kabelac <zkabelac@redhat.com>
>>>>
>>>> Adds missing blk_trace_remove_sysfs() to be in pair with
>>>> blk_trace_init_sysfs() introduced in commit
>>>> 1d54ad6da9192fed5dd3b60224d9f2dfea0dcd82.
>>>>
>>>> Problem was noticed via kmemleak backtrace when some sysfs entries
>>>> were note properly destroyed during  device removal:
>>>>
>>> Thanks for reporting and fixing this!
>>>
>>>> @@ -465,6 +466,7 @@ void blk_unregister_queue(struct gendisk *disk)
>>>>
>>>>               kobject_uevent(&q->kobj, KOBJ_REMOVE);
>>>>               kobject_del(&q->kobj);
>>>> +             blk_trace_remove_sysfs(disk_to_dev(disk));
>>> This should be moved outside of 'if'.
>>>
>>
>> I was not really sure about the proper place - if it could be placed
>> before if() or after the if(){} - as I've not checked in depth
>
> Just use the reverse order against blk_register_queue() should be fine.

Yes - I think the order of release is correct.

>
>> connection between kobj and sysfs. It's somewhat unclear why all the
>> kobject operation are only within this if(){} block - so I've thought
>> there is some reason...
>> IMHO only elv_unregister_queue() should be probably in the if(){} block.
>>
>
> Seems it's a bug to put kobject_put(dev->kobj) in the if block.
>
> I created a stacked device (mdadm) and kmemleak still reported leaks
> even after I fixed the blktrace issue. And then I moved kobejct_put()
> outside the if, no more leaks reports.
>

Ok - I didn't have a testcase where the request_fn would be NULL.
So in this case I propose this patch:

---
Add missing blk_trace_remove_sysfs to be in pair with blk_trace_init_sysfs
introduced in commit 1d54ad6da9192fed5dd3b60224d9f2dfea0dcd82.
Release kobject also in case the request_fn is NULL.

Problem was noticed via kmemleak backtrace when some sysfs entries were
note properly destroyed during  device removal:

unreferenced object 0xffff88001aa76640 (size 80):
  comm "lvcreate", pid 2120, jiffies 4294885144
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 f0 65 a7 1a 00 88 ff ff  .........e......
    90 66 a7 1a 00 88 ff ff 86 1d 53 81 ff ff ff ff  .f........S.....
  backtrace:
    [<ffffffff813f9cc6>] kmemleak_alloc+0x26/0x60
    [<ffffffff8111d693>] kmem_cache_alloc+0x133/0x1c0
    [<ffffffff81195891>] sysfs_new_dirent+0x41/0x120
    [<ffffffff81194b0c>] sysfs_add_file_mode+0x3c/0xb0
    [<ffffffff81197c81>] internal_create_group+0xc1/0x1a0
    [<ffffffff81197d93>] sysfs_create_group+0x13/0x20
    [<ffffffff810d8004>] blk_trace_init_sysfs+0x14/0x20
    [<ffffffff8123f45c>] blk_register_queue+0x3c/0xf0
    [<ffffffff812447e4>] add_disk+0x94/0x160
    [<ffffffffa00d8b08>] dm_create+0x598/0x6e0 [dm_mod]
    [<ffffffffa00de951>] dev_create+0x51/0x350 [dm_mod]
    [<ffffffffa00de823>] ctl_ioctl+0x1a3/0x240 [dm_mod]
    [<ffffffffa00de8f2>] dm_compat_ctl_ioctl+0x12/0x20 [dm_mod]
    [<ffffffff81177bfd>] compat_sys_ioctl+0xcd/0x4f0
    [<ffffffff81036ed8>] sysenter_dispatch+0x7/0x2c
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 block/blk-sysfs.c            |   11 ++++++-----
 include/linux/blktrace_api.h |    2 ++
 kernel/trace/blktrace.c      |    5 +++++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b78c9c3..8a6d81a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -452,6 +452,7 @@ int blk_register_queue(struct gendisk *disk)
 	if (ret) {
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
 		kobject_del(&q->kobj);
+		blk_trace_remove_sysfs(disk_to_dev(disk));
 		return ret;
 	}

@@ -465,11 +466,11 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return;

-	if (q->request_fn) {
+	if (q->request_fn)
 		elv_unregister_queue(q);

-		kobject_uevent(&q->kobj, KOBJ_REMOVE);
-		kobject_del(&q->kobj);
-		kobject_put(&disk_to_dev(disk)->kobj);
-	}
+	kobject_uevent(&q->kobj, KOBJ_REMOVE);
+	kobject_del(&q->kobj);
+	blk_trace_remove_sysfs(disk_to_dev(disk));
+	kobject_put(&disk_to_dev(disk)->kobj);
 }
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 7e4350e..622939a 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -198,6 +198,7 @@ extern int blk_trace_setup(struct request_queue
*q, char *name, dev_t dev,
 			   char __user *arg);
 extern int blk_trace_startstop(struct request_queue *q, int start);
 extern int blk_trace_remove(struct request_queue *q);
+extern void blk_trace_remove_sysfs(struct device *dev);
 extern int blk_trace_init_sysfs(struct device *dev);

 extern struct attribute_group blk_trace_attr_group;
@@ -211,6 +212,7 @@ extern struct attribute_group blk_trace_attr_group;
 # define blk_trace_startstop(q, start)			(-ENOTTY)
 # define blk_trace_remove(q)				(-ENOTTY)
 # define blk_add_trace_msg(q, fmt, ...)			do { } while (0)
+# define blk_trace_remove_sysfs(struct device *dev)	do { } while (0)
 static inline int blk_trace_init_sysfs(struct device *dev)
 {
 	return 0;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 3eb159c..60b5c5a 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1657,6 +1657,11 @@ int blk_trace_init_sysfs(struct device *dev)
 	return sysfs_create_group(&dev->kobj, &blk_trace_attr_group);
 }

+void blk_trace_remove_sysfs(struct device *dev)
+{
+	sysfs_remove_group(&dev->kobj, &blk_trace_attr_group);
+}
+
 #endif /* CONFIG_BLK_DEV_IO_TRACE */

 #ifdef CONFIG_EVENT_TRACING
-- 
1.6.4.4
