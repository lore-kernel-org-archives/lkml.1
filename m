Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZC3Oaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZC3Oaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZC3Oai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:30:38 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:38116 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZC3Oah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=n0GD4ql4IBvcXYuw+oqnRSXZCLp7vrEhIR6ujhU9ced8H57FkuEXRdy0eYCk4N9wPu
         YwZCMauQ/dzmIAXpTSwZhYdUJW6+F0slToGSOVCU8cE6S43rcg/mCyy3wQPgwVr09q0W
         bfnXMLaJfAWI0OUjrbMZiMSUBVI0YONQ0phpg=
Message-ID: <49D0D788.6070405@gmail.com>
Date: Mon, 30 Mar 2009 16:30:32 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it>
In-Reply-To: <cllvN-2Gf-1@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2009 11:00 AM, Tejun Heo wrote:
> Hello,
> 
> For some reason, I can't find the original thread, so replying here.
> 
> Niel Lambrechts wrote:
>>>>>> The ext4 errors are interleaved with hardware errors, and the ext4
>>>>>> errors are about I/O errors.
>>>>>>
>>>>>> EXT4-fs error (device sda6): __ext4_get_inode_loc: unable to read inode block - inode=2346519
>>>>>> EXT4-fs error (device sda6) in ext4_reserve_inode_write: IO failure
>>>>>>
>>>>>> This looks more like a hibernation problem than an ext4 problem.
>>>>>> Looks like the hard drive is being left in some inconsistent state
>>>>>> after resuming from hibernation.
> 
> Yeap, ext4 is just the victim here.
> 
>>>>> ata1.00: irq_stat 0x00400008, PHY RDY changed
>>>>> ata1: SError: { PHYRdyChg CommWake }
>>>> Your SATA hardware flags a connect-or-disconnect event ("PHY RDY"), 
>>>> which requires us to abort a bunch of queued commands:
>>>>
>>>>> ata1.00: cmd 60/18:00:77:88:6f/00:00:0e:00:00/40 tag 0 ncq 12288 in
>>>>>          res 50/00:30:07:b3:10/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
>>>> [...]
> ...
>>>> The SCSI subsystem aborts each of the queued commands.
>>> No .. this is the SCSI subsystem receives an ABORTED COMMAND return in
>>> sense data for each of the outstanding I/Os
>>>
>>> The only place these are generated is in ata_sense_to_error() which only
>>> occurs if there's some type of ata error.
>>>
>>> If I had to theorise, I'd say the system suspended with commands
>>> outstanding to the device.  On resume, the device gets reset and returns
>>> some type of ATA error which gets translated to ABORTED COMMAND which
>>> causes a failure.
>>>
>>> In the mid layer, we translate ABORTED_COMMAND into a retry until the
>>> command runs out of them ... could it be there's a race readying the
>>> device and we run through the retries before it can accept the command?
> 
> When libata-eh thinks that the problem isn't worth retrying, it sets
> scmd->retries to scmd->allowed so that it gets aborted immediately.
> The code is in ata_eh_qc_complete().
> 
> Whether a command is to be retried or not is determined with
> ATA_QCFLAG_RETRY which is set in ata_eh_link_autopsy() for each failed
> command.  Immediate-failure criteria is pretty strict - only driver
> software errors (AC_ERR_INVALID) and PC or other special commands
> which failed which got aborted by the device get the immediate pink
> slip.  In this case, the commands are from FS and failed with
> AC_ERR_ATA_BUS, so it definitely doesn't fit into the criteria.
> Strange.
> 
> How reproducible is the problem?  Are you interested in trying out
> some debug patches?

Hi Tejun,

I think I should be able to reproduce when actively using X with 2.6.29,
and I have an external disk where I could backup to / boot from if the
corruption became a problem.

These issues are keeping me from 2.6.29 so I'll gladly help where I can,
if you can please provide me the patches and the .config settings that
may be required?

Niel
