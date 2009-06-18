Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZFRQS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZFRQS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 12:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFRQSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 12:18:50 -0400
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:44684 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZFRQSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:18:50 -0400
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
In-Reply-To: <9ea470500906180843w73435e74sade8a78894f75be5@mail.gmail.com> (Borislav Petkov's message of "Thu\, 18 Jun 2009 17\:43\:31 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
References: <87zlc58xgd.fsf@fever.mssgmbh.com>
	<9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com>
	<87vdmt8ugm.fsf@fever.mssgmbh.com>
	<9ea470500906180843w73435e74sade8a78894f75be5@mail.gmail.com>
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Thu, 18 Jun 2009 18:18:44 +0200
Message-ID: <87my858qhn.fsf@fever.mssgmbh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (mss-uk.mssgmbh.com [217.174.251.109]); Thu, 18 Jun 2009 18:18:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <petkovbb@googlemail.com> writes:
> On Thu, Jun 18, 2009 at 4:52 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
>> Borislav Petkov <petkovbb@googlemail.com> writes:

[...]

>>> so this request is completed as a whole and the rq
>>> freed."
>>
>> Technically, this is not quite correct (assuming I haven't overlooked
>> something), because ide_cd_queue_pc still has a reference to the rq.
>
> That doesn't matter because the OOPS happens after the command has been
> issued and _before_ ide_cd_queue_pc() gets to access the rq ptr
> again.

Yes. Because the pointer I already mentioned has been reset. But the
request itself is still alive.

[...]

> ide_complete_rq simply does
>
> blk_end_request
> |->blk_end_bidi_request
>    |->blk_finish_request
>
> after checking the rq->bio pointer through blk_update_bidi_request() and
> if the prior is NULL it does __blk_put_request in blk_finish_request and
> this is where the thing vanishes.
>
> The second time ide_complete_rq() comes to run at the end of the IRQ
> handler the rq is already 0xdeadbeef :).

Not quite. Below is the blk_execute_rq-function:

int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
                   struct request *rq, int at_head)
{
        DECLARE_COMPLETION_ONSTACK(wait);
        char sense[SCSI_SENSE_BUFFERSIZE];
        int err = 0;

        /*
         * we need an extra reference to the request, so we can look at
         * it after io completion
         */
        rq->ref_count++;

        if (!rq->sense) {
                memset(sense, 0, sizeof(sense));
                rq->sense = sense;
                rq->sense_len = 0;
        }

        rq->end_io_data = &wait;
        blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
        wait_for_completion(&wait);

        if (rq->errors)
                err = -EIO;

        return err;
}

and the refcount is incremented at the start of that 'so we can look
at it after io-completion', which means 'after the code below has
executed':

static void blk_end_sync_rq(struct request *rq, int error)
{
        struct completion *waiting = rq->end_io_data;

        rq->end_io_data = NULL;
        __blk_put_request(rq->q, rq);

        /*
         * complete last, if this is a stack request the process (and thus
         * the rq pointer) could be invalid right after this complete()
         */
        complete(waiting);
}

which puts the rq once, decrementing the refcount by
one. Both blk_execute_rq and ide_cd_queue_pc inspect the rq after it
has been completed and the latter puts it again. While inspecting a
'freed' data structure would probably be harmless, freeing it twice
would be quite of a problem :-). I have spent something like 18 hours
of my life to determine what was going on here, starting from 'I have
never seen any of this again' and came across a bit of it in the
process.

But I am actually busy doing 'something completely different' with 2.4
for my job ...
