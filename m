Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156Ab0ATXuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0ATXuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971Ab0ATXuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:50:11 -0500
Received: from kroah.org ([198.145.64.141]:33614 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab0ATXuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] driver-core: fix devtmpfs crash on s390
Date: Wed, 20 Jan 2010 15:49:18 -0800
Message-Id: <1264031359-32196-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234753.GB32068@kroah.com>
References: <20100120234753.GB32068@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

On Mon, Jan 18, 2010 at 05:26:20PM +0530, Sachin Sant wrote:
> Hello Heiko,
>
> Today while trying to boot next-20100118 i came across
> the following Oops :
>
> Brought up 4 CPUs
> Unable to handle kernel pointer dereference at virtual kernel address 0000000000
> 543000
> Oops: 0004 #1 SMP
> Modules linked in:
> CPU: 0 Not tainted 2.6.33-rc4-autotest-next-20100118-5-default #1
> Process swapper (pid: 1, task: 00000000fd792038, ksp: 00000000fd797a30)
> Krnl PSW : 0704200180000000 00000000001eb0b8 (shmem_parse_options+0xc0/0x328)
>           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
> Krnl GPRS: 000000000054388a 000000000000003d 0000000000543836 000000000000003d
>           0000000000000000 0000000000483f28 0000000000536112 00000000fd797d00
>           00000000fd4ba100 0000000000000100 0000000000483978 0000000000543832
>           0000000000000000 0000000000465958 00000000001eb0b0 00000000fd797c58
> Krnl Code: 00000000001eb0aa: c0e5000994f1       brasl   %r14,31da8c
>           00000000001eb0b0: b9020022           ltgr    %r2,%r2
>           00000000001eb0b4: a784010b           brc     8,1eb2ca
>          >00000000001eb0b8: 92002000           mvi     0(%r2),0
>           00000000001eb0bc: a7080000           lhi     %r0,0
>           00000000001eb0c0: 41902001           la      %r9,1(%r2)
>           00000000001eb0c4: b9040016           lgr     %r1,%r6
>           00000000001eb0c8: b904002b           lgr     %r2,%r11
> Call Trace:
> (<00000000fd797c50> 0xfd797c50)
> <00000000001eb5da> shmem_fill_super+0x13a/0x25c
> <0000000000228cfa> get_sb_single+0xbe/0xdc
> <000000000034ffc0> dev_get_sb+0x2c/0x38
> <000000000066c602> devtmpfs_init+0x46/0xc0
> <000000000066c53e> driver_init+0x22/0x60
> <000000000064d40a> kernel_init+0x24e/0x3d0
> <000000000010a7ea> kernel_thread_starter+0x6/0xc
> <000000000010a7e4> kernel_thread_starter+0x0/0xc
>
> I never tried to boot a kernel with DEVTMPFS enabled on a s390 box.
> So am wondering if this is supported or not ? If you think this
> is supported i will send a mail to community on this.

There is nothing arch specific to devtmpfs. This part crashes because the
kernel tries to modify the data read-only section which is write protected
on s390.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 090dd48..42ae452 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -354,6 +354,7 @@ int __init devtmpfs_init(void)
 {
 	int err;
 	struct vfsmount *mnt;
+	char options[] = "mode=0755";
 
 	err = register_filesystem(&dev_fs_type);
 	if (err) {
@@ -362,7 +363,7 @@ int __init devtmpfs_init(void)
 		return err;
 	}
 
-	mnt = kern_mount_data(&dev_fs_type, "mode=0755");
+	mnt = kern_mount_data(&dev_fs_type, options);
 	if (IS_ERR(mnt)) {
 		err = PTR_ERR(mnt);
 		printk(KERN_ERR "devtmpfs: unable to create devtmpfs %i\n", err);
-- 
1.6.5.7

