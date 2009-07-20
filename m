Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZGTRME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZGTRME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZGTRMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:12:03 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:44983 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZGTRMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:12:02 -0400
Date: Mon, 20 Jul 2009 19:12:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a
	kernel
Message-ID: <20090720171200.GA6730@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org> <1248086059.15751.8405.camel@twins> <20090720115134.GA6517@merkur.ravnborg.org> <1248091243.15751.8550.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248091243.15751.8550.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 02:00:43PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-20 at 13:51 +0200, Sam Ravnborg wrote:
> > -if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
> > -if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
> > +for INSTALL in ~/bin/${CROSS_COMPILE} /sbin/${CROSS_COMPILE} ~/bin /sbin/; do
> > +       if [ -x ${INSTALL}installkernel ]; then
> > +               exec ${INSTALL}installkernel "$@"
> > +       fi
> > +done
> 
> Won't that still get upset if CROSS_COMPILE has whitespace in it, which
> would form weird filenames etc.. or worse, it might match ~/bin/distcc

The root cause of this is the use of CROSS_COMPILE for the installkernel
script.
We know that the CROSS_COMPILE prefix changes with the toolcahin and
likely is a very personal thing.
So rather than using CROSS_COMPILE we should let the user override
the installkernel script used.

The simplest replacement is the following patch which solves this and
only people relying on the use of CROSS_COMPILE for installkernel
needs to change anything.

Needs to change the other ~20 uses of installkernel if we agree on
this change.

	Sam

diff --git a/Makefile b/Makefile
index 3c95e76..b55b47a 100644
--- a/Makefile
+++ b/Makefile
@@ -342,6 +342,7 @@ OBJCOPY             = $(CROSS_COMPILE)objcopy
 OBJDUMP                = $(CROSS_COMPILE)objdump
 AWK            = awk
 GENKSYMS       = scripts/genksyms/genksyms
+INSTALLKERNEL  := installkernel
 DEPMOD         = /sbin/depmod
 KALLSYMS       = scripts/kallsyms
 PERL           = perl
@@ -380,7 +381,8 @@ KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
+export CPP AR NM STRIP OBJCOPY OBJDUMP
+export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
diff --git a/arch/x86/boot/install.sh b/arch/x86/boot/install.sh
index 8d60ee1..d13ec1c 100644
--- a/arch/x86/boot/install.sh
+++ b/arch/x86/boot/install.sh
@@ -33,8 +33,8 @@ verify "$3"
 
 # User may have a custom install script
 
-if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
-if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 
 # Default install - same as make zlilo
 

