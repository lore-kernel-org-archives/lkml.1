Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXFMC5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXFMC5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 22:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXFMC5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 22:57:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42723 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbXFMC5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 22:57:31 -0400
Message-ID: <466F5D11.7000404@tw.ibm.com>
Date: Wed, 13 Jun 2007 10:57:21 +0800
From: Albert Lee <albertcc@tw.ibm.com>
Reply-To: albertl@mail.com
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: libata passthru: support PIO multi commands
References: <200706112200.l5BM0qFn005767@hera.kernel.org>	<20070611233917.4bd8c6d7@the-village.bc.nu>	<466DE438.70108@garzik.org>	<20070612111621.10074408@the-village.bc.nu>	<466EB937.6050807@garzik.org> <20070612170519.5f427a70@the-village.bc.nu>
In-Reply-To: <20070612170519.5f427a70@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>ata_scsi_pass_thru() is not executed at ioctl submission time (block 
>>queue submission time), but rather immediately before it is issued to 
>>the drive.  At that point you know the bus is idle, all other commands 
>>have finished executing, and dev->multi_count is fresh not stale.  The 
>>code path goes from ata_scsi_pass_thru() to ata_qc_issue() without 
>>releasing the spinlock, even.
> 
> 
> Think up to user space
> 
> Poorusersapp			set multicount to 4
> 
> Evilproprietarytuningdaemon	set multicount to 8
> 
> Poorusersapp			issue I/O
> 
> at which point an error is indeed best.
> 
> 
>>But the last point is true -- we should error rather than just warn 
>>there, AFAICS.
> 
> 
> Definitely. We've been asked "please do something stupid" and not even in
> a case where the requester may know better.
> 

It looks like the ATA passthru commands contain more information than
what libata needs to execute a command.

e.g. protocol number:
     libata could possibly infer the protocol from the command opcode.

e.g. multi_count:
     libata caches dev->multi_count. Passing multi_count along with
     each passthru command looks useless for libata.     

e.g. t_dir:
     libata could possible infer the direction from the command opcode
     or from the protocol number (e.g. 4: PIO_IN / 5: PIO_OUT).

Due to the redundant info, there is possiblely inconsistency between
the parameters. e.g. t_dir vs protocol. e.g. command vs protocol.

It seems the "redundant" parameters are designed to allow stateless SATL
implementation: The application/passthru command tells the stateless SATL
implementation the protocol and the multi_count, etc. Then SATL just
follows the instruction blindly, even if asked to do something stupid.

Currently libata
 - uses the passthru protocol number blindly
   (even if the application issues a DMA command with wrong PIO protocol.)
 - checks and warns about multi_count
 - ignores t_dir, byte_block and so on.

Maybe we need a strategy to deal with incorrect passed-thru commands?
say,
 - check and reject if something wrong
 - mimimal check and warn/ignore, if it doesn't hurt command execution

--
albert

