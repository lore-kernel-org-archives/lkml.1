Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZA1SE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZA1SE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZA1SEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:04:49 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43211 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZA1SEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:04:47 -0500
Date: Wed, 28 Jan 2009 10:04:46 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] firmware: speed up request_firmware()
Message-ID: <20090128180446.GB31107@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 28 Jan 2009 10:04:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to load a large file with request_firmware() is currently very slow,
due to calling vmalloc() for each write. This patch makes the allocations
double in size each time.

Without this patch, loading a 12MB firmware image (FPGA bitfiles) called
vmalloc() approximately 3000 times. With the patch, vmalloc() is only
called 13 times, however, some memory is wasted until firmware_release() is
called. Usually, this happens very quickly, so it shouldn't be a problem.

Without this patch, it took about 2 1/2 minutes to load the 12MB firmware
image. With the patch, it now takes about 1/2 second.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/base/firmware_class.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b7e5710..a947a88 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -207,7 +207,12 @@ fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 	if (min_size <= fw_priv->alloc_size)
 		return 0;
 
-	new_size = ALIGN(min_size, PAGE_SIZE);
+	/* Allocate double the current size. If that is not enough, allocate
+	 * the minimum amount needed instead (aligned to PAGE_SIZE). */
+	new_size = fw_priv->alloc_size * 2;
+	if (new_size < min_size)
+		new_size = ALIGN(min_size, PAGE_SIZE);
+
 	new_data = vmalloc(new_size);
 	if (!new_data) {
 		printk(KERN_ERR "%s: unable to alloc buffer\n", __func__);
-- 
1.5.4.3

