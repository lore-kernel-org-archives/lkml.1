Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYDWS6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYDWS6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYDWS63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:58:29 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:45086 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYDWS62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:58:28 -0400
X-IronPort-AV: E=Sophos;i="4.25,700,1199682000"; 
   d="scan'208";a="66993446"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] mm/nommu.c - return 0 from kobjsize with invalid objects
Date: Wed, 23 Apr 2008 14:58:53 -0400
User-Agent: KMail/1.9.5
Cc: "Greg Ungerer" <gerg@snapgear.com>, linux-kernel@vger.kernel.org,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
References: <200804221356.15748.rgetz@blackfin.uclinux.org> <8682.1208900110@redhat.com>
In-Reply-To: <8682.1208900110@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231458.53282.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 23 Apr 2008 18:58:27.0048 (UTC) FILETIME=[0350DE80:01C8A574]
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

As pointed out by David Howells on Tue 22 Apr 2008 17:35, the first
version I sent could still have a problem:
> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
> > +	if (!objp || !((page = virt_to_page(objp))) || (unsigned long)objp >= memory_end)
> 
> You should probably do the additional test before calling
> virt_to_page(), just in case the illegal value you've 
> rejected would otherwise break virt_to_page()

True enough... try that one again.

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
+	if (!objp || (unsigned long)objp >= memory_end || !((page = virt_to_page(objp))))
 		return 0;
 
 	if (PageSlab(page))
