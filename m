Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYLBXng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYLBXng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYLBXn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:43:27 -0500
Received: from waste.org ([66.93.16.53]:46070 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYLBXn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:43:26 -0500
Subject: Re: mmotm 2008-12-01-19-41: early exception (page fault -- deref
	of 0x20)
From: Matt Mackall <mpm@selenic.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <4935C03A.7030603@gmail.com>
References: <4935C03A.7030603@gmail.com>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 17:29:33 -0600
Message-Id: <1228260573.3196.171.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 00:09 +0100, Jiri Slaby wrote:
> Hi,
> 
> while writing out warning about empty mtrr (or any other in the early stage),
> I'm getting this:
> PANIC: early exception 0e rip 10:ffffffff8025be26 error 0 cr2 20
> Pid: 0, comm: swapper Not tainted 2.6.28-rc6-mm1_64 #484
> Call Trace:
>  [<ffffffff80770195>] early_idt_handler+0x55/0x69
>  [<ffffffff8025be26>] ? getnstimeofday+0x46/0xc0
>  [<ffffffff80258a81>] ktime_get_real+0x11/0x50
>  [<ffffffff803aa8d1>] seed_std_data+0x11/0x30
>  [<ffffffff8020ff60>] ? show_trace+0x10/0x20
>  [<ffffffff803aa900>] seed_random_pools+0x10/0x30
>  [<ffffffff8023dda9>] init_oops_id+0x9/0x40
>  [<ffffffff8023dde9>] print_oops_end_marker+0x9/0x20
>  [<ffffffff8023dfed>] warn_slowpath+0x9d/0xd0
>  [<ffffffff802595e4>] ? up+0x34/0x50
>  [<ffffffff8023e77d>] ? release_console_sem+0x1bd/0x210
>  [<ffffffff80592c38>] ? printk+0x3c/0x44
>  [<ffffffff80776e67>] mtrr_trim_uncached_memory+0x166/0x390
>  [<ffffffff8077fca0>] ? early_gart_iommu_check+0xaf/0x2a7
>  [<ffffffff80772574>] setup_arch+0x3ec/0x6a8
>  [<ffffffff80770adf>] start_kernel+0x65/0x3c6
>  [<ffffffff8077027d>] x86_64_start_reservations+0x7d/0x89
>  [<ffffffff80770384>] x86_64_start_kernel+0xd8/0xdf
> RIP 0x10
> 
> The clock is still null in kernel/time/timekeeping.c.
> 
> This one is to blame:
> random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on.patch

Nice. I didn't like that patch anyway.

Seems to me we really need to simplify all our startup dependencies.
Some things should -always- work. Time is one of them, random number
generation may be another, memory allocation ought to be one as well.

So I think:

a) we need to come up with a solution/rule for early ktime faulting
b) the RNG should initialize itself on demand
c) seeding the RNG should include a (void *, len)

-- 
Mathematics is the supreme nostalgia of our time.

