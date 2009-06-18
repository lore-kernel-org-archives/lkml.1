Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZFRS0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZFRS0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZFRSZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:25:51 -0400
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:45313 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZFRSZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:25:50 -0400
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
In-Reply-To: <9ea470500906181007y4cff3e58n440a64c807fd14df@mail.gmail.com> (Borislav Petkov's message of "Thu\, 18 Jun 2009 19\:07\:29 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
References: <87zlc58xgd.fsf@fever.mssgmbh.com>
	<9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com>
	<87vdmt8ugm.fsf@fever.mssgmbh.com>
	<9ea470500906180843w73435e74sade8a78894f75be5@mail.gmail.com>
	<87my858qhn.fsf@fever.mssgmbh.com>
	<9ea470500906181007y4cff3e58n440a64c807fd14df@mail.gmail.com>
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Thu, 18 Jun 2009 20:25:44 +0200
Message-ID: <87iqitiel3.fsf@fever.mssgmbh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (mss-uk.mssgmbh.com [217.174.251.109]); Thu, 18 Jun 2009 20:25:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <petkovbb@googlemail.com> writes:
> On Thu, Jun 18, 2009 at 6:18 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
>> Borislav Petkov <petkovbb@googlemail.com> writes:
>>> On Thu, Jun 18, 2009 at 4:52 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
>>>> Borislav Petkov <petkovbb@googlemail.com> writes:
>>
>> [...]
>>
>>>>> so this request is completed as a whole and the rq
>>>>> freed."
>>>>
>>>> Technically, this is not quite correct (assuming I haven't overlooked
>>>> something), because ide_cd_queue_pc still has a reference to the rq.
>>>
>>> That doesn't matter because the OOPS happens after the command has been
>>> issued and _before_ ide_cd_queue_pc() gets to access the rq ptr
>>> again.
>>
>> Yes. Because the pointer I already mentioned has been reset.

And this happens here (!!!, code from 2.6.30 vanilla):

int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
{
	ide_hwif_t *hwif = drive->hwif;
	struct request *rq = hwif->rq;
	int rc;

	/*
	 * if failfast is set on a request, override number of sectors
	 * and complete the whole request right now
	 */
	if (blk_noretry_request(rq) && error <= 0)
		nr_bytes = rq->hard_nr_sectors << 9;

	rc = ide_end_rq(drive, rq, error, nr_bytes); 
	if (rc == 0)
		hwif->rq = NULL; /* !!! */

	return rc;
}
[explanation below]

My first attempt at getting this to work again actually looked like
this (as addition to cdrom_newpc_intr)

                if (uptodate == 0) {
                        ide_cd_error_cmd(drive, cmd);
                        rq = drive->hwif->rq;
                }

                if (rq) {
                	/* code up to the 2nd complete call */
                }

                if (sense && rc == 2)
                        ide_error(drive, "request sense failure", stat);

[...]

That was before I had any idea why complete was being called twice and
that what this is supposed to do won't be done for bio-less requests,
anyway, and it worked fine. 

> and now here we do the second direct ide_complete_rq and here the rq is freed:
>
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000048

I have just restored the original file to generate another crash
dump. [the relevant part of] What I get is EIP == c0251311, edx == 0.
This corresponds with the following machine code:

c02512fc <ide_complete_rq>:
c02512fc:       55                      push   %ebp
c02512fd:       89 e5                   mov    %esp,%ebp
c02512ff:       56                      push   %esi
c0251300:       53                      push   %ebx
c0251301:       83 ec 04                sub    $0x4,%esp
c0251304:       89 c3                   mov    %eax,%ebx
c0251306:       89 d0                   mov    %edx,%eax

/* ide_hwif_t *hwif = drive->hwif; */
c0251308:       8b 73 28                mov    0x28(%ebx),%esi 

/* struct request *rq = hwif->rq; */
c025130b:       8b 96 c8 01 00 00       mov    0x1c8(%esi),%edx

/* if (blk_noretry_request(rq) .... */
c0251311:       f6 42 24 0e             testb  $0xe,0x24(%edx) /* !!! */
c0251315:       74 04                   je     c025131b <ide_complete_rq+0x1f>

blk_notretry_request is 

#define blk_noretry_request(rq)	(blk_failfast_dev(rq) ||	\
				 blk_failfast_transport(rq) ||	\
				 blk_failfast_driver(rq))

and
                                 
#define blk_failfast_dev(rq)	((rq)->cmd_flags & REQ_FAILFAST_DEV)
#define blk_failfast_transport(rq) ((rq)->cmd_flags & REQ_FAILFAST_TRANSPORT)
#define blk_failfast_driver(rq)	((rq)->cmd_flags & REQ_FAILFAST_DRIVER)

and

#define REQ_FAILFAST_DEV        (1 << __REQ_FAILFAST_DEV)
#define REQ_FAILFAST_TRANSPORT  (1 << __REQ_FAILFAST_TRANSPORT)
#define REQ_FAILFAST_DRIVER     (1 << __REQ_FAILFAST_DRIVER)

and

enum rq_flag_bits {
        __REQ_RW,               /* not set, read. set, write */
        __REQ_FAILFAST_DEV,     /* no driver retries of device errors */
        __REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
        __REQ_FAILFAST_DRIVER,  /* no driver retries of driver errors */
        __REQ_DISCARD,          /* request to discard sectors */

        [...]

This means the values of the relevant __REQ_-constants are 1, 2, and
3 and (1 << 1) | (1 << 2) | (1 << 3) == 2 + 4 + 8 == 14 (== 0xe),
hence testb $0xe, 0x24(%edx) (optimized by compiler). edx is 0.
0x24(%edx) is the field at offset 36 in a struct request, which is
cmd_flags (on my computer).

blk_end_io always returns zero for bio-less requests. More precisely,
it calls end_that_request_data, which is

static int end_that_request_data(struct request *rq, int error,
                                 unsigned int nr_bytes, unsigned int bidi_bytes)
{
        if (rq->bio) {
                if (__end_that_request_first(rq, error, nr_bytes))
                        return 1;

                /* Bidi request must be completed as a whole */
                if (blk_bidi_rq(rq) &&
                    __end_that_request_first(rq->next_rq, error, bidi_bytes))
                        return 1;
        }

        return 0;
}

ie it returns 0 for a request w/o a bio, and looks itself like this:

static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
                      unsigned int bidi_bytes,
                      int (drv_callback)(struct request *))
{
        struct request_queue *q = rq->q;
        unsigned long flags = 0UL;

        if (end_that_request_data(rq, error, nr_bytes, bidi_bytes))
                return 1;

        /* Special feature for tricky drivers */
        if (drv_callback && drv_callback(rq))
                return 1;

        add_disk_randomness(rq->rq_disk);

        spin_lock_irqsave(q->queue_lock, flags);
        end_that_request_last(rq, error);
        spin_unlock_irqrestore(q->queue_lock, flags);

        return 0;
}

drv_callback is NULL and the 'final return value' is ultimatively
returned from the ide_end_rq-call mentioned at the beginning of this
overly long e-mail.

An easy way to verify that would be a

	BUG_ON(!rq)

inserted before the blkdev_noretry_request in ide_complete_rq (which I
also did -- I have been doing this for long enough to never trust my
own assumptions blindly ...).

He who doesn't understand assembly will have a more difficult life
because of that :-). While this is interesting, my boss [righfully]
hates it and I will now have to do at least an hour of additional
overtime.
