Return-Path: <linux-kernel-owner+w=401wt.eu-S1161276AbXCGHeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161276AbXCGHeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161133AbXCGHbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:31:32 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44322 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161276AbXCGH14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:27:56 -0500
Date: Wed, 7 Mar 2007 12:50:08 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: [PATCH 16/20] swsusp: do not use virt_to_page on kernel data address
Message-ID: <20070307072008.GQ23412@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



o virt_to_page() call should be used on kernel linear addresses and not
  on kernel text and data addresses. Swsusp code uses it on kernel data
  (statically allocated swsusp_header).

o Allocate swsusp_header dynamically so that virt_to_page() can be used
  safely.

o I am changing this because in next few patches, __pa() on x86_64 will
  no longer support kernel text and data addresses and hibernation breaks. 

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 kernel/power/swap.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff -puN kernel/power/swap.c~swsusp-do-not-use-virt_to_page-on-kernel-data-addr kernel/power/swap.c
--- linux-2.6.21-rc2-reloc/kernel/power/swap.c~swsusp-do-not-use-virt_to_page-on-kernel-data-addr	2007-03-07 01:30:43.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/kernel/power/swap.c	2007-03-07 01:30:43.000000000 +0530
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
_
