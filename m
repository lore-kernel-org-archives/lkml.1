Return-Path: <linux-kernel-owner+w=401wt.eu-S965159AbXBQKv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159AbXBQKv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965162AbXBQKv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:51:59 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60610 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965159AbXBQKv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:51:58 -0500
Date: Sat, 17 Feb 2007 11:52:03 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       kkeil@suse.de, kai.germaschewski@gmx.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: Kbuild problem (was: [2.6 patch] drivers/isdn/gigaset/: build asyncdata.o into the gigaset module)
Message-ID: <20070217105203.GR13958@stusta.de>
References: <20070215215638.GI13958@stusta.de> <45D4F80F.8040200@imap.cc> <20070216083339.GK13958@stusta.de> <45D64691.8070901@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D64691.8070901@imap.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 01:04:33AM +0100, Tilman Schmidt wrote:
> Am 16.02.2007 09:33 schrieb Adrian Bunk:
> >>> ...
> >>>   LD      drivers/isdn/gigaset/built-in.o
> >>> drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_send_skb':
> >>> (.text+0xe50): multiple definition of `gigaset_m10x_send_skb'
> >>> drivers/isdn/gigaset/usb_gigaset.o:(.text+0x0): first defined here
> >>> drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_input':
> >>> (.text+0x1121): multiple definition of `gigaset_m10x_input'
> >>> drivers/isdn/gigaset/usb_gigaset.o:(.text+0x2d1): first defined here
> >>> make[4]: *** [drivers/isdn/gigaset/built-in.o] Error 1
> 
> > CONFIG_ISDN_DRV_GIGASET=y
> > CONFIG_GIGASET_BASE=y
> > CONFIG_GIGASET_M105=y
> > CONFIG_GIGASET_M101=y
> 
> Ah, thanks, I can see what's happening now. When both the M101 and M105
> drivers are built into the kernel, asyncdata.o gets linked in twice, via
> 
> 	usb_gigaset-y := usb-gigaset.o asyncdata.o
> 	obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
> 
> and
> 
> 	ser_gigaset-y := ser-gigaset.o asyncdata.o
> 	obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o gigaset.o
> 
> The assertion in Documentation/kbuild/makefiles.txt:
> 
>         The order of files in $(obj-y) is significant.  Duplicates in
>         the lists are allowed: the first instance will be linked into
>         built-in.o and succeeding instances will be ignored.
> 
> doesn't work out in this case because asyncdata.o isn't added directly
> to $(obj-y), but as part of usb_gigaset.o and ser_gigaset.o.
> 
> I'm not quite happy with your solution, though. I'd prefer a
> Makefile which builds modular usb_gigaset.ko and/or ser_gigaset.ko
> like the present one (including asyncdata.o), but when linking
> usb-gigaset.o and ser-gigaset.o into the kernel includes asyncdata.o
> only once. Trouble is, I don't know how to express that in Kbuild.
> 
> Any ideas?

CONFIG_GIGASET_M105=y, CONFIG_GIGASET_M101=m and similar problems might 
make this quite tricky.

Shared functionality simply doesn't belong into any of the affected 
modules, but to a different place where all users can access it.

> Thanks,
> Tilman

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

