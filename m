Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbXFWXUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbXFWXUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 19:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXFWXUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 19:20:44 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:34794 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXFWXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 19:20:43 -0400
Date: Sun, 24 Jun 2007 01:20:33 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fbdev: uvesafb driver
Message-ID: <20070623232033.GB7148@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070623105243.GD12623@spock.one.pl> <20070623113557.f0295218.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070623113557.f0295218.akpm@linux-foundation.org>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 11:35:57AM -0700, Andrew Morton wrote:
> On Sat, 23 Jun 2007 12:52:43 +0200 Michal Januszewski <spock@gentoo.org> wrote:

> > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > index 403dac7..5cc03f9 100644
> > --- a/drivers/video/Kconfig
> > +++ b/drivers/video/Kconfig
> > @@ -585,6 +585,24 @@ config FB_TGA
> >  
> >  	  Say Y if you have one of those.
> >  
> > +config FB_UVESA
> > +	tristate "Userspace VESA VGA graphics support"
> > +	depends on FB && CONNECTOR
> 
> These dependencies are insufficient.

What exactly is missing here?  A dep on X86?  This would indicate the
arches on which the driver has actually been tested.  But which arches
are supported and which aren't is, in the end, up to the userspace helper.
 
> > +static struct cb_id uvesafb_cn_id = {
> > +	.idx = CN_IDX_V86D,
> > +	.val = CN_VAL_V86D_UVESAFB
> > +};
> > +static struct sock *nls;
> > +static char v86d_path[PATH_MAX] = "/sbin/v86d";
> 
> Remove the PATH_MAX, save some memory.
> 
> Oh, it gets set via sysfs.  hrm.

Hmm, I guess I could make it a hard-coded value, but paths to userspace 
helpers should generally be configurable, right?

> Now I'm wondering what this code actually does.  It would be nice to have
> an overall design and implementation description in the changelog so we
> don't have to reverse-engineer your thoughts from your implementation...

OK, I'll include a more detailed description in the next round of the
patches.
 
> > +#ifdef __i386__
> 
> CONFIG_X86 would be more typical.
> 
> Be aware that CONFIG_X86 is true for both i386 and x86_64.  You don't state
> whether this code works on x86_64.  If it can, it should.

AFAIK, it can't.  PMI code is meant to be run in 32-bit protected mode.
I'll add a note about this to the patch and change __i386__ to
CONFIG_X86_32.
 
> You might care to cc "H.  Peter Anvin" <hpa@zytor.com> on the next version
> of this patch - he's a whizz at this sort of low-level x86 bios
> communication stuff.

Thanks, I'll do that.
 
> > +	if (!request_mem_region(info->fix.smem_start, info->fix.smem_len,
> > +	    "uvesafb")) {
> > +		printk(KERN_WARNING "uvesafb: cannot reserve video memory at "
> > +		       "0x%lx\n", info->fix.smem_start);
> > +		/* We cannot make this fatal. Sometimes this comes from magic
> > +		   spaces our resource handlers simply don't know about. */
> 
> so...  what happens?  The driver starts altering mrmory regions which it
> doesn't own?

Fixed.  This was a leftover from vesafb.c.  Are there any reasons for not
fixing it there as well?
 
> > +#ifndef MODULE
> > +static int __devinit uvesafb_setup(char *options)
> > +{
> > +	char *this_opt;
> > +
> > +	if (!options || !*options)
> > +		return 0;
> > +
> > +	while ((this_opt = strsep(&options, ",")) != NULL) {
> > +		if (!*this_opt) continue;
> > +
> > +		if (!strcmp(this_opt, "redraw"))
> > +			ypan = 0;
> > +		else if (!strcmp(this_opt, "ypan"))
> > +			ypan = 1;
> > +		else if (!strcmp(this_opt, "ywrap"))
> > +			ypan = 2;
> > +		else if (!strcmp(this_opt, "vgapal"))
> > +			pmi_setpal = 0;
> > +		else if (!strcmp(this_opt, "pmipal"))
> > +			pmi_setpal = 1;
> > +		else if (!strncmp(this_opt, "mtrr:", 5))
> > +			mtrr = simple_strtoul(this_opt+5, NULL, 0);
> > +		else if (!strcmp(this_opt, "nomtrr"))
> > +			mtrr = 0;
> > +		else if (!strcmp(this_opt, "nocrtc"))
> > +			nocrtc = 1;
> > +		else if (!strcmp(this_opt, "noedid"))
> > +			noedid = 1;
> > +		else if (!strcmp(this_opt, "noblank"))
> > +			blank = 0;
> > +		else if (!strncmp(this_opt, "vtotal:", 7))
> > +			vram_total = simple_strtoul(this_opt + 7, NULL, 0);
> > +		else if (!strncmp(this_opt, "vremap:", 7))
> > +			vram_remap = simple_strtoul(this_opt + 7, NULL, 0);
> > +		else if (!strncmp(this_opt, "maxhf:", 6))
> > +			maxhf = simple_strtoul(this_opt + 6, NULL, 0);
> > +		else if (!strncmp(this_opt, "maxvf:", 6))
> > +			maxvf = simple_strtoul(this_opt + 6, NULL, 0);
> > +		else if (!strncmp(this_opt, "maxclk:", 7))
> > +			maxclk = simple_strtoul(this_opt + 7, NULL, 0);
> > +		else if (!strncmp(this_opt, "vbemode:", 8))
> > +			vbemode = simple_strtoul(this_opt + 8, NULL,0);
> > +		else if (this_opt[0] >= '0' && this_opt[0] <= '9') {
> > +			mode_option = this_opt;
> > +		} else {
> > +			printk(KERN_WARNING
> > +			       "uvesafb: unrecognized option %s\n", this_opt);
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +#endif /* !MODULE */
> 
> The #ifdef MODULE is unpleasing.  Can we use module_param() here?  That'll
> work for both modular and non-modular case.

True, but it would also make uvesafb the only (?) fb driver that
doesn't support the "video=smthfb:<options>" way of setting options.
Unless it's considered deprecated, I think it would be best to leave
it as it is, for the sake of consistency.
 
Thanks for all your comments & suggestions, and I'm sorry for the screw-up
with checkpatch.pl.  I've fixed the code in my git tree and the updates
will be included in the next version of this patch.

Best regards,
Michal

