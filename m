Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbYFDEA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbYFDEA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYFDEAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:00:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48856 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYFDEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:00:11 -0400
Date: Tue, 3 Jun 2008 21:59:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: per_cpu_counter_sum lockdep warning
Message-ID: <20080604035954.GE3549@parisc-linux.org>
References: <48460B94.8050000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48460B94.8050000@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 08:57:16AM +0530, Balbir Singh wrote:
> Saw this warning on an x86_64 box, while booting up 2.6.26-rc4. Has anybody else
> seen it? Working on it?

I've neither seen it, nor am I working on it, but I can decode it.

> inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.

Translation: "This lock was previously grabbed in hardirq context.  Now
someone's taking it in process context without interrupts disabled.
That could lead to a deadlock."

> init/1 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&fbc->lock){+...}, at: [<ffffffff80386382>] __percpu_counter_sum+0xf/0x5a

That's the name of the lock -- &fbc->lock and the function where it
happens.

> {in-hardirq-W} state was registered at:
>   [<ffffffffffffffff>] 0xffffffffffffffff

Drat, no backtrace for the guy who took the lock in hardirq context.

> Call Trace:
>  [<ffffffff802518e6>] print_usage_bug+0x15e/0x16f
>  [<ffffffff8025281f>] mark_lock+0x22f/0x416
>  [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
>  [<ffffffff80253576>] __lock_acquire+0x4e7/0xc8a
>  [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
>  [<ffffffff80253da7>] lock_acquire+0x8e/0xb2
>  [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
>  [<ffffffff805990d7>] _spin_lock+0x26/0x53
>  [<ffffffff80386382>] __percpu_counter_sum+0xf/0x5a
>  [<ffffffff803139e2>] ext3_statfs+0xd6/0x160

ext3_statfs was the one who asked for the lock to be taken without
disabling interrupts.


Some percpu counters are supposed to be used from interrupt context.
These are created with percpu_counter_init_irq.  Others are not and
should be created with percpu_counter_init.  It seems like someone's
made a mess of that rule.  This is likely to be a driver, IMO.  Perhaps
you could work on tracking this down?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
