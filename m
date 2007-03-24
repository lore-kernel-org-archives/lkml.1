Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbXCXPIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbXCXPIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 11:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXCXPIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 11:08:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33466 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752890AbXCXPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 11:08:04 -0400
Date: Sat, 24 Mar 2007 16:08:06 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Armin Schindler <armin@melware.de>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] fix ISDN_CAPI<->ISDN_DIVAS
Message-ID: <20070324150806.GA2078@stusta.de>
References: <20070324130622.GE752@stusta.de> <Pine.LNX.4.61.0703241442220.28244@phoenix.one.melware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703241442220.28244@phoenix.one.melware.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 02:49:42PM +0100, Armin Schindler wrote:
> On Sat, 24 Mar 2007, Adrian Bunk wrote:
> > Randy Dunlap reported in kernel Bugzilla #8241 the following compile 
> > error with CONFIG_ISDN_CAPI=m, CONFIG_ISDN_DIVAS=y:
> > 
> > <--  snip  -->
> > 
> > ...
> > WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/divacapi.ko] undefined!
> > WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/diva_mnt.ko] undefined!
> > WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/diva_idi.ko] undefined!
> > WARNING: "proc_net_eicon" [drivers/isdn/hardware/eicon/diva_idi.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > 
> > <--  snip  -->
> > 
> > 
> > Kconfig contains the following strange thing:
> > 
> > menu "Active Eicon DIVA Server cards"
> >         depends on NET && ISDN && ISDN_CAPI!=n
> > 
> > 
> > It seems that except for ISDN_DIVAS_DIVACAPI (that already has a proper 
> > dependency), nothing here actually requires ISDN_CAPI?
> 
> Not quite true. Yes, the base modules for the divas driver do not require 
> ISDN_CAPI, but without ISDN_CAPI it doesn't make any sense.

Let me try to understand this:

Does it make sense to have CONFIG_ISDN_DIVAS=y, CONFIG_ISDN_CAPI=m?
And do CONFIG_ISDN_DIVAS=y/m, CONFIG_ISDN_DIVAS_DIVACAPI=n 
configurations make sense?

If not, what about:
- let ISDN_DIVAS depend on ISDN_CAPI and
- enable ISDN_DIVAS_DIVACAPI unconditionally (and perhaps even build 
                                              it into the divas module)?

> The patch below (go into /hardware even for non ISDN_CAPI) is wrong. The
> subdir /hardware was created for new drivers using CAPI. So it is correct to
> go there when ISDN_CAPI != n only.
> 
> I don't understand the warnings above. The symbols are exported by divas 
> modules, so why is it causing warnings? There have been no change in the 
> divas modules for this. Any change in the kernel module creation structure
> which may causing this?

These aren't warnings, these are errors.

Due to
  obj-$(CONFIG_ISDN_CAPI)                    += hardware/

hardware/ isn't visited with CONFIG_ISDN_CAPI=m when building vmlinux.

This means the modules were built, but the static code they were using 
wasn't linkd into the kernel.

This might not have occured before since CONFIG_ISDN_CAPI=m, 
CONFIG_ISDN_DIVAS=y is an unusual configuration.

> Armin
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

