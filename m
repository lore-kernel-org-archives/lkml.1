Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZGUBDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZGUBDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZGUBDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:03:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbZGUBDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:03:48 -0400
Date: Mon, 20 Jul 2009 18:01:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marc Dionne <marc.c.dionne@gmail.com>
cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <4A650DE1.20105@gmail.com>
Message-ID: <alpine.LFD.2.01.0907201750150.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <4A650219.3060003@gmail.com> <alpine.LFD.2.01.0907201650570.19335@localhost.localdomain> <4A650DE1.20105@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Marc Dionne wrote:
> > 
> > Hmm. This sounds more like the binutils bug that people had. Sounds like
> > an assembler bug if the *.o file ends up being empty or at some fixed
> > size. If it was cc1 that fails, I'd expect to not see an *.o file at all,
> > since it didn't generate good assembly.
> > 
> > In fact, your behavior sounds like the thing that produces the *.o files
> > core-dumped or died for other reasons, and had a 64kB buffer that either
> > got flushed or not. That would explain the "zero or exactly 64kB" size.
> > 
> > It could be ccache too, of course.
> 
> Actually in my case it turns out that it is ccache after all - if I remove it
> from the picture everything is fine.  If I re-enable it, even with a clean
> cache, I get the problem.
> 
> It might just be a coincidence that it's triggered by the -fwrapv change.

Ok, so this is getting ridiculous. Do we have _three_ different kernel 
issues going on at the same time, all subtly related to tools issues 
rather than the kernel source tree itself?

That's just completely bizarre.

So right now we have:

 - Krzysztof Oledzki: the only one who so far has really pinpointed it to 
   the -fwrapv change itself.

   It would be good to really double-check that this is not about ccache, 
   since Marc apparently gets a good kernel without ccache, and -fwrapv 
   seems to be involved. 

 - Marc Dionne: ccache getting confused, with 0-byte and 64kB object 
   files. But why -fwrapv vs -fno-strict-overflow would matter is totally 
   unclear. Just happenstance? Something silly like overflowing the 
   length of the ccache argument buffer?

   It would be wonderful to figure out what odd issue ccache might have. 
   The kernel command line isn't _that_ long, but it does end up being 
   something reasonably monstrous like

	gcc -Wp,-MD,kernel/.fork.s.d -nostdinc -isystem 
		/usr/lib/gcc/x86_64-redhat-linux/4.4.0/include -Iinclude 
		-I/home/torvalds/v2.6/linux/arch/x86/include -include 
		include/linux/autoconf.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes 
		-Wno-trigraphs -fno-strict-aliasing -fno-common 
		-Werror-implicit-function-declaration -Wno-format-security 
		-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
		-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
		-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare 
		-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
		-Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer 
		-fno-optimize-sibling-calls -Wdeclaration-after-statement 
		-Wno-pointer-sign -fwrapv -fno-dwarf2-cfi-asm -D"KBUILD_STR(s)=#s" 
		-D"KBUILD_BASENAME=KBUILD_STR(fork)"  -D"KBUILD_MODNAME=KBUILD_STR(fork)"  
		-fverbose-asm -S -o kernel/fork.s kernel/fork.c

   so we are getting into the kilobyte range for it, and mayeb simply the 
   longer argument made something fail. But other build systems do even 
   worse things, I'm sure.

 - the Debian/sid binutils package failure, solved by downgrading 
   binutils.

Crazy, crazy.

		Linus
