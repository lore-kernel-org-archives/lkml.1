Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZFHVSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZFHVSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZFHVR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:17:58 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43920 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZFHVR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:17:57 -0400
Message-ID: <4A2D7FFE.9070701@cosmosbay.com>
Date: Mon, 08 Jun 2009 23:17:50 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [Security, resend] Instant crash with rtl8169 and large packets
References: <4A2D1147.8020101@msgid.tls.msk.ru> <4A2D1FE4.5030100@gmail.com> <4A2D25F6.9080300@msgid.tls.msk.ru> <4A2D2906.6090002@gmail.com> <4A2D301D.9040301@msgid.tls.msk.ru> <4A2D3568.6010901@gmail.com> <4A2D3BC6.3040904@msgid.tls.msk.ru> <4A2D4AA7.6020204@gmail.com> <4A2D6D0C.6060206@msgid.tls.msk.ru>
In-Reply-To: <4A2D6D0C.6060206@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 08 Jun 2009 23:17:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev a écrit :
> Eric Dumazet wrote:
> []
>> OK I suspect driver is buggy since 2.6.10 days :)
>>
>> Could you try this patch ?
> 
> Tried it, and it appears to work.  Tried various MTU combinations
> and packet sizes.  Checked iperf too, with and without the patch
> and with different MTU too, to be sure the patch does not introduce
> any slowdowns - everything looks sane.  In case the incoming packet
> is larger than the RX buffer size, `errors' and `frames' RX stats
> gets incremented.
> 
> The only somewhat odd thing is that rx path accepts packets larger
> than MTU by 3 bytes.  For example, if I set mtu to 2000, the
> largest packet I can send is 2003 bytes; with mtu=2002, largest
> actual packet size is 2005 bytes.  This is complete frame - in
> terms of ping size (ping -s) it's 1975 and 1977 bytes.  That to
> say, maybe we still have some corner case somewhere, for packets
> larger than mtu by 1, 2 or 3 bytes.
> 
> Also I didn't try MTU < 1500.
> 
> Other than that,
> 
> Tested-By: Michael Tokarev <mjt@tls.msk.ru>

Could you confirm this last patch was ok without former two patches ?

> 
> And by the way, your email client uses quoted-printable encoding.
> I had to use trivial perl one-liner to convert your patches to
> plaintext.  JFYI.

Ah yes, this is when I reply to one of your mail, thank you for the hint.

When submitting a new mail, my thunderbird agent uses a regular "Content-Transfer-Encoding: 7bit"


BTW, this driver uses NAPI, but still calls dev_kfree_skb_irq() in rtl8169_tx_interrupt()

You probably can get better performance calling dev_kfree_skb(tx_skb->skb); instead

@@ -3372,7 +3372,7 @@ static void rtl8169_tx_interrupt(struct net_device *dev,
                rtl8169_unmap_tx_skb(tp->pci_dev, tx_skb, tp->TxDescArray + entry);

                if (status & LastFrag) {
-                       dev_kfree_skb_irq(tx_skb->skb);
+                       dev_kfree_skb(tx_skb->skb);
                        tx_skb->skb = NULL;
                }
                dirty_tx++;



