Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbXEINp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbXEINp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbXEINpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:45:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:16151 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbXEINpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eE9c7iPksEKImyxIqWH7kpmY7pc7W4Kj04JKQeLsvEwbb1OTgcJcRAOra7BuIfvPB4tH8Zch6BBQRMevtqGHGwd0UOXzleqhT6bbtD0s0kzmsPXBrUsiC5BbfB6433+XwKHWPfOjuEOW2nXH5zQRIGmOcMrEGAq+2Z9U05QYzh8=
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070509085434.GA13712@mailshack.com>
References: <20070505104452.GA30944@mailshack.com>
	 <20070508032817.e4734798.akpm@linux-foundation.org>
	 <20070508183232.GA13225@mailshack.com> <1178669047.4747.15.camel@daplas>
	 <20070509085434.GA13712@mailshack.com>
Content-Type: text/plain
Date: Wed, 09 May 2007 21:45:00 +0800
Message-Id: <1178718300.4861.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 10:54 +0200, Alexander van Heukelum wrote:
> On Wed, May 09, 2007 at 08:04:07AM +0800, Antonino A. Daplas wrote:
> > On Tue, 2007-05-08 at 20:32 +0200, Alexander van Heukelum wrote:
> > > diff --git a/arch/i386/boot/bootsect.S b/arch/i386/boot/bootsect.S
> > > diff --git a/arch/i386/boot/video.S b/arch/i386/boot/video.S
> > > index 8143c95..8e404cb 100644
> > > --- a/arch/i386/boot/video.S
> > > +++ b/arch/i386/boot/video.S
> > > @@ -95,7 +95,8 @@ #define PARAM_VESAPM_SEG	0x2e
> > >  #define PARAM_VESAPM_OFF	0x30
> > >  #define PARAM_LFB_PAGES		0x32
> > >  #define PARAM_VESA_ATTRIB	0x34
> > > -#define PARAM_CAPABILITIES	0x36
> > > +#define PARAM_VESA_PAD		0x36
> > > +#define PARAM_CAPABILITIES	0x38
> > >  
> > >  /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
> > >  #ifdef CONFIG_VIDEO_RETAIN
> > > diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
> > > index b02308e..0a2e892 100644
> > > --- a/include/linux/screen_info.h
> > > +++ b/include/linux/screen_info.h
> > > @@ -41,8 +41,8 @@ struct screen_info {
> > >  	u16 vesapm_off;		/* 0x30 */
> > >  	u16 pages;		/* 0x32 */
> > >  	u16 vesa_attributes;	/* 0x34 */
> > > -	u32 capabilities;       /* 0x36 */
> > > -				/* 0x3a -- 0x3b reserved for future expansion */
> > > +	u16 vesa_pad;		/* 0x36 */
> > > +	u32 capabilities;       /* 0x38 */
> > >  				/* 0x3c -- 0x3f micro stack for relocatable kernels */
> > >  };
> > >  
> > 
> > You would also need this minor change.
> > 
> > Tony
> > 
> > diff --git a/arch/i386/boot/video.S b/arch/i386/boot/video.S
> > index 5e2280c..2d637d1 100644
> > --- a/arch/i386/boot/video.S
> > +++ b/arch/i386/boot/video.S
> > @@ -95,7 +95,7 @@ #define PARAM_VESAPM_SEG      0x2e
> >  #define PARAM_VESAPM_OFF       0x30
> >  #define PARAM_LFB_PAGES                0x32
> >  #define PARAM_VESA_ATTRIB      0x34
> > -#define PARAM_CAPABILITIES     0x36
> > +#define PARAM_CAPABILITIES     0x38
> >  
> >  /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
> >  #ifdef CONFIG_VIDEO_RETAIN
> 
> Hi!
> 
> I'm making coffee now. I just don't see what I missed? Maybe you were
> led astray by the new PARAM_VESA_PAD I added?

Since you moved screen_info.capabilities forward by 2 bytes, you must
also tell video.S where to poke for the new location, otherwise, vesafb
(which uses the capabilities field) will get confused.

These are the values for the unadjusted and adjusted PARAM_CAPABILITIES:
(The latter one is correct).

capabilities: 746f0000
capabilities: 1

Tony


