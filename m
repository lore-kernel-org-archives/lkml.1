Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZCENxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZCENxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZCENxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:53:32 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:16524 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZCENxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:53:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Efok0l5KpzsmBHLjUV+vgDJ/VGY6SaaEPEqz2CG9gpPtW3Fz0S5ybjZn0pTb9Qv0E0
         UNvAaCbZgJY6z0bZhFdIw1PjS06aXyt2l60VqJUHPkkzerIOXa6wQEFRNypZLRsT/AsZ
         kRdzWBTDxs4/PjQP1Ct8B3iZQxIzADKbHwLCE=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <200903051312.29784.bzolnier@gmail.com>
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com>
	 <1236158216-23052-4-git-send-email-petkovbb@gmail.com>
	 <200903051312.29784.bzolnier@gmail.com>
Date: Thu, 5 Mar 2009 14:53:28 +0100
Message-ID: <9ea470500903050553m6ab9dfa5hab340213388a4c67@mail.gmail.com>
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 5, 2009 at 1:12 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
> Hi,
>
> On Wednesday 04 March 2009, Borislav Petkov wrote:
>> ... since some do not transfer any data from the drive and
>> rq->buffer is unset leading to an OOPS when checking VM translations
>> (CONFIG_DEBUG_VIRTUAL).
>>
>> Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>
> Thanks for fixing it but I worry that the patch is not entirely correct
> (why o why did you have to throw in unrelated changes...?)

What unrelated changes? This is the ide-cd fix for when mapping a NULL
rq->buffer pointer to an sg. If you mean the [2/3] patch, I had to
remove the partial completions for ide-floppy because it was OOPSing on NULL
rq-pointer in the interrupt handler. I sent you a pretty detailed OOPS along
with backtracking to the offending code line, remember? Also, for reasons of
bisectability.

> also ideally there should have been two patches:
> - minimal bugfix for the buggy patch
> - unification/cleanup of PIO sg setup
>
>> ---
>>  drivers/ide/ide-atapi.c  |    9 ++++++++-
>>  drivers/ide/ide-cd.c     |    4 ----
>>  drivers/ide/ide-floppy.c |    4 ----
>>  3 files changed, 8 insertions(+), 9 deletions(-)
>>

..

>> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
>> index 091d414..106cacb 100644
>> --- a/drivers/ide/ide-cd.c
>> +++ b/drivers/ide/ide-cd.c
>> @@ -916,10 +916,6 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
>>
>>       cmd.rq = rq;
>>
>> -     ide_init_sg_cmd(&cmd,
>> -             blk_fs_request(rq) ? (rq->nr_sectors << 9) : rq->data_len);
>> -     ide_map_sg(drive, &cmd);
>> -
>>       return ide_issue_pc(drive, &cmd);
>>  out_end:
>>       nsectors = rq->hard_nr_sectors;
>> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
>> index 2f8f453..b91deef 100644
>> --- a/drivers/ide/ide-floppy.c
>> +++ b/drivers/ide/ide-floppy.c
>> @@ -281,10 +281,6 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
>>               cmd.tf_flags |= IDE_TFLAG_WRITE;
>>
>>       cmd.rq = rq;
>> -
>> -     ide_init_sg_cmd(&cmd, pc->req_xfer);
>
> There was a reason for using ->req_xfer.

Yeah, this is also one of those painful places where I cringe everytime I have
to look at. We finally have to sit down and decide which is which; sometimes
pc->req_xfer _is_ rq->data_len (idefloppy_blockpc_cmd()) and sometimes obviously
not. I'll take a look at that whole mess next and try to come up with something
more clean.

> I don't see where rq->data_len is set for REQ_TYPE_SPECIAL requests
> (ide_queue_pc_tail() and friends)?

me neither :(.

>> -     ide_map_sg(drive, &cmd);
>> -
>>       pc->rq = rq;
>>
>>       return ide_floppy_issue_pc(drive, &cmd, pc);

Man, this sucks!

-- 
Regards/Gruss,
Boris
