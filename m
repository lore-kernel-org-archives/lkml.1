Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZKDMAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZKDMAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZKDMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:00:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47142 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbZKDMAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:00:14 -0500
Date: Wed, 4 Nov 2009 13:00:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for threads
Message-ID: <20091104120019.GK31511@one.firstfloor.org>
References: <1257233486.22553.6.camel@wall-e> <874opaa68v.fsf@basil.nowhere.org> <1257335404.2123.29.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257335404.2123.29.camel@wall-e>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is true, but i think it is better to get an outdated value than a
> complete wrong value like -1.

-1 means "I don't know".  I don't think "completely wrong" 
is the correct term to describe that.

> The truth is that KSTK_ESP always return an outdated value on a multi
> core system if the process never do a system call.

I think not supporting updates on interrupts at least is very poor.
Unfortunately there's no good way fast path way to detect this I know of
(that is why I originally added -1 here)

> Question: is task_pt_regs(task)->sp set in 64 bit mode when the process
> is blocked in an interrupt? If true, we can add two additional assembly
> instruction to the system call handler and store the stack pointer into
> this. Than KSTK_ESP wil be again a simple macro like

You want to add instructions to one of the hottest kernel paths
for this hyper-obscure application?  Bad idea.

> The drawback is that this will cost a litte bit performance for a litte
> bit more accuracy.

As far as I can figure out this whole proc hack is never accurate
anyways, because it can report arbitarily outdated (or completely bogus
if the process never did any system calls/interrupts) information.

My recommendation would be to just deprecate this proc field
and if anyone really wants that information they can use
a trivial ptrace() based user program.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
