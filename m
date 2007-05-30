Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbXE3XPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbXE3XPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXE3XO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:14:57 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:62486 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXE3XO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:14:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sCuspc4lvQVEJPDEbScXowIxXerNJD501YKtcop63mGS0ZN3QxYySwsQ6ZxPIxGXZamvt1IJETvzEVJ9ZWTatu8bmeckM0XcF6rI4i85TfjqTrHnESfEjp7G0IgAG29IEI/v3dYOjcX32YflnyWB6flzjBNHTPX81mxEap5NXVY=
Subject: Re: tty-related oops in latest kernel(s)?
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tero Roponen <teanropo@jyu.fi>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20070530180428.GA5731@martell.zuzino.mipt.ru>
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
Content-Type: text/plain
Date: Thu, 31 May 2007 07:14:46 +0800
Message-Id: <1180566886.4570.14.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 22:04 +0400, Alexey Dobriyan wrote:
> On Wed, May 30, 2007 at 09:09:45AM -0700, Andrew Morton wrote:
> > On Wed, 30 May 2007 19:01:09 +0300 (EEST) Tero Roponen <teanropo@jyu.fi> wrote:
> > 
> > > On Wed, 30 May 2007, Andrew Morton wrote:
> > > 
> > > > On Wed, 30 May 2007 15:02:49 +0300 (EEST) Tero Roponen <teanropo@jyu.fi> wrote:
> > > > 
> > > > > On Wed, 30 May 2007, Pekka Enberg wrote:
> > > > > 
> > > > > > On 5/30/07, Tero Roponen <teanropo@jyu.fi> wrote:
[snip]
> Two suspicious things for me:
> 
> 1)
> 
> --- a/drivers/video/neofb.c
> +++ b/drivers/video/neofb.c
> @@ -1295,7 +1295,7 @@ static int neofb_setcolreg(u_int regno, 
>  		outb(blue >> 10, 0x3c9);
>  		break;
>  	case 16:
> -		((u32 *) fb->pseudo_palette)[regno] =
> +		((u16 *) fb->pseudo_palette)[regno] =

u32 is correct.

>  				((red & 0xf800)) | ((green & 0xfc00) >> 5) |
>  				((blue & 0xf800) >> 11);
>  		break;
> 
> 
> 
> 2) palette in neofb_par is "u32 palette[16];" which is 4x16 = 64 bytes.
>    struct fb_info::pseudo_palette is assigned to it in neo_alloc_fb_info().
>    Yet, we check at the beginning of neofb_setcolreg() for color map
>    length which neofb advertises as 256 which seems too many.
> 

Yes, 256 is too many. the pseudo_palette is used for the 16-color
console only.

I'm impressed that this bug has escaped notice for this long. That bug
is present since the 2.5.x era.

Probably, the best thing to do is hide the pseudo_palette from the
drivers and move it to the console layer where it belongs to spare
future driver writers from palette usage confusion. That will be a
thankless job.

Tony


