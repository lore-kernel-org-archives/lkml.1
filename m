Return-Path: <linux-kernel-owner+w=401wt.eu-S938809AbXG1CPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938809AbXG1CPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938439AbXG1CO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:14:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:20298 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933855AbXG1CO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Gd8mFNKx1LMZFTcjJZz1rhJnzyleSgzIELtZK8s0lh4EgcOxh7TGIVAOMX+3xz5tfnviAmBxRUaA2KhEx3HJDIziF8yrtiUPjB9wCM6SjsOb9z42CdQRzhQAulpI3tnCt/lvx+efCIYcojMBpAar0H5WEgm2StL1FHuzCokAnAI=
Subject: Re: Problems with framebuffer in 2.6.22-git17
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <92a12cdb0707271806q60fcaa91s77a628b31cd65b4d@mail.gmail.com>
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
	 <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
	 <92a12cdb0707271318t141ee32bs69cb9dab22eabba2@mail.gmail.com>
	 <1185571890.26603.7.camel@daplas>
	 <92a12cdb0707271525i46970157ke1b2b2e6575682d6@mail.gmail.com>
	 <1185578576.26603.16.camel@daplas>
	 <92a12cdb0707271732l1d61f0aajfbd72c62d7ded3b6@mail.gmail.com>
	 <1185583925.26603.24.camel@daplas>
	 <92a12cdb0707271806q60fcaa91s77a628b31cd65b4d@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 10:14:46 +0800
Message-Id: <1185588887.26603.42.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-28 at 02:06 +0100, Adrian McMenamin wrote:
> On 28/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> 
> >
> But certainly better at 16bpp
> 
> Can mess about with it later to see if I can get the colours right I suppose.
> 

You can start with pvr2fb_setcolreg() and pvr2fb_set_pal_entry().

A few things I've noticed:

1. In pvr2fb_setcolreg(), pvr2fb_set_pal_entry() is called for bpp 16
and 32.  This means that the palette is modifiable, so
FB_VISUAL_TRUECOLOR is probably not the correct visual for this driver,
FB_VISUAL_DIRECTCOLOR is more appropriate.

So, you either remove the call to set_pal_entry() in setcolreg() or
change the visual to FB_VISUAL_DIRECTCOLOR. Of course, with directcolor,
the pseudo_palette is now written with tmp as:

tmp = transp << var->transp.offset | red << var->red.offset |
	green << var->green.offset | blue << var->green.offset;
 

2. Perhaps, the 3rd parameter passed to set_pal_entry() is not  correct?
Maybe you can try doing it like this for all bpp's, assuming ARGB?

pvr2fb_set_pal_entry(par, regno, transp << 24 | red << 16 | green << 8 |
			blue);

And if you want to maintain FB_VISUAL_TRUECOLOR format, initialize the
palette once on init:

for (i = 0; i < 256; i++)
	pvr2fb_set_pal_entry(par, i, i << 24 | i << 16 | i << 8 | i);

to create a linear color map consistent with truecolor, then remove all
other calls to pvr2fb_set_pal_entry().

Tony


