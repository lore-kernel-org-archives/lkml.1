Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYG1QQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYG1QQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbYG1QQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:16:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:13535 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbYG1QQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=g9O/5incrpgKiueQkrA6XKmUu1PeUivk/MA/NXOcBh2SeJxkPRGiwQjUJcx6HVOy/3
         E6N4aICbb/cuixHZGdLPk8EiKbmE+OwLfJnHW06lxarqQMJfv5NxsXzIs3vwW0tpkPJg
         3Z6TM4NhmRZZ1usyltLnQzpz1gxiCt1iw/1+Y=
Message-ID: <9ea470500807280916k7824dc28m169f4c4db65023fa@mail.gmail.com>
Date: Mon, 28 Jul 2008 18:16:16 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: IDE S.M.A.R.T. ioctl errors
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <200807281644.38419.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080728060133.GA14007@gollum.tnic>
	 <200807281644.38419.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 4:44 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
> Hi,
>
> On Monday 28 July 2008, Borislav Petkov wrote:
>
> [...]
>
>> [   32.918048] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd5 args[3]: 0x1
>> [   32.918164] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
>> [   32.918392] ide: failed opcode was: 0xb0
>> [   32.918491] hdd: drive not ready for command
>> [   32.918618] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
>> [   32.918844] ide: failed opcode was: 0xea
>> [   32.918949] hdd: drive not ready for command
>> ...
>>
>> and this is "caused" by
>> ide-use-correct-data-phase-for-smart-read-data-log-in-ide_cmd_ioctl.patch. This
>> happens, IMHO, because when you do ATA_CMD_SMART from userspace ioctl, one of
>> the cases is that the tf->feature flags have values which are inconsistent with
>> the ATA/ATAPI v.7 spec (6.54.5 SMART READ DATA):
>>
>> "If the device does not support this command, if SMART is disabled, or if the
>> values in the Features, LBA Mid, or LBA High registers are invalid, the device
>> shall return command aborted."
>>
>> For example this one:
>>
>> [   30.499581] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd1 args[3]: 0x1
>> [   30.516111] hda: task_no_data_intr: status=0x58 { DriveReady SeekComplete DataRequest }
>> [   30.516387] ide: failed opcode was: 0xb0
>>
>> However, the case with the SMART_READ_LOG looks correct above: args[2] = 0xd5
>> which is the tf->feature flag, cmd = 0xb0 (ATA_CMD_SMART). This one fails too, though.
>
> Thanks for spotting it.
>
> It seems that ide_cmd_ioctl() ->data_phase change is not as obvious as
> I previously thought.  Since the patch is quite low-prio (it prepares
> the code for future changes) I just dropped it until we learn more about
> the underlying issues.

How about aborting the ioctl in all those cases when the relevant
registers above contain invalid values
according to the spec? It sounds a pretty sane thing to do...


-- 
Regards/Gruﬂ,
Boris
