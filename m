Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZCQEKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZCQEKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZCQEKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:10:21 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:37202 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751134AbZCQEKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:10:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQFAHW8vklMQW1W/2dsb2JhbACBTtMkg38G
Date: Tue, 17 Mar 2009 00:10:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, jwboyer@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
Message-ID: <20090317041016.GA26748@Krystal>
References: <20090317013220.GA22474@Krystal> <20090316.203705.218202510.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090316.203705.218202510.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:53:35 up 17 days, 19 min,  1 user,  load average: 0.62, 0.67,
	0.64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Mon, 16 Mar 2009 21:32:20 -0400
> 
> > If some of you would be kind enough to run my test module provided below
> > and provide the results of these tests on a recent kernel (2.6.26~2.6.29
> > should be good) along with their cpuinfo, I would greatly appreciate.
> 
> Here's sparc64, but cycles is always computed as zero.
> 
> Probably that's because get_cycles() on sparc64 counts system
> bus clock cycles, not CPU cycles, and you the loop iteration
> isn't expensive enough to get a system clock tick in.
> 
> This is a dual UltraSPARC-IIIi at 1.2 GHz
> 

Hi David,

Thanks for running those tests. Actually, I did not expect good results
for sparc64 because the local_t primitives map to atomic_t. Looking at
sparc atomic_64.h, I notice that all atomic operations except cmpxchg
are done through function calls even when those functions only contain
few instructions.  Is there any particular reason for that ? These
function calls can be quite costly. We could easily inline those.

And to "unleash" the full power of local_t, we should see if there are
variants of the atomic operations which are safe only on UP and if there
are some memory barriers currently embedded in the atomic_t ops we could
remove in a local_t version. Actually, all the
BACKOFF_SETUP/BACKOFF_SPIN is specific to SMP, and therefore the local_t
version probably does not need that because it touches specifically
per-cpu data. That could give very interesting results.

The reason why the results shows 0 cycles per loop is just because there
is less that a bus clock cycle per loop. But the total time (in bus
cycles) for the whole 20000 cycles gives us equivalent information.

Mathieu

> [1052598.484452] test init
> [1052598.486230] test results: time for baseline
> [1052598.487878] number of loops: 20000
> [1052598.489485] total time: 752
> [1052598.491061] -> baseline takes 0 cycles
> [1052598.492649] test end
> [1052598.494874] test results: time for locked cmpxchg
> [1052598.496460] number of loops: 20000
> [1052598.498005] total time: 7879
> [1052598.499521] -> locked cmpxchg takes 0 cycles
> [1052598.501060] test end
> [1052598.503194] test results: time for non locked cmpxchg
> [1052598.504733] number of loops: 20000
> [1052598.506213] total time: 7879
> [1052598.507722] -> non locked cmpxchg takes 0 cycles
> [1052598.509229] test end
> [1052598.511347] test results: time for locked add return
> [1052598.512821] number of loops: 20000
> [1052598.514265] total time: 8254
> [1052598.515682] -> locked add return takes 0 cycles
> [1052598.517130] test end
> [1052598.519427] test results: time for non locked add return
> [1052598.520850] number of loops: 20000
> [1052598.522230] total time: 11259
> [1052598.523561] -> non locked add return takes 0 cycles
> [1052598.524939] test end
> [1052598.526393] test results: time for enabling interrupts (STI)
> [1052598.527767] number of loops: 20000
> [1052598.529085] total time: 1877
> [1052598.530373] -> enabling interrupts (STI) takes 0 cycles
> [1052598.531713] test end
> [1052598.533240] test results: time for disabling interrupts (CLI)
> [1052598.534594] number of loops: 20000
> [1052598.535892] total time: 3189
> [1052598.537189] -> disabling interrupts (CLI) takes 0 cycles
> [1052598.538551] test end
> [1052598.540176] test results: time for disabling/enabling interrupts (STI/CLI)
> [1052598.541579] number of loops: 20000
> [1052598.542900] total time: 3940
> [1052598.544207] -> enabling/disabling interrupts (STI/CLI) takes 0 cycles
> [1052598.545595] test end
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
