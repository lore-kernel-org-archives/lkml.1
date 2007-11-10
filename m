Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbXKJArm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbXKJArm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 19:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXKJAre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 19:47:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbXKJArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 19:47:33 -0500
Date: Fri, 9 Nov 2007 16:47:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank Lichtenheld <frank@lichtenheld.de>
Cc: spock@gentoo.org, linux-kernel@vger.kernel.org, frank@lichtenheld.de,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] uvesafb: Fix warnings about unused variables on non-x86
Message-Id: <20071109164713.f31c6cd1.akpm@linux-foundation.org>
In-Reply-To: <1194563299-19768-1-git-send-email-frank@lichtenheld.de>
References: <1194563299-19768-1-git-send-email-frank@lichtenheld.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Nov 2007 00:08:19 +0100
Frank Lichtenheld <frank@lichtenheld.de> wrote:

> Variables that are only used in #ifdef CONFIG_X86 should also
> only be declared there.
> 
> Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
> ---
>  drivers/video/uvesafb.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> index b983d26..d1d6c0f 100644
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
> @@ -926,8 +926,10 @@ static int uvesafb_setpalette(struct uvesafb_pal_entry *entries, int count,
>  		int start, struct fb_info *info)
>  {
>  	struct uvesafb_ktask *task;
> +#ifdef CONFIG_X86
>  	struct uvesafb_par *par = info->par;
>  	int i = par->mode_idx;
> +#endif
>  	int err = 0;
>  
>  	/*
> @@ -1103,11 +1105,11 @@ static int uvesafb_pan_display(struct fb_var_screeninfo *var,
>  
>  static int uvesafb_blank(int blank, struct fb_info *info)
>  {
> -	struct uvesafb_par *par = info->par;
>  	struct uvesafb_ktask *task;
>  	int err = 1;
> -
>  #ifdef CONFIG_X86
> +	struct uvesafb_par *par = info->par;
> +
>  	if (par->vbe_ib.capabilities & VBE_CAP_VGACOMPAT) {
>  		int loop = 10000;
>  		u8 seq = 0, crtc17 = 0;

OK, but ug.  That's some quite nasty code you've found there.

it would come out better if that x86-specific code was pulled out into
separate functions like

#ifdef CONFIG_X86
static int do_x86_stuff(...)
{
	...
	return 1;
}
#else
static int do_x86_stuff(...)
{
	return 0;
}
#endif


static int uvesafb_setpalette(...)
{
	if (do_x86_stuff(...) == 0) {
		<do non-x86-specific-stuff>
	}
}

