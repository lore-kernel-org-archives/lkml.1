Return-Path: <linux-kernel-owner+w=401wt.eu-S1750926AbXBUXlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926AbXBUXlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXBUXlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:41:01 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:39611 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbXBUXk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:40:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aDWQDAOPRGrchTg1bCh3BdrjmzEabN5ZzmWFlm7L7KytmArGzcbp2wNNh8HGyl91YbHb4pjRM4UUl6t57n6auXuBS87gk8u8UyCUInOlFcjIrKvJ7t8y4OTQR0G25O4wBfuqBe+yejejq0bopoem4xVqeb1jSzclnS1RXFR65sk=
Subject: Re: [Linux-fbdev-devel] [PATCH 2.6.20 1/1] fbdev, mm: hecuba/E-Ink
	fbdev driver
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       James Simmons <jsimmons@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <45a44e480702210855t344441c1xf8e081c82ece4e63@mail.gmail.com>
References: <20070217104215.GB25512@localhost>
	 <1171715652.5186.7.camel@lappy>
	 <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
	 <20070217135922.GA15373@linux-sh.org>
	 <45a44e480702180331t7e76c396j1a9861f689d4186b@mail.gmail.com>
	 <20070218235741.GA22298@linux-sh.org>
	 <45a44e480702192013s7d49d05ai31e576f0448a485e@mail.gmail.com>
	 <Pine.LNX.4.62.0702200906070.2082@pademelon.sonytel.be>
	 <45a44e480702210855t344441c1xf8e081c82ece4e63@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 07:43:36 +0800
Message-Id: <1172101416.4217.19.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 11:55 -0500, Jaya Kumar wrote: 
> On 2/20/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > Don't you need a way to specify the maximum deferral time? E.g. a field in
> > fb_info.
> >
> 
> You are right. I will need that. I could put that into struct
> fb_deferred_io. So drivers would setup like:
> 

Is it also possible to let the drivers do the 'deferred_io'
themselves?  Say, a driver that would flush the dirty pages on
every VBLANK interrupt.

> static struct fb_deferred_io hecubafb_defio = {
>         .delay          = HZ,
>         .deferred_io    = hecubafb_dpy_update,
> };
> 
> where that would be:
> struct fb_deferred_io {
>         unsigned long delay;    /* delay between mkwrite and deferred handler */
>         struct mutex lock;      /* mutex that protects the page list */
>         struct list_head pagelist;      /* list of touched pages */
>         struct delayed_work deferred_work;
>         void (*deferred_io)(struct fb_info *info, struct list_head
> *pagelist); /* callback */
> };
> 
> and the driver would do:
> ...
> info->fbdefio = hecubafb_defio;
> register_framebuffer...
> 
> When the driver calls register_framebuffer and unregister_framebuffer,
> I can then do the init and destruction of the other members of that
> struct. Does this sound okay?

It would be better if separate registering functions are created for
this functionality (ie deferred_io_register/unregister).

Tony


