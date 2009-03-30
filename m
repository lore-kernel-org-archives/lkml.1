Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbZC3I71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbZC3I71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 04:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZC3I7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 04:59:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:51502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbZC3I7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 04:59:14 -0400
Message-ID: <49D088FB.7000705@kernel.org>
Date: Mon, 30 Mar 2009 17:55:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <cjtH6-3Ll-13@gated-at.bofh.it> <cjtH6-3Ll-15@gated-at.bofh.it> <cjtH6-3Ll-11@gated-at.bofh.it> <cjutt-577-11@gated-at.bofh.it> <cjJCb-47c-23@gated-at.bofh.it> <49CD24BC.8040303@devnull.org>
In-Reply-To: <49CD24BC.8040303@devnull.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 30 Mar 2009 08:55:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

For some reason, I can't find the original thread, so replying here.

Niel Lambrechts wrote:
>>>>> The ext4 errors are interleaved with hardware errors, and the ext4
>>>>> errors are about I/O errors.
>>>>>
>>>>> EXT4-fs error (device sda6): __ext4_get_inode_loc: unable to read inode block - inode=2346519
>>>>> EXT4-fs error (device sda6) in ext4_reserve_inode_write: IO failure
>>>>>
>>>>> This looks more like a hibernation problem than an ext4 problem.
>>>>> Looks like the hard drive is being left in some inconsistent state
>>>>> after resuming from hibernation.

Yeap, ext4 is just the victim here.

>>>> ata1.00: irq_stat 0x00400008, PHY RDY changed
>>>> ata1: SError: { PHYRdyChg CommWake }
>>> Your SATA hardware flags a connect-or-disconnect event ("PHY RDY"), 
>>> which requires us to abort a bunch of queued commands:
>>>
>>>> ata1.00: cmd 60/18:00:77:88:6f/00:00:0e:00:00/40 tag 0 ncq 12288 in
>>>>          res 50/00:30:07:b3:10/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
>>> [...]
...
>>> The SCSI subsystem aborts each of the queued commands.
>> No .. this is the SCSI subsystem receives an ABORTED COMMAND return in
>> sense data for each of the outstanding I/Os
>>
>> The only place these are generated is in ata_sense_to_error() which only
>> occurs if there's some type of ata error.
>>
>> If I had to theorise, I'd say the system suspended with commands
>> outstanding to the device.  On resume, the device gets reset and returns
>> some type of ATA error which gets translated to ABORTED COMMAND which
>> causes a failure.
>>
>> In the mid layer, we translate ABORTED_COMMAND into a retry until the
>> command runs out of them ... could it be there's a race readying the
>> device and we run through the retries before it can accept the command?

When libata-eh thinks that the problem isn't worth retrying, it sets
scmd->retries to scmd->allowed so that it gets aborted immediately.
The code is in ata_eh_qc_complete().

Whether a command is to be retried or not is determined with
ATA_QCFLAG_RETRY which is set in ata_eh_link_autopsy() for each failed
command.  Immediate-failure criteria is pretty strict - only driver
software errors (AC_ERR_INVALID) and PC or other special commands
which failed which got aborted by the device get the immediate pink
slip.  In this case, the commands are from FS and failed with
AC_ERR_ATA_BUS, so it definitely doesn't fit into the criteria.
Strange.

How reproducible is the problem?  Are you interested in trying out
some debug patches?

Thanks.

-- 
tejun
