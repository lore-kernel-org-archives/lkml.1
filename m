Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbXFKFBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbXFKFBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 01:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbXFKFBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 01:01:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:50781 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbXFKFBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 01:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Ku/nEvkC2CvlL1wgEPlY7/Yt/LxQoqxSMbYPNEH6ZKpcsIEOnm6BVmguF2OyB/kVdSGFqUMLklp2LcOD6VkL+GCFknqrbgNZj0XumbuI/dpuLOXY8SWOyE9bsNgVmuGpw66zh0RAmM9fHvpPbKRaBhvy3hUFZvKuS/zGH6zDAp8=
Date: Mon, 11 Jun 2007 14:01:07 +0900
From: Tejun Heo <htejun@gmail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org,
       cebbert@redhat.com, sandeen@redhat.com, maneesh@in.ibm.com,
       cs@tequila.co.jp
Subject: [PATCHSET 2.6.22-rc4] sysfs: fix race conditions
Message-ID: <20070611050107.GJ29122@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello, all.

Currently, there are several race conditions around dentry/inode
reclamation.

a. sysfs_dirent->s_dentry dereferencing in sysfs_readdir()

b. sysfs_dirent->s_dentry dereferencing in sysfs_drop_dentry()

c. sysfs_dirent->s_dentry clearing in sysfs_d_iput()

All aboves are done without synchronization and can cause oops if the
timing is right (or wrong).

These race conditions are difficult to trigger but with the attached
patch (sysfs-races.patch) and the following commands running
parallelly, all three are reliably reproducible (you may have to
change timings or disable others to trigger specific one).

1. while true; do insmod drivers/ata/libata.ko; insmod drivers/ata/ata_piix.ko; sleep 1; rmmod ata_piix; rmmod libata; sleep 1; echo -n . ; done
2. while true; do find /sys -type f | xargs cat > /dev/null; echo -n .; sleep 1; done
3. while true; do find /sys/class/scsi_disk -type f | sort | xargs cat > /dev/null; echo -n .; sleep 1; done
4. while true; do umount /sys; sleep 1; mount /sys; sleep 1; echo -n .; done

#1 assumes there are several devices attached to ata_piix controller.
Change #1 to any module or command which creates and removes sysfs
nodes repeatedly and adjust #3 to cat those sysfs nodes.

All known race conditions are fixed in the current -mm.  #a is
replaced by adding sd->s_ino and allocating unique ino with ida.  #b
and #c are fixed during sysfs_drop_dentry() rewrite.  However, those
changes were too big to apply to 2.6.22-rcX or any stable branches.

This patchset contains three minimal backports of fixes in -mm.  With
all patches in the patchset and sysfs-races.patch applied, kernel
survived ~20 hours of stress test without any problem.

Thanks.

-- 
tejun

--fUYQa+Pmc3FrFX/N
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="sysfs-races.patch"

---
 fs/sysfs/dir.c   |    7 +++++--
 fs/sysfs/inode.c |    2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: work1/fs/sysfs/dir.c
===================================================================
--- work1.orig/fs/sysfs/dir.c
+++ work1/fs/sysfs/dir.c
@@ -18,6 +18,8 @@ static void sysfs_d_iput(struct dentry *
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 
+	udelay(10);
+
 	if (sd) {
 		BUG_ON(sd->s_dentry != dentry);
 		sd->s_dentry = NULL;
@@ -538,9 +540,10 @@ static int sysfs_readdir(struct file * f
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
+				if (next->s_dentry) {
+					msleep(1);
 					ino = next->s_dentry->d_inode->i_ino;
-				else
+				} else
 					ino = iunique(sysfs_sb, 2);
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
Index: work1/fs/sysfs/inode.c
===================================================================
--- work1.orig/fs/sysfs/inode.c
+++ work1/fs/sysfs/inode.c
@@ -248,6 +248,8 @@ void sysfs_drop_dentry(struct sysfs_dire
 	struct dentry * dentry = sd->s_dentry;
 	struct inode *inode;
 
+	msleep(1);
+
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);

--fUYQa+Pmc3FrFX/N--
