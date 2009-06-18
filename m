Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZFRRHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZFRRHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZFRRHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:07:30 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:43348 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZFRRH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lPNgnJSk4nkdOBQkAigSYR4lH02+ClAUP7tKErEYtSQC1ZqMfEiWOIqtgaIu+72PKK
         f+B3I2AiefIGDf+EoRrurqqpGQ9NgkmssaGMHXbyjvkLTRJ6KYcE/I/xSvn6JllEEMRj
         GMTQuxtRgygwAdKL3zJa2GFuEs+H+pgVECBq8=
MIME-Version: 1.0
In-Reply-To: <87my858qhn.fsf@fever.mssgmbh.com>
References: <87zlc58xgd.fsf@fever.mssgmbh.com>
	 <9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com>
	 <87vdmt8ugm.fsf@fever.mssgmbh.com>
	 <9ea470500906180843w73435e74sade8a78894f75be5@mail.gmail.com>
	 <87my858qhn.fsf@fever.mssgmbh.com>
Date: Thu, 18 Jun 2009 19:07:29 +0200
Message-ID: <9ea470500906181007y4cff3e58n440a64c807fd14df@mail.gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
From: Borislav Petkov <petkovbb@googlemail.com>
To: Rainer Weikusat <rweikusat@mssgmbh.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 6:18 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
> Borislav Petkov <petkovbb@googlemail.com> writes:
>> On Thu, Jun 18, 2009 at 4:52 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
>>> Borislav Petkov <petkovbb@googlemail.com> writes:
>
> [...]
>
>>>> so this request is completed as a whole and the rq
>>>> freed."
>>>
>>> Technically, this is not quite correct (assuming I haven't overlooked
>>> something), because ide_cd_queue_pc still has a reference to the rq.
>>
>> That doesn't matter because the OOPS happens after the command has been
>> issued and _before_ ide_cd_queue_pc() gets to access the rq ptr
>> again.
>
> Yes. Because the pointer I already mentioned has been reset. But the
> request itself is still alive.
>
> [...]
>
>> ide_complete_rq simply does
>>
>> blk_end_request
>> |->blk_end_bidi_request
>>    |->blk_finish_request
>>
>> after checking the rq->bio pointer through blk_update_bidi_request() and
>> if the prior is NULL it does __blk_put_request in blk_finish_request and
>> this is where the thing vanishes.
>>
>> The second time ide_complete_rq() comes to run at the end of the IRQ
>> handler the rq is already 0xdeadbeef :).
>
> Not quite. Below is the blk_execute_rq-function:
>
> int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
>                   struct request *rq, int at_head)
> {
>        DECLARE_COMPLETION_ONSTACK(wait);
>        char sense[SCSI_SENSE_BUFFERSIZE];
>        int err = 0;
>
>        /*
>         * we need an extra reference to the request, so we can look at
>         * it after io completion
>         */
>        rq->ref_count++;
>
>        if (!rq->sense) {
>                memset(sense, 0, sizeof(sense));
>                rq->sense = sense;
>                rq->sense_len = 0;
>        }
>
>        rq->end_io_data = &wait;
>        blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
>        wait_for_completion(&wait);
>
>        if (rq->errors)
>                err = -EIO;
>
>        return err;
> }
>
> and the refcount is incremented at the start of that 'so we can look
> at it after io-completion', which means 'after the code below has
> executed':
>
> static void blk_end_sync_rq(struct request *rq, int error)
> {
>        struct completion *waiting = rq->end_io_data;
>
>        rq->end_io_data = NULL;
>        __blk_put_request(rq->q, rq);
>
>        /*
>         * complete last, if this is a stack request the process (and thus
>         * the rq pointer) could be invalid right after this complete()
>         */
>        complete(waiting);
> }
>
> which puts the rq once, decrementing the refcount by
> one.

Please, look at the following trace:

ide-cd: ide_cd_queue_pc: cmd[0]: 0x51, write: 0x0, timeout: 1750,
cmd_flags: 0x8000
ide-cd: ide_cd_do_request: cmd: 0x51, block: 18446744073709551615
ide_cd_do_request: dev hda: type=a, flags=108a640
  sector 18446744073709551615, nr/cnr 0/0
  bio (null), biotail (null), buffer (null), data ffff88011b849ba0, len 32
ide-cd: cdrom_do_block_pc: rq->cmd[0]: 0x51, rq->cmd_type: 0xa
ide-cd: cdrom_newpc_intr: cmd: 0x51, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x58, thislen: 30
ide-cd: ide_cd_check_ireason: ireason: 0x2, rw: 0x0
ide-cd: cdrom_newpc_intr: data transfer, rq->cmd_type: 0xa, ireason: 0x2
ide-cd: cdrom_newpc_intr: cmd: 0x51, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x50, thislen: 2
ide-cd: ide_cd_request_sense_fixup: rq->cmd[0]: 0x51
#3

[ this is a printk I added to show from where we hit the out_end label.
There we call the first ide_complete_rq() over ide_cd_error_cmd() where
we put the request. __blk_put_request returns without freeing the rq if
the refcount is > 1, which, in this case, is.]

and now here we do the second direct ide_complete_rq and here the rq is freed:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000048

However, despite the refcounting, the rq->bio check kills the rq -
otherwise the block layer would've waited, see the beginning of
blk_update_request():

	if (!req->bio)
		return false;

but let me do more tracing to see exactly what happens and when it
happens, now that we're waist-deep into the block layer :).

-- 
Regards/Gruss,
Boris
