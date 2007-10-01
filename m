Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbXJAJ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbXJAJ1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbXJAJ1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:27:37 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:48531 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbXJAJ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:27:35 -0400
Message-ID: <4700BD57.1090404@free.fr>
Date: Mon, 01 Oct 2007 11:26:47 +0200
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: 2.6.23-rc8-mm2 - tcp_fastretrans_alert() WARNING
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <46FD20F0.3050909@fr.ibm.com> <Pine.LNX.4.64.0709282143020.6013@kivilampi-30.cs.helsinki.fi> <Pine.LNX.4.64.0709291532200.6776@kivilampi-30.cs.helsinki.fi> <46FE6751.3050205@free.fr> <Pine.LNX.4.64.0709292333480.8339@kivilampi-30.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0709292333480.8339@kivilampi-30.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> On Sat, 29 Sep 2007, Cedric Le Goater wrote:
> 
>> Ilpo Järvinen wrote:
>>> On Fri, 28 Sep 2007, Ilpo Järvinen wrote:
>>>> On Fri, 28 Sep 2007, Cedric Le Goater wrote:
>>>>
>>>>> I just found that warning in my logs. It seems that it's been 
>>>>> happening since rc7-mm1 at least. 
>>>>>
>>>>> WARNING: at /home/legoater/linux/2.6.23-rc8-mm2/net/ipv4/tcp_input.c:2314 tcp_fastretrans_alert()
>>>>>
>>>>> Call Trace:
>>>>>  <IRQ>  [<ffffffff8040fdc3>] tcp_ack+0xcd6/0x1894
>>>>> ...snip...
>>>> ...Thanks for the report, I'll have look what could still break 
>>>> fackets_out...
>>> I think this one is now clear to me, tcp_fragment/collapse adjusts 
>>> fackets_out (incorrectly) also for reno flow when there were some dupACKs 
>>> that made sacked_out != 0. Could you please try if patch below proves all 
>>> them to be of non-SACK origin... In case that's true, it's rather 
>>> harmless, I'll send a fix on Monday or so (this would anyway be needed)... 
>>> If you find out that them occur with SACK enabled flow, that would be
>>> more interesting and requires more digging...
>> I'm trying now to reproduce this WARNING. 
>>
>> It seems that the n/w behaves differently during the week ends. Probably
>> taking a break. 
> 
> Thanks.
> 
> Of course there are other means too to determine if TCP flows do negotiate 
> SACK enabled or not. Depending on your test case (which is fully unknown 
> to me) they may or may not be usable... At least the value of tcp_sack 
> sysctl on both systems or tcpdump catching SYN packets should give that 
> detail. ...If you know to which hosts TCP could be connected (and active) 
> to, while the WARNING triggers, it's really easy to test what is being 
> negotiated as it's unlikely to change at short notice and any TCP flow to 
> that host will get us the same information though the WARNING would not be 
> triggered with it at this time. Obviously if at least one of the remotes 
> is not known or the set ends up being mixture of reno and SACK flows, then 
> we'll just have to wait and see which fish we get...
 
got it !

r3-06.test.meiosys.com login: WARNING: at /home/legoater/linux/2.6.23-rc8-mm2/net/ipv4/tcp_input.c:2314 tcp_fastretrans_alert()

Call Trace:
 <IRQ>  [<ffffffff8040fdc3>] tcp_ack+0xcd6/0x18af
 [<ffffffff80412b6f>] tcp_rcv_established+0x61f/0x6df
 [<ffffffff80254146>] __lock_acquire+0x8a1/0xf1b
 [<ffffffff80419d19>] tcp_v4_do_rcv+0x3e/0x394
 [<ffffffff8041a68b>] tcp_v4_rcv+0x61c/0x9a9
 [<ffffffff803ff1e3>] ip_local_deliver+0x1da/0x2a4
 [<ffffffff803ffb4e>] ip_rcv+0x583/0x5c9
 [<ffffffff8046d35b>] packet_rcv_spkt+0x19a/0x1a8
 [<ffffffff803e081c>] netif_receive_skb+0x2cf/0x2f5
 [<ffffffff88042505>] :tg3:tg3_poll+0x65d/0x8a4
 [<ffffffff803e09e8>] net_rx_action+0xb8/0x191
 [<ffffffff8023a927>] __do_softirq+0x5f/0xe0
 [<ffffffff8020c98c>] call_softirq+0x1c/0x28
 [<ffffffff8020e9c3>] do_softirq+0x3b/0xb8
 [<ffffffff8023aa1e>] irq_exit+0x4e/0x50
 [<ffffffff8020e7df>] do_IRQ+0xbd/0xd7
 [<ffffffff80209cb9>] mwait_idle+0x0/0x4d
 [<ffffffff8020bce6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80209cfc>] mwait_idle+0x43/0x4d
 [<ffffffff802099fb>] enter_idle+0x22/0x24
 [<ffffffff80209c4f>] cpu_idle+0x9d/0xc0
 [<ffffffff80476aa1>] rest_init+0x55/0x57
 [<ffffffff80630815>] start_kernel+0x2d6/0x2e2
 [<ffffffff80630134>] _sinittext+0x134/0x13b

TCP 0


I wasn't doing any particular test on n/w so it took me a while to figure 
out how I was triggering the WARNING. Apparently, this is happening when I 
run ketchup, but not always. This test machine is behind many firewall & 
routers so it might be a reason.

tcpdump gave me this output for a wget on kernel.org :

10:51:14.835981 IP r3-06.test.meiosys.com.40322 > pub2.kernel.org.http: S 737836267:737836267(0) win 5840 <mss 1460,sackOK,timestamp 1309245 0,nop,wscale 7>
10:51:14.975153 IP pub2.kernel.org.http > r3-06.test.meiosys.com.40321: F 524:524(0) ack 166 win 5840
10:51:14.975177 IP r3-06.test.meiosys.com.40321 > pub2.kernel.org.http: . ack 525 win 7504

I'm trying to get the WARNING and the tcpdump output for it but for the
moment, it seems it's beyond my reach :/

Hope it helps !

C. 

