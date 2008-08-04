Return-Path: <linux-kernel-owner+w=401wt.eu-S1763193AbYHDVIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763193AbYHDVIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYHDVI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:08:26 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:24737 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbYHDVIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:08:25 -0400
Date: Mon, 4 Aug 2008 23:08:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: Kconfig no longer outputs a .config with freshly updated defconfigs
Message-ID: <20080804210848.GA29902@uranus.ravnborg.org>
References: <1217693013.2328.22.camel@localhost.localdomain> <20080802192646.GR19682@cs181140183.pp.htv.fi> <20080803080019.GA13265@uranus.ravnborg.org> <20080803100732.GA7442@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080803100732.GA7442@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 01:07:32PM +0300, Adrian Bunk wrote:
> On Sun, Aug 03, 2008 at 10:00:19AM +0200, Sam Ravnborg wrote:
> > On Sat, Aug 02, 2008 at 10:26:47PM +0300, Adrian Bunk wrote:
> > > On Sat, Aug 02, 2008 at 12:03:33PM -0400, Josh Boyer wrote:
> > > > I was going through the somewhat tedious task of updating the 4xx
> > > > defconfigs today, and I noticed some odd behavior from Kconfig.
> > > > Basically, I would do:
> > > > 
> > > > 	make ppc44x_defconfig
> > > > 	make oldconfig
> > > > 	<build>
> > > > 	cp .config arch/powerpc/configs/ppc44x_defconfig
> > > > 	make distclean
> > > > 
> > > > I did this for a number of configs.  Then I went back and tried to build
> > > > ppc44x_defconfig again and I got this result:
> > > > 
> > > > [jwboyer@localhost linux-2.6]$ make ppc44x_defconfig
> > > >   HOSTCC  scripts/basic/fixdep
> > > >   HOSTCC  scripts/basic/docproc
> > > >   HOSTCC  scripts/kconfig/conf.o
> > > >   HOSTCC  scripts/kconfig/kxgettext.o
> > > >   SHIPPED scripts/kconfig/zconf.tab.c
> > > >   SHIPPED scripts/kconfig/lex.zconf.c
> > > >   SHIPPED scripts/kconfig/zconf.hash.c
> > > >   HOSTCC  scripts/kconfig/zconf.tab.o
> > > > scripts/kconfig/lex.zconf.c:1628: warning: ‘input’ defined but not used
> > > >   HOSTLD  scripts/kconfig/conf
> > > > [jwboyer@localhost linux-2.6]$ make oldconfig
> > > > scripts/kconfig/conf -o arch/powerpc/Kconfig
> > > > #
> > > > # using defaults found in /boot/config-2.6.25.13-104.fc9.ppc64
> > > > #
> > > > 
> > > > There was no .config file present after the initial 'make
> > > > ppc44x_defconfig', so it defaulted to using something in /boot.  I'm a
> > > > bit baffled here, but that seems to be common to any newly updated
> > > > defconfig I've done.
> > > > 
> > > > Was there a change to Kconfig recently that won't copy the defconfig
> > > > file to .config if there are no symbol changes or something like that?
> > > 
> > > Thanks for your bug report, this should have worked.
> > > 
> > > @Sam:
> > > I've bisected this and it is caused by
> > > commit f443d2eccf077afd8a839cc7ed66cc4d520c5f05
> > > (kconfig: speed up all*config + randconfig).
> > > 
> > > Minimal example for reproducing it:
> > > 
> > > make x86_64_defconfig
> > > cp .config arch/x86/configs/x86_64_defconfig
> > > rm .config
> > > make x86_64_defconfig
> > > ls .config
> > 
> > Thanks Adrian.
> > 
> > The code has started to check if anything changed
> > and if not - then do not write out a new config.
> > So in your sample above we would not see any changes
> > compared to what we read in autoconf.h so we did nto write
> > out a new autoconf.h (and thus no .config).
> > 
> > The right fix seems to check for .config and for changes
> > and in both cases to write a new config.
> > 
> > Patch below.
> 
> This breaks with:
> 
> make ARCH=x86 x86_64_defconfig
> cp .config arch/x86/configs/x86_64_defconfig
> make ARCH=x86 i386_defconfig
> make ARCH=x86 x86_64_defconfig
> 
> Why can't we simply always write the .config?

Hi Adrian.

I just pushed a patch that does this.

Thanks,
	Sam
