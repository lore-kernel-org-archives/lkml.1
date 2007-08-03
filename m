Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbXHCNTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbXHCNTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXHCNTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:19:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40750 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbXHCNTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:19:07 -0400
Date: Fri, 3 Aug 2007 15:19:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "T. J. Brumfield" <enderandrew@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about modularization
Message-ID: <20070803131900.GA26203@elte.hu>
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.1.7-deb
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* T. J. Brumfield <enderandrew@gmail.com> wrote:

> 1 - Can someone please explain why the kernel can be modular in every 
> other aspect, including offering a choice of IO schedulers, but not 
> kernel schedulers?

that's a fundamental misconception. If you boot into a distro kernel on 
a typical PC, about half of the kernel code that the box runs in any 
moment will be in modules, half of it is in the "kernel core". For 
example, on a random laptop:

 $ echo `lsmod | cut -c1-30 | cut -d' ' -f2-` | sed 's/Size //' |
   sed 's/ /+/g' | bc
 2513784

i.e. 2.5 MB of modules. The core kernel's size:

 $ dmesg | grep 'kernel code'
 Memory: 2053212k/2087808k available (2185k kernel code, 33240k reserved, 1174k data, 244k init, 1170304k highmem)

2.1 MB of kernel core code. (of course the total body of "possible 
drivers" is 10 times larger than that of the core kernel - but the 
fundamental 'variety' is not.)

most of the modules are for stuff where there is a significant physical 
difference between the components they support. Drivers for different 
pieces of hardware. Filesystem drivers for different on-disk physical 
layouts. Network protocol drivers for different on-wire formats. The 
sanest technological decision there is clearly to modularize.

And note that often it's not even about choice there: the user's system 
has a particular piece of hardware, to which there is usually one 
primary driver. The user does not have any real 'choice' over the 
modularization here, it's largely a technological act to make the 
kernel's footprint smaller.

But the kernel core, which does not depend as much on the physical 
properties of the stuff it supports (it depends on the physics of the 
machine of course, but those rules are mostly shared between all 
machines of that architecture), and is fundamentally influenced by the 
syscall API (which is not modular either) and by our OS design 
decisions, has much less reason to be modularized.

The core kernel was always non-modular, and it depends on the technical 
details whether we want to or _have to_ modularize something so that it 
becomes modular to the user too. For example we dont have 'competing', 
modular versions of the IPv4 stack. Neither of the VFS. Nor of timers, 
futexes, nor of locking code or of the CPU scheduler. But we can switch 
out any of those implementations from the core kernel, and did so 
numerous times in the past and will do so in the future.

CPU schedulers are as core kernel code as it gets - you cannot even boot 
without having a CPU scheduler. IO schedulers, although similar in name, 
are quite different beasts from CPU schedulers, and they are somewhere 
between the core kernel and drivers. They are not 'physical drivers' (an 
IO scheduler can drive any disk), nor are they fully 'core kernel code' 
in the sense of a kernel not even being able to boot without them. Also, 
disks are physically different from CPUs, in a way which works _against_ 
the user-modularization of CPU schedulers. (there are also many other 
differences which have been pointed out in the past)

In any case, the IO subsystem maintainers decided to modularize IO 
schedulers, and that's their decision. One of the authors of the IO 
scheduler code said it on lkml recently that while modularization of IO 
scheduler had advantages too, in retrospect he wishes they would not 
have made IO schedulers modular and now that decision cannot be undone. 
So even that much different situation was far from a clear decision, and 
some negative effects can be felt today too, in form of having two 
primary IO schedulers but not having one IO scheduler that works well in 
all cases. For CPU schedulers the circumstances point away away from 
user-selectable modularization even stronger.

	Ingo
