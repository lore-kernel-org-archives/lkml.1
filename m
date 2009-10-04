Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZJDTSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZJDTSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZJDTSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:18:10 -0400
Received: from [195.41.46.235] ([195.41.46.235]:53082 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757822AbZJDTSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:18:09 -0400
Date: Sun, 4 Oct 2009 21:17:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
	building a kernel
Message-ID: <20091004191729.GA20203@merkur.ravnborg.org>
References: <20091003103441.GA10874@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003103441.GA10874@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 12:34:41PM +0200, Ingo Molnar wrote:
> 
> Sam,
> 
> that arch-cache thing introduced in:
> 
>  5755433: kbuild: save ARCH & CROSS_COMPILE when building a kernel
> 
> isnt working very well in my experience.
> 
> 1) it's a nuisance in cross-builds (it broke several cross-build scripts 
>    of mine)
On the contrary it has helped me big time on my cross builds.
No need to script is all to remember to set the correct ARCH + CROSS_COMPILE
settings.

We should make the default case easy. And I consider the default case when
people fire up their shell and type:

    make CROSS_COMPILE=arm-linux- ARCH=arm defconfig

When they hit something they fix it up and do a simple:

    make

This is what this commit enables.
This commit is know to break scripts that expect that they can
seamlessly change CROSS_COMPILE or ARCH settings.
More on that below.

It is a nusiance that we have to instruct people to do a

    make mrproper

But on the other hand what else can we do to make sure people base their
work on a clean tree when the change either ARCH or CROSS_COMPILE.
Albeit for the latter we could drop the check as kbuild would see the
change in the commandline anyway.


 
> 2) it makes it hard to switch from 32-bit x86 builds to 64-bit ones: 
>    previously i only needed 'make ARCH=i386 defconfig' and off we went - 
>    now i have to add a 'make mrproper' step.

x86 is a mess in respect to ARCH setting.
We have:

ARCH=i386 =>
		- ARCH is set to i386
		- 64BIT is forced to n
		- defconfig is i386_defconfig

ARCH=x86 =>
		- ARCH is set to x86
		- 64BIT is configurable
		- defconfig is set to x86_64_defconfig

ARCH=x86_64 =>
		- ARCH is set to x86_64
		- 64BIT is forced y
		- defconfig is set to x86_64_defconfig
		
ARCH=""
		- let `uname -m` determine ARCH setting and follow rules above


And now when um enters the scene everyone gets confused.
I think the correct way to fix this is to always set ARCH=x86 in the x86 case.
And i386/x86_64 is only a user-interface thing - not a valid ARCH setting.

Pushing this to sparc and sh would also simplify a few things.

We would loose one thing. The current ARCH setting is used to _remember_
how we were started out. So if you once used ARCH=i386 you will not
be allowed to change 64BIT to 'y'.
But using ARCH to remember this is ackward at best and I guess very few people
realise this.

I will try to take a look at this in the hope that the current 'um'
mess can be cleaned up as a side effect.

> 3) it can also get stuck:
> 
>   phoenix:~/linux/linux> make mrproper
>   Makefile:571: /home/mingo/tip/arch/no/Makefile: No such file or directory
>   make: *** No rule to make target `/home/mingo/tip/arch/no/Makefile'.  Stop.

So you tried to configure a kernel with ARCH=no
The version I have now will ask you to do a:

    make mrporper ARCH=no

But this is suboptimal.

> Dunno - why isnt the .config enough in terms of determining which 
> architecture we are on? If we want more info we should put it into the 
> .config - not some other hidden state. I do think a single file should 
> carry all 'configuration state' - that makes it easier to reproduce 
> things, etc. etc. Everything else is really just hindering us.

chicken and egg + a few other issues.
If I want to have ARCH moved to Kconfig then this better be a true option.
Which requires kconfig to read in Kconfig* for all architectures in one sweep.

There is so many corner cases around this that I gave up last time
I looked at it.
But maybe the correct solution would be to move CROSS_COMPILE to Kconfig space.
And only leave ARCH out...


	Sam
