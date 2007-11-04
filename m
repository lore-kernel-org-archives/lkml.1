Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbXKDKR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbXKDKR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 05:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXKDKRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 05:17:51 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52030 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbXKDKRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 05:17:50 -0500
Date: Sun, 4 Nov 2007 11:19:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>,
       Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Message-ID: <20071104101927.GA16920@uranus.ravnborg.org>
References: <fg5kar$d70$1@ger.gmane.org> <alpine.LFD.0.9999.0710292310040.3186@localhost.localdomain> <47266BF6.6070206@archlinux.org> <alpine.LFD.0.9999.0710300033470.3186@localhost.localdomain> <4726F510.9060207@archlinux.org> <472C47B4.4030808@archlinux.org> <20071103121149.GA22149@uranus.ravnborg.org> <20071104020217.GJ12045@stusta.de> <20071104100429.GA12311@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071104100429.GA12311@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 11:04:29AM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Sat, Nov 03, 2007 at 01:11:49PM +0100, Sam Ravnborg wrote:
> > > On Sat, Nov 03, 2007 at 11:04:36AM +0100, Thomas Bächler wrote:
> > > > Thomas Bächler schrieb:
> > > > > 
> > > > > I just remembered, a friend of mine got it to compile with the exact
> > > > > same toolchain, but with a different configuration (which I don't have).
> > > > > He used a snapshot tarball from yesterday though, not the git tree.
> > > > > 
> > > > 
> > > > I found the problem and eliminated it. While this is my own fault, it is
> > > > still a bug in either the kernel or the build system: I had CFLAGS set
> > > > to "-Wall -O3 -march=native -pipe". I always thought the kernel would
> > > > ignore those and set its own CFLAGS, but I was wrong. Either the -O3 or
> > > > the -march=native break the build process on gcc 4.2.2.
> > > > 
> > > The kernel will now honour the users CFLAGS setting as you just discovered.
> > > The flags will be appended to the flags specified by the kernel.
> > >...
> > 
> > I think this should be changed:
> > 
> > I also have CFLAGS set on some computers in my environments since for 
> > packages using GNU autoconf that's the correct way to set the compiler 
> > flags.
> > 
> > The kernel already sets all flags correctly, and a user wanting to 
> > change the flags for the kernel is an exception with very special 
> > needs (I'd even claim so special that he could simply edit the 
> > Makefile...).
> > 
> > Using the *FLAGS automatically in the kernel doesn't sound right, can 
> > we prefix all environment variables the kernel honours with KERNEL_ ?
> 
> this _must_ be changed before v2.6.24 is released. Thomas Bächler, 
> Thomas Gleixner and me already wasted hours on this problem, and these 
> kinds of issues will reoccur again and again - in perhaps even more 
> spurious ways.
> 
> Picking up randon environment details during build reduces 
> reproducability (i couldnt reproduce the problem using the exact same 
> toolchain) and might break various existing setups and distro builds as 
> well.
> 
> At minimum the extra CFLAGS needs to be put into the .config - but 
> that's not a too nice solution either. How about just adding an 
> extra-CFLAGS option to .config and perhaps a 'make configpickupCFLAGS' 
> pass for anyone who wants to propagate the environment CFLAGS into the 
> kernel build.

The simpler solutions are to
a) only pick up the values if specified on the make command line as in:
   make CFLAGS=-O3
   [CFLAGS set in the environment would be ignored]
b) do not pick up these variables at all
c) Pick up variables with a unique name

I just did c) but all three options are simple.
Comments?

	Sam

diff --git a/Makefile b/Makefile
index 188c3b6..67c0639 100644
--- a/Makefile
+++ b/Makefile
@@ -527,10 +527,11 @@ KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 # disable pointer signed / unsigned warnings in gcc 4.0
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
-# Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
-KBUILD_CPPFLAGS += $(CPPFLAGS)
-KBUILD_AFLAGS   += $(AFLAGS)
-KBUILD_CFLAGS   += $(CFLAGS)
+# Add user supplied KCPPFLAGS, KAFLAGS and KCFLAGS as the last assignments
+# (The K prefix is added so we do not pick up often-used variables)
+KBUILD_CPPFLAGS += $(KCPPFLAGS)
+KBUILD_AFLAGS   += $(KAFLAGS)
+KBUILD_CFLAGS   += $(KCFLAGS)
 
 # Use --build-id when available.
 LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
> 
> 	Ingo
