Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZLCPhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZLCPhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZLCPhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:37:13 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:50121 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbZLCPhK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 3 Dec 2009 10:37:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jayakumar.lkml@gmail.com, damm@opensource.se, linux-kernel@vger.kernel.org
Cc: armbru@redhat.com, jeremy@goop.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] fb-defio: If FBINFO_VIRTFB is defined, do not set VM_IO flag.
Date: Thu,  3 Dec 2009 10:31:56 -0500
Message-Id: <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B17DB13.01D8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most users (except sh_mobile_lcdcfb.c) get their framebuffer from
vmalloc. Setting VM_IO is not necessary as the memory obtained
from vmalloc is System RAM type and is not susceptible to PCI memory
constraints.
---
 drivers/video/fb_defio.c |    4 +++-
 include/linux/fb.h       |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index c27ab1e..94414fc 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -144,7 +144,9 @@ static const struct address_space_operations fb_deferred_io_aops = {
 static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vma->vm_flags |= ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
+	vma->vm_flags |= ( VM_RESERVED | VM_DONTEXPAND );
+	if (!(info->flags & FBINFO_VIRTFB))
+		vma->vm_flags |= VM_IO;
 	vma->vm_private_data = info;
 	return 0;
 }
diff --git a/include/linux/fb.h b/include/linux/fb.h
index de9c722..369767b 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -763,6 +763,7 @@ struct fb_tile_ops {
 	 *  takes over; acceleration engine should be in a quiescent state */
 
 /* hints */
+#define FBINFO_VIRTFB		0x0004 /* FB is System RAM, not device. */
 #define FBINFO_PARTIAL_PAN_OK	0x0040 /* otw use pan only for double-buffering */
 #define FBINFO_READS_FAST	0x0080 /* soft-copy faster than rendering */
 
-- 
1.6.2.5

