Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZFHRab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZFHRab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZFHRaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:30:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:58038 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZFHRaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:30:16 -0400
Message-ID: <4A2D4AA7.6020204@gmail.com>
Date: Mon, 08 Jun 2009 19:30:15 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [Security, resend] Instant crash with rtl8169 and large packets
References: <4A2D1147.8020101@msgid.tls.msk.ru> <4A2D1FE4.5030100@gmail.com> <4A2D25F6.9080300@msgid.tls.msk.ru> <4A2D2906.6090002@gmail.com> <4A2D301D.9040301@msgid.tls.msk.ru> <4A2D3568.6010901@gmail.com> <4A2D3BC6.3040904@msgid.tls.msk.ru>
In-Reply-To: <4A2D3BC6.3040904@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 08 Jun 2009 19:30:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev a écrit :
> Eric Dumazet wrote:
>> Michael Tokarev a écrit :
>>> Eric Dumazet wrote:
>>>> Michael Tokarev a écrit :
>>> []
>>>>>>> The situation is very simple: with an RTL8169 (probably
>>>>>>> onboard) GigE card which, by default, is configured to
>>>>>>> have MTU (maximal transmission unit) to be 1500 bytes,
>>>>>>> it's *trivial* to instantly crash the machine by sending
>>>>>>> it a *single* packet of size >1500 bytes (provided the
>>>>>>> network switch can handle jumbo frames).
>>> []
>>>> OK, 2nd try then :)
>>>> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
>>>> index e94316b..9080b08 100644
>>>> --- a/drivers/net/r8169.c
>>>> +++ b/drivers/net/r8169.c
>>>> @@ -3495,7 +3495,8 @@ static int rtl8169_rx_interrupt(struct
>>>> net_device *dev,
>>>>               * frames. They are seen as a symptom of over-mtu
>>>>               * sized frames.
>>>>               */
>>>> -            if (unlikely(rtl8169_fragmented_frame(status))) {
>>>> +            if (unlikely(rtl8169_fragmented_frame(status) ||
>>>> +                     (unsigned int)pkt_size > tp->rx_buf_sz)) {
>>>>                  dev->stats.rx_dropped++;
>>>>                  dev->stats.rx_length_errors++;
>>>>                  rtl8169_mark_to_asic(desc, tp->rx_buf_sz);
>>> This one behaves much better.  There's no instant crash anymore, and the
>>> 'dropped' and 'frame' stats in ifconfig gets incremented with each ping.
>>>
>>> It fails down the line however.  I wasn't able to reply to this email
>>> after
>>> doing the ping test with the above change (no more large packets were
>>> sent).
>>> With OOPSes like this one:
>>>
>>>  general protection fault: 0000 [#1] SMP
> []
>>>   [<ffffffff803dbc7f>] ? skb_release_data+0xaf/0xe0
>>>   [<ffffffff803db911>] ? __kfree_skb+0x11/0xa0
>>>   [<ffffffff80418a88>] ? tcp_recvmsg+0x6d8/0x950
> []
>>> Looks like some memory corruption.  And most probably it is in
>>> that error path in r8169 driver - it is the only new codepath
>>> which were executed here.  The problem is quite repeatable -
>>> after sending a single large ping system starts behaving like
>>> the above at random.
> []
>> Hmm... this code path is not new, I believe your adapter is buggy,
>> because it
>> is overwriting part of memory it should not touch at all.
>>
>> When this driver queues a skb in rx queue, it tells NIC the max size
>> of the skb,
>> and apparently NIC happily delivers packets with larger sizes, so
>> probably DMA
>> wrote data past end of skb data.
> 
> That's a very likely situation.
> 
>> Try to change
>> static void rtl_set_rx_max_size(void __iomem *ioaddr)
>>     RTL_W16(RxMaxSize, 16383);
>> to ->
>>
>>     RTL_W16(RxMaxSize, RX_BUF_SIZE);
>>
>> (But it will probably break jumbo frames rx as well)
> 
> (RX_BUF_SIZE is defined as 1536).
> Aha, so it should set some flags instead (as were tested in your
> first try), for packets larger than that.  Makes sense.
> 
> But if we told the NIC that we can receive 16K buffers, and it
> delivered 3K packet to us, we've got some memory corruption...
> I.e., the problem is that we told the driver that we can handle
> 16k buffers but actually we had only 1500, no?
> 
> Lemme check this all...
> 
> Setting RxMaxSize to RX_BUF_SIZE indeed solved the problem, --
> I don't see random corruptions like the last one above.
> 
> But after setting RxMaxSize to 2500, I can trigger your 2nd
> check/patch condition (for pkt_size > tp->rx_buf_sz) for
> packets <2500 in size, and your *first* check/patch condition
> (RxRES | RxRWT | RxRUNT | RxCRC | RxFOVF) for packets >2500
> in size.
> 
> So to me (who has no knowledge about hardware at all), it looks
> like the card behaves quite correctly.
> 
> Also note that I've seen this behavior on several different
> machines.  Here @home where I'm doing this all testing I've
> Asus M3A78-EM motherboard (AMD780), and the second one is
> Gigabyte GA-MA74GM-S2H (AMD740) - both behaves very similarly.
> Both are AMD7xx, but I've seen the same problem on Intel-based
> machines too.
> 
> I'll try out some more tests later today.  (And there's another
> issue with these NICs -- the famous, quite frequent under load
> "NETDEV WATCHDOG: eth0 (r8169): transmit timed out" errors, which
> are quite annoying... Also shown by both the above-mentioned mobos
> and by other machines).
> 
> Thanks!
> 

OK I suspect driver is buggy since 2.6.10 days :)

Could you try this patch ?

Thanks

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 8247a94..c5ab5a8 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2357,10 +2357,10 @@ static u16 rtl_rw_cpluscmd(void __iomem *ioaddr)
 	return cmd;
 }
 
-static void rtl_set_rx_max_size(void __iomem *ioaddr)
+static void rtl_set_rx_max_size(void __iomem *ioaddr, unsigned int rx_buf_sz)
 {
 	/* Low hurts. Let's disable the filtering. */
-	RTL_W16(RxMaxSize, 16383);
+	RTL_W16(RxMaxSize, rx_buf_sz);
 }
 
 static void rtl8169_set_magic_reg(void __iomem *ioaddr, unsigned mac_version)
@@ -2407,7 +2407,7 @@ static void rtl_hw_start_8169(struct net_device *dev)
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	if ((tp->mac_version == RTL_GIGA_MAC_VER_01) ||
 	    (tp->mac_version == RTL_GIGA_MAC_VER_02) ||
@@ -2668,7 +2668,7 @@ static void rtl_hw_start_8168(struct net_device *dev)
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	tp->cp_cmd |= RTL_R16(CPlusCmd) | PktCntrDisable | INTT_1;
 
@@ -2846,7 +2846,7 @@ static void rtl_hw_start_8101(struct net_device *dev)
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
-	rtl_set_rx_max_size(ioaddr);
+	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
 	tp->cp_cmd |= rtl_rw_cpluscmd(ioaddr) | PCIMulRW;
 


