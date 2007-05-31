Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbXEaJE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbXEaJE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXEaJEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:04:48 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:21781 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbXEaJEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LQ4R5DWE6FrQ8he8qyacNEMR/w/Enls4jZ59xcjDxNn7a6X/PsmI5k0wpOe9vR/7NXkOQhRnKoLc+SL5dMRqkdVLADeD8FR05BnUSzwl5p+wK4cK5F/rzkRHgdG15I0HaB0TyFMwtYgNrKd3lhLIPAxpMe/HWZkVHxD1fE6Af1o=
Subject: Re: [Linux-fbdev-devel] tty-related oops in latest kernel(s)?
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tero Roponen <teanropo@jyu.fi>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <Pine.LNX.4.64.0705310916240.17047@anakin>
References: <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
	 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
	 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
	 <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com>
	 <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
	 <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
	 <Pine.LNX.4.64.0705301458400.4634@jalava.cc.jyu.fi>
	 <20070530083953.9909bcef.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi>
	 <20070530090945.ab9d51d9.akpm@linux-foundation.org>
	 <20070530180428.GA5731@martell.zuzino.mipt.ru>
	 <1180566886.4570.14.camel@daplas>
	 <Pine.LNX.4.64.0705310916240.17047@anakin>
Content-Type: text/plain
Date: Thu, 31 May 2007 17:04:38 +0800
Message-Id: <1180602278.4570.42.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-31 at 09:17 +0200, Geert Uytterhoeven wrote:
> On Thu, 31 May 2007, Antonino A. Daplas wrote:
> > On Wed, 2007-05-30 at 22:04 +0400, Alexey Dobriyan wrote:
> > > 2) palette in neofb_par is "u32 palette[16];" which is 4x16 = 64 bytes.
> > >    struct fb_info::pseudo_palette is assigned to it in neo_alloc_fb_info().
> > >    Yet, we check at the beginning of neofb_setcolreg() for color map
> > >    length which neofb advertises as 256 which seems too many.
> > > 
> > 
> > Yes, 256 is too many. the pseudo_palette is used for the 16-color
> > console only.
> > 
> > I'm impressed that this bug has escaped notice for this long. That bug
> > is present since the 2.5.x era.
> > 
> > Probably, the best thing to do is hide the pseudo_palette from the
> > drivers and move it to the console layer where it belongs to spare
> > future driver writers from palette usage confusion. That will be a
> > thankless job.
> 
> The console layer doesn't know how to fill in the pseudo palette in all
> cases, that's why the driver have to do it.
> 

I have actually started working on that.  It involves breaking down
fb_setcolreg() so it deals only with writing to the actual hardware
registers.  The part of fb_setcolreg() that adds entries to the
pseudo_palette can be separated as a new method, fb_get_pixel(), which
given red, blue, green, transp, the driver returns a u32 pixel value
that can be written to the pseudo_palette.

So fbcon can hold a copy of the pseudo_palette and fills it up by
calling info->fbops->fb_get_pixel() successively.

This will touch the logo code, the drawing libraries, each driver, etc
so it's a lot of work.  During the conversion period,  we support having
info->pseudo_palette and fbcon->pseudo_palette at the same time. Once
all drivers are converted, we can remove info->pseudo_palette.

One use for having an fb_get_pixel() method is we can use this as an
rgb888-image-to-raw-framebuffer-format converter.

Currently, I have only converted vesafb. Once the core code is done,
I'll start converting the rest of the drivers one by one.

Tony



