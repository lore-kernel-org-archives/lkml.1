Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXEMDNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXEMDNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 23:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbXEMDNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 23:13:40 -0400
Received: from relais.videotron.ca ([24.201.245.36]:52051 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbXEMDNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 23:13:40 -0400
Date: Sat, 12 May 2007 23:13:30 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: [PATCH] fix PXA27x MMC workaround for bad CRC with 136 bit response
In-reply-to: <4645E76B.2060704@drzeus.cx>
X-X-Sender: nico@xanadu.home
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.0.99.0705122307000.24220@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <46375B18.4080802@drzeus.cx>
 <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx>
 <20070509221253.GC26981@flint.arm.linux.org.uk> <4642B122.5070609@drzeus.cx>
 <46432502.4050901@drzeus.cx> <alpine.LFD.0.99.0705101037220.24220@xanadu.home>
 <alpine.LFD.0.99.0705121122440.24220@xanadu.home> <4645E76B.2060704@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

... and make it depend on the response flag instead of the command type.

Signed-off-by: Nicolas Pitre <npitre@mvista.com>
---

On Sat, 12 May 2007, Pierre Ossman wrote:
> Nicolas Pitre wrote:
> > Please apply the following patch.  It is compile tested only as I don't 
> > have PXA27x hardware with MMC at the moment, but it just cannot be worse 
> > than the current code even when it was compiling.
> >
> >   
> 
> I would think that it would be better to look at just MMC_RSP_136 and
> MMC_RSP_CRC in case we get future variations.

Makes sense.

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index d97d386..f8985c5 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -232,20 +232,14 @@ static int pxamci_cmd_done(struct pxamci_host *host, unsigned int stat)
 		/*
 		 * workaround for erratum #42:
 		 * Intel PXA27x Family Processor Specification Update Rev 001
+		 * A bogus CRC error can appear if the msb of a 136 bit
+		 * response is a one.
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
+		if (cmd->flags & MMC_RSP_136 && cmd->resp[0] & 0x80000000) {
+			pr_debug("ignoring CRC from command %d - *risky*\n", cmd->opcode);
+		} else
 #endif
+		cmd->error = MMC_ERR_BADCRC;
 	}
 
 	pxamci_disable_irq(host, END_CMD_RES);
