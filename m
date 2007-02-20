Return-Path: <linux-kernel-owner+w=401wt.eu-S964960AbXBTO7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbXBTO7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964971AbXBTO7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:59:45 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37068 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964960AbXBTO7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:59:44 -0500
Date: Tue, 20 Feb 2007 15:59:43 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Kai Germaschewski <kai.germaschewski@unh.edu>,
       Hansjoerg Lipp <hjlipp@web.de>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: Kbuild problem
Message-ID: <20070220145943.GU13958@stusta.de>
References: <45D74B46.3090602@imap.cc> <Pine.LNX.4.44.0702180017170.1150-100000@localhost.localdomain> <20070218104028.GU13958@stusta.de> <45DAFE0B.1070305@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DAFE0B.1070305@imap.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 02:56:27PM +0100, Tilman Schmidt wrote:
> Adrian Bunk schrieb:
> > On Sun, Feb 18, 2007 at 12:22:10AM -0500, Kai Germaschewski wrote:
> >> On Sat, 17 Feb 2007, Tilman Schmidt wrote:
> >> 
> >> > asyncdata.o is only needed for M105 and M101, not for the base
> >> > driver. How do I express in Kbuild that asyncdata.o is to be added
> >> > to gigaset-y only if CONFIG_GIGASET_M105 and CONFIG_GIGASET_M101
> >> > are not both 'n'?
> >> 
> >> The way this is typically done is via Kconfig. Add a config option 
> >> ASYNCDATA (actually something more descriptive/specific would be better), 
> >> add a "select ASYNCDATA" to the config options for m101 and m105, and then 
> >> you can use CONFIG_ASYNCDATA to decide whether to add asyncdata.o in the 
> >> Makefile.
> > 
> > One disadvantage of this approach is that in a kernel with 
> > CONFIG_GIGASET_BASE=y, you can't later compile and load the usb_gigaset 
> > or ser_gigaset modules without rebooting since they require a change to 
> > the kernel image.
> 
> You've got a point there. So linking asyncdata.o into the modules that
> need it, as it is currently done, would perhaps be better after all?
> The original problem (asyncdata.o linked in twice, causing duplicate
> symbol definitions) could be fixed with this (admittedly somewhat
> awkward) change to the Makefile (build tested):
> 
> --- linux-2.6.20-mm1-work/drivers/isdn/gigaset/Makefile 2007-02-20 13:39:44.000000000 +0100
> +++ u/drivers/isdn/gigaset/Makefile     2007-02-20 13:38:58.000000000 +0100
> @@ -1,7 +1,10 @@
>  gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o
>  usb_gigaset-y := usb-gigaset.o asyncdata.o
>  bas_gigaset-y := bas-gigaset.o isocdata.o
> -ser_gigaset-y := ser-gigaset.o asyncdata.o
> +ser_gigaset-y := ser-gigaset.o
> +ifneq ($(CONFIG_GIGASET_M101)$(CONFIG_GIGASET_M105),yy)
> +ser_gigaset-y += asyncdata.o
> +endif

What happens with CONFIG_GIGASET_M101=y, CONFIG_GIGASET_M105=m ?

>  obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
>  obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
> 
> The alternative would be to always link asyncdata.o into the gigaset
> module whether it's needed or not. "size asyncdata.o" says:
>    text    data     bss     dec     hex filename
>    4200       0       0    4200    1068 asyncdata.o
> which appears tolerable.
> 
> Opinions?

I'm usually someone who likes to avoid including unneeded code in the 
kernel, but in this case I'd say KISS - and build it always into the 
gigaset module.

> Tilman Schmidt

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

