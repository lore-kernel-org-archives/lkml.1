Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbXFMSy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbXFMSy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759641AbXFMSyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:54:05 -0400
Received: from h155.mvista.com ([63.81.120.155]:50579 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759627AbXFMSyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:54:03 -0400
Message-ID: <46703DB1.9010702@ru.mvista.com>
Date: Wed, 13 Jun 2007 22:55:45 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: albertl@mail.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: libata passthru: support PIO multi commands
References: <200706112200.l5BM0qFn005767@hera.kernel.org>	<20070611233917.4bd8c6d7@the-village.bc.nu>	<466DE438.70108@garzik.org>	<20070612111621.10074408@the-village.bc.nu>	<466EB937.6050807@garzik.org> <20070612170519.5f427a70@the-village.bc.nu> <466F5D11.7000404@tw.ibm.com>
In-Reply-To: <466F5D11.7000404@tw.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Lee wrote:
> Alan Cox wrote:
> 
>>>ata_scsi_pass_thru() is not executed at ioctl submission time (block 
>>>queue submission time), but rather immediately before it is issued to 
>>>the drive.  At that point you know the bus is idle, all other commands 
>>>have finished executing, and dev->multi_count is fresh not stale.  The 
>>>code path goes from ata_scsi_pass_thru() to ata_qc_issue() without 
>>>releasing the spinlock, even.
>>
>>
>>Think up to user space
>>
>>Poorusersapp			set multicount to 4
>>
>>Evilproprietarytuningdaemon	set multicount to 8
>>
>>Poorusersapp			issue I/O
>>
>>at which point an error is indeed best.
>>
>>
>>
>>>But the last point is true -- we should error rather than just warn 
>>>there, AFAICS.
>>
>>
>>Definitely. We've been asked "please do something stupid" and not even in
>>a case where the requester may know better.
>>
> 
> 
> It looks like the ATA passthru commands contain more information than
> what libata needs to execute a command.
> 
> e.g. protocol number:
>      libata could possibly infer the protocol from the command opcode.

    This is generally a bad practice to guess protocol based on opcode. What 
if the code will have to handle a vendor unique command (or some other command 
not yet known to it but known to issuer)?

> e.g. multi_count:
>      libata caches dev->multi_count. Passing multi_count along with
>      each passthru command looks useless for libata.     

    I'd agree here.

> e.g. t_dir:
>      libata could possible infer the direction from the command opcode

    Bad idea again.

>      or from the protocol number (e.g. 4: PIO_IN / 5: PIO_OUT).

    This is reasonable if DMA direction can also be inferred from the protocol 
number.

> Due to the redundant info, there is possiblely inconsistency between
> the parameters. e.g. t_dir vs protocol. e.g. command vs protocol.

    I think it's better to allow inconsistency then to limit functionality.
There's another option though -- let the caller specify the default protocol 
for the command to be issued or override it if it *knows* what it's doing.

> It seems the "redundant" parameters are designed to allow stateless SATL
> implementation: The application/passthru command tells the stateless SATL
> implementation the protocol and the multi_count, etc. Then SATL just
> follows the instruction blindly, even if asked to do something stupid.

> Currently libata
>  - uses the passthru protocol number blindly
>    (even if the application issues a DMA command with wrong PIO protocol.)
>  - checks and warns about multi_count
>  - ignores t_dir, byte_block and so on.

> Maybe we need a strategy to deal with incorrect passed-thru commands?
> say,
>  - check and reject if something wrong
>  - mimimal check and warn/ignore, if it doesn't hurt command execution

- let the caller use defaults based on command code or override them.

> --
> albert

MBR, Sergei
