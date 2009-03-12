Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZCLHNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZCLHNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZCLHNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:13:00 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:48525 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZCLHM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=xhVbj2/WGKZM/LfEGt5v2tKFrz+IqnN6uQXZmkf4T6Y+eJ6Flt6kYcJF86X8npdH7j
         R743NXTENK3DOmvNuB+ZVeTTdzLp64x3Ae8A490h4aUr7JUOkctvZm85cdOExUdEpXm+
         MLe8qTE2Dzmynl6vDeocSc8RbmxytntYlpYS8=
Date: Thu, 12 Mar 2009 08:12:49 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
Message-ID: <20090312071248.GA26881@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com> <200903081808.05448.bzolnier@gmail.com> <20090310060833.GA7895@liondog.tnic> <200903111734.28956.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200903111734.28956.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 05:34:28PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 10 March 2009, Borislav Petkov wrote:
> > Hi,
> > 
> > > If the mainline is broken sg fix can wait but to be honest I don't see much
> > > point in delaying it (it is an independent problem and the bugfix should be
> > > a completely safe one-liner).
> > 
> > --
> > From: Borislav Petkov <petkovbb@gmail.com>
> > Date: Tue, 10 Mar 2009 07:04:52 +0100
> > Subject: [PATCH] ide-floppy: do not map dataless cmds to an sg
> > 
> > since it fails the virt_to_page() translation check with DEBUG_VIRTUAL
> > enabled.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> I applied it with some changes:
> 
> > ---
> >  drivers/ide/ide-atapi.c  |   12 ++++++++++++
> >  drivers/ide/ide-floppy.c |    6 ++++--
> >  2 files changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> > index a5596a6..11a680c 100644
> > --- a/drivers/ide/ide-atapi.c
> > +++ b/drivers/ide/ide-atapi.c
> > @@ -90,6 +90,12 @@ static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
> >  	rq->cmd_flags |= REQ_PREEMPT;
> >  	rq->buffer = (char *)pc;
> >  	rq->rq_disk = disk;
> > +
> > +	if (pc->req_xfer) {
> > +		rq->data = pc->buf;
> > +		rq->data_len = pc->req_xfer;
> > +	}
> > +
> >  	memcpy(rq->cmd, pc->c, 12);
> >  	if (drive->media == ide_tape)
> >  		rq->cmd[13] = REQ_IDETAPE_PC1;
> > @@ -112,6 +118,12 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
> >  	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
> >  	rq->cmd_type = REQ_TYPE_SPECIAL;
> >  	rq->buffer = (char *)pc;
> > +
> > +	if (pc->req_xfer) {
> > +		rq->data = pc->buf;
> > +		rq->data_len = pc->req_xfer;
> > +	}
> > +
> >  	memcpy(rq->cmd, pc->c, 12);
> >  	if (drive->media == ide_tape)
> >  		rq->cmd[13] = REQ_IDETAPE_PC1;
> 
> ide-atapi.c part doesn't seem to be needed for fixing the issue
> so I removed it (IMO it would fit much better with your sg setup
> cleanup patch than this one)

No, you need that part. And especially the rq->data assignment.
Take a look at ide_floppy_get_capacity() - it calls into
ide_queue_pc_tail() with pc->req_xfer == 255 resulting from the
ide_floppy_create_read_capacity_cmd(). However, the rq->data is still
NULL if you'd remove the chunk I added and you get

[    6.317953] ------------[ cut here ]------------
[    6.318011] kernel BUG at arch/x86/mm/ioremap.c:80!
[    6.318699] invalid opcode: 0000 [#1] PREEMPT SMP 
[    6.318895] last sysfs file: 
[    6.318895] Modules linked in:
[    6.318895] 
[    6.318895] Pid: 1, comm: swapper Not tainted (2.6.29-rc7 #27) P4I45PE    1.00
[    6.318895] EIP: 0060:[<c0115608>] EFLAGS: 00010213 CPU: 0
[    6.318895] EIP is at __phys_addr+0xc/0x41
[    6.318895] EAX: 00000000 EBX: c1000000 ECX: 00000001 EDX: 00000000
[    6.318895] ESI: df882000 EDI: 00000000 EBP: df82faa4 ESP: df82faa4
[    6.318895]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    6.318895] Process swapper (pid: 1, ti=df82e000 task=df830000 task.ti=df82e000)
[    6.318895] Stack:
[    6.318895]  df82fabc c01fcfe3 00000000 df882000 df82faec df82fb2c df82facc c0256b61
[    6.320031]  df9aba00 df82faec df82fb38 c0260e10 df8f6000 dfa636c0 df8f6000 df82fe0c
[    6.320031]  c01fa4e3 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.321008] Call Trace:
[    6.321008]  [<c01fcfe3>] ? sg_init_one+0x27/0x70
[    6.321008]  [<c0256b61>] ? ide_map_sg+0x3f/0x59
[    6.321008]  [<c0260e10>] ? ide_floppy_do_request+0x2a4/0x3a0
[    6.321008]  [<c01fa4e3>] ? delay_tsc+0x6d/0x86
[    6.321008]  [<c025f2fc>] ? ide_gd_do_request+0xa/0xd
[    6.321008]  [<c0257031>] ? do_ide_request+0x326/0x4a5
[    6.321008]  [<c032b9de>] ? _spin_lock_irqsave+0x1b/0x21
[    6.322015]  [<c012977d>] ? lock_timer_base+0x1f/0x3e
[    6.322015]  [<c032b8bf>] ? _spin_unlock_irqrestore+0x17/0x2c
[    6.322015]  [<c012984a>] ? del_timer+0x47/0x4e
[    6.322015]  [<c01ee8d8>] ? blk_start_queueing+0x18/0x23
[    6.322015]  [<c01ecb71>] ? elv_insert+0x6e/0x18b
[    6.322015]  [<c012995f>] ? mod_timer+0x21/0x27
[    6.322015]  [<c01ecd0f>] ? __elv_add_request+0x81/0x86
[    6.322015]  [<c01f0f9c>] ? blk_execute_rq_nowait+0x58/0x7e
[    6.323007]  [<c01f105c>] ? blk_execute_rq+0x9a/0xba
[    6.323007]  [<c01f0f1c>] ? blk_end_sync_rq+0x0/0x28
[    6.323007]  [<c025c31c>] ? ide_queue_pc_tail+0x5a/0x6d
[    6.323007]  [<c0260f81>] ? ide_floppy_get_capacity+0x75/0x47e
[    6.323007]  [<c01f9ac6>] ? vsnprintf+0x3a6/0x8c5
[    6.323007]  [<c0329da9>] ? schedule_timeout+0x16/0x9d
[    6.323007]  [<c01f5559>] ? idr_get_empty_slot+0x13c/0x1f0
[    6.323007]  [<c01f5559>] ? idr_get_empty_slot+0x13c/0x1f0
[    6.323007]  [<c01f56dd>] ? ida_get_new_above+0xd0/0x171
[    6.323007]  [<c032a116>] ? mutex_unlock+0x8/0xa
[    6.323007]  [<c01a0c4f>] ? sysfs_addrm_finish+0x16/0x1ca
[    6.323007]  [<c01a0977>] ? __sysfs_add_one+0x14/0x8e
[    6.323007]  [<c01a052c>] ? sysfs_add_file_mode+0x4e/0x6d
[    6.323007]  [<c026144a>] ? ide_floppy_setup+0x85/0x9b
[    6.323007]  [<c025f712>] ? ide_gd_probe+0x104/0x162
[    6.323007]  [<c0255bd1>] ? generic_ide_probe+0x1f/0x21
[    6.323007]  [<c024e743>] ? driver_probe_device+0x9c/0x12f
[    6.325013]  [<c024e822>] ? __driver_attach+0x4c/0x6b
[    6.325013]  [<c024e177>] ? bus_for_each_dev+0x3b/0x63
[    6.325013]  [<c024e5ea>] ? driver_attach+0x14/0x16
[    6.325013]  [<c024e7d6>] ? __driver_attach+0x0/0x6b
[    6.325013]  [<c024dba8>] ? bus_add_driver+0xa0/0x1bd
[    6.325013]  [<c024e9cb>] ? driver_register+0x81/0xe1
[    6.325013]  [<c048d35b>] ? ide_gd_init+0x17/0x19
[    6.325013]  [<c0101132>] ? _stext+0x4a/0x10c
[    6.325013]  [<c048d344>] ? ide_gd_init+0x0/0x19
[    6.325013]  [<c0147f0d>] ? register_irq_proc+0x7f/0x9b
[    6.325013]  [<c0147f7c>] ? init_irq_proc+0x53/0x60
[    6.325013]  [<c04772cb>] ? kernel_init+0x101/0x155
[    6.325013]  [<c04771ca>] ? kernel_init+0x0/0x155
[    6.325013]  [<c010370b>] ? kernel_thread_helper+0x7/0x10

If you don't want the changes to ide-atapi you can alternatively do
the following (checking the rq->data being NULL is simply paranoid
cautiousness on my side :)) :

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index f7a3ea0..fc6648d 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -283,6 +283,9 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	cmd.rq = rq;
 
 	if (pc->req_xfer) {
+		if (!rq->data)
+			rq->data = pc->buf;
+
 		ide_init_sg_cmd(&cmd, pc->req_xfer);
 		ide_map_sg(drive, &cmd);
 	}


> > diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> > index 2f8f453..2b4868d 100644
> > --- a/drivers/ide/ide-floppy.c
> > +++ b/drivers/ide/ide-floppy.c
> > @@ -282,8 +282,10 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
> >  
> >  	cmd.rq = rq;
> >  
> > -	ide_init_sg_cmd(&cmd, pc->req_xfer);
> > -	ide_map_sg(drive, &cmd);
> > +	if (blk_fs_request(rq) || pc->req_xfer) {
> 
> ditto for blk_fs_request(rq) check

Unfortunately I can't confirm that because of the other breakage. It
won't hurt if we'd left it in though.

-- 
Regards/Gruss,
    Boris.
