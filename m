Return-Path: <linux-kernel-owner+w=401wt.eu-S1758513AbZC3Sa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbZC3Sa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZC3SYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:24:14 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40319 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426AbZC3SYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=sSfLUjJD3RrIkUh0o40tSfPEXxlwvj6qIlrHZ+H6sJSamVBxfdHnkbmrN/a3TroQsT
         2nzYPNpBoYCu2MofZdVYZBE9R2gxrU50QvrNDugGe4QQyzxGArnwk/lIHlu/ld/j118g
         JPhlI2FILicLm5X2bnbds0CrsJo7ZLE5g1gj4=
Message-ID: <49D10E51.8000104@devnull.org>
Date: Mon, 30 Mar 2009 20:24:17 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it> <clqON-2Xv-9@gated-at.bofh.it> <clqON-2Xv-11@gated-at.bofh.it> <clqON-2Xv-13@gated-at.bofh.it> <clqON-2Xv-15@gated-at.bofh.it> <clqON-2Xv-17@gated-at.bofh.it> <clqON-2Xv-19@gated-at.bofh.it> <clqON-2Xv-5@gated-at.bofh.it> <clqYt-3bu-5@gated-at.bofh.it>
In-Reply-To: <clqYt-3bu-5@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2009 04:50 PM, Jeff Garzik wrote:
> Niel Lambrechts wrote:
>> On 03/30/2009 11:00 AM, Tejun Heo wrote:
>>> Hello,
>>>
>>> For some reason, I can't find the original thread, so replying here.
>>>
>>> Niel Lambrechts wrote:
>>>>>>>> The ext4 errors are interleaved with hardware errors, and the ext4
>>>>>>>> errors are about I/O errors.
>>>>>>>>
>>>>>>>> EXT4-fs error (device sda6): __ext4_get_inode_loc: unable to
>>>>>>>> read inode block - inode=2346519
>>>>>>>> EXT4-fs error (device sda6) in ext4_reserve_inode_write: IO failure
>>>>>>>>
>>>>>>>> This looks more like a hibernation problem than an ext4 problem.
>>>>>>>> Looks like the hard drive is being left in some inconsistent state
>>>>>>>> after resuming from hibernation.
>>> Yeap, ext4 is just the victim here.
>>>
>>>>>>> ata1.00: irq_stat 0x00400008, PHY RDY changed
>>>>>>> ata1: SError: { PHYRdyChg CommWake }
>>>>>> Your SATA hardware flags a connect-or-disconnect event ("PHY
>>>>>> RDY"), which requires us to abort a bunch of queued commands:
>>>>>>
>>>>>>> ata1.00: cmd 60/18:00:77:88:6f/00:00:0e:00:00/40 tag 0 ncq 12288 in
>>>>>>>          res 50/00:30:07:b3:10/00:00:0c:00:00/40 Emask 0x10 (ATA
>>>>>>> bus error)
>>>>>> [...]
>>> ...
>>>>>> The SCSI subsystem aborts each of the queued commands.
>>>>> No .. this is the SCSI subsystem receives an ABORTED COMMAND return in
>>>>> sense data for each of the outstanding I/Os
>>>>>
>>>>> The only place these are generated is in ata_sense_to_error() which
>>>>> only
>>>>> occurs if there's some type of ata error.
>>>>>
>>>>> If I had to theorise, I'd say the system suspended with commands
>>>>> outstanding to the device.  On resume, the device gets reset and
>>>>> returns
>>>>> some type of ATA error which gets translated to ABORTED COMMAND which
>>>>> causes a failure.
>>>>>
>>>>> In the mid layer, we translate ABORTED_COMMAND into a retry until the
>>>>> command runs out of them ... could it be there's a race readying the
>>>>> device and we run through the retries before it can accept the
>>>>> command?
>>> When libata-eh thinks that the problem isn't worth retrying, it sets
>>> scmd->retries to scmd->allowed so that it gets aborted immediately.
>>> The code is in ata_eh_qc_complete().
>>>
>>> Whether a command is to be retried or not is determined with
>>> ATA_QCFLAG_RETRY which is set in ata_eh_link_autopsy() for each failed
>>> command.  Immediate-failure criteria is pretty strict - only driver
>>> software errors (AC_ERR_INVALID) and PC or other special commands
>>> which failed which got aborted by the device get the immediate pink
>>> slip.  In this case, the commands are from FS and failed with
>>> AC_ERR_ATA_BUS, so it definitely doesn't fit into the criteria.
>>> Strange.
>>>
>>> How reproducible is the problem?  Are you interested in trying out
>>> some debug patches?
>>
>> Hi Tejun,
>>
>> I think I should be able to reproduce when actively using X with 2.6.29,
>> and I have an external disk where I could backup to / boot from if the
>> corruption became a problem.
>>
>> These issues are keeping me from 2.6.29 so I'll gladly help where I can,
>> if you can please provide me the patches and the .config settings that
>> may be required?
>>
>> Niel
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> Any chance you could use bisect to narrow down the problem commit?
> 
> http://kernel.org/pub/software/scm/git/docs/v1.4.4.4/howto/isolate-bugs-with-bisect.txt
> 
> 
> This should identify which patch caused your problems, if you have a
> known good starting point (such as 2.6.28).
> 
>     Jeff

Any idea of the volume of data would I need to download, git repository
wise? I currently only have the 2.6.27 source and patches on top... and
bandwidth is quite expensive in SA...

Niel
