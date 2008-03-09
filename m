Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYCIVN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYCIVN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYCIVNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:13:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34473 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbYCIVNQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:13:16 -0400
Message-Id: <1205097195.13205.1241421773@webmail.messagingengine.com>
X-Sasl-Enc: e0eBDXeVgVFj4JxDH25w0jI1K2uB7jVRBjOW9IOpuEIy 1205097195
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
In-Reply-To: <20080309201016.GA28454@elte.hu>
Date: Sun, 09 Mar 2008 22:13:15 +0100
References: <20080309200103.GA895@mailshack.com> <20080309201016.GA28454@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 21:10:16 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> > 		Athlon		Xeon		Opteron 32/64bit
> > x86-specific:	0m3.692s	0m2.820s	0m3.196s / 0m2.480s
> > generic:	0m2.622s	0m1.662s	0m2.100s / 0m1.572s
> 
> ok, that's rather convincing.
> 
> the generic version in lib/find_next_bit.c is open-coded C which gcc can 
> optimize pretty nicely.
> 
> the hand-coded assembly versions in arch/x86/lib/bitops_32.c mostly use 
> the special x86 'bit search forward' (BSF) instruction - which i know 
> from the days when the scheduler relied on it has some non-trivial setup 
> costs. So especially when there's _small_ bitmasks involved, it's more 
> expensive.

Hi,

BSF is fine, it doesn't need any special setup. The problem is probably
that the old versions use find_first_bit and find_first_zero_bit,
which are also hand optimized versions... and they use "repe scasl/q".
That's another little project ;).

> > If the bitmap size is not a multiple of BITS_PER_LONG, and no set 
> > (cleared) bit is found, find_next_bit (find_next_zero_bit) returns a 
> > value outside of the range [0,size]. The generic version always 
> > returns exactly size. The generic version also uses unsigned long 
> > everywhere, while the x86 versions use a mishmash of int, unsigned 
> > (int), long and unsigned long.
> 
> i'm not surprised that the hand-coded assembly versions had a bug ...

Not surprised about the bug, but it was in fact noticed, and fixed
in x86_64!

> [ this means we have to test it quite carefully though, as lots of code 
>   only ever gets tested on x86 so code could have built dependency on 
>   the buggy behavior. ]

Agreed.

> > Using the generic version does give a slightly bigger kernel, though.
> > 
> > defconfig:	   text    data     bss     dec     hex filename
> > x86-specific:	4738555  481232  626688 5846475  5935cb vmlinux (32 bit)
> > generic:	4738621  481232  626688 5846541  59360d vmlinux (32 bit)
> > x86-specific:	5392395  846568  724424 6963387  6a40bb vmlinux (64 bit)
> > generic:	5392458  846568  724424 6963450  6a40fa vmlinux (64 bit)
> 
> i'd not worry about that too much. Have you tried to build with:

I don't but I needed to compile something to test the build anyhow ;)

>   CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>   CONFIG_OPTIMIZE_INLINING=y

This was defconfig in -x86#testing, they were both already enabled. 
Here is what you get with those options turned off ;).

                   text    data     bss     dec     hex filename
x86-specific:   5543996  481232  626688 6651916  65800c vmlinux (32 bit)
generic:        5543880  481232  626688 6651800  657f98 vmlinux (32 bit)
x86-specific:   6111834  846568  724424 7682826  753b0a vmlinux (64 bit)
generic:        6111882  846568  724424 7682874  753b3a vmlinux (64 bit)

(and I double-checked the i386 results)

> (the latter only available in x86.git)
> 
> > Patch is against -x86#testing. It compiles.
> 
> i've picked it up into x86.git, lets see how it goes in practice.

Thanks,
    Alexander

> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - And now for something completely different…

