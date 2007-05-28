Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbXE1Bnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbXE1Bnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbXE1Bnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:43:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:56412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753592AbXE1Bnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:43:37 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/7vo8xkuf7agB64qa9bWvydtX+wDHBx1KnfBJP7r
	lC9H1iOpvjUuaZ
Date: Mon, 28 May 2007 03:43:39 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>, acme@redhat.com,
       davem@davemloft.net
Subject: Re: Oops with prism54 in 2.6.22-rc3
Message-ID: <20070528014339.GA6136@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, acme@redhat.com,
	davem@davemloft.net
References: <200705261442.34054.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705261442.34054.maxi@daemonizer.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.26 14:42:30 +0200, Maximilian Engelhardt wrote:
> Hello,
> 
> when using the prism54 driver including in the 2.6.22-rc3 kernel I get this 
> Oops when putting the card into monitor mode:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 000001d8
>  printing eip:
> c0500608
> *pde = 00000000
> Oops: 0002 [#1]
> PREEMPT 
> Modules linked in: fuse
> CPU:    0
> EIP:    0060:[<c0500608>]    Not tainted VLI
> EFLAGS: 00010046   (2.6.22-rc3 #2)
> EIP is at netif_rx+0x48/0xc0
> eax: 00000000   ebx: c18fdbc0   ecx: c087991c   edx: c0879910
> esi: 00000246   edi: f7c68010   ebp: f7fe0ba0   esp: c07bbef0
> ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> Process swapper (pid: 0, ti=c07ba000 task=c075a280 task.ti=c07ba000)
> Stack: f7ec0000 00000000 c03d2b8f c07bbf24 00000082 f7c68024 f7fe0800 c18fdbc0 
>        00000070 00000046 00000286 00000286 00000008 00000007 0032dcd5 00000000 
>        f7fe0ba0 00000002 f7fe0800 c03d913d 00000000 00000000 f7f4d2c0 00000000 
> Call Trace:
>  [<c03d2b8f>] islpci_eth_receive+0x12f/0x590
>  [<c03d913d>] islpci_interrupt+0x1cd/0x280
>  [<c0144e15>] handle_IRQ_event+0x25/0x50
>  [<c014669c>] handle_fasteoi_irq+0x5c/0xe0
>  [<c010674a>] do_IRQ+0x4a/0x80
>  [<c010498f>] common_interrupt+0x23/0x28
>  [<c0102b3a>] default_idle+0x2a/0x40
>  [<c01023e3>] cpu_idle+0x43/0x80
>  [<c07bcb2a>] start_kernel+0x21a/0x260
>  [<c07bc450>] unknown_bootoption+0x0/0x260
>  =======================
> Code: c7 43 0c 00 00 00 00 c7 43 10 00 00 00 00 9c 5e fa ff 05 bc 9c 87 c0 a1 
> 0c 99 87 c0 3b 05 c0 4a 7b c0 77 30 85 c0 74 43 8b 43 14 <ff> 80 d8 01 00 00 
> a1 08 99 87 c0 ff 05 0c 99 87 c0 c7 03 04 99 
> EIP: [<c0500608>] netif_rx+0x48/0xc0 SS:ESP 0068:c07bbef0
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> After this the system is frozen. Using kernel 2.6.21 everything works fine, I 
> can capture packets in monitor mode and do not get any Oops.

That's probably due to commit 4c13eb6657fe9ef7b4dc8f1a405c902e9e5234e0,
which moved the setting of skb->dev into eth_type_trans, which is never
called when the card is in monitor mode.

Could you try this patch?


Manually set the device of a skb for prism54 cards that are in monitor
mode as we never call eth_type_trans in that case.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
diff --git a/drivers/net/wireless/prism54/islpci_eth.c b/drivers/net/wireless/prism54/islpci_eth.c
index dd070cc..f49eb06 100644
--- a/drivers/net/wireless/prism54/islpci_eth.c
+++ b/drivers/net/wireless/prism54/islpci_eth.c
@@ -378,9 +378,10 @@ islpci_eth_receive(islpci_private *priv)
 	display_buffer((char *) skb->data, skb->len);
 #endif
 	/* take care of monitor mode and spy monitoring. */
-	if (unlikely(priv->iw_mode == IW_MODE_MONITOR))
+	if (unlikely(priv->iw_mode == IW_MODE_MONITOR)) {
+		skb->dev = ndev;
 		discard = islpci_monitor_rx(priv, &skb);
-	else {
+	} else {
 		if (unlikely(skb->data[2 * ETH_ALEN] == 0)) {
 			/* The packet has a rx_annex. Read it for spy monitoring, Then
 			 * remove it, while keeping the 2 leading MAC addr.
