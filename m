Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbZIYIWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbZIYIWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZIYIWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:22:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:36425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbZIYIWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:22:36 -0400
Message-ID: <4ABC7DB5.9010402@kernel.org>
Date: Fri, 25 Sep 2009 17:22:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Colin Guthrie <cguthrie@mandriva.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: get_device_parent() race bug
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 25 Sep 2009 08:22:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg, Kay, Guthrie.

This problem was reported in bko#14023.  (aiee.. again, sorry about
the delay)

  http://bugzilla.kernel.org/show_bug.cgi?id=14023

sysfs is creating several devices in cuse class concurrently and with
CONFIG_SYSFS_DEPRECATED turned off, it triggers the following oops.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
 IP: [<ffffffff81158b0a>] sysfs_addrm_start+0x4a/0xf0
 PGD 75bb067 PUD 75be067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP
 last sysfs file: /sys/devices/system/cpu/cpu7/topology/core_siblings
 CPU 1
 Modules linked in: cuse fuse
 Pid: 4737, comm: osspd Not tainted 2.6.31-work #77
 RIP: 0010:[<ffffffff81158b0a>]  [<ffffffff81158b0a>] sysfs_addrm_start+0x4a/0xf0
 RSP: 0018:ffff88000042f8f8  EFLAGS: 00010296
 RAX: ffff88000042ffd8 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffff880007eef660 RDI: 0000000000000001
 RBP: ffff88000042f918 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: ffffffff81158b0a R12: ffff88000042f928
 R13: 00000000fffffff4 R14: 0000000000000000 R15: ffff88000042f9a0
 FS:  00007fe93905a950(0000) GS:ffff880008600000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000038 CR3: 00000000077c9000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process osspd (pid: 4737, threadinfo ffff88000042e000, task ffff880007eef040)
 Stack:
  ffff880005da10e8 0000000011cc8d6e ffff88000042f928 ffff880003d28a28
 <0> ffff88000042f988 ffffffff811592d7 0000000000000000 0000000000000000
 <0> 0000000000000000 0000000000000000 ffff88000042f958 0000000011cc8d6e
 Call Trace:
  [<ffffffff811592d7>] create_dir+0x67/0xe0
  [<ffffffff811593a8>] sysfs_create_dir+0x58/0xb0
  [<ffffffff8128ca7c>] ? kobject_add_internal+0xcc/0x220
  [<ffffffff812942e1>] ? vsnprintf+0x3c1/0xb90
  [<ffffffff8128cab7>] kobject_add_internal+0x107/0x220
  [<ffffffff8128cd37>] kobject_add_varg+0x47/0x80
  [<ffffffff8128ce53>] kobject_add+0x53/0x90
  [<ffffffff81357d84>] device_add+0xd4/0x690
  [<ffffffff81356c2b>] ? dev_set_name+0x4b/0x70
  [<ffffffffa001a884>] cuse_process_init_reply+0x2b4/0x420 [cuse]
  ...

The problem is that kobject_add_internal() first adds a kobject to the
kset and then try to create sysfs directory for it.  If the creation
fails, it remove the kobject from the kset.  get_device_parent()
accesses class_dirs kset while only holding class_dirs.list_lock to
see whether the cuse class dir exists.  But when it exists, it may not
have finished initialization yet or may fail and get removed soon.  In
the above case, the former happened so the second one ends up trying
to create subdirectory under null sysfs_dirent.

Patch attached at the end of this email solves this problem in an ugly
way.

<rant>
One of the things I really dislike about these k* stuff is that the
API advertises much more than they're actually capable of.  The
encapsulated synchronization might look like a good idea but it fails
horribly in practice because these things are always used in
connection with other objects.  The API just tricks developers to
think that all the complexities have been handled and nicely
encapsulated when the reality is those are just hidden under giant
pile of abstract crap.  I really hope someday driver model can do away
with all these k* stuff and use just necessary amount of abstraction
like other sane kernel subsystems.  :-(
</rant>

Thanks.

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6bee6af..71938ed 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -596,6 +596,7 @@ static struct kobject *get_device_parent(struct device *dev,
 	int retval;

 	if (dev->class) {
+		static DEFINE_MUTEX(gdp_mutex);
 		struct kobject *kobj = NULL;
 		struct kobject *parent_kobj;
 		struct kobject *k;
@@ -612,6 +613,8 @@ static struct kobject *get_device_parent(struct device *dev,
 		else
 			parent_kobj = &parent->kobj;

+		mutex_lock(&gdp_mutex);
+
 		/* find our class-directory at the parent and reference it */
 		spin_lock(&dev->class->p->class_dirs.list_lock);
 		list_for_each_entry(k, &dev->class->p->class_dirs.list, entry)
@@ -620,20 +623,26 @@ static struct kobject *get_device_parent(struct device *dev,
 				break;
 			}
 		spin_unlock(&dev->class->p->class_dirs.list_lock);
-		if (kobj)
+		if (kobj) {
+			mutex_unlock(&gdp_mutex);
 			return kobj;
+		}

 		/* or create a new class-directory at the parent device */
 		k = kobject_create();
-		if (!k)
+		if (!k) {
+			mutex_unlock(&gdp_mutex);
 			return NULL;
+		}
 		k->kset = &dev->class->p->class_dirs;
 		retval = kobject_add(k, parent_kobj, "%s", dev->class->name);
 		if (retval < 0) {
+			mutex_unlock(&gdp_mutex);
 			kobject_put(k);
 			return NULL;
 		}
 		/* do not emit an uevent for this simple "glue" directory */
+		mutex_unlock(&gdp_mutex);
 		return k;
 	}

-- 
tejun
