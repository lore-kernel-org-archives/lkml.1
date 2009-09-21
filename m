Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZIUQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZIUQK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZIUQK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:10:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:54929 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZIUQK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:10:26 -0400
In-Reply-To: <alpine.LRH.2.00.0909211539520.16077@vixen.sonytel.be>
References: <alpine.LRH.2.00.0909211539520.16077@vixen.sonytel.be>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <87FFD936-384D-4A04-AD6D-90BBDD3DAD18@kernel.crashing.org>
Cc: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux Test Project <Ltp-list@lists.sourceforge.net>
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [LTP] mmapstress03 weirdness? (fwd)
Date: Mon, 21 Sep 2009 18:10:32 +0200
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>         if (mmap((caddr_t)(1UL << (POINTER_SIZE  - 1)) - pagesize,
>                 (size_t)((1UL << (POINTER_SIZE - 1)) - pagesize),
>                 PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_FIXED| 
> MAP_SHARED, 0, 0)
>                 != (caddr_t)-1)

> With 32-bit userland, this boils down to:
>
> | mmap addr 0x7fff0000 size 0x7fff0000
> | mmap returned 0x7fff0000
>
> i.e. mmap() succeeds,

Yes, on a powerpc64 kernel, every 32-bit userspace process has 4GB
available (well, except the lowest few pages).  The process text sits
normally at 1M and the shared libs around 256M.

> but (1) the test expects it to fail, so the test returns
> TFAIL,

That's a bug in the test then.

> but (2) ltp-pan still reports that the tests passed?

Sounds like another bug.

> In addition, sometimes mmapstress03 fails due to SEGV. I created a  
> small test
> program that just does the above mmap(), and depending on the  
> distro and what
> else I print later it crashes with a SEGV, too. Probably this  
> happens because
> the mmap() did succeed, and corrupted some existing mappings,

It probably killed the stack, which sits all the way up near 4G.

> JFYI, with 64-bit userland, this boils down to:
>
> | mmap addr 0x7fffffffffff0000 size 0x7fffffffffff0000
> | mmap returned 0xffffffffffffffff
>
> i.e. mmap() fails as expected, and the test succeeds.

It tries to map space that is reserved for the kernel (c000...)

> Does all of this sound OK?

Seems to me everything works fine, except the tests themselves.


Segher

