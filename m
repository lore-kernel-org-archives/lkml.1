Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbYKQTbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbYKQTbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYKQTbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:31:43 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:54209 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbYKQTbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:31:42 -0500
Message-ID: <4921C663.2050003@cosmosbay.com>
Date: Mon, 17 Nov 2008 20:30:43 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from	2.6.22
 -&gt; 2.6.28
References: <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu>
In-Reply-To: <20081117184951.GA5585@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 20:31:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> 4> The place for the sock_rfree() hit looks a bit weird, and i'll 
>> investigate it now a bit more to place the real overhead point 
>> properly. (i already mapped the test-bit overhead: that comes from 
>> napi_disable_pending())
> 
> ok, here's a new set of profiles. (again for tbench 64-thread on a 
> 16-way box, with v2.6.28-rc5-19-ge14c8bf and with the kernel config i 
> posted before.)
> 
> Here are the per major subsystem percentages:
> 
>            NET       overhead ( 5786945/10096751): 57.31%
>            security  overhead (  925933/10096751):  9.17%
>            usercopy  overhead (  837887/10096751):  8.30%
>            sched     overhead (  753662/10096751):  7.46%
>            syscall   overhead (  268809/10096751):  2.66%
>            IRQ       overhead (  266500/10096751):  2.64%
>            slab      overhead (  180258/10096751):  1.79%
>            timer     overhead (   92986/10096751):  0.92%
>            pagealloc overhead (   87381/10096751):  0.87%
>            VFS       overhead (   53295/10096751):  0.53%
>            PID       overhead (   44469/10096751):  0.44%
>            pagecache overhead (   33452/10096751):  0.33%
>            gtod      overhead (   11064/10096751):  0.11%
>            IDLE      overhead (       0/10096751):  0.00%
> ---------------------------------------------------------
>                          left (  753878/10096751):  7.47%
> 
> The breakdown is very similar to what i sent before, within noise.
> 
> [ 'left' is random overhead from all around the place - i categorized 
>   the 500 most expensive functions in the profile per subsystem.
>   I stopped short of doing it for all 1300+ functions: it's rather
>   laborous manual work even with hefty use of regex patterns.
>   It's also less meaningful in practice: the trend in the first 500
>   functions is present in the remaining 800 functions as well. I 
>   watched the breakdown evolve as i increased the coverage - in 
>   practice it is the first 100 functions that matter - it just doesnt 
>   change after that. ]
> 
> The readprofile output below seems structured in a more useful way now 
> - i tweaked compiler options to have the profiler hits spread out in a 
> more meaningful way. I collected 10 million NMI profiler hits, and 
> normalized the readprofile output up to 100%.
> 
> [ I'll post per function analysis as i complete them, as a reply to
>   this mail. ]
> 
> 	Ingo
> 
> 100.000000 total
> ................
>   7.253355 copy_user_generic_string
>   3.934833 avc_has_perm_noaudit

>   3.356152 ip_queue_xmit

>   3.038025 skb_release_data
>   2.118525 skb_release_head_state
>   1.997533 tcp_ack
>   1.833688 tcp_recvmsg

>   1.717771 eth_type_trans
Strange, in my profile, eth_type_trans is not in the top 20
Maybe an alignment problem ?
Oh, I understand, you hit the netdevice->last_rx update probblem, already corrected on net-next-2.6

>   1.673249 __inet_lookup_established
TCP established/timewait table is now RCUified (for linux-2.6.29), this one
should go down in profiles. 

>   1.508888 system_call

>   1.469183 tcp_current_mss
Yes there is a divide that might be expensive. discussion on netdev.

>   1.431553 tcp_transmit_skb
>   1.385125 tcp_sendmsg
>   1.327643 tcp_v4_rcv
>   1.292328 nf_hook_thresh
>   1.203205 schedule
>   1.059501 nf_hook_slow
>   1.027373 constant_test_bit
>   0.945183 sock_rfree
>   0.922748 __switch_to
>   0.911605 netif_rx
>   0.876270 register_gifconf
>   0.788200 ip_local_deliver_finish
>   0.781467 dev_queue_xmit
>   0.766530 constant_test_bit
>   0.758208 _local_bh_enable_ip
>   0.747184 load_cr3
>   0.704341 memset_c
>   0.671260 sysret_check
>   0.651845 ip_finish_output2
>   0.620204 audit_free_names


