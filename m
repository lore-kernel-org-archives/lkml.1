Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZFUWk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZFUWk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 18:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZFUWkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 18:40:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60371 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZFUWkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 18:40:18 -0400
Date: Sun, 21 Jun 2009 23:40:18 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Lutomirski <luto@mit.edu>, Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <4A3DABE1.50309@mit.edu> <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie> <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain> <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com> <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> On Sun, 21 Jun 2009, Andrew Lutomirski wrote:
> > >
> > > Anyway, here's a totally UNTESTED patch that hopefully gives a warning on
> > > where exactly we set the invalid bits. Andy, mind trying it out? You
> > > should get the warnign much earlier, and it should have a much more useful
> > > back-trace.
> > 
> > Your patch worked.  Photo attached.
> 
> Ok.
> 
> So it's fb_mmap() that uses an invalid page frame number when it does the 
> "io_remap_pfn_range()" thing. 
> 
> And the way it gets that page frame number is basically
> 
>  - Offset (in bytes) from start of mapping:
> 
> 	off = vma->vm_pgoff << PAGE_SHIFT;
> 	..
> 
>  - frame buffer start address:
> 
>         /* frame buffer memory */
>         start = info->fix.smem_start;
>         len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.smem_len);
> 	..
> 	off += start;
> 
>  - do the remap:
> 
> 	io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT, ..
> 
> and there has been no changes to this logic in drivers/video/fbmem.c 
> lately.
> 
> What *has* changed is that we have a newradeon driver, and it looks like 
> that new radeon driver is crap, and does this:
> 
> 	info->fix.smem_start = (unsigned long)fbptr;
> 
> which is totally screwed up. It assigns a _virtual_ address to that 
> "smem_start" thing, even though it should be a physical one. 
> 
> I don't know the radeon driver, so I don't know where to find the physical 
> address.  It's also possible that there is no good single physical 
> address, and the radeon driver should implement a "fb_mmap" function.
> 
> Does this patch make the warning and the oops at least go away? Obviously 
> it won't result in a working frame buffer, but that's a separate issue
> 
> 		Linus

I noticed the same bogus line myself last night, I'll get Jerome to look 
at it since its his code, he was trying to be smart about how the 
radeon fbdev emulation should work, but fbdev isn't smart enough to do 
what he wants, so I've asked him to go back to the dumb pin the fbcon in 
VRAM until we can fix fbdev to do some sort of prepare/commit type hooks 
around blocks of reads/writes.

With the safe method we end up with an 8MB pinned fbcon on 32MB in some 
scenarios, which is still totally unacceptable from a user pov.

Btw this driver is under staging for a good reason, nobody claimed it was 
perfect, we just said we felt it was a good baseline to build the final 
driver on top off. Maybe I can add 
CONFIG_DONT_CC_LINUS_ON_STAGING_DRIVERS.

Dave.

 > 
> ---
>  drivers/gpu/drm/radeon/radeon_fb.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
> index fa86d39..4aa151e 100644
> --- a/drivers/gpu/drm/radeon/radeon_fb.c
> +++ b/drivers/gpu/drm/radeon/radeon_fb.c
> @@ -380,6 +380,14 @@ int radeonfb_blank(int blank, struct fb_info *info)
>  	return 0;
>  }
>  
> +/*
> + * Not yet implemented. The fix.smem_start is crap.
> + */
> +static int radeonfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
> +{
> +	return -EINVAL;
> +}
> +
>  static struct fb_ops radeonfb_ops = {
>  	.owner = THIS_MODULE,
>  	.fb_check_var = radeonfb_check_var,
> @@ -390,6 +398,7 @@ static struct fb_ops radeonfb_ops = {
>  	.fb_imageblit = cfb_imageblit,
>  	.fb_pan_display = radeonfb_pan_display,
>  	.fb_blank = radeonfb_blank,
> +	.fb_mmap = radeonfb_mmap,
>  };
>  
>  /**
> 
> ------------------------------------------------------------------------------
> Are you an open source citizen? Join us for the Open Source Bridge conference!
> Portland, OR, June 17-19. Two days of sessions, one day of unconference: $250.
> Need another reason to go? 24-hour hacker lounge. Register today!
> http://ad.doubleclick.net/clk;215844324;13503038;v?http://opensourcebridge.org
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
> 
