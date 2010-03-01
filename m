Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab0CAFE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:04:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47384 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab0CAFEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:04:52 -0500
Date: Mon, 1 Mar 2010 16:04:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Dave Jones <davej@redhat.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Sage Weil <sage@newdream.net>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       =?UTF-8?B?Iko=?= =?UTF-8?B?w7ZybiBFbmdlbCI=?= <joern@logfs.org>
Subject: linux-next: current pending merge fix patches
Message-Id: <20100301160445.5e281f11.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I am carrying a few merge fixup patches in linux-next that I thought you
might want a heads up about.  Hopefully, these will be fixed before you
see them, but just in case, here they are (in no particular order).

This could also be taken as a reminder to the respective maintiners that
they may want to do a merge of your tree before asking you to pull theirs.

(of course, the SHA1's may change due to rebasing :-()

1) The acpi[1] tree renames drivers/acpi/processor_core.c
to drivers/acpi/processor_driver.c (commit
5f45c35d7ede1c00cbaa3b09b8a84c425af81c4b "ACPI: processor:
mv processor_core.c processor_driver.c") and then
drivers/acpi/processor_pdc.c to drivers/acpi/processor_core.c
(commit de53479b92857f82e4d595104d112b16733b9949 "ACPI: processor:
mv processor_pdc.c processor_core.c"), so the patch in the
cpufreq[2] tree that modifies drivers/acpi/processor_core.c (commit
0f1d683fb35d6c6f49ef696c95757f3970682a0e "[CPUFREQ] Processor Clocking
Control interface driver") get rather confused.  My solution was to
use the acpi tree's version of drivers/acpi/processor_core.c and apply
this patch:

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 7e8e1ba..b5658cd 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -123,6 +123,8 @@ static const struct file_operations acpi_processor_info_fops = {
 #endif
 
 DEFINE_PER_CPU(struct acpi_processor *, processors);
+EXPORT_PER_CPU_SYMBOL(processors);
+
 struct acpi_processor_errata errata __read_mostly;
 
 /* --------------------------------------------------------------------------


2) The i2c[3] tree adds a new file (drivers/i2c/i2c-smbus.c) (patch "i2c:
Add SMBus alert support") that needs updating after the driver-core[4]
tree converts the semaphore in struct device to a mutex (patch
"drivers/base: Convert dev->sem to mutex").

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 333527c..52aa775 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -27,6 +27,7 @@
 #include <linux/workqueue.h>
 #include <linux/i2c.h>
 #include <linux/i2c-smbus.h>
+#include <linux/mutex.h>
 
 struct i2c_smbus_alert {
 	unsigned int		alert_edge_triggered:1;
@@ -55,7 +56,7 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 	 * Drivers should either disable alerts, or provide at least
 	 * a minimal handler.  Lock so client->driver won't change.
 	 */
-	down(&dev->sem);
+	device_lock(dev);
 	if (client->driver) {
 		if (client->driver->alert)
 			client->driver->alert(client, data->flag);
@@ -63,7 +64,7 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 			dev_warn(&client->dev, "no driver alert()!\n");
 	} else
 		dev_dbg(&client->dev, "alert with no driver\n");
-	up(&dev->sem);
+	device_unlock(dev);
 
 	/* Stop iterating after we find the device */
 	return -EBUSY;


3) The nfs[5] tree contains a patch that splits BDI_RECLAIMABLE (commit
d63a2d5fbb857f93df3085593b097dbf4b22bdcc "VM: Split out the accounting
of unstable writes from BDI_RECLAIMABLE") and the ceph[6] tree adds
a use of that (commit 1d3576fd10f0d7a104204267b81cf84a07028dad "ceph:
address space operations"), so I apply the following patch after both
trees have been merged:

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index bf53581..eab46b0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -101,8 +101,7 @@ static int ceph_set_page_dirty(struct page *page)
 
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			__inc_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
+			__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
 			task_io_account_write(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,


4) The slab[7] tree adds a percpu variable usage case (commit
9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864 "SLUB: Use this_cpu operations in
slub"), but the percpu[8] tree removes the prefixing of percpu variables
(commit dd17c8f72993f9461e9c19250e3f155d6d99df22 "percpu: remove per_cpu__
prefix"), thus the fooling patch after mergeing these trees:

diff --git a/mm/slub.c b/mm/slub.c
index 6e34309..9e86e6b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2071,7 +2071,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
 		 * Boot time creation of the kmalloc array. Use static per cpu data
 		 * since the per cpu allocator is not available yet.
 		 */
-		s->cpu_slab = per_cpu_var(kmalloc_percpu) + (s - kmalloc_caches);
+		s->cpu_slab = kmalloc_percpu + (s - kmalloc_caches);
 	else
 		s->cpu_slab =  alloc_percpu(struct kmem_cache_cpu);
 


5) The vfs[9] tree modifies the write_inode method API (commit
716c28c0bc8bcbdd26e819f38dfc8fdfaafc0289 "pass writeback_control to
->write_inode") and the logfs[10] tree adds a write_inode method (commit
5db53f3e80dee2d9dff5e534f9e9fe1db17c9936 "[LogFS] add new flash file
system"), so:

diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index 6d08b37..36308af 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -8,6 +8,7 @@
 #include "logfs.h"
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
+#include <linux/writeback.h>
 
 /*
  * How soon to reuse old inode numbers?  LogFS doesn't store deleted inodes
@@ -282,7 +283,7 @@ struct inode *logfs_read_meta_inode(struct super_block *sb, u64 ino)
 	return inode;
 }
 
-static int logfs_write_inode(struct inode *inode, int do_sync)
+static int logfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
 	long flags = WF_LOCK;


6) The nfsd[11] tree comtains a change
(commit 978ebd97d1426d5708d3f353179ab81f191a7eeb
"xfs_export_operations.commit_metadata") that needs
the following patch due to a change in the xfs code (commit
a14a348bff2f99471a28e5928eb6801224c053d8 "xfs: cleanup up xfs_log_force
calling conventions") that has now been merged into your tree:

diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index 8f4d707..846b75a 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -226,8 +226,8 @@ xfs_fs_nfs_commit_metadata(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_ipincount(ip)) {
-		error = _xfs_log_force(mp, ip->i_itemp->ili_last_lsn,
-				XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);
+		error = _xfs_log_force_lsn(mp, ip->i_itemp->ili_last_lsn,
+				XFS_LOG_SYNC, NULL);
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

---------
[1] git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
	current head in linux-next: fb84181cc2863589ed06d48010fb4f6722105c7c
[2] git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
	current head in linux-next: fb4635932a4e19c2f55383f968a0e9b64da37354
[3] http://kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
	quilt series
	current head in linux-next: 07e9eb11f7b2e730b26c729ef77425b36721b389
[4] http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-driver-core/
	quilt series
	current head in linux-next: 26576add2492e80eb1a24f3e7e3ebc066627edec
[5] git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git
	current head in linux-next: 8e7544eef4f7007e4605aa9bff53dee6b610c164
[6] git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
	current head in linux-next: aa262d2a6155b67eecf13e4964549d1465923a0f
[7] git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git
	current head in linux-next: ca69e392ebe662761f0356dd9de557ba20390dba
[8] git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git
	current head in linux-next: a29d8b8e2d811a24bbe49215a0f0c536b72ebc18
[9] git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git
	current head in linux-next: 9f009a78fb3b54976cfe8173d05ef483dbda4571
[10] git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git
	current head in linux-next: 5c564c2a04d4bb6ba79eeb83bd06de584479f362
[11] git://git.linux-nfs.org/~bfields/linux.git
	current head in linux-next: 7cf498470ae470ee55b3080692604e0dbf63312c
