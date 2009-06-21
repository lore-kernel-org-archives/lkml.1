Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZFUTsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZFUTsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 15:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZFUTrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 15:47:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbZFUTru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 15:47:50 -0400
Date: Sun, 21 Jun 2009 12:47:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Lutomirski <luto@mit.edu>
cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>,
       Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>  <4A3DABE1.50309@mit.edu>  <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>  <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>  <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Jun 2009, Andrew Lutomirski wrote:
> >
> > Anyway, here's a totally UNTESTED patch that hopefully gives a warning on
> > where exactly we set the invalid bits. Andy, mind trying it out? You
> > should get the warnign much earlier, and it should have a much more useful
> > back-trace.
> 
> Your patch worked.  Photo attached.

Ok.

So it's fb_mmap() that uses an invalid page frame number when it does the 
"io_remap_pfn_range()" thing. 

And the way it gets that page frame number is basically

 - Offset (in bytes) from start of mapping:

	off = vma->vm_pgoff << PAGE_SHIFT;
	..

 - frame buffer start address:

        /* frame buffer memory */
        start = info->fix.smem_start;
        len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.smem_len);
	..
	off += start;

 - do the remap:

	io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT, ..

and there has been no changes to this logic in drivers/video/fbmem.c 
lately.

What *has* changed is that we have a newradeon driver, and it looks like 
that new radeon driver is crap, and does this:

	info->fix.smem_start = (unsigned long)fbptr;

which is totally screwed up. It assigns a _virtual_ address to that 
"smem_start" thing, even though it should be a physical one. 

I don't know the radeon driver, so I don't know where to find the physical 
address.  It's also possible that there is no good single physical 
address, and the radeon driver should implement a "fb_mmap" function.

Does this patch make the warning and the oops at least go away? Obviously 
it won't result in a working frame buffer, but that's a separate issue

		Linus

---
 drivers/gpu/drm/radeon/radeon_fb.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index fa86d39..4aa151e 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -380,6 +380,14 @@ int radeonfb_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
+/*
+ * Not yet implemented. The fix.smem_start is crap.
+ */
+static int radeonfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	return -EINVAL;
+}
+
 static struct fb_ops radeonfb_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = radeonfb_check_var,
@@ -390,6 +398,7 @@ static struct fb_ops radeonfb_ops = {
 	.fb_imageblit = cfb_imageblit,
 	.fb_pan_display = radeonfb_pan_display,
 	.fb_blank = radeonfb_blank,
+	.fb_mmap = radeonfb_mmap,
 };
 
 /**
