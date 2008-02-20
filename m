Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbYBTBmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbYBTBmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbYBTBmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:42:10 -0500
Received: from [216.31.210.20] ([216.31.210.20]:3243 "EHLO mms5.broadcom.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbYBTBmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:42:08 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 20:42:08 EST
X-Server-Uuid: 93BB6497-3EF8-45A3-B447-1CDF3B37573C
Date: Tue, 19 Feb 2008 17:38:24 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Tony Battersby" <tonyb@cybernetics.com>
cc: "Michael Chan" <mchan@broadcom.com>, "David Miller" <davem@davemloft.net>,
       herbert@gondor.apana.org.au, netdev <netdev@vger.kernel.org>,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
Message-ID: <20080220013824.GA5416@localdomain>
References: <47BA0984.2070306@cybernetics.com>
 <1203381120.13495.78.camel@dell>
 <20080218.163554.74130592.davem@davemloft.net>
 <1203383046.13495.87.camel@dell> <47BB00EC.3010607@cybernetics.com>
 <1203448265.13495.95.camel@dell> <47BB54C2.6090501@cybernetics.com>
MIME-Version: 1.0
In-Reply-To: <47BB54C2.6090501@cybernetics.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 20 Feb 2008 01:34:54.0024 (UTC)
 FILETIME=[CB055C80:01C87360]
X-WSS-ID: 6BA55C4038S2921738-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:14:26PM -0500, Tony Battersby wrote:
> Michael Chan wrote:
> > On Tue, 2008-02-19 at 11:16 -0500, Tony Battersby wrote:
> >   
> >> iSCSI
> >> performance drops to 6 - 15 MB/s when the 3Com NIC is doing heavy rx
> >> with light tx,
> >>     
> >
> > That's strange.  The patch should only affect TX performance slightly
> > since we are just turning off SG for TX.  Please take an ethereal trace
> > to see what's happening and compare with a good trace.
> >
> >   
> 
> Update: when I revert Herbert's patch in addition to applying your
> patch, the iSCSI performance goes back up to 115 MB/s again in both
> directions.  So it looks like turning off SG for TX didn't itself cause
> the performance drop, but rather that the performance drop is just
> another manifestation of whatever bug is causing the data corruption.
> 
> I do not regularly use wireshark or look at network packet dumps, so I
> am not really sure what to look for.  Given the above information, do
> you still believe that there is value in examining the packet dump?
> 
> Tony

Hi Tony.  Can you give us the output of :

sudo lspci -vvv -xxxx -s 03:01.0'

(assuming that is still the correct address of the 3Com NIC.)

Also, after some digging, I found that the 5701 can run into trouble if
a 64-bit DMA read terminates early and then completes as a 32-bit transfer.
The problem is reportedly very rare, but the failure mode looks like a
match.  Can you apply the following patch and see if it helps your
performance / corruption problems?


diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index db606b6..7ad08ce 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -11409,6 +11409,8 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 		tp->tg3_flags |= TG3_FLAG_PCI_HIGH_SPEED;
 	if ((pci_state_reg & PCISTATE_BUS_32BIT) != 0)
 		tp->tg3_flags |= TG3_FLAG_PCI_32BIT;
+	else if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5701)
+		tp->grc_mode |= GRC_MODE_FORCE_PCI32BIT;
 
 	/* Chip-specific fixup from Broadcom driver */
 	if ((tp->pci_chip_rev_id == CHIPREV_ID_5704_A0) &&


