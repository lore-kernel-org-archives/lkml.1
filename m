Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYE3WPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYE3WPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbYE3WPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:15:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36410 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbYE3WPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:15:00 -0400
Message-ID: <48407C61.4040805@garzik.org>
Date: Fri, 30 May 2008 18:14:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [RFC PATCH] libata-sff: Fix oops reported in kerneloops.org for
 pnp devices with no ctl
References: <20080529161453.24735.805.stgit@core>	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>	<20080529190235.258d304e@core>	<483EF536.90801@garzik.org>	<20080529194238.36458a46@core>	<483F049E.2090809@garzik.org> <20080529221058.1169e140@core>
In-Reply-To: <20080529221058.1169e140@core>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> Want me to roll a patch in that style ?
>> Works for me...
> 
> Ok
> 
> - Make ata_sff_altstatus private so nobody uses it by mistake
> - Drop the 400nS delay from it
> 
> Add
> 
> ata_sff_irq_status	-	encapsulates the IRQ check logic
> 
> This function keeps the existing behaviour for altstatus using devices. I
> actually suspect the logic was wrong before the changes but -rc isn't the
> time to play with that
> 
> ata_sff_sync		-	ensure writes hit the device
> 
> Really we want an io* operation for 'is posted' eg ioisposted(ioaddr) so
> that we can fix the nasty delay this causes on most systems.
> 
> - ata_sff_pause		-	400nS delay
> 
> Ensure the command hit the device and delay 400nS
> 
> - ata_sff_dma_pause
> 
> Ensure the I/O hit the device and enforce an HDMA1:0 transition delay.
> Requires altstatus register exists, BUG if not so we don't risk
> corruption in MWDMA modes. (UDMA the checksum will save your backside in
> theory)
> 
> The only other complication then is devices with their own handlers.
> rb532 can use dma_pause but scc needs to access its own altstatus
> register for internal errata workarounds so directly call the drivers own
> altstatus function.
> 
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
>  drivers/ata/libata-sff.c    |  115 +++++++++++++++++++++++++++++++++++++------
>  drivers/ata/pata_icside.c   |    2 -
>  drivers/ata/pata_rb532_cf.c |    4 +
>  drivers/ata/pata_scc.c      |    5 +-
>  include/linux/libata.h      |   16 +-----
>  5 files changed, 109 insertions(+), 33 deletions(-)

ACK

If no further comments, I'm OK with this version...


