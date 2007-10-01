Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbXJAGnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbXJAGnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 02:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbXJAGno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 02:43:44 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:41459 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXJAGnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 02:43:43 -0400
From: "Denys" <nuclearcat@nuclearcat.com>
To: linux-kernel@vger.kernel.org
Cc: data1@cosmosbay.com
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Date: Mon, 1 Oct 2007 09:43:31 +0300
Message-Id: <20071001064331.M36471@nuclearcat.com>
In-Reply-To: <200709301425.37564.nickpiggin@yahoo.com.au>
References: <20070930144443.M52139@visp.net.lb> <46FFE17C.9020202@cosmosbay.com> <200709301425.37564.nickpiggin@yahoo.com.au>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a bit more details about hardware:

Sun Fire X4100 (AMD Opteron 252), chipset looks like AMD-8111/AMD-8131 chips.
There is no HPET detected, and by default acpi_pm used, which is seems more 
CPU intensive(based on oprofile results) than TSC. Choosing TSC over /sys 
doesn't make much difference.

Workload is http requests coming from customers, noticeable slowdown 
happening on >250 requests/second, then routed to squid, then marked at squid 
ToS and depends on ToS routed over netfilter to required TCP port. At 
required TCP port "satellite accelerator" intercepting connection (so it is 
loopback, and it means "double" tcp work), and encapsulate stuff to UDP. Sure 
receiving UDP (stream around 10-20Mbit/s), and decapsulating ... and same way 
but in reverse to customer. So summary:

2x Opteron 2.4 Ghz
Processing incoming TCP requests rate 250-500 req/s
Incoming TCP bandwidth around 3-5 Mbit/s
Outgoing TCP bandwidth around 33-35Mbit/s 
Internally routed TCP also around this number (-cached content)
Incoming UDP bandwidth arounn 20-25Mbit/s
Outgoing UDP bandwidth around 500Kbit/s


At 2x Dual Core Opteron 2.6 Ghz (means total 4 cores) and similar load i 
cannot notice big slowdown, so it is noticable only when hardware used nearby 
it's limits i think. BUT! I can notice in mpstat spikes of softirq, from 
normal value 7-8% to 50-60%, but it didn't cause any noticeable slowdown on 
ssh or system operations. I am expecting 2.6.21 to serve 600-700 req/s. Maybe 
there is some additional overhead in this calculations, or improper irq 
locking? I am not guru in such stuff.
I guess who have similar workload can check mpstat 1, and see if there is 
spikes in soft% or not.


>Denys a :
>> Hi 
>> 
>> I got
>> 
>> pi linux-git # git bisect bad
>> Bisecting: 0 revisions left to test after this
>> [f85958151900f9d30fa5ff941b0ce71eaa45a7de] [NET]: random functions can use 
>> nsec resolution instead of usec
>> 
>> I will make sure and will try to reverse this patch on 2.6.22
>> 
>> But it seems "that's it".
>
>Well... thats interesting...
>
>No problem here on bigger servers, so I CC David Miller and netdev on this 
>one.
>
>AFAIK do_gettimeofday() and ktime_get_real() should use the same underlying 
>hardware functions on PC and no performance problem should happen here.
>
>(relevant part of this patch :
>
>@ -1521,7 +1515,6 @@ __u32 secure_ip_id(__be32 daddr)
>  __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
>                                  __be16 sport, __be16 dport)
>  {
>-       struct timeval tv;
>         __u32 seq;
>         __u32 hash[4];
>         struct keydata *keyptr = get_keyptr();
>@@ -1543,12 +1536,11 @@ __u32 secure_tcp_sequence_number(__be32 saddr, 
>__be32 
>daddr,
>          *      As close as possible to RFC 793, which
>          *      suggests using a 250 kHz clock.
>          *      Further reading shows this assumes 2 Mb/s networks.
>-        *      For 10 Mb/s Ethernet, a 1 MHz clock is appropriate.
>+        *      For 10 Gb/s Ethernet, a 1 GHz clock is appropriate.
>          *      That's funny, Linux has one built in!  Use it!
>          *      (Networks are faster now - should this be increased?)
>          */
>-       do_gettimeofday(&tv);
>-       seq += tv.tv_usec + tv.tv_sec * 1000000;
>+       seq += ktime_get_real().tv64;
>
>
>Thank you for doing this research.
>
>> 
>> 
>> On Sun, 30 Sep 2007 14:25:37 +1000, Nick Piggin wrote
>>> Hi Denys, thanks for reporting (btw. please reply-to-all when 
>>> replying on lkml).
>>>
>>> You say that SLAB is better than SLUB on an otherwise identical 
>>> kernel, but I didn't see if you quantified the actual numbers? It 
>>> sounds like there is still a regression with SLAB?
>>>
>>> On Monday 01 October 2007 03:48, Eric Dumazet wrote:
>>>> Denys a  :
>>>>> I've moved recently one of my proxies(squid and some compressing
>>>>> application) from 2.6.21 to 2.6.22, and notice huge performance drop. I
>>>>> think this is important, cause it can cause serious regression on some
>>>>> other workloads like busy web-servers and etc.
>>>>>
>>>>> After some analysis of different options i can bring more exact numbers:
>>>>>
>>>>> 2.6.21 able to process 500-550 requests/second and 15-20 Mbit/s of
>>>>> traffic, and working great without any slowdown or instability.
>>>>>
>>>>> 2.6.22 able to process only 250-300 requests and 8-10 Mbit/s of traffic,
>>>>> ssh and console is "freezing" (there is delay even for typing
>>>>> characters).
>>>>>
>>>>> Both proxies is on identical hardware(Sun Fire X4100),
>>>>> configuration(small system, LFS-like, on USB flash), different only
>>>>> kernel.
>>>>>
>>>>> I tried to disable/enable various options and optimisations - it doesn't
>>>>> change anything, till i reach SLUB/SLAB option.
>>>>>
>>>>> I've loaded proxy configuration to gentoo PC with 2.6.22 (then upgraded
>>>>> it to 2.6.23-rc8), and having same effect.
>>>>> Additionally, when load reaching maximum i can notice whole system
>>>>> slowdown, for example ssh and scp takes much more time to run, even i do
>>>>> nice -n -5 for them.
>>>>>
>>>>> But even choosing 2.6.23-rc8+SLAB i noticed same "freezing" of ssh (and
>>>>> sure it slowdown other kind of network performance), but much less
>>>>> comparing with SLUB. On top i am seeing ksoftirqd taking almost 100%
>>>>> (sometimes ksoftirqd/0, sometimes ksoftirqd/1).
>>>>>
>>>>> I tried also different tricks with scheduler (/proc/sys/kernel/sched*),
>>>>> but it's also didn't help.
>>>>>
>>>>> When it freezes it looks like:
>>>>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>>>>     7 root      15  -5     0    0    0 R   64  0.0   2:47.48 ksoftirqd/1
>>>>>  5819 root      20   0  134m 130m  596 R   57  3.3   4:36.78 globax
>>>>>  5911 squid     20   0 1138m 1.1g 2124 R   26 28.9   2:24.87 squid
>>>>>    10 root      15  -5     0    0    0 S    1  0.0   0:01.86 events/1
>>>>>  6130 root      20   0  3960 2416 1592 S    0  0.1   0:08.02 oprofiled
>>>>>
>>>>>
>>>>> Oprofile results:
>>>>>
>>>>>
>>>>> Thats oprofile with 2.6.23-rc8 - SLUB
>>>>>
>>>>> 73918    21.5521  check_bytes
>>>>> 38361    11.1848  acpi_pm_read
>>>>> 14077     4.1044  init_object
>>>>> 13632     3.9747  ip_send_reply
>>>>> 8486      2.4742  __slab_alloc
>>>>> 7199      2.0990  nf_iterate
>>>>> 6718      1.9588  page_address
>>>>> 6716      1.9582  tcp_v4_rcv
>>>>> 6425      1.8733  __slab_free
>>>>> 5604      1.6339  on_freelist
>>>>>
>>>>>
>>>>> Thats oprofile with 2.6.23-rc8 - SLAB
>>>>>
>>>>> CPU: AMD64 processors, speed 2592.64 MHz (estimated)
>>>>> Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a
>>>>> unit mask of 0x00 (No unit mask) count 100000
>>>>> samples  %        symbol name
>>>>> 138991   14.0627  acpi_pm_read
>>>>> 52401     5.3018  tcp_v4_rcv
>>>>> 48466     4.9037  nf_iterate
>>>>> 38043     3.8491  __slab_alloc
>>>>> 34155     3.4557  ip_send_reply
>>>>> 20963     2.1210  ip_rcv
>>>>> 19475     1.9704  csum_partial
>>>>> 19084     1.9309  kfree
>>>>> 17434     1.7639  ip_output
>>>>> 17278     1.7481  netif_receive_skb
>>>>> 15248     1.5428  nf_hook_slow
>>>>>
>>>>> My .config is at http://www.nuclearcat.com/.config (there is SPARSEMEM
>>>>> enabled, it doesn't make any noticeable difference)
>>>>>
>>>>> Please CC me on reply, i am not in list.
>>>> Could you try with SLUB but disabling CONFIG_SLUB_DEBUG ?
>> 
>> 
>> --
>> Denys Fedoryshchenko
>> Technical Manager
>> Virtual ISP S.A.L.
>> 
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> 
>> 
--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

