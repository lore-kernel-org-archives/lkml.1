Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753555AbYLQH0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYLQH0L (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbYLQHZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:25:45 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53929 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbYLQHZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:25:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=BuEPNlA16gdFsu+7E3ZetGvSwgdxwLLb6Y8VFTACPB0UIO7ubTywuQADGXPiI077OT
         90YZ7CaFkR+59mBzqlO3haY2w5pMSed2yJ5lPMnv22/030tRQH6KqU85u1hZlEdAJkLq
         qwI4Abqvkm7udc8cBcZ2lZYgaoYXFrp/bXxWg=
Date: Wed, 17 Dec 2008 08:25:43 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/9] ide-atapi: remove ide_atapi_pc from the irq handler
Message-ID: <20081217072543.GA828@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com> <200812162135.27902.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812162135.27902.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hmm.  I recall discussing this before and having some concerns about struct
> ide_atapi_pc removal idea probably being premature...
> 
> Looking at the patchset itself -- I'm very sorry but I just cannot apply it
> with all these command specific fields going into ide_drive_t:
> 
>         unsigned long pc_flags;
>         int pc_req_xfer;
>         int pc_buf_size;
>         int pc_error;
> 
> While they may look similar to the existing pc_* fields:
> 
>         /* callback for packet commands */
>         void (*pc_callback)(struct ide_drive_s *, int);
> 
>         void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
>         int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
>                               unsigned int, int);
> 
> they are clearly not.  Existing pc_* callbacks are per-device type (they
> should have been probably named drv_*) and new ones are per-command ones.

maybe I didn't express myself clear in the commit messages - those
fields are only temporary - the emphasis being on temporary - and was
going to remove them after the dust settles.

> I also don't see a way for code to differentiate between pc and failed_pc.

This happens only in once place in ide-tape and this is taken care of rather
clumsily with an additional flag.

> Why attack the "hard" problem first (struct ide_atapi_pc one) while there
> are easier ones to deal with?  It may happen that once these easier ones
> are fixed we will be able to view the "hard" one from a completely different
> perspective (because code's complexity will decrease a lot in the meantime
> it no longer will be a "hard" problem) and apply a better solution.
> 
> Besides I'm not fully convinced that struct ide_atapi_pc has to go first in
> order to port ide-cd over ide-atapi -- we can just instead port ide-cd to
> use struct ide_atapi_pc (however probably only after converting the driver
> to use sg-s for PIO transfers -- otherwise it becomes another "hard" problem)
> and then deal with struct ide_atapi_pc for all ATAPI code (be using struct
> request fields directly or by merging struct ide_atapi_pc into ide_task_t
> and always using the latter structure for ATA[PI] commands -- which is the
> option that I personally came to prefer lately)...

Here are the problems i see with ide_atapi_pc, judging by my somewhat limited
experience:

1. ide_issue_pc/ide_transfer_pc and all those other ATAPI functions have to
check the pc pointer depending on being entered from ide-cd or from the other
drivers, which means that either ide-cd is ported to use ide_atapi_pc's or we
have lots of spaghetti if/else checks.

2. But, it really seems too unnatural to have ide_atapi_pc structs representing
an ATAPI cmd, IMHO, and doing all those memcpy(rq->cmd, pc->c, BLK_MAX_CDB) and
generally mapping the atapi_pc's to an rq - I'd rather much prefer to use the
rqs which are pretty much sufficient for most tasks and have maybe a smaller
struct which is in rq->buffer or similar handling all the ATAPI specific things
like pc->req_xfer and such.

3. I also think that it is kinda not so smart to have a buffer in the atapi_pc
and move it all around. True, Linus removed some of the allocations on stack but
ide-floppy used to be one of the biggest stack users, ide-tape might still be,
haven't checked.

So, to sum up, I think that ide-cd and especially all the logic around
ide_cd_queue_pc and its users is much more cleaner, IMHO, than what
ide-floppy/tape do by saying

ide_init_pc()
ide_create_bla_cmd()
ide_queue_pc_head/tail() /* here you unnecessarily map the pc to an rq */
ide_issue_pc()

and, in most cases, ide_create_bla_cmd() is used only in one place so
it gets inlined by gcc. So, I think using private buffers in all those
get_capacity/check_status/read_tocentry and sending them down through an
rq is the cleaner solution because you do

cdrom_check_status()
ide_cd_queue_pc()

and this might become

ide_atapi_check_status()
ide_atapi_queue_pc()

and that's pretty awesome, don't you think?

p.s. I'm sure there's something else I'm forgetting.

-- 
Regards/Gruss,
    Boris.
