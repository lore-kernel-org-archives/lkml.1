Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZGTLvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZGTLvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 07:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZGTLvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 07:51:36 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39512 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZGTLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 07:51:36 -0400
Date: Mon, 20 Jul 2009 13:51:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a
	kernel
Message-ID: <20090720115134.GA6517@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org> <1248086059.15751.8405.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248086059.15751.8405.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 12:34:19PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-20 at 12:01 +0200, Sam Ravnborg wrote:
> 
> > From 9e27e311540fbe0c31d9cdfe731ad60a54ad1202 Mon Sep 17 00:00:00 2001
> > From: Sam Ravnborg <sam@ravnborg.org>
> > Date: Mon, 20 Jul 2009 11:49:54 +0200
> > Subject: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a kernel
> > 
> > When building a kernel for a different architecture
> > kbuild requires the user always to specify ARCH and
> > CROSS_COMPILE on the command-line.
> > 
> > We use the asm symlink to detect if user forgets to
> > specify the correct ARCH value - but that symlink
> > is about to die. And we do now want to loose this check.
> > 
> > This patch save the settings of ARCH and CROSS_COMPILE
> > in a file named ".kbuild".
> > The settings are saved during "make *config" time
> > and always read.
> > 
> > If user try to change the settings we error out.
> > 
> > This works both for plain builds and for O=...
> > builds.
> > So now you can do:
> > $ mkdir sparc64
> > $ make O=sparc64 ARCH=sparc64 CROSS_COMPILE=sparc64-linux- defconfig
> > $ cd sparc64
> > $ make
> > 
> > Notice that you no longer need to tell kbuild
> > the settings of ARCH and CROSS_COMPILE when you type make
> > in the output directory.
> > Likewise for plain builds where you do not use O=...
> 
> If I were to do:
> 
> $ make O=foo-build INSTALL_MOD_STRIP=1 modules_install install
> 
> after that, would that still use the CROSS_COMPILE setting used before?
> 
> If so, that would break my build. Because arch/x86/boot/install.sh does:
> 
> if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
> 
> Which will not match my:
> 
> make CROSS_COMPILE="distcc ${ARCH}-linux-" -j $DISTCC_SLOTS "$@"
> 

You are right that this would fail.....
And we would not be able to override the value of CROSS_COMPILE as kbuild
will error out is we try to change that.

We have 5 archs that does the above so this needs to be addressed somehow.

The best solution I can come up with right now would be
to fall back to the native version if the CROSS_COMPILE version
does not exist.

Then the only situation where this would not work is if you use
distcc/ccache to build your kernel for another architecture and you
want to use the kbuild supplied install.sh script to install it.
Because you cannot override the old CROSS_COMPILE setting.

Maybe the right solution would be to add specific support for distcc/ccache
to overcome this if it turns out to be a real issue.

Suggested patch for x86 below.

diff --git a/arch/x86/boot/install.sh b/arch/x86/boot/install.sh
index 8d60ee1..59f0f0f 100644
--- a/arch/x86/boot/install.sh
+++ b/arch/x86/boot/install.sh
@@ -32,9 +32,11 @@ verify "$2"
 verify "$3"
 
 # User may have a custom install script
-
-if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
-if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
+for INSTALL in ~/bin/${CROSS_COMPILE} /sbin/${CROSS_COMPILE} ~/bin /sbin/; do
+       if [ -x ${INSTALL}installkernel ]; then
+               exec ${INSTALL}installkernel "$@"
+       fi
+done
 
 # Default install - same as make zlilo
 

Patch is only RFC for now. If we can agree on this I will patch all relevant archs.

	Sam


