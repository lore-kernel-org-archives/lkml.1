Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZCEOum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZCEOum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZCEOt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:49:58 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:48011 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbZCEOt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:49:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=kNHvR3FoX0waDnt/Oiv9VZOY+8f+dzQ8QDy5qOngV8oM9CzHGCMeN+t8xS474C60bg
         ++I9xcZrvpsJ7L6R5F8ByltcIgAsKmfig/cefQbtzveq7z01ze1GD44ywI5D6j1wsHGB
         kZvXWtCkmfgZ7uLQAPhkLO2sZpi/m34VZ8svI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
Date: Thu, 5 Mar 2009 15:49:22 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090304; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com> <200903051312.29784.bzolnier@gmail.com> <9ea470500903050553m6ab9dfa5hab340213388a4c67@mail.gmail.com>
In-Reply-To: <9ea470500903050553m6ab9dfa5hab340213388a4c67@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903051549.22518.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009, Borislav Petkov wrote:
> Hi,
> 
> On Thu, Mar 5, 2009 at 1:12 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >
> > Hi,
> >
> > On Wednesday 04 March 2009, Borislav Petkov wrote:
> >> ... since some do not transfer any data from the drive and
> >> rq->buffer is unset leading to an OOPS when checking VM translations
> >> (CONFIG_DEBUG_VIRTUAL).
> >>
> >> Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> >> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> >
> > Thanks for fixing it but I worry that the patch is not entirely correct
> > (why o why did you have to throw in unrelated changes...?)
> 
> What unrelated changes? This is the ide-cd fix for when mapping a NULL

Unrelated to the original issue that the patch tries to fix
(sg mapping no data commands which OOPS-es w/ DEBUG_VIRTUAL=y):
- moving ide_init_sg_cmd()+ide_map_sg() to ide_issue_pc()
- converting the code to use blk_rq_bytes()

[ Moreover if you actually cared to write down the proper changelog
  I'm pretty sure that you would ask yourself whether these changes
  really belong to a bugfix patch... ]

Why not simply do what originally has been suggested:

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -916,9 +916,11 @@ static ide_startstop_t ide_cd_do_request
 
 	cmd.rq = rq;
 
-	ide_init_sg_cmd(&cmd,
-		blk_fs_request(rq) ? (rq->nr_sectors << 9) : rq->data_len);
-	ide_map_sg(drive, &cmd);
+	if (blk_fs_request(rq) || rq->data_len) {
+		ide_init_sg_cmd(&cmd, blk_fs_request(rq) ? (rq->nr_sectors << 9)
+							 : rq->data_len);
+		ide_map_sg(drive, &cmd);
+	}
 
 	return ide_issue_pc(drive, &cmd);
 out_end:

?

The bonus is that it can be either queued after the problematic patch
or just merged with it later (even if it needs to be applied by-hand
the change is so trivial that it is very unlikely to cause problems).

Doing cleanup is fine but not at the same time because we don't want to
make things more complex (they are pretty complex already) and thus risk
introducing new bugs.  Yes, it is tempting to do few things at once and
save some work, and it is also perfectly fine to do it sometimes but we
have to draw a line somewhere...

> rq->buffer pointer to an sg. If you mean the [2/3] patch, I had to
> remove the partial completions for ide-floppy because it was OOPSing on NULL
> rq-pointer in the interrupt handler. I sent you a pretty detailed OOPS along
> with backtracking to the offending code line, remember? Also, for reasons of
> bisectability.

I meant this patch, 2/3 is fine and was applied
(thanks for fixing it again).

> > also ideally there should have been two patches:
> > - minimal bugfix for the buggy patch
> > - unification/cleanup of PIO sg setup
> >
> >> ---
> >>  drivers/ide/ide-atapi.c  |    9 ++++++++-
> >>  drivers/ide/ide-cd.c     |    4 ----
> >>  drivers/ide/ide-floppy.c |    4 ----
> >>  3 files changed, 8 insertions(+), 9 deletions(-)
> >>
> 
> ..
> 
> >> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> >> index 091d414..106cacb 100644
> >> --- a/drivers/ide/ide-cd.c
> >> +++ b/drivers/ide/ide-cd.c
> >> @@ -916,10 +916,6 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
> >>
> >>       cmd.rq = rq;
> >>
> >> -     ide_init_sg_cmd(&cmd,
> >> -             blk_fs_request(rq) ? (rq->nr_sectors << 9) : rq->data_len);
> >> -     ide_map_sg(drive, &cmd);
> >> -
> >>       return ide_issue_pc(drive, &cmd);
> >>  out_end:
> >>       nsectors = rq->hard_nr_sectors;
> >> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> >> index 2f8f453..b91deef 100644
> >> --- a/drivers/ide/ide-floppy.c
> >> +++ b/drivers/ide/ide-floppy.c
> >> @@ -281,10 +281,6 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
> >>               cmd.tf_flags |= IDE_TFLAG_WRITE;
> >>
> >>       cmd.rq = rq;
> >> -
> >> -     ide_init_sg_cmd(&cmd, pc->req_xfer);
> >
> > There was a reason for using ->req_xfer.
> 
> Yeah, this is also one of those painful places where I cringe everytime I have
> to look at. We finally have to sit down and decide which is which; sometimes
> pc->req_xfer _is_ rq->data_len (idefloppy_blockpc_cmd()) and sometimes obviously

This is exactly my point -- these things are tricky so it is very risky to do
drive-by cleanups together with fixes.

> not. I'll take a look at that whole mess next and try to come up with something
> more clean.

Ok.

> > I don't see where rq->data_len is set for REQ_TYPE_SPECIAL requests
> > (ide_queue_pc_tail() and friends)?
> 
> me neither :(.
> 
> >> -     ide_map_sg(drive, &cmd);
> >> -
> >>       pc->rq = rq;
> >>
> >>       return ide_floppy_issue_pc(drive, &cmd, pc);
> 
> Man, this sucks!

:)
