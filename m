Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYFDEpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYFDEpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYFDEpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:45:24 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:38400 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYFDEpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:45:23 -0400
Message-ID: <48461D85.7020604@linux.vnet.ibm.com>
Date: Wed, 04 Jun 2008 10:13:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-fsdevel@vger.kernel.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: per_cpu_counter_sum lockdep warning
References: <48460B94.8050000@linux.vnet.ibm.com> <20080604035954.GE3549@parisc-linux.org>
In-Reply-To: <20080604035954.GE3549@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Jun 04, 2008 at 08:57:16AM +0530, Balbir Singh wrote:
>> Saw this warning on an x86_64 box, while booting up 2.6.26-rc4. Has anybody else
>> seen it? Working on it?
> 
> I've neither seen it, nor am I working on it, but I can decode it.
> 
>> inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> 
> Translation: "This lock was previously grabbed in hardirq context.  Now
> someone's taking it in process context without interrupts disabled.
> That could lead to a deadlock."
> 

I understand this part. I did not want to interpret the data, but I think that's
a better way of reporting problems.

>> init/1 [HC0[0]:SC0[0]:HE1:SE1] takes:
>>  (&fbc->lock){+...}, at: [<ffffffff80386382>] __percpu_counter_sum+0xf/0x5a
> 
> That's the name of the lock -- &fbc->lock and the function where it
> happens.
> 
>> {in-hardirq-W} state was registered at:
>>   [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Drat, no backtrace for the guy who took the lock in hardirq context.
> 
>> Call Trace:
>>  [<ffffffff802518e6>] print_usage_bug+0x15e/0x16f
>>  [<ffffffff8025281f>] mark_lock+0x22f/0x416
>>  [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
>>  [<ffffffff80253576>] __lock_acquire+0x4e7/0xc8a
>>  [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
>>  [<ffffffff80253da7>] lock_acquire+0x8e/0xb2
>>  [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
>>  [<ffffffff805990d7>] _spin_lock+0x26/0x53
>>  [<ffffffff80386382>] __percpu_counter_sum+0xf/0x5a
>>  [<ffffffff803139e2>] ext3_statfs+0xd6/0x160
> 
> ext3_statfs was the one who asked for the lock to be taken without
> disabling interrupts.
> 
> 
> Some percpu counters are supposed to be used from interrupt context.
> These are created with percpu_counter_init_irq.  Others are not and
> should be created with percpu_counter_init.  It seems like someone's
> made a mess of that rule.  This is likely to be a driver, IMO.  Perhaps
> you could work on tracking this down?
> 

Sure, I will. Let me poke harder, I'll recheck all patches I have applied (if
any) on my current tree.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
