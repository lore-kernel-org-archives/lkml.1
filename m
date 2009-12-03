Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZLCPhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZLCPhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZLCPhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:37:10 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:55070 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZLCPhG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 3 Dec 2009 10:37:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jayakumar.lkml@gmail.com, damm@opensource.se, linux-kernel@vger.kernel.org
Cc: armbru@redhat.com, jeremy@goop.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] xen pvfb: Inhibit VM_IO flag to be set on vmalloc-ed framebuffers.
Date: Thu,  3 Dec 2009 10:31:57 -0500
Message-Id: <1259854318-16907-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
 <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B17DB12.01F2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Xen-paravirt mode, VM_IO flag signifies that the page frame number (PFN)
is actually a machine frame number (MFN). This is correct for memory backed by
PCI devices, but wrong for memory allocated from System RAM where the PFN
!= MFN.

During page faults, pages with VM_IO, get assigned to special domain I/O
domain and as said, the PFN is interpreted as MFN. When Xen hypervisor
modifies the PTE it interprets the PFN as the MFN, complains and
fails the PTE modification.

The end result is an infinitive page fault in the domain.
---
 drivers/video/xen-fbfront.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 54cd916..91a68e9 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -440,7 +440,7 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	fb_info->fix.type = FB_TYPE_PACKED_PIXELS;
 	fb_info->fix.accel = FB_ACCEL_NONE;
 
-	fb_info->flags = FBINFO_FLAG_DEFAULT;
+	fb_info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	ret = fb_alloc_cmap(&fb_info->cmap, 256, 0);
 	if (ret < 0) {
-- 
1.6.2.5

