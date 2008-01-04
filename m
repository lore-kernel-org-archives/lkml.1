Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYADW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYADW0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYADW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:26:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:45925 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754138AbYADW0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:26:37 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/z354HwYbzc3MNpI3B5IMjvKqgBH4ZcVP9yNAuxc
	w0EIcECPT87k8F
Date: Fri, 4 Jan 2008 23:26:33 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Richard Jonsson <richie@coderworld.net>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Andreas Mohr <andi@lisas.de>, Ayaz Abdulla <aabdulla@nvidia.com>,
       jgarzik@pobox.com, netdev@vger.kernel.org
Subject: [PATCH] Fix forcedeth reversing the MAC address on suspend
Message-ID: <20080104222633.GA21133@atjola.homenet>
References: <477BFC71.7090002@coderworld.net> <20080102214843.GA19224@rhlx01.hs-esslingen.de> <20080102234209.GA10831@does.not.exist> <20080104034357.GA2113@atjola.homenet> <477E3DEA.4070001@coderworld.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <477E3DEA.4070001@coderworld.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For cards that initially have the MAC address stored in reverse order,
the forcedeth driver uses a flag to signal whether the address was
already corrected, so that it is not reversed again on a subsequent
probe.

Unfortunately this flag, which is stored in a register of the card,
seems to get lost during suspend, resulting in the MAC address being
reversed again. To fix that, the MAC address needs to be written back in
reversed order before we suspend and the flag needs to be reset.

The flag is still required because at least kexec will never write back
the reversed address and thus needs to know what state the card is in.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
On 2008.01.04 15:08:42 +0100, Richard Jonsson wrote:
> Björn Steinbrink skrev:
>> Richard, could you give this a spin? And then we'd likely need someone
>> to test that with kexec...
>
> The patch you sent does the trick, works fine now, thanks!
> I cannot test this with kexec as I barely know what it is, I'll leave that 
> to someone else.

Thanks.

Ayaz, you originally wrote the kexec fix (IIRC), was my analysis of the
problem correct? If so, I'm quite sure that the patch DTRT. Still it
should be tested for the rmmod+modprobe and the kexec case. I'll try to
get my box free for some testing, but that's unlikely in the next few
days. Plus, I've never used kexec myself either. So I'd be grateful if
someone else would step up.

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index a96583c..f84c752 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5199,10 +5199,6 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 		dev->dev_addr[3] = (np->orig_mac[0] >> 16) & 0xff;
 		dev->dev_addr[4] = (np->orig_mac[0] >>  8) & 0xff;
 		dev->dev_addr[5] = (np->orig_mac[0] >>  0) & 0xff;
-		/* set permanent address to be correct aswell */
-		np->orig_mac[0] = (dev->dev_addr[0] << 0) + (dev->dev_addr[1] << 8) +
-			(dev->dev_addr[2] << 16) + (dev->dev_addr[3] << 24);
-		np->orig_mac[1] = (dev->dev_addr[4] << 0) + (dev->dev_addr[5] << 8);
 		writel(txreg|NVREG_TRANSMITPOLL_MAC_ADDR_REV, base + NvRegTransmitPoll);
 	}
 	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
@@ -5414,6 +5410,8 @@ static void __devexit nv_remove(struct pci_dev *pci_dev)
 	 */
 	writel(np->orig_mac[0], base + NvRegMacAddrA);
 	writel(np->orig_mac[1], base + NvRegMacAddrB);
+	writel(readl(base + NvRegTransmitPoll) & ~NVREG_TRANSMITPOLL_MAC_ADDR_REV,
+	       base + NvRegTransmitPoll);
 
 	/* free all structures */
 	free_rings(dev);
