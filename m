Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYHDPEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYHDPEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYHDPEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:04:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:10166 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYHDPD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:03:59 -0400
X-IronPort-AV: E=Sophos;i="4.31,304,1215388800"; 
   d="scan'208";a="1277002"
Date: Mon, 4 Aug 2008 16:03:53 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: ext3 seems to ignore ECC errors
Message-ID: <20080804150353.GS4470@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 04 Aug 2008 15:03:53.0534 (UTC) FILETIME=[4F654DE0:01C8F643]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am having qemu report to its guest that a device is read-only (because
the backend format, file or device is) by returning ECC errors instead
of letting the guest believe that the writes went fine, see patch below.

However, to my surprise Linux (2.6.26) continued to mount the ext3
filesystem read/write, spitting out a lot of IDE errors.  Shouldn't
filesystems remount read-only and let the admin try to save data in such
case?

Samuel

Index: hw/ide.c
===================================================================
--- hw/ide.c	(révision 4938)
+++ hw/ide.c	(copie de travail)
@@ -891,7 +891,6 @@
     return 1;
 }
 
-/* XXX: handle errors */
 static void ide_read_dma_cb(void *opaque, int ret)
 {
     BMDMAState *bm = opaque;
@@ -899,6 +898,14 @@
     int n;
     int64_t sector_num;
 
+    if (ret) {
+        s->status = READY_STAT | ERR_STAT;
+        s->error = ABRT_ERR | ECC_ERR;
+        s->nsector = 0;
+        ide_set_irq(s);
+        goto eot;
+    }
+
     n = s->io_buffer_size >> 9;
     sector_num = ide_get_sector(s);
     if (n > 0) {
@@ -992,7 +999,6 @@
     }
 }
 
-/* XXX: handle errors */
 static void ide_write_dma_cb(void *opaque, int ret)
 {
     BMDMAState *bm = opaque;
@@ -1000,6 +1006,14 @@
     int n;
     int64_t sector_num;
 
+    if (ret) {
+        s->status = READY_STAT | ERR_STAT;
+        s->error = ABRT_ERR | ECC_ERR;
+        s->nsector = 0;
+        ide_set_irq(s);
+        goto eot;
+    }
+
     n = s->io_buffer_size >> 9;
     sector_num = ide_get_sector(s);
     if (n > 0) {
