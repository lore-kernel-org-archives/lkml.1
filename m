Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZFSIyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZFSIyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZFSIyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:54:09 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38101 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZFSIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=idyzClC6fiy0ayukwAg3pLAh7LScrOhJwCRJLuQgI+NRbUStoB6+cMwUP86PCj1DSC
         Hdcg1qTKU+HIrth35fCaXcTLtkdlmFInEgrRj4ba0GTsqc9f6+A9qiZJPPSlEIEwt/1u
         m2qfWiWSoReygV3a/zRImM3nAdtLMO/IbiS2Y=
Date: Fri, 19 Jun 2009 10:54:02 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Rainer Weikusat <rweikusat@mssgmbh.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
Message-ID: <20090619085402.GA24674@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Rainer Weikusat <rweikusat@mssgmbh.com>,
	linux-kernel@vger.kernel.org,
	Linux IDE mailing list <linux-ide@vger.kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <87zlc58xgd.fsf@fever.mssgmbh.com> <9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com> <87vdmt8ugm.fsf@fever.mssgmbh.com> <9ea470500906180843w73435e74sade8a78894f75be5@mail.gmail.com> <87my858qhn.fsf@fever.mssgmbh.com> <9ea470500906181007y4cff3e58n440a64c807fd14df@mail.gmail.com> <87iqitiel3.fsf@fever.mssgmbh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87iqitiel3.fsf@fever.mssgmbh.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 18, 2009 at 08:25:44PM +0200, Rainer Weikusat wrote:
> Borislav Petkov <petkovbb@googlemail.com> writes:
> > On Thu, Jun 18, 2009 at 6:18 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
> >> Borislav Petkov <petkovbb@googlemail.com> writes:
> >>> On Thu, Jun 18, 2009 at 4:52 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
> >>>> Borislav Petkov <petkovbb@googlemail.com> writes:
> >>
> >> [...]
> >>
> >>>>> so this request is completed as a whole and the rq
> >>>>> freed."
> >>>>
> >>>> Technically, this is not quite correct (assuming I haven't overlooked
> >>>> something), because ide_cd_queue_pc still has a reference to the rq.
> >>>
> >>> That doesn't matter because the OOPS happens after the command has been
> >>> issued and _before_ ide_cd_queue_pc() gets to access the rq ptr
> >>> again.
> >>
> >> Yes. Because the pointer I already mentioned has been reset.
> 
> And this happens here (!!!, code from 2.6.30 vanilla):
> 
> int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
> {
> 	ide_hwif_t *hwif = drive->hwif;
> 	struct request *rq = hwif->rq;
> 	int rc;
> 
> 	/*
> 	 * if failfast is set on a request, override number of sectors
> 	 * and complete the whole request right now
> 	 */
> 	if (blk_noretry_request(rq) && error <= 0)
> 		nr_bytes = rq->hard_nr_sectors << 9;
> 
> 	rc = ide_end_rq(drive, rq, error, nr_bytes); 
> 	if (rc == 0)
> 		hwif->rq = NULL; /* !!! */
> 
> 	return rc;
> }
> [explanation below]
> 
> My first attempt at getting this to work again actually looked like
> this (as addition to cdrom_newpc_intr)
> 
>                 if (uptodate == 0) {
>                         ide_cd_error_cmd(drive, cmd);
>                         rq = drive->hwif->rq;
>                 }
> 
>                 if (rq) {
>                 	/* code up to the 2nd complete call */
>                 }
> 
>                 if (sense && rc == 2)
>                         ide_error(drive, "request sense failure", stat);
> 
> [...]
> 
> That was before I had any idea why complete was being called twice and
> that what this is supposed to do won't be done for bio-less requests,
> anyway, and it worked fine. 
> 
> > and now here we do the second direct ide_complete_rq and here the rq is freed:
> >
> > BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000048
> 
> I have just restored the original file to generate another crash
> dump. [the relevant part of] What I get is EIP == c0251311, edx == 0.
> This corresponds with the following machine code:
> 
> c02512fc <ide_complete_rq>:
> c02512fc:       55                      push   %ebp
> c02512fd:       89 e5                   mov    %esp,%ebp
> c02512ff:       56                      push   %esi
> c0251300:       53                      push   %ebx
> c0251301:       83 ec 04                sub    $0x4,%esp
> c0251304:       89 c3                   mov    %eax,%ebx
> c0251306:       89 d0                   mov    %edx,%eax
> 
> /* ide_hwif_t *hwif = drive->hwif; */
> c0251308:       8b 73 28                mov    0x28(%ebx),%esi 
> 
> /* struct request *rq = hwif->rq; */
> c025130b:       8b 96 c8 01 00 00       mov    0x1c8(%esi),%edx
> 
> /* if (blk_noretry_request(rq) .... */
> c0251311:       f6 42 24 0e             testb  $0xe,0x24(%edx) /* !!! */
> c0251315:       74 04                   je     c025131b <ide_complete_rq+0x1f>
> 
> blk_notretry_request is 
> 
> #define blk_noretry_request(rq)	(blk_failfast_dev(rq) ||	\
> 				 blk_failfast_transport(rq) ||	\
> 				 blk_failfast_driver(rq))
> 
> and
>                                  
> #define blk_failfast_dev(rq)	((rq)->cmd_flags & REQ_FAILFAST_DEV)
> #define blk_failfast_transport(rq) ((rq)->cmd_flags & REQ_FAILFAST_TRANSPORT)
> #define blk_failfast_driver(rq)	((rq)->cmd_flags & REQ_FAILFAST_DRIVER)
> 
> and
> 
> #define REQ_FAILFAST_DEV        (1 << __REQ_FAILFAST_DEV)
> #define REQ_FAILFAST_TRANSPORT  (1 << __REQ_FAILFAST_TRANSPORT)
> #define REQ_FAILFAST_DRIVER     (1 << __REQ_FAILFAST_DRIVER)
> 
> and
> 
> enum rq_flag_bits {
>         __REQ_RW,               /* not set, read. set, write */
>         __REQ_FAILFAST_DEV,     /* no driver retries of device errors */
>         __REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
>         __REQ_FAILFAST_DRIVER,  /* no driver retries of driver errors */
>         __REQ_DISCARD,          /* request to discard sectors */
> 
>         [...]
> 
> This means the values of the relevant __REQ_-constants are 1, 2, and
> 3 and (1 << 1) | (1 << 2) | (1 << 3) == 2 + 4 + 8 == 14 (== 0xe),
> hence testb $0xe, 0x24(%edx) (optimized by compiler). edx is 0.
> 0x24(%edx) is the field at offset 36 in a struct request, which is
> cmd_flags (on my computer).
> 
> blk_end_io always returns zero for bio-less requests. More precisely,
> it calls end_that_request_data, which is
> 
> static int end_that_request_data(struct request *rq, int error,
>                                  unsigned int nr_bytes, unsigned int bidi_bytes)
> {
>         if (rq->bio) {
>                 if (__end_that_request_first(rq, error, nr_bytes))
>                         return 1;
> 
>                 /* Bidi request must be completed as a whole */
>                 if (blk_bidi_rq(rq) &&
>                     __end_that_request_first(rq->next_rq, error, bidi_bytes))
>                         return 1;
>         }
> 
>         return 0;
> }
> 
> ie it returns 0 for a request w/o a bio, and looks itself like this:
> 
> static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
>                       unsigned int bidi_bytes,
>                       int (drv_callback)(struct request *))
> {
>         struct request_queue *q = rq->q;
>         unsigned long flags = 0UL;
> 
>         if (end_that_request_data(rq, error, nr_bytes, bidi_bytes))
>                 return 1;
> 
>         /* Special feature for tricky drivers */
>         if (drv_callback && drv_callback(rq))
>                 return 1;
> 
>         add_disk_randomness(rq->rq_disk);
> 
>         spin_lock_irqsave(q->queue_lock, flags);
>         end_that_request_last(rq, error);
>         spin_unlock_irqrestore(q->queue_lock, flags);
> 
>         return 0;
> }
> 
> drv_callback is NULL and the 'final return value' is ultimatively
> returned from the ide_end_rq-call mentioned at the beginning of this
> overly long e-mail.
> 
> An easy way to verify that would be a
> 
> 	BUG_ON(!rq)
> 
> inserted before the blkdev_noretry_request in ide_complete_rq (which I
> also did -- I have been doing this for long enough to never trust my
> own assumptions blindly ...).
> 
> He who doesn't understand assembly will have a more difficult life
> because of that :-).

Well, this is a very good code analysis, I'd say, one for the books :)

> While this is interesting, my boss [righfully] hates it and I will now
> have to do at least an hour of additional overtime.

Sorry about that, same here :)

Here's another trace I did:

[  266.037646] ide-cd: ide_cd_queue_pc: cmd[0]: 0x51, write: 0x0, timeout: 7000, cmd_flags: 0x8000
[  266.037662] ide-cd: ide_cd_do_request: cmd: 0x51, block: 4294967295, marker: 114
[  266.037667] ide_cd_do_request: dev hdc: type=a, flags=128a440
[  266.037670]   sector 4294967295, nr/cnr 0/0
[  266.037675]   bio dde1e840, biotail dde1e840, buffer (null), len 2
[  266.037678] ide-cd: cdrom_do_block_pc: rq->cmd[0]: 0x51, rq->cmd_type: 0xa
[  266.066559] ide-cd: cdrom_newpc_intr: cmd: 0x51, write: 0x0
[  266.066567] ide-cd: cdrom_newpc_intr: DRQ: stat: 0x58, thislen: 2
[  266.066570] ide-cd: ide_cd_check_ireason: ireason: 0x2, rw: 0x0
[  266.066572] ide-cd: cdrom_newpc_intr: data transfer, rq->cmd_type: 0xa, ireason: 0x2
[  266.149000] ide-cd: cdrom_newpc_intr: cmd: 0x51, write: 0x0
[  266.149010] ide-cd: cdrom_newpc_intr: DRQ: stat: 0x50, thislen: 0
[  266.149014] ide-cd: ide_cd_request_sense_fixup: rq->cmd[0]: 0x51
[  266.149017] ide_complete_rq: completing rq, marker: 114

this is the end of the IRQ handler

[  266.149023] __blk_put_request: marker: 114, ref_count: 2
[  266.149033] ide_cd_queue_pc: putting rq, marker: 114

and here ide_cd_queue_pc comes _after_ that and frees the rq due to refcount ==
1.

[  266.149039] __blk_put_request: marker: 114, ref_count: 1
[  266.149045] blk_free_request: marker: 114, ref_count: 0

Now in the fragmented packet command case - that what you call 32/30 -
you'll have the first ide_complete_rq() call from ide_cd_error_cmd() and
the first decrement of the refcount. Had the rq had a bio, it'd never be
come to do a __blk_put_request and decrement the refcount.

But even if it did decrement it, as it does in the real case, that
wouldn't be a problem since the rq is still alive (refcount is now 1)
and it will be only freed in the second ide_complete_rq() at the end of
the IRQ handler.

But, it seems that ide_cd_queue_pc() goes after that first
ide_complete_rq() and decrements the refcount, as you suggest, right?

What bothers me here is that we're in IRQ context and running with
interrupts disabled so _actually_ the blk_put_request() part of
ide_cd_queue_pc() should be getting to run only _after_ the IRQ
handler is done and we should be getting the NULL ptr deref in
ide_cd_queue_pc(), but we don't. I guess I'm missing something here.

-- 
Regards/Gruss,
    Boris.
