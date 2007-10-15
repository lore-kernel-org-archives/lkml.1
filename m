Return-Path: <linux-kernel-owner+w=401wt.eu-S934907AbXJOUZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907AbXJOUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbXJOUZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:25:42 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:47666 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbXJOUZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:25:40 -0400
Date: Mon, 15 Oct 2007 22:25:35 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, Rob Landley <rob@landley.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
In-Reply-To: <20071012102124.GA18959@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0710152217150.16889@anakin>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710111707270.3729@anakin>
 <Pine.LNX.4.64.0710120211130.4083@loopy.telegraphics.com.au>
 <200710111614.39879.rob@landley.net> <Pine.LNX.4.64.0710120849480.11634@anakin>
 <Pine.LNX.4.64.0710121731110.17887@loopy.telegraphics.com.au>
 <Pine.LNX.4.64.0710121046020.7335@anakin> <20071012102124.GA18959@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007, Sam Ravnborg wrote:
> On Fri, Oct 12, 2007 at 10:51:00AM +0200, Geert Uytterhoeven wrote:
> > On Fri, 12 Oct 2007, Finn Thain wrote:
> > > > If your cross-compiler is called differently than the default on in 
> > > > arch/*/Makefile,
> > > 
> > > Part of the problem is that there is no compelling default. The name of 
> > > the cross-compiler can vary depending on the chosen executable prefix or 
> > > the chosen target tuple.
> > > 
> > > Let's say I create new cross toolchains for both m68k and powerpc. I use 
> > > the "m68k-linux-gnu" to follow the m68k default, but let's assume powerpc 
> > > users prefer their default "powerpc-linux" so I follow that too. The 
> > > result is that I now have gcc's -B option working (or not working) in 
> > > suprising ways too.
> > > 
> > > Uniformity is more helpful downstream than a different arbitrary default 
> > > for each architecture. Debian should patch their default into their kernel 
> > > source packages if they've standardised on cross compiler prefixes.
> > > 
> > > > what's the problem with calling?
> > > > 
> > > >     make ARCH=myarch CROSS_COMPILE=my-cross-compile-prefx-
> > > > 
> > > > This has been working for +10 years on all non-ia32 platforms I ever worked on.
> > > 
> > > But there is no problem with calling that (?). Rob's patch doesn't change 
> > > this.
> > 
> > But it makes life harder for the people who use it daily.
> > 
> > If the consensus is to not provide default cross compiler prefixes in
> > arch/*/Makefile, fine for me, but IFF it's done for all architectures
> > (i.e. check with the blackfin, h8300, mips, parisc, and xtensa people
> > first).
> 
> Test if the expected gcc is available and set CROSS_COMPILE
> if it is present. Otherwise do not touch CROSS_COMPILE.
> 
> m68kgcc := $(shell "test if m68k-gcc is present and echo 'y' if so")
> ifeq ($(m68kgcc,y)
>         CROSS_COMPILE := m68k-foo
> endif
> 
> Then everyone is happy.
> parisc does something similar.

64-bit parisc tests if /usr/bin/hppa64-linux-gnu- exists.
If yes, it sets CROSS_COMPILE to hppa64-linux-gnu-.
If no, it sets CROSS_COMPILE to hppa64-linux-

32-bit parisc unconditionally sets CROSS_COMPILE to hppa-linux-.

This still breaks Rob's setup if his compiler is called differently.

Anyway, here's a try to make it autodetect m68k-linux-gnu-gcc and
m68k-linux-gcc. Perhaps it can be generalized in kbuild, to allow
arch/*/Makefile to set a list of possible cross-compiler prefixes?

Subject: m68k: Improve cross-compiler autodetection

m68k: Improve cross-compiler autodetection

Set CROSS_COMPILE to m68k-linux-gnu- resp. m68k-linux-, but only if such a
cross compiler is found in your $PATH

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Makefile |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -22,7 +22,17 @@ LDFLAGS := -m m68kelf
 LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
 ifneq ($(COMPILE_ARCH),$(ARCH))
 	# prefix for cross-compiling binaries
-	CROSS_COMPILE = m68k-linux-gnu-
+	m68k-linux-gnu-gcc := $(shell if [ `which m68k-linux-gnu-gcc` ]; then \
+		echo y; fi)
+	ifeq ($(m68k-linux-gnu-gcc),y)
+		CROSS_COMPILE := m68k-linux-gnu-
+	else
+		m68k-linux-gcc := $(shell if [ `which m68k-linux-gcc` ]; then \
+			echo y; fi)
+		ifeq ($(m68k-linux-gcc),y)
+			CROSS_COMPILE := m68k-linux-
+		endif
+	endif
 endif
 
 ifdef CONFIG_SUN3

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
