Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbYKQTn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbYKQTn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYKQTnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:43:49 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:39464 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYKQTns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:43:48 -0500
Message-ID: <4921C947.9070609@cosmosbay.com>
Date: Mon, 17 Nov 2008 20:43:03 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
References: <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org>	<20081117182320.GA26844@elte.hu>	<20081117184951.GA5585@elte.hu> <20081117.113936.81699150.davem@davemloft.net>
In-Reply-To: <20081117.113936.81699150.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 20:43:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 17 Nov 2008 19:49:51 +0100
> 
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>> 4> The place for the sock_rfree() hit looks a bit weird, and i'll 
>>> investigate it now a bit more to place the real overhead point 
>>> properly. (i already mapped the test-bit overhead: that comes from 
>>> napi_disable_pending())
>> ok, here's a new set of profiles. (again for tbench 64-thread on a 
>> 16-way box, with v2.6.28-rc5-19-ge14c8bf and with the kernel config i 
>> posted before.)
> 
> Again, do a non-NMI profile and the top (at least for me)
> looks like this:
> 
> samples  %        app name                 symbol name
> 473       6.3928  vmlinux                  finish_task_switch
> 349       4.7169  vmlinux                  tcp_v4_rcv
> 327       4.4195  vmlinux                  U3copy_from_user
> 322       4.3519  vmlinux                  tl0_linux32
> 178       2.4057  vmlinux                  tcp_ack
> 170       2.2976  vmlinux                  tcp_sendmsg
> 167       2.2571  vmlinux                  U3copy_to_user
> 
> That tcp_v4_rcv() hit is %98 on the wake_up() call it does.
> 
> 

Another profile from my tree (net-next-2.6 + some patches), on my machine


CPU: Core 2, speed 3000.22 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 100000
samples  %        symbol name
223265    9.2711  __copy_user_zeroing_intel
87525     3.6345  __copy_user_intel
73203     3.0398  tcp_sendmsg
53229     2.2103  netif_rx
53041     2.2025  tcp_recvmsg
47241     1.9617  sysenter_past_esp
42888     1.7809  __copy_from_user_ll
40858     1.6966  tcp_transmit_skb
39390     1.6357  __switch_to
37363     1.5515  dst_release
36823     1.5291  __sk_dst_check_get
36050     1.4970  tcp_v4_rcv
35829     1.4878  __do_softirq
32333     1.3426  tcp_rcv_established
30451     1.2645  tcp_clean_rtx_queue
29758     1.2357  ip_queue_xmit
28497     1.1833  __copy_to_user_ll
28119     1.1676  release_sock
25218     1.0472  lock_sock_nested
23701     0.9842  __inet_lookup_established
23463     0.9743  tcp_ack
22989     0.9546  netif_receive_skb
21880     0.9086  sched_clock_cpu
20730     0.8608  tcp_write_xmit
20372     0.8460  ip_rcv
20336     0.8445  local_bh_enable
19153     0.7953  __update_sched_clock
18603     0.7725  skb_release_data
17020     0.7068  local_bh_enable_ip
16932     0.7031  process_backlog
16299     0.6768  ip_finish_output
16279     0.6760  dev_queue_xmit
15858     0.6585  sock_recvmsg
15641     0.6495  native_read_tsc
15454     0.6417  sock_wfree
15366     0.6381  update_curr
14585     0.6056  sys_socketcall
14564     0.6048  __alloc_skb
14519     0.6029  __tcp_select_window
14417     0.5987  tcp_current_mss
14391     0.5976  nf_iterate
14221     0.5905  page_address
14122     0.5864  local_bh_disable



