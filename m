Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYICGwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYICGwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYICGwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:52:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYICGwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:52:04 -0400
Subject: Re: [2.6.27] early exception - lockdep related?
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20080902210646.GA10925@dreamland.darkstar.lan>
References: <20080902210646.GA10925@dreamland.darkstar.lan>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 08:52:01 +0200
Message-Id: <1220424721.8609.74.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 23:06 +0200, Luca Tettamanti wrote:
> Hello,
> I'm seeing an early exception (0e) - which seems related to lockdep - at
> boot with many 2.6.27 kernels and I'm having troubles to track it down.

Does it print one of these nice stack traces?

> The strange thing is that it comes and goes with different kernel
> versions

What kernel version did you generate the below with - and what config.

> , but a "bad" kernel consistently fails across reboots. It also
> seems to be sensitive to the configuration (attached)

you seem to have forgotten that attachment.

> , at least in one
> case the difference between a non-working kernel and a working one is
> CONFIG_DEBUG enabled in the latter.
> 
> The address printed is inside the function __lock_acqurie:
> 
> in __lock_acquire (/home/kronos/src/linux-2.6.git/kernel/lockdep.c:727).
> 722
> 723             /*
> 724              * We can walk the hash lockfree, because the hash only
> 725              * grows, and we are careful when adding entries to the end:
> 726              */
> 727             list_for_each_entry(class, hash_head, hash_entry) {
> 728                     if (class->key == key) {
> 729                             WARN_ON_ONCE(class->name != lock->name);
> 730                             return class;
> 731                     }

Right - except this isn't in __lock_acquire, its from
look_up_lock_class, which probably gets inlined.

> And the disassembly (faulting address is 0xffffffff80253b66)

<snip asm>

> I actually tried to bisect it using an early working kernel and this first
> (read: the first pull from Linus' tree that gave me a broken kernel). The
> result is inconclusive, the commit pointed out was:
> 
> e5f363e358cf16e4ad13a6826e15088c5495efe9 is first bad commit
> commit e5f363e358cf16e4ad13a6826e15088c5495efe9
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Aug 11 12:37:27 2008 +0200
> 
>     lockdep: increase MAX_LOCKDEP_KEYS
> 
>     certain configs produce:
> 
>      [   70.076229] BUG: MAX_LOCKDEP_KEYS too low!
>      [   70.080230] turning off the locking correctness validator.
> 
>     tune them up.
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> but reverting it didn't make any difference.
> 
> Is there any other action that I can take to debug this issue? Btw, do you
> think that kgdb can be usefull? I can give it a try in the weekend...

Might - I've never tried it..

