Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYCHRbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYCHRbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 12:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYCHRbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 12:31:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41974 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbYCHRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 12:31:07 -0500
Subject: Re: Lockdep problem
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry <dbaryshkov@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <bc64b4640803080910w3c2905d6gd17357aafa7b2db9@mail.gmail.com>
References: <bc64b4640803080910w3c2905d6gd17357aafa7b2db9@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 18:30:57 +0100
Message-Id: <1204997457.6241.314.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-08 at 20:10 +0300, Dmitry wrote:
> Hi,
> 
> I've ran into the lockdep problem: I'm hitting the condition at the
> lockdep.c:2437:
>        if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
>                 return 0;
> 
> What does it mean and how to overcome it? Dumbly increasing constants
> at kernel/lockdep_internals.h didn't help.

It means you have more lockdep classes (lock instantiation sites,
explicit class keys etc..) that we have static storage reserved for.

One way to quickly achieve this is load/unload modules. Zapping the
classes on module unload does not make the space available again.

Sadly most setups these days try to load every module under the sun,
wasting valuable boot time, and causing this head-ache.

Someone reported to me increasing MAX_LOCKDEP_KEYS_BITS to 15 (IIRC)
made his distro build work again. Of course, cycle reloading a module
will eventually run you out of space anyway.

> The warning is pretty fatal for me because it happens when I'm locking
> clocks lock, so when serial console output calls
> clk_enable/clk_disable the kernel deadlocks.

Not sure I fully understand what you mean here, but I've never seen this
result in anything but a warning, the kernel will just continue..

Or are you trying to debug a deadlock and can't because lockdep runs out
of classes before it gets to the offending code?

Something you can do is build a kernel without (or very few modules) - a
good idea anyway as turning off all that unused stuff will significantly
improve build times too :-)

