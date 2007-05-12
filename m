Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbXELPir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbXELPir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXELPik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:38:40 -0400
Received: from relais.videotron.ca ([24.201.245.36]:51783 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbXELPik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:38:40 -0400
Date: Sat, 12 May 2007 11:38:32 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: [GIT PULL] MMC updates
In-reply-to: <alpine.LFD.0.99.0705101037220.24220@xanadu.home>
X-X-Sender: nico@xanadu.home
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.0.99.0705121122440.24220@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <46375B18.4080802@drzeus.cx>
 <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx>
 <20070509221253.GC26981@flint.arm.linux.org.uk> <4642B122.5070609@drzeus.cx>
 <46432502.4050901@drzeus.cx> <alpine.LFD.0.99.0705101037220.24220@xanadu.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Nicolas Pitre wrote:

> On Thu, 10 May 2007, Pierre Ossman wrote:
> 
> > You seem to be the source of this workaround, and also the maintainer of
> > PXA.
> 
> Well... I used to.

Actually, I'm not the author of this workaround.  And looking at it 
closer, the current workaround is utterly buggy as it completely inhibit 
CRC error reporting for everything but the listed commands when the MSB 
of the response is a zero.

> But the only MMC capable PXA hardware in working conditions I have 
> access to at the moment is PXA255 based which doesn't suffer from this 
> erratum.
> 
> > Pierre Ossman wrote:
> > > I've read through the erratum, and to me it seems like the bug affects
> > > all long replies, not just these codes. So I think the code should be
> > > fixed to look at the response flag, not the opcode.

Indeed.

Please apply the following patch.  It is compile tested only as I don't 
have PXA27x hardware with MMC at the moment, but it just cannot be worse 
than the current code even when it was compiling.

----- >8
Subject: fix PXA27x MMC workaround for bad CRC on R2 response erratum

... and make it depend on the response flag rather than the command type.

Signed-off-by: Nicolas Pitre <nico@cam.org>
---
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index d97d386..8240609 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -232,20 +232,15 @@ static int pxamci_cmd_done(struct pxamci_host *host, unsigned int stat)
 		/*
 		 * workaround for erratum #42:
 		 * Intel PXA27x Family Processor Specification Update Rev 001
+		 * A bogus CRC error can appear if the msb of a R2 response
+		 * is a one.
 		 */
-		if (cmd->opcode == MMC_ALL_SEND_CID ||
-		    cmd->opcode == MMC_SEND_CSD ||
-		    cmd->opcode == MMC_SEND_CID) {
-			/* a bogus CRC error can appear if the msb of
-			   the 15 byte response is a one */
-			if ((cmd->resp[0] & 0x80000000) == 0)
-				cmd->error = MMC_ERR_BADCRC;
-		} else {
-			pr_debug("ignoring CRC from command %d - *risky*\n",cmd->opcode);
-		}
-#else
-		cmd->error = MMC_ERR_BADCRC;
+		if (RSP_TYPE(mmc_resp_type(cmd)) == RSP_TYPE(MMC_RSP_R2) &&
+		    (cmd->resp[0] & 0x80000000)) {
+			pr_debug("ignoring CRC from command %d - *risky*\n", cmd->opcode);
+		} else
 #endif
+		cmd->error = MMC_ERR_BADCRC;
 	}
 
 	pxamci_disable_irq(host, END_CMD_RES);
