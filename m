Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbXC2LGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbXC2LGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 07:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbXC2LGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 07:06:15 -0400
Received: from mx.melware.net ([217.91.97.190]:3794 "EHLO mx.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbXC2LGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 07:06:15 -0400
Date: Thu, 29 Mar 2007 13:06:12 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
X-X-Sender: armin@phoenix.one.melware.de
To: Adrian Bunk <bunk@stusta.de>
Cc: randy.dunlap@oracle.com, kai.germaschewski@gmx.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       kkeil@suse.de
Subject: Re: [RFC: 2.6 patch] fix ISDN_CAPI<->ISDN_DIVAS
In-Reply-To: <20070324150806.GA2078@stusta.de>
Message-ID: <Pine.LNX.4.61.0703291235330.12116@phoenix.one.melware.de>
References: <20070324130622.GE752@stusta.de> <Pine.LNX.4.61.0703241442220.28244@phoenix.one.melware.de>
 <20070324150806.GA2078@stusta.de>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007, Adrian Bunk wrote:
> On Sat, Mar 24, 2007 at 02:49:42PM +0100, Armin Schindler wrote:
> > On Sat, 24 Mar 2007, Adrian Bunk wrote:
> > > Randy Dunlap reported in kernel Bugzilla #8241 the following compile 
> > > error with CONFIG_ISDN_CAPI=m, CONFIG_ISDN_DIVAS=y:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > > WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/divacapi.ko] undefined!
> > > WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/diva_mnt.ko] undefined!
> > > WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/diva_idi.ko] undefined!
> > > WARNING: "proc_net_eicon" [drivers/isdn/hardware/eicon/diva_idi.ko] undefined!
> > > make[1]: *** [__modpost] Error 1
> > > 
> > > <--  snip  -->
> > > 
> > > 
> > > Kconfig contains the following strange thing:
> > > 
> > > menu "Active Eicon DIVA Server cards"
> > >         depends on NET && ISDN && ISDN_CAPI!=n
> > > 
> > > 
> > > It seems that except for ISDN_DIVAS_DIVACAPI (that already has a proper 
> > > dependency), nothing here actually requires ISDN_CAPI?
> > 
> > Not quite true. Yes, the base modules for the divas driver do not require 
> > ISDN_CAPI, but without ISDN_CAPI it doesn't make any sense.
> 
> Let me try to understand this:
> 
> Does it make sense to have CONFIG_ISDN_DIVAS=y, CONFIG_ISDN_CAPI=m?

Yes, this is possible. DIVAS itself does not depend on CAPI.

> And do CONFIG_ISDN_DIVAS=y/m, CONFIG_ISDN_DIVAS_DIVACAPI=n 
> configurations make sense?

Yes, but for only for experts who want to use the DIVAS own API
without CAPI.
 
> If not, what about:
> - let ISDN_DIVAS depend on ISDN_CAPI and
> - enable ISDN_DIVAS_DIVACAPI unconditionally (and perhaps even build 
>                                               it into the divas module)?

That would not be correct.
 
> > The patch below (go into /hardware even for non ISDN_CAPI) is wrong. The
> > subdir /hardware was created for new drivers using CAPI. So it is correct to
> > go there when ISDN_CAPI != n only.
> > 
> > I don't understand the warnings above. The symbols are exported by divas 
> > modules, so why is it causing warnings? There have been no change in the 
> > divas modules for this. Any change in the kernel module creation structure
> > which may causing this?
> 
> These aren't warnings, these are errors.
> 
> Due to
>   obj-$(CONFIG_ISDN_CAPI)                    += hardware/
> 
> hardware/ isn't visited with CONFIG_ISDN_CAPI=m when building vmlinux.
> 
> This means the modules were built, but the static code they were using 
> wasn't linkd into the kernel.
> 
> This might not have occured before since CONFIG_ISDN_CAPI=m, 
> CONFIG_ISDN_DIVAS=y is an unusual configuration.

I see. So for DIVAS the line 
  obj-$(CONFIG_ISDN_CAPI)                    += hardware/
causes the trouble, because all hardware/ driver are meant to be CAPI 
drivers...

In that case we should change hardware/eicon/ as you proposed:
> - let ISDN_DIVAS depend on ISDN_CAPI and

So the solution might be just to change
 
    menu "Active Eicon DIVA Server cards"
      depends on NET && ISDN && ISDN_CAPI!=n
to 
    menu "Active Eicon DIVA Server cards"
      depends on NET && ISDN && ISDN_CAPI

in drivers/isdn/hardware/eicon/Kconfig
right?

Armin


