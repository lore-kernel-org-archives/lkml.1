Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYHTFLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYHTFLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 01:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYHTFKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 01:10:53 -0400
Received: from xenotime.net ([66.160.160.81]:49985 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751471AbYHTFKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 01:10:52 -0400
Date: Tue, 19 Aug 2008 22:10:46 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, sfr@canb.auug.org.au,
       sam@ravnborg.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, sameo@openedhand.com
Subject: Re: linux-next: Tree for August 19 (mfd/ucb)
In-Reply-To: <20080820112531.e50db074.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0808192207120.17511@shark.he.net>
References: <20080819185454.d9c74915.sfr@canb.auug.org.au>
 <20080819170517.04d91de8.randy.dunlap@oracle.com>
 <20080819171658.4cdb8cd9.akpm@linux-foundation.org>
 <20080820112531.e50db074.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, KAMEZAWA Hiroyuki wrote:

> On Tue, 19 Aug 2008 17:16:58 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 19 Aug 2008 17:05:17 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > drivers/mfd/ucb1400 is a sound (AC97) driver, so it should depend
> > > on AC97_BUS, like in the patch below.  However, with that patch in
> > > place, oldconfig goes belly up on me:
> > > 
> > > 
> > > linux-next-20080819> make ARCH=x86_64  O=X64  V=1 oldconfig
> > > make -C /local/linsrc/linux-next-20080819/X64 \
> > > 	KBUILD_SRC=/local/linsrc/linux-next-20080819 \
> > > 	KBUILD_EXTMOD="" -f /local/linsrc/linux-next-20080819/Makefile \
> > > 	oldconfig
> > > make -f /local/linsrc/linux-next-20080819/scripts/Makefile.build obj=scripts/basic
> > > /bin/sh /local/linsrc/linux-next-20080819/scripts/mkmakefile \
> > > 	    /local/linsrc/linux-next-20080819 /local/linsrc/linux-next-20080819/X64 2 6
> > >   GEN     /local/linsrc/linux-next-20080819/X64/Makefile
> > > mkdir -p include/linux include/config
> > > make -f /local/linsrc/linux-next-20080819/scripts/Makefile.build obj=scripts/kconfig oldconfig
> > > scripts/kconfig/conf -o arch/x86/Kconfig
> > > make[2]: *** [oldconfig] Segmentation fault (core dumped)
> > > make[1]: *** [oldconfig] Error 2
> > > make: *** [sub-make] Error 2
> > > 
> > > 
> > > 
> > > ---
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > mfd/ucb1400 sound driver uses/depends on AC97_BUS:
> > > 
> > > ERROR: "ac97_bus_type" [drivers/mfd/ucb1400_core.ko] undefined!
> > > 
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > cc: Samuel Ortiz <sameo@openedhand.com>
> > > 
> > > ---
> > >  drivers/mfd/Kconfig |    1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > --- linux-next-20080819.orig/drivers/mfd/Kconfig
> > > +++ linux-next-20080819/drivers/mfd/Kconfig
> > > @@ -52,6 +52,7 @@ config HTC_PASIC3
> > >  
> > >  config UCB1400_CORE
> > >  	tristate "Philips UCB1400 Core driver"
> > > +	depends on AC97_BUS
> > >  	help
> > >  	  This enables support for the Philips UCB1400 core functions.
> > >  	  The UCB1400 is an AC97 audio codec.
> > 
> > And this:
> > 
> I still see SEGV in the latest mmtom (on x86-64)
> 
> drivers/input/touchscreen/Kconfig has this definition.
> 
> config TOUCHSCREEN_UCB1400
>         tristate "Philips UCB1400 touchscreen"
>         select AC97_BUS
>         depends on UCB1400_CORE
>         depends on GPIOLIB
> 
> "select" should be "depends on" ,here ?

Thanks for pointing that out.  Yes, that should be depends on IMO.
What is happening is that selecting AC97_BUS doesn't do anything
useful since CONFIG_SOUND is not enabled.  Also, IMO we don't
want to select SOUND since it is a non-trivial subsystem and
should be enabled by user(s), not via select.

And changing this will probably fix the SEGV in kconfig...

-- 
~Randy
