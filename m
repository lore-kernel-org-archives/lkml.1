Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYCHTAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYCHTAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 14:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYCHTAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 14:00:47 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:23144 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYCHTAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 14:00:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gkNOXsV/pX/PAuVel2g/wL3CggpkQOdBFuYbFncPdaqeJrEmNLCqRTywpNPTchrXnOOJIQZfD/4ruO5U0axPHlGRIpahRbN7nv8fvbwKN/dyi2p6JzTxhAxIvYvetVJ9KM+RDCmeqPODExk0QxLpsPzKUy0/GQx2WAn8PJWmyCc=
Message-ID: <bc64b4640803081100i3872d699udfc64beb9d0e6@mail.gmail.com>
Date: Sat, 8 Mar 2008 22:00:41 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: Lockdep problem
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1204997457.6241.314.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bc64b4640803080910w3c2905d6gd17357aafa7b2db9@mail.gmail.com>
	 <1204997457.6241.314.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/3/8, Peter Zijlstra <peterz@infradead.org>:
>
>  On Sat, 2008-03-08 at 20:10 +0300, Dmitry wrote:
>  > Hi,
>  >
>  > I've ran into the lockdep problem: I'm hitting the condition at the
>  > lockdep.c:2437:
>  >        if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
>  >                 return 0;
>  >
>  > What does it mean and how to overcome it? Dumbly increasing constants
>  > at kernel/lockdep_internals.h didn't help.
>
>
> It means you have more lockdep classes (lock instantiation sites,
>  explicit class keys etc..) that we have static storage reserved for.
>
>  One way to quickly achieve this is load/unload modules. Zapping the
>  classes on module unload does not make the space available again.
>
>  Sadly most setups these days try to load every module under the sun,
>  wasting valuable boot time, and causing this head-ache.

Unfortunately this happens before modules loading --- it's kernel itself.

>
>  Someone reported to me increasing MAX_LOCKDEP_KEYS_BITS to 15 (IIRC)
>  made his distro build work again. Of course, cycle reloading a module
>  will eventually run you out of space anyway.
>
>
>  > The warning is pretty fatal for me because it happens when I'm locking
>  > clocks lock, so when serial console output calls
>  > clk_enable/clk_disable the kernel deadlocks.
>
>
> Not sure I fully understand what you mean here, but I've never seen this
>  result in anything but a warning, the kernel will just continue..
>
>  Or are you trying to debug a deadlock and can't because lockdep runs out
>  of classes before it gets to the offending code?

Actually no and yes. IIUC, the call chain looks like this (it's with
modified clk's functions, so
it may be a bit hard to understand. If you wish, search for "clocklib"
patches posted to LKML
nearly a month ago).
kernel -> clk_enable() takes global clock spinlock -> my function
which calls another spin_lock which causes lockdep warning.
If I disable global clocks spinlock locking, I get the lockdep
warning. Otherwise, I see no output. This seems to be related to the
fact that I have pxa serial console enabled which in turn also uses
clk_enable/clk_disable to manage its serial port.


>
>  Something you can do is build a kernel without (or very few modules) - a
>  good idea anyway as turning off all that unused stuff will significantly
>  improve build times too :-)

I have a plenty of modules configured to build, but as I hope this
doesn't count, since they aren't loaded

-- 
With best wishes
Dmitry
