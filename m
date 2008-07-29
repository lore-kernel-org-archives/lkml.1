Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbYG2Was@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbYG2Was (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYG2Wak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:30:40 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:13335 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbYG2Wak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:30:40 -0400
Date: Wed, 30 Jul 2008 00:30:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.27-rc1
Message-ID: <20080729223051.GB25073@uranus.ravnborg.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <20080729213746.GA22548@uranus.ravnborg.org> <alpine.LFD.1.10.0807291439270.3334@nehalem.linux-foundation.org> <20080729215942.GA22760@uranus.ravnborg.org> <alpine.LFD.1.10.0807291502271.3334@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807291502271.3334@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 03:03:47PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 29 Jul 2008, Sam Ravnborg wrote:
> > 
> > For arm the actual diff is:
> >  Makefile                 |   20 +++++++-------------
> >  boot/compressed/Makefile |    3 ---
> >  tools/Makefile           |    1 +
> >  3 files changed, 8 insertions(+), 16 deletions(-)
> > 
> > But on top of this there are ~600 files that needed a
> > replacement of:
> > #include <asm/arch/foo.h>
> > to
> > #include <arch/foo.h>
> 
> Yeah, that latter part doesn't strike me as wonderful.
> 
> > So maybe not such a minimal patch - because I wanted to drop all
> > the symlink stuff.
> 
> Why? There's nothing wrong with symlinks.
> 
> The problem with 'include/asm' isn't the symlink per se, it's that it 
> split up the architecture parts in two separate areas - arch and include.

I agree that we do this to combine all arch files. But we then have the
possibility to get rid of some build stuff that is fragile and needs
special care for O=.. builds etc.
So when we anyway do the renames I saw the opportunity to go one step
further.
Lets see how the x86 + um stuff looks like.

For x86 alone the patchs looks like this:

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f5631da..c7493e7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -110,16 +110,16 @@ KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 mcore-y  := arch/x86/mach-default/
 
 # Voyager subarch support
-mflags-$(CONFIG_X86_VOYAGER)	:= -Iinclude/asm-x86/mach-voyager
+mflags-$(CONFIG_X86_VOYAGER)	:= -Iarch/x86/include/mach-voyager
 mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/mach-voyager/
 
 # generic subarchitecture
-mflags-$(CONFIG_X86_GENERICARCH):= -Iinclude/asm-x86/mach-generic
+mflags-$(CONFIG_X86_GENERICARCH):= -Iarch/x86/include/mach-generic
 fcore-$(CONFIG_X86_GENERICARCH)	+= arch/x86/mach-generic/
 mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
 
 # default subarch .h files
-mflags-y += -Iinclude/asm-x86/mach-default
+mflags-y += -Iarch/x86/include/mach-default
 
 # 64 bit does not support subarch support - clear sub arch variables
 fcore-$(CONFIG_X86_64)  :=

And the script to move the files looks like this:
set -e
for D in include/asm-x86/mach-*; do
	echo $D
	DD=$(echo $D | cut -d '-' -f 3)
        mkdir -p arch/x86/include/mach-$DD/arch
        git mv include/asm-x86/mach-$DD/* arch/x86/include/mach-$DD
        rmdir include/asm-x86/mach-$DD
done

mkdir -p arch/x86/include/asm
git mv include/asm-x86/* arch/x86/include/asm

But I have not yet looked at um.

	Sam
