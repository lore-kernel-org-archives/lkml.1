Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0BEIuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:50:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:53874 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab0BEIuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:50:44 -0500
Message-ID: <4B6BDD5E.7080904@kernel.org>
Date: Fri, 05 Feb 2010 17:57:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Colin Guthrie <cguthrie@mandriva.org>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] driver-core: fix race condition in get_device_parent()
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 08:50:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
to create subdirectory under NULL sysfs_dirent.

Fix it by grabbing a mutex in get_device_parent().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Colin Guthrie <cguthrie@mandriva.org>
---
This fell through the crack.  This patch isn't very pretty but it's
better than having the race condition open.  Greg, can you please
apply this?

Thanks.

 drivers/base/core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2820257..fb4bc4f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -607,6 +607,7 @@ static struct kobject *get_device_parent(struct device *dev,
 	int retval;
 
 	if (dev->class) {
+		static DEFINE_MUTEX(gdp_mutex);
 		struct kobject *kobj = NULL;
 		struct kobject *parent_kobj;
 		struct kobject *k;
@@ -623,6 +624,8 @@ static struct kobject *get_device_parent(struct device *dev,
 		else
 			parent_kobj = &parent->kobj;
 
+		mutex_lock(&gdp_mutex);
+
 		/* find our class-directory at the parent and reference it */
 		spin_lock(&dev->class->p->class_dirs.list_lock);
 		list_for_each_entry(k, &dev->class->p->class_dirs.list, entry)
@@ -631,20 +634,26 @@ static struct kobject *get_device_parent(struct device *dev,
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
 
