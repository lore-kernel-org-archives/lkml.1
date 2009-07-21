Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZGUTRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZGUTRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZGUTRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:17:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbZGUTRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:17:02 -0400
Date: Tue, 21 Jul 2009 12:15:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Krzysztof Oledzki <olel@ans.pl>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Jul 2009, Linus Torvalds wrote:
> 
> Great. This is all about as perfect as could be asked for. Now it's just a 
> question of trying to find the right code generation difference...

Ok, that "just" is turning out to be really painful.

I've tried to do clever things, but the best I've been able to do is to 
get the relevant differences down to about 22 thousand lines of assembler 
diffs that don't match either of the working kernels. Sadly, 22KLOC of 
assembler diffs isn't something anybody can reasonably read to even start 
to make a guess about which lines are causing problems. 

So what I'd love to do is to narrow the failure down a bit, by using 
-fno-strict-overflow only on _parts_ of the tree and then try a couple of 
kernels to see if they hang, to see which part it is that mis-compiles.

With a newer kernel, we could do something like this:

	diff --git a/Makefile b/Makefile
	index 79957b3..b096be2 100644
	--- a/Makefile
	+++ b/Makefile
	@@ -565,9 +565,6 @@ KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
	 # disable pointer signed / unsigned warnings in gcc 4.0
	 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
	 
	-# disable invalid "can't wrap" optimizations for signed / pointers
	-KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
	-
	 # revert to pre-gcc-4.4 behaviour of .eh_frame
	 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
	 
	diff --git a/drivers/Makefile b/drivers/Makefile
	index bc4205d..1250b55 100644
	--- a/drivers/Makefile
	+++ b/drivers/Makefile
	@@ -5,6 +5,8 @@
	 # Rewritten to use lists instead of if-statements.
	 #
	 
	+subdir-ccflags-y += -fno-strict-overflow
	+
	 obj-y				+= gpio/
	 obj-$(CONFIG_PCI)		+= pci/
	 obj-$(CONFIG_PARISC)		+= parisc/

to say "use -fno-strict-overflow only when compiling objects in the
drivers/ subdirectories", but I'm pretty sure that whole clever
'subdir-ccflags-y' thing was added pretty recently, and won't work in
2.6.27

However, since there is _some_ reason to wonder about whether the problem 
could be in radeonfb (because the last printouts before the hang are about 
that), it would be good to test just that part.

So if you have the time and energy, it would be very interesting if you 
could do something like this:

 - remove the "KBUILD_CFLAGS  += $(call cc-option,-fno-strict-overflow)"
   entirely from the main Makefile.

 - one directory at a time, add

	ccflags-y += -fno-strict-overflow

   to the Makefile in just that particular directory, and compile and test 
   the kernel. Now, since your old kernel doesn't have that nifty new
   "subdir-ccflags-y" thing, you can't do it for big parts of the kernel, 
   you can literally do it for just the contents of one subdirectory 
   (non-recusive!) at a time, but while there's two thousand 
   subdirectories in the Linux kernel sources, judicious sprinking of that 
   into the tree could hopefully make it possible to find.

 - the first Makefile's to test would be 'drivers/video/aty/Makefile'. If 
   that one doesn't work, some scripting might be in order, eg something 
   like

	for i in $(find drivers -name Makefile)
	do
		( echo "ccflags-y += -fno-strict-overflow" ; cat $i ) > $i.new
		mv $i.new $i
	done

   should add it to all the subdirectories under 'drivers', etc.

and if you can find the subdirectory where '-fno-strict-overflow' makes 
the difference, at that point I'd love to see the kernel image where 
things worked (ie the last kernel you booted successfully _before_ the 
kernel that failed) and the kernel that fails - now hopefully the 
differences should be much smaller (how small will obviously depend on 
whether you caught the difference in just one subdirectory or whether you 
scripted it over lots and lots of subdirectories).

Of course, the tighter you can do this, the better. If it happens to be in 
'drivers/video/aty/' for example, and you end up being really gung-ho 
about this and want to narrow it down to not just the subdirectory, but a 
few files, you could remove the per-directory "ccflags-y" line, and do a 
few per-file CFLAGS entries instead, like:

	CFLAGS_radeon_base.o += -fno-strict-overflow

etc.

And hey, if you think this is too much work, then you're right. It's a lot 
of work. So don't worry if you can't be bothered - it would be wonderful 
to try to get this thing resolved, but I do realize I'm asking a lot here.

			Linus
