Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbYDVR4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbYDVR4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763402AbYDVRzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:55:55 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:34364 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763232AbYDVRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:55:53 -0400
X-IronPort-AV: E=Sophos;i="4.25,695,1199682000"; 
   d="scan'208";a="52340976"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: [PATCH] mm/nommu.c - return 0 from kobjsize with invalid objects
Date: Tue, 22 Apr 2008 13:56:15 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "David Howells" <dhowells@redhat.com>,
       Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221356.15748.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 22 Apr 2008 17:55:50.0286 (UTC) FILETIME=[19B2BAE0:01C8A4A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <Michael.Hennerich@analog.com>

Don't perform kobjsize operations on objects the kernel doesn't manage.

Signed-off-by: Michael Hennerich <Michael.Hennerich@analog.com>
Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

---
On Blackfin, drivers can get dma coherent memory by calling a function
dma_alloc_coherent(). We do this in nommu by configuring a chunk of uncached
memory at the top of memory.

Since we don't want the kernel to use the uncached memory, we lie to the
kernel, and tell it that it's max memory is between 0, and the start of the
uncached dma coherent section.

this all works well, until this memory gets exposed into userspace (with a
frame buffer), when you look at the process's maps, it shows the framebuf:

root:/proc> cat maps
[snip]
03f0ef00-03f34700 rw-p 00000000 1f:00 192        /dev/fb0
root:/proc>

This is outside the "normal" range for the kernel. When the kernel tries to
find the size of this object (when you run ps), it dies in nommu.c in
kobjsize.

BUG_ON(page->index >= MAX_ORDER);

since the page we are referring to is outside what the kernel thinks is it's
max valid memory.

root:~> while [ 1 ]; ps > /dev/null; done
kernel BUG at mm/nommu.c:119!
Kernel panic - not syncing: BUG!

We fixed this by adding a check to reject out of range object pointers as it
already does that for NULL pointers.

----

--- linux/mm/nommu.c	2008-04-16 21:00:20.000000000 -0400
+++ linux/mm/nommu.c	2008-04-22 13:39:04.000000000 -0400
@@ -105,7 +106,11 @@
 {
 	struct page *page;
 
-	if (!objp || !((page = virt_to_page(objp))))
+	/*
+	 * If the object we have should not have ksize performed on it,
+	 * return size of 0
+	 */
+	if (!objp || !((page = virt_to_page(objp))) || (unsigned long)objp >= memory_end)
 		return 0;
 
 	if (PageSlab(page))
