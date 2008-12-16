Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759160AbYLQAA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbYLQAA2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYLQAAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:00:10 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:46369 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYLQAAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:00:08 -0500
Message-ID: <494840C4.50000@cosmosbay.com>
Date: Wed, 17 Dec 2008 00:59:00 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, paulus@samba.org,
        benh@kernel.crashing.org, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: local_add_return
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com> <200812161703.00697.rusty@rustcorp.com.au> <20081215.231314.92267481.davem@davemloft.net> <200812170908.05423.rusty@rustcorp.com.au>
In-Reply-To: <200812170908.05423.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 17 Dec 2008 00:59:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell a écrit :
> On Tuesday 16 December 2008 17:43:14 David Miller wrote:
>> Here ya go:
> 
> Very interesting.  There's a little noise there (that first local_inc of 243
> is wrong), but the picture is clear: trivalue is the best implementation for
> sparc64.
> 
> Note: trivalue uses 3 values, so instead of hitting random values across 8MB
> it's across 24MB, and despite the resulting cache damage it's 15% faster.  The
> cpu_local_inc test is a single value, so no cache effects: it shows trivalue
> to be 3 to 3.5 times faster in the cache-hot case.
> 
> This sucks, because it really does mean that there's no one-size-fits-all
> implementation of local_t.  There's also no platform yet where atomic_long_t
> is the right choice; and that's the default!
> 
> Any chance of an IA64 or s390 run?  You can normalize if you like, since
> it's only to compare the different approaches.
> 
> Cheers,
> Rusty.
> 
> Benchmarks for local_t variants
> 
> (This patch also fixes the x86 cpu_local_* macros, which are obviously
> unused).
> 
> I chose a large array (1M longs) for the inc/add/add_return tests so
> the trivalue case would show some cache pressure.
> 
> The cpu_local_inc case is always cache-hot, so it's not comparable to
> the others.

Would be good to differenciate results, if data is already in cache or not...

> 
> Time in ns per iteration (brackets is with CONFIG_PREEMPT=y):
> 
> 		inc	add	add_return	cpu_local_inc	read
> x86-32: 2.13 Ghz Core Duo 2
> atomic_long	118	118	115		17		17

really strange atomic_long performs so badly here.
LOCK + data not in cache -> really really bad...

> irqsave/rest	77	78	77		23		16
> trivalue	45	45	127		3(6)		21
> local_t		36	36	36		1(5)		17
> 
> x86-64: 2.6 GHz Dual-Core AMD Opteron 2218
> atomic_long	55	60	-		6		19
> irqsave/rest	54	54	-		11		19
> trivalue	47	47	-		5		28
> local_t		47	46	-		1		19
> 

Running local_t variant benchmarks
atomic_long: local_inc=395001846/11 local_add=395000325/11 cpu_local_inc=362000295/10 local_read=49000040/1 local_add_return=396000322/11 (total was 1728053248)
irqsave/restore: local_inc=498000400/14 local_add=496000395/14 cpu_local_inc=486000384/14 local_read=68000054/2 local_add_return=502000394/14 (total was 1728053248)
trivalue: local_inc=1325001024/39 local_add=1324001226/39 cpu_local_inc=81000080/2 local_read=786000766/23 local_add_return=4193003781/124 (total was 1728053248)
local_t: local_inc=69000059/2 local_add=69000058/2 cpu_local_inc=42000035/1 local_read=50000043/1 local_add_return=90000076/2 (total was 1728053248, warm_total 62914562)


Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz

two quadcore cpus, x86-32 kernel

It seems Core2 are really better than Core Duo 2,
or their cache is big enough to hold the array of your test...

(at least for l1 & l2, their 4Mbytes working set fits in cache)

processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz
stepping        : 6
cpu MHz         : 3000.099
cache size      : 6144 KB    <<<< yes, thats big :) >>>>

If I double size of working set

#define NUM_LOCAL_TEST (2*1024*1024)

then I get quite different numbers :

Running local_t variant benchmarks
atomic_long: local_inc=6729007264/100 local_add=6727005943/100 cpu_local_inc=724000569/10 local_read=1030000784/15 local
_add_return=6623004616/98 (total was 3456106496)
irqsave/restore: local_inc=4458002796/66 local_add=4459001998/66 cpu_local_inc=971000381/14 local_read=1060000389/15 loc
al_add_return=4528001388/67 (total was 3456106496)
trivalue: local_inc=2871000855/42 local_add=2867000976/42 cpu_local_inc=162000052/2 local_read=1747000551/26 local_add_r
eturn=8829002352/131 (total was 3456106496)
local_t: local_inc=2210000492/32 local_add=2206000460/32 cpu_local_inc=84000017/1 local_read=1029000203/15 local_add_ret
urn=2216000415/33 (total was 3456106496, warm_total 125829124)

If now I reduce NUM_LOCAL_TEST to 256*1024 so that even trivalue l3 fits cache.

Running local_t variant benchmarks
atomic_long: local_inc=98984929/11 local_add=98984889/11 cpu_local_inc=89986248/10 local_read=11998165/1 local_add_retur
n=99003292/11 (total was 2579496960)
irqsave/restore: local_inc=124000102/14 local_add=124000102/14 cpu_local_inc=121000100/14 local_read=17000013/2 local_ad
d_return=126000103/15 (total was 2579496960)
trivalue: local_inc=21000017/2 local_add=20000016/2 cpu_local_inc=20000017/2 local_read=25000021/2 local_add_return=1360
00110/16 (total was 2579496960)
local_t: local_inc=17000014/2 local_add=17000015/2 cpu_local_inc=11000009/1 local_read=12000010/1 local_add_return=23000
019/2 (total was 2579496960, warm_total 15728642)



About trivalues, their use in percpu_counter local storage (one trivalue for each cpu)
would make the accuracy a litle bit more lazy...


