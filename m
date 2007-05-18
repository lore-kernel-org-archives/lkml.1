Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbXERXcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbXERXcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXERXcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:32:06 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:48133 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbXERXcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:32:04 -0400
Date: Fri, 18 May 2007 17:31:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
In-reply-to: <fa.NGBsZzMiMJ9x7V/pv+sqAv36hwA@ifi.uio.no>
To: Kuan Luo <kluo@nvidia.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Peer Chen <pchen@nvidia.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Message-id: <464E3764.90900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.NGBsZzMiMJ9x7V/pv+sqAv36hwA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kuan Luo wrote:
> Thanks for your comment, see the explaination inline.
> We'll apply your advice in later patch.

...

> Please don't duplicate this code in the driver, this is part of libata 
> core in libata-scsi.c. Add an export for these functions if you need to 
> use them in the driver.
> [kuan]: These calls are declared in static type . I can't export them
> and don't want to
> modify libata code.

If you really need these functions then they should be made non-static 
and exported. Duplicating the code is not a solution.

I'm not so sure you actually need all that, though. I suspect you can 
likely handle the deferring of commands if you detect an FPDMA data 
phase inside the qc_issue function only (like you already do in some 
cases) instead of having to mess with deferring them at the SCSI layer.

> I'm still puzzling out how this stuff all works, but it looks like this 
> code makes you stop sending new commands if:
> 
> -the port is in the FPDMA Data Phase (DMA Setup FIS received but the 
> transfer is not complete yet) - I assume the hardware doesn't handle 
> this itself, which seems rather unique
> -we previously deferred a command inside of qc_issue because we were in 
> the FPDMA data phase
> -we previously saw dhfis_flags not equal to qc_active, or we got a 
> BACKOUT interrupt (whatever exactly that means), both of which set some 
> value in the back_byte
> [kuan]: 
> -If we got BACKOUT interrupt, it means that a command just sent by
> driver
> backed out.The driver should resend the command.So new commands should
> be defered.
> -If dhfis_flags != qc_active, it indicates that the last command doesn't
> generate a device to host register FIS .
> After sending some commands, I found that the last command sometimes has
> this problem 
> but previous commands are normal.In this case, we need resend the last
> command.
> Both cases set back_byte. 

The case where the command didn't generate a D2H FIS should likely be 
investigated further, otherwise we don't necessarily know that this 
workaround will work in all cases?

> This code seems a bit odd. Isn't this tossing out a bunch of potential 
> error status, etc?
> [kuan]:
> If there are commands in queue, the driver can  send  a new command 
> only after receiving dhfis intr of previous command and before receiving
> any dmasetup fis intr.
> In this place,  i do the last check before sending the command.

But the D2H FIS can contain an error indication, correct? If that 
happens here it won't detect this. In this situation error handling 
should be triggered.

> 	+	done_mask = pp->qc_active ^ sactive;
> 	+	if (unlikely(done_mask & sactive)) {
> 	+		ata_port_printk(ap, KERN_ERR, "illegal qc_active
> transition "
> 	+				"(%08x->%08x)\n", ap->qc_active,
> sactive);
> 	+		return -EINVAL;
> 	+	}	
> 
> Shouldn't this trigger error handling if it happens instead of just 
> printing an error?
> [kuan]:
> I think the error handling can be triggered by timeout. In fact, 
> this case should seldom happen.

There have been reports of some drives with bad NCQ implementations that 
return completion status for commands that were not issued. If we detect 
this case we should raise an HSM violation which will disable NCQ on 
this drive if it happens repeatedly. See the code in ahci.c in 
ahci_host_intr.

This comment still applies:

> Additional/general comments:
> 
> Think you need some code to handle suspend and resume (re-enable SATA 
> MMIO space, etc.)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

