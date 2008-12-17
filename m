Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757521AbYLQQtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYLQQtm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLQQtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:49:32 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:23566 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYLQQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:49:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=vD9MlP3BvD/V0rgTmc84hAFxdHn6BMUgtYIlc3x1h0O/k2gihmsk8PohKFczub93ZU
         fE6btTv13PrJpz2ItJ+JBLhaMPiskYBY/DHZMetiu9Av0pl+w+77aTFncCPbT5AbdRUo
         B5ksV37zhC59E37sWtsO8SsUXGbCNq0qK6G/M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 0/9] ide-atapi: remove ide_atapi_pc from the irq handler
Date: Wed, 17 Dec 2008 17:45:41 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com> <200812162135.27902.bzolnier@gmail.com> <20081217072543.GA828@gollum.tnic>
In-Reply-To: <20081217072543.GA828@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812171745.41830.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 17 December 2008, Borislav Petkov wrote:
> Hi,
> 
> > Hmm.  I recall discussing this before and having some concerns about struct
> > ide_atapi_pc removal idea probably being premature...
> > 
> > Looking at the patchset itself -- I'm very sorry but I just cannot apply it
> > with all these command specific fields going into ide_drive_t:
> > 
> >         unsigned long pc_flags;
> >         int pc_req_xfer;
> >         int pc_buf_size;
> >         int pc_error;
> > 
> > While they may look similar to the existing pc_* fields:
> > 
> >         /* callback for packet commands */
> >         void (*pc_callback)(struct ide_drive_s *, int);
> > 
> >         void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
> >         int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
> >                               unsigned int, int);
> > 
> > they are clearly not.  Existing pc_* callbacks are per-device type (they
> > should have been probably named drv_*) and new ones are per-command ones.
> 
> maybe I didn't express myself clear in the commit messages - those
> fields are only temporary - the emphasis being on temporary - and was
> going to remove them after the dust settles.

We accept temporary / hacky solutions as an exception and only when there is
a justified need, i.e. it fixes real user problem and we are close to release
date, or it is a standalone issue in a newly merged driver and we don't want
to delay it more from being used by users just because of it.  This is not
the case here.  The alone fact that you need such invasive temporary changes
is a hint that there is a problem with either the implemention or the proposed
solution.

Looking once again at the patchset, it doesn't seem to remove a single struct
ide_atapi_pc field.  The problem is just moved from one place into the other
introducing new design issues, clearly not an improvement.  This again seems
to come back to the approach taken for removing struct ide_atapi_pc (which is
a "hard" problem currently) -- if we stop being so focused on the idea that
struct ide_atapi_pc has to be removed _now_ at all cost and instead look into
possibilities of solving smaller problems, the big one may solve itself in
the meantime...

[ That being said it still good that you've posted this patchset early so we
  can still discuss it and potentially choose the other way before investing
  too much time into it. ]

> > I also don't see a way for code to differentiate between pc and failed_pc.
> 
> This happens only in once place in ide-tape and this is taken care of rather
> clumsily with an additional flag.

Unfortunately no.  Sorry but upon closer look the new code is just broken.

Before the patchset we had separate fields (i.e. pc_flags) for drive->pc
and floppy->failed_pc.  After the changes we have a _single_ pc_flags for
both REQUEST SENSE packet command and the original failed packet command.

[ ->failed_pc is used to keep pointer to the failed packet command while
  the driver is issuing REQUEST SENSE pc to the device (=> drive->pc now
  points to REQUEST SENSE pc) ]

Since REQUEST SENSE pc is using exactly the same pc issue code path as any
other pc [ ide_issue_pc() ] the code will be incorrectly checking pc_flags
of the original pc (i.e. original pc may have PC_FLAG_DMA_OK set which will
be incorrect for REQUEST SENSE pc).

> > Why attack the "hard" problem first (struct ide_atapi_pc one) while there
> > are easier ones to deal with?  It may happen that once these easier ones
> > are fixed we will be able to view the "hard" one from a completely different
> > perspective (because code's complexity will decrease a lot in the meantime
> > it no longer will be a "hard" problem) and apply a better solution.
> > 
> > Besides I'm not fully convinced that struct ide_atapi_pc has to go first in
> > order to port ide-cd over ide-atapi -- we can just instead port ide-cd to
> > use struct ide_atapi_pc (however probably only after converting the driver
> > to use sg-s for PIO transfers -- otherwise it becomes another "hard" problem)
> > and then deal with struct ide_atapi_pc for all ATAPI code (be using struct
> > request fields directly or by merging struct ide_atapi_pc into ide_task_t
> > and always using the latter structure for ATA[PI] commands -- which is the
> > option that I personally came to prefer lately)...
> 
> Here are the problems i see with ide_atapi_pc, judging by my somewhat limited
> experience:
> 
> 1. ide_issue_pc/ide_transfer_pc and all those other ATAPI functions have to
> check the pc pointer depending on being entered from ide-cd or from the other
> drivers, which means that either ide-cd is ported to use ide_atapi_pc's or we
> have lots of spaghetti if/else checks.

Or use mixed approach.

> 2. But, it really seems too unnatural to have ide_atapi_pc structs representing
> an ATAPI cmd, IMHO, and doing all those memcpy(rq->cmd, pc->c, BLK_MAX_CDB) and
> generally mapping the atapi_pc's to an rq - I'd rather much prefer to use the
> rqs which are pretty much sufficient for most tasks and have maybe a smaller
> struct which is in rq->buffer or similar handling all the ATAPI specific things
> like pc->req_xfer and such.

Well, we don't have to port ide-cd over struct ide_atapi_pc completely.

Moreover we can be fixing other drivers as we go (BTW I thought that all ATAPI
drivers have been already fixed WRT s/pc->c/rq->cmd/).

> 3. I also think that it is kinda not so smart to have a buffer in the atapi_pc
> and move it all around. True, Linus removed some of the allocations on stack but
> ide-floppy used to be one of the biggest stack users, ide-tape might still be,
> haven't checked.

Yes, we have to be very careful with using private buffers by not increasing
stack usage too much.

> So, to sum up, I think that ide-cd and especially all the logic around
> ide_cd_queue_pc and its users is much more cleaner, IMHO, than what
> ide-floppy/tape do by saying
> 
> ide_init_pc()
> ide_create_bla_cmd()
> ide_queue_pc_head/tail() /* here you unnecessarily map the pc to an rq */
> ide_issue_pc()
> 
> and, in most cases, ide_create_bla_cmd() is used only in one place so
> it gets inlined by gcc. So, I think using private buffers in all those
> get_capacity/check_status/read_tocentry and sending them down through an
> rq is the cleaner solution because you do
> 
> cdrom_check_status()
> ide_cd_queue_pc()
> 
> and this might become
> 
> ide_atapi_check_status()
> ide_atapi_queue_pc()
> 
> and that's pretty awesome, don't you think?

Sure and I didn't question the goal.

What I was asking in my mail was for you to take your ide-cd maintainer hat
off for a minute and instead put IDE maintainer one on.  From the perspective
of the whole subsystem porting ide-cd over to ide-atapi is of much higher
importance than getting rid of struct ide_atapi_pc.  The former can be pretty
much done now and shouldn't really be difficult problem once you start working
towards solving it.  Porting ide-cd over ide-atapi will decrease the amount
of all ATAPI code and its complexity immediately enabling the possibility of
other improvements inside IDE subsystem itself (right now they would require
ide-cd specific changes), which in turn should give a feedback loop into
ide-cd which may as well help solving the other issue (struct ide_atapi_pc
removal).  OTOH having struct ide_atapi_pc removed just for the sake of it
alone wouldn't give us much benetifs, especially looking at the potential
time it will take to done properly.

[ Yes, I'm a bit disappointed that 2.6.29 is going to be the next release
  that we will miss on ide-cd -> ide-atapi conversion (I was initially
  hoping for .28) and the fact that in few weeks this will become a limiting
  factor to the further progress on core IDE changes (despite few issues
  to still take care of things are starting to look really well there)... ]

Thanks,
Bart
