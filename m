Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbXGZPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbXGZPQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbXGZPQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:16:43 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:49437 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbXGZPQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:16:42 -0400
Message-ID: <46A8BAC8.9000306@free.fr>
Date: Thu, 26 Jul 2007 17:16:24 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070723095357.GA886@elte.hu> <46A4B7C2.1070304@free.fr> <20070723160442.GA7995@elte.hu> <46A5B8E3.4060004@free.fr>
In-Reply-To: <46A5B8E3.4060004@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding linux-net to the mix ]

John Sigler wrote:

> ( check_dektec_in-1095 |#0): new 271 us user-latency.
> ( check_dektec_in-1095 |#0): new 275 us user-latency.
> ( check_dektec_in-1095 |#0): new 290 us user-latency.
> ( check_dektec_in-1095 |#0): new 297 us user-latency.
> ( check_dektec_in-1095 |#0): new 345 us user-latency.
> ( check_dektec_in-1095 |#0): new 358 us user-latency.
> ( check_dektec_in-1095 |#0): new 384 us user-latency.
> ( check_dektec_in-1095 |#0): new 392 us user-latency.
> ( check_dektec_in-1095 |#0): new 395 us user-latency.
> ( check_dektec_in-1095 |#0): new 396 us user-latency.
> ( check_dektec_in-1095 |#0): new 1031 us user-latency.
> ( check_dektec_in-1095 |#0): new 1100 us user-latency.
> ( check_dektec_in-1095 |#0): new 1105 us user-latency.
> ( check_dektec_in-1095 |#0): new 1106 us user-latency.
> 
> Here's the function trace for the 1106-µs latency:
> 
> http://linux.kernel.free.fr/latency/1106-us-trace.txt
> 
> These two lines repeat ~2000 times for ~800 µs:
> 
> softirq--4     0....  272us : __lock_text_start (rt_run_flush)
> softirq--4     0....  272us : rt_spin_unlock (rt_run_flush)
> 
> With a pair of the following in the middle:
> 
> softirq--4     0....  670us : call_rcu (rt_run_flush)
> softirq--4     0D..1  670us : __rcu_advance_callbacks (call_rcu)

Could someone explain why the kernel is "spinning" in rt_run_flush.
http://lxr.linux.no/source/net/ipv4/route.c#L692
What is the kernel trying to do?

Is the kernel in the following loop?

701         for (i = rt_hash_mask; i >= 0; i--) {
702                 spin_lock_bh(rt_hash_lock_addr(i));
703                 rth = rt_hash_table[i].chain;
704                 if (rth)
705                         rt_hash_table[i].chain = NULL;
706                 spin_unlock_bh(rt_hash_lock_addr(i));

Line 702 would be __lock_text_start (rt_run_flush)
Line 706 would be rt_spin_unlock
Is that correct?

And this would be done 2000 times because rt_hash_mask=2000?

Regards.
