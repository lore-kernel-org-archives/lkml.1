Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYKQLWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYKQLWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 06:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYKQLWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 06:22:15 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:41999 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYKQLWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 06:22:15 -0500
Message-ID: <4921539B.2000002@cosmosbay.com>
Date: Mon, 17 Nov 2008 12:20:59 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11308] tbench regression on each kernel release from	2.6.22
 -&gt; 2.6.28
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu>
In-Reply-To: <20081117110119.GL28786@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 12:21:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * David Miller <davem@davemloft.net> wrote:
> 
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Mon, 17 Nov 2008 10:06:48 +0100
>>
>>> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>
>>>> This message has been generated automatically as a part of a report
>>>> of regressions introduced between 2.6.26 and 2.6.27.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
>>>> be listed and let me know (either way).
>>>>
>>>>
>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
>>>> Subject		: tbench regression on each kernel release from  2.6.22 -&gt; 2.6.28
>>>> Submitter	: Christoph Lameter <cl@linux-foundation.org>
>>>> Date		: 2008-08-11 18:36 (98 days old)
>>>> References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
>>>> 		  http://marc.info/?l=linux-kernel&m=122125737421332&w=4
>>> Christoph, as per the recent analysis of Mike:
>>>
>>>  http://fixunix.com/kernel/556867-regression-benchmark-throughput-loss-a622cf6-f7160c7-pull.html
>>>
>>> all scheduler components of this regression have been eliminated.
>>>
>>> In fact his numbers show that scheduler speedups since 2.6.22 have 
>>> offset and hidden most other sources of tbench regression. (i.e. the 
>>> scheduler portion got 5% faster, hence it was able to offset a 
>>> slowdown of 5% in other areas of the kernel that tbench triggers)
>> Although I respect the improvements, wake_up() is still several 
>> orders of magnitude slower than it was in 2.6.22 and wake_up() is at 
>> the top of the profiles in tbench runs.
> 
> hm, several orders of magnitude slower? That contradicts Mike's 
> numbers and my own numbers and profiles as well: see below.
> 
> The scheduler's overhead barely even registers on a 16-way x86 system 
> i'm running tbench on. Here's the NMI profile during 64 threads tbench 
> on a 16-way x86 box with an v2.6.28-rc5 kernel [config attached]:
> 
>   Throughput 3437.65 MB/sec 64 procs
>   ==================================
>   21570252  total 
>   ........
>    1494803  copy_user_generic_string 
>     998232  sock_rfree 
>     491471  tcp_ack 
>     482405  ip_dont_fragment 
>     470685  ip_local_deliver 
>     436325  constant_test_bit         [ called by napi_disable_pending() ]
>     375469  avc_has_perm_noaudit 
>     347663  tcp_sendmsg 
>     310383  tcp_recvmsg 
>     300412  __inet_lookup_established 
>     294377  system_call 
>     286603  tcp_transmit_skb 
>     251782  selinux_ip_postroute 
>     236028  tcp_current_mss 
>     235631  schedule 
>     234013  netif_rx 
>     229854  _local_bh_enable_ip 
>     219501  tcp_v4_rcv 
> 
>     [ etc. - see full profile attached further below ]
> 
> Note that the scheduler does not even show up in the profile up to 
> entry #15!
> 
> I've also summarized NMI profiler output by major subsystems:
> 
>            NET       overhead (12603450/21570252): 58.43%
>            security  overhead ( 1903598/21570252):  8.83%
>            usercopy  overhead ( 1753617/21570252):  8.13%
>            sched     overhead ( 1599406/21570252):  7.41%
>            syscall   overhead (  560487/21570252):  2.60%
>            IRQ       overhead (  555439/21570252):  2.58%
>            slab      overhead (  492421/21570252):  2.28%
>            timer     overhead (  226573/21570252):  1.05%
>            pagealloc overhead (  192681/21570252):  0.89%
>            PID       overhead (  115123/21570252):  0.53%
>            VFS       overhead (  107926/21570252):  0.50%
>            pagecache overhead (   62552/21570252):  0.29%
>            gtod      overhead (   38651/21570252):  0.18%
>            IDLE      overhead (       0/21570252):  0.00%
> ---------------------------------------------------------
>                          left ( 1349494/21570252):  6.26%
> 
> The scheduler's functions are absolutely flat, and consistent with an 
> extreme context-switching rate of 1.35 million per second. The 
> scheduler can go up to about 20 million context switches per second on 
> this system:
> 
>  procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
>   r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  32  0      0 32229696  29308 649880    0    0     0     0 164135 20026853 24 76  0  0  0
>  32  0      0 32229752  29308 649880    0    0     0     0 164203 20032770 24 76  0  0  0
>  32  0      0 32229752  29308 649880    0    0     0     0 164201 20036492 25 75  0  0  0
> 
> ... and 7% scheduling overhead is roughly consistent with 1.35/20.0.
> 
> Wake up affinities and data flow caching is just fine in this workload 
> - we've got scheduler statistics for that and they look good too.
> 
> It all looks like pure old-fashioned straight overhead in the 
> networking layer to me. Do we still touch the same global cacheline 
> for every localhost packet we process? Anything like that would show 
> up big time.

Yes we do, I find strange we dont see dst_release() in your NMI profile

I posted a patch ( commit 5635c10d976716ef47ae441998aeae144c7e7387
net: make sure struct dst_entry refcount is aligned on 64 bytes)
 (in net-next-2.6 tree)
to properly align struct dst_entry refcounter and got 4% speedup on tbench on my machine.

Small speedups too with commit ef711cf1d156428d4c2911b8c86c6ce90519dc45
(net: speedup dst_release())

Also on net-next-2.6, patches avoid dirtying last_rx on netdevices (loopback for example)
, it helps a lot tbench too.


