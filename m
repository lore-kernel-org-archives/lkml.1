Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXJUEac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXJUEac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 00:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbXJUEaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 00:30:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXJUEaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 00:30:15 -0400
Message-ID: <471AD5AD.9030000@zytor.com>
Date: Sat, 20 Oct 2007 21:29:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com>
In-Reply-To: <4719174A.7020004@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
> 
> usually I'll wait for rc1 and test compile external module to see which are broken and what need fixing
> but while I need virtualbox for some tests I test compile it on current git and it failed badly.
> 
> Maybe something is missing from x86 merge ?
> 
> Here is what I get :
> 
> ...
> 
> /linux/memobj-r0drv-linux.c
> In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic_32.h:265,
>                  from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic.h:2,
>                  from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock_32.h:4,
>                  from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock.h:2,
>                  from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/spinlock.h:87,
>                  from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:53,
>                  from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
> /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'atomic_long_t'

I have been unable to make heads or tails of the maze of twisty 
dependencies that VirtualBox wants, but the fact that it gets to line 23 
of <asm-generic/atomic.h> means it has gotten past:

     21  #if BITS_PER_LONG == 64
     22
     23  typedef atomic64_t atomic_long_t;

BITS_PER_LONG was originally set in <asm/types.h>:

     39  #ifdef CONFIG_X86_32
     40  # define BITS_PER_LONG 32
     41  #else
     42  # define BITS_PER_LONG 64
     43  #endif

The most obvious reason for failure is that the symbol CONFIG_X86_32 
isn't being defined where expected.  From that point on everything goes 
to hell.

Have you done "make oldconfig && make prepare" in your kernel tree since 
you last updated it?

	-hpa

