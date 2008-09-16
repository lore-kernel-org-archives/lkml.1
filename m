Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYIPTaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYIPTaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYIPTaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:30:12 -0400
Received: from esentire.com ([64.7.150.32]:52940 "EHLO eSentire.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbYIPTaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:30:11 -0400
X-Greylist: delayed 698 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 15:30:11 EDT
Message-ID: <48D0067F.3020007@esentire.com>
Date: Tue, 16 Sep 2008 15:18:23 -0400
From: Jonathan Steel <jon.steel@esentire.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080609)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kexec, kernel 2.6.26.5, segmentation fault in kimage_add_entry
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A segmentation fault can occur in kimage_add_entry in kexec.c when 
loading a kernel image into memory. The fault occurs because a page is 
requested by calling kimage_alloc_page with gfp_mask GFP_KERNEL and the 
function may actually return a page with gfp_mask GFP_HIGHUSER. The high 
mem page is returned because it was swapped with the kernel page due to 
the kernel page being a page that will shortly be copied to.

This patch ensures that kimage_alloc_page returns a page that was 
created with the correct gfp flags.

--- linux-2.6.26.5.orig/kernel/kexec.c    2008-09-16 13:17:56.000000000 
-0400
+++ linux-2.6.26.5/kernel/kexec.c    2008-09-16 13:26:35.000000000 -0400
@@ -743,8 +743,15 @@ static struct page *kimage_alloc_page(st
             *old = addr | (*old & ~PAGE_MASK);
 
             /* The old page I have found cannot be a
-             * destination page, so return it.
-             */
+             * destination page, so return it if its
+             * gfp_flags honor the ones passed in.
+            */
+            if (!(gfp_mask & __GFP_HIGHMEM) &&
+                    PageHighMem(old_page)) {
+                kimage_free_pages(old_page);
+                continue;
+            }
+
             addr = old_addr;
             page = old_page;
             break;

Signed-off-by: Jonathan Steel <jon.steel@esentire.com>

Jonathan Steel
