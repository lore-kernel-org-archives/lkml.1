Return-Path: <linux-kernel-owner+w=401wt.eu-S1163349AbXD1SBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163349AbXD1SBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163347AbXD1SB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:34694 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163354AbXD1R7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:59:05 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [17/22] x86_64: do not use virt_to_page on kernel data address
Message-Id: <20070428175904.AC9AF151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:59:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


o virt_to_page() call should be used on kernel linear addresses and not
  on kernel text and data addresses. Swsusp code uses it on kernel data
  (statically allocated swsusp_header).

o Allocate swsusp_header dynamically so that virt_to_page() can be used
  safely.

o I am changing this because in next few patches, __pa() on x86_64 will
  no longer support kernel text and data addresses and hibernation breaks. 

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 kernel/power/swap.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

Index: linux/kernel/power/swap.c
===================================================================
--- linux.orig/kernel/power/swap.c
+++ linux/kernel/power/swap.c
@@ -33,12 +33,14 @@ extern char resume_file[];
 
 #define SWSUSP_SIG	"S1SUSPEND"
 
-static struct swsusp_header {
+struct swsusp_header {
 	char reserved[PAGE_SIZE - 20 - sizeof(sector_t)];
 	sector_t image;
 	char	orig_sig[10];
 	char	sig[10];
-} __attribute__((packed, aligned(PAGE_SIZE))) swsusp_header;
+} __attribute__((packed));
+
+static struct swsusp_header *swsusp_header;
 
 /*
  * General things
@@ -141,14 +143,14 @@ static int mark_swapfiles(sector_t start
 {
 	int error;
 
-	bio_read_page(swsusp_resume_block, &swsusp_header, NULL);
-	if (!memcmp("SWAP-SPACE",swsusp_header.sig, 10) ||
-	    !memcmp("SWAPSPACE2",swsusp_header.sig, 10)) {
-		memcpy(swsusp_header.orig_sig,swsusp_header.sig, 10);
-		memcpy(swsusp_header.sig,SWSUSP_SIG, 10);
-		swsusp_header.image = start;
+	bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
+	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
+		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
+		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
+		swsusp_header->image = start;
 		error = bio_write_page(swsusp_resume_block,
-					&swsusp_header, NULL);
+					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "swsusp: Swap header not found!\n");
 		error = -ENODEV;
@@ -564,7 +566,7 @@ int swsusp_read(void)
 	if (error < PAGE_SIZE)
 		return error < 0 ? error : -EFAULT;
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = get_swap_reader(&handle, swsusp_header.image);
+	error = get_swap_reader(&handle, swsusp_header->image);
 	if (!error)
 		error = swap_read_page(&handle, header, NULL);
 	if (!error)
@@ -591,17 +593,17 @@ int swsusp_check(void)
 	resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_READ);
 	if (!IS_ERR(resume_bdev)) {
 		set_blocksize(resume_bdev, PAGE_SIZE);
-		memset(&swsusp_header, 0, sizeof(swsusp_header));
+		memset(swsusp_header, 0, sizeof(PAGE_SIZE));
 		error = bio_read_page(swsusp_resume_block,
-					&swsusp_header, NULL);
+					swsusp_header, NULL);
 		if (error)
 			return error;
 
-		if (!memcmp(SWSUSP_SIG, swsusp_header.sig, 10)) {
-			memcpy(swsusp_header.sig, swsusp_header.orig_sig, 10);
+		if (!memcmp(SWSUSP_SIG, swsusp_header->sig, 10)) {
+			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
 			error = bio_write_page(swsusp_resume_block,
-						&swsusp_header, NULL);
+						swsusp_header, NULL);
 		} else {
 			return -EINVAL;
 		}
@@ -632,3 +634,13 @@ void swsusp_close(void)
 
 	blkdev_put(resume_bdev);
 }
+
+static int swsusp_header_init(void)
+{
+	swsusp_header = (struct swsusp_header*) __get_free_page(GFP_KERNEL);
+	if (!swsusp_header)
+		panic("Could not allocate memory for swsusp_header\n");
+	return 0;
+}
+
+core_initcall(swsusp_header_init);
