Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbYEXV6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbYEXV6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762317AbYEXV6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:58:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:4451 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761667AbYEXV6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c52kkI3dyDbU825aBXK5oSgDa26uGnjlxITs4IODT4WUYBc38fIhT3HCRbD/xhaU3C5tgt8EE9NMIAyx2Lx6icrECxHQzZFaDLkO3IWuOdJLRDzE3rGLNmkXTr5ObM/gHYkAqziGplBjBiymco8OtDul9M6RzGBSs5XiomxznRQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 00/40] ide: generic ATAPI support
Date: Sun, 25 May 2008 15:23:25 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain> <20080522074354.GB2414@gollum.tnic>
In-Reply-To: <20080522074354.GB2414@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251523.26523.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008, Borislav Petkov wrote:
> On Sun, May 18, 2008 at 08:54:28PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > This patch series unifies ATAPI support present in ide-{floppy,tape,scsi}
> > device drivers and moves it out to the core IDE code (new ide-atapi.c file).
> > 
> > In the process many bugs were shaken out and ~300 LOC were removed.
> > 
> > diffstat:
> > 
> >  drivers/ide/Kconfig      |    6 
> >  drivers/ide/Makefile     |    1 
> >  drivers/ide/ide-atapi.c  |  296 ++++++++++++++++++++++
> >  drivers/ide/ide-cd.c     |    5 
> >  drivers/ide/ide-floppy.c |  431 +++++++-------------------------
> >  drivers/ide/ide-tape.c   |  630 ++++++++++++++---------------------------------
> >  drivers/scsi/ide-scsi.c  |  455 +++++++++++----------------------
> >  include/linux/ide.h      |   28 +-
> >  8 files changed, 777 insertions(+), 1075 deletions(-)
> > 
> > Now, while this is a big step in the right direction there are still some
> > things left on TODO for generic ATAPI support to be complete:
> > 
> > - convert ide-cd to use generic ATAPI code
> > 
> > - kill pc and rq stacks in ide-{floppy,tape}
> > 
> > - generic handling of REQUEST SENSE command
> > 
> > - generic handling of MODE SENSE command for ide-{floppy,tape}
> > 
> > - convert ide-{cd,floppy,tape} to use scatterlists for PIO transers
> >   (ala ide-scsi)
> > 
> > I know that Borislav is working on the first two items but other ones
> > are free at the moment so if you feel brave you may give it a try :-).
> > 
> > PS I'll be travelling during this weekend and be rather busy with day job
> >    so replies from me may be delayed a bit.
> 
> Hi Bart,
> 
> yep, these all look real good, makes all drivers really lightweight. Looks like
> ide-cd will follow not too far behind. By the way, here's another one you count apply ontop:
> 
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Thu, 22 May 2008 09:36:53 +0200
> Subject: [PATCH] ide-tape: unify idetape_create_read/write_cmd
> 
> A straightforward one. There should be no functional change resulting from this
> change.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied with minor fixups (mainly to silence checkpatch.pl, interdiff below)

thanks!

diff -u b/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
--- b/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -954,7 +954,7 @@
 
 static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 		struct ide_atapi_pc *pc, unsigned int length,
-		struct idetape_bh *bh, int opcode)
+		struct idetape_bh *bh, u8 opcode)
 {
 	idetape_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
@@ -969,14 +969,12 @@
 	if (opcode == READ_6) {
 		pc->c[0] = READ_6;
 		atomic_set(&bh->b_count, 0);
-	}
-	else if (opcode == WRITE_6) {
+	} else if (opcode == WRITE_6) {
 		pc->c[0] = WRITE_6;
 		pc->flags |= PC_FLAG_WRITING;
 		pc->b_data = bh->b_data;
 		pc->b_count = atomic_read(&bh->b_count);
-	} else
-		printk(KERN_ERR "%s: Invalid opcode: 0x%x\n", __func__, opcode);
+	}
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
