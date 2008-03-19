Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYCSWGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYCSWGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933624AbYCSUcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:32:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:63565 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615AbYCSUb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:31:58 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc4
Date: Wed, 19 Mar 2008 02:21:58 +0100
User-Agent: KMail/1.9.9
Cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803180751200.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803180751200.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803190221.58968.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008, Linus Torvalds wrote:
> 
> On Tue, 18 Mar 2008, Anders Eriksson wrote:
> > 
> > Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
> > Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
> > Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
> > Mar 18 14:18:26 tippex task_in_intr: hda: stat=50
> 
> Uhhuh. That's READY_STAT | SRV_STAT. No error, no DRQ, no nothing.
> 
> And I think this also explains why your bisect found that old commit
> 4d977e43d8ae758434e603cf2455d955f71c77c4 to be problematic.
> 
> The thing is, that commit - and the taskfile code that it then all got 
> replaced with - use this totally bogus check:
> 
> 	OK_STAT(stat, DRQ_STAT, BAD_R_STAT)
> 		...
> 
> which basically says that the only OK situation is that no error bits are 
> set, and DRQ _has_ to be set.
> 
> Before that, the code did the right thing in any _combination_ of bits: if 
> DRQ wasn't set, it would just say "oh, ok, the command is done", but the 
> taskfile code and the 4d977e43d commit code thinks that DRQ not being set 
> is an error, and then it gets confused when the actual error bits aren't 
> set!

Which is with compliance with PIO-in protocol specification and years of
usage of the task_in_intr() code for fs code paths and HDIO_DRIVE_TASKFILE
ioctl has proven that real hardware also works this way (please note that
the changed code was used only for HDIO_DRIVE_CMD ioctl requests).

> I think that whole way of writing code is totally horribly bad! It's not 
> only trying to tie together bits that are independent, but it actually 
> gets a lot harder to understand too, because now you have *four* different 
> cases ("no error, no drq", "error, no drq", "no error, drq", "error, drq") 
> but you use one test to try to find the one you expect, and then the code 
> easily messes up on all the other three cases!

If INTRQ is asserted and "BSY is cleared to zero and DRQ is cleared, then
the device has completed the command with an error." (thus task_in_intr()
assumed ERR bit to be set), otherwise the value ERR may not be defined
(however task_in_intr() still assumed that it is OK to check ERR bit).

Additionally handling of premature shared PCI interrupts comes into the
picture making the whole thing much more messier.  It could happen in the
past that drive_is_ready() was called before drive had time to assert BSY
so later also task_in_intr() assumed that the drive is ready.  However this
should be already fixed as we now always guarantee sufficient delay after
the command was written so how's about the following patch which just makes
DRQ == 0 || BSY == 1 || ERR == 1 an error (ideally we should also proceed
with transfer if DRQ == 1 && ERR == 1 but it may have other gotchas so lets
keep it as it was for now):

---
preferably this should get some testing in -mm first

 drivers/ide/ide-taskfile.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -431,14 +431,9 @@ static ide_startstop_t task_in_intr(ide_
 	struct request *rq = HWGROUP(drive)->rq;
 	u8 stat = ide_read_status(drive);
 
-	/* new way for dealing with premature shared PCI interrupts */
-	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
-		if (stat & (ERR_STAT | DRQ_STAT))
-			return task_error(drive, rq, __FUNCTION__, stat);
-		/* No data yet, so wait for another IRQ. */
-		ide_set_handler(drive, &task_in_intr, WAIT_WORSTCASE, NULL);
-		return ide_started;
-	}
+	/* TODO: more complex handling is needed for ERR == 1 */
+	if ((stat & DRQ_STAT) == 0 || (stat & (BUSY_STAT | ERR_STAT)))
+		return task_error(drive, rq, __func__, stat);
 
 	ide_pio_datablock(drive, rq, 0);


Now back to the recent debug log from Anders:

Mar 18 16:02:14 tippex hda: tf: feat 0xd2 nsect 0xf1 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 16:02:14 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 16:02:14 tippex task_in_intr: hda: stat=50

This is SMART command with SMART ENABLE ATTRIBUTE AUTOSAVE sub-command
(feat == 0xd2, nsect == 0xf1) but it should use no-data protocol instead of
PIO-in which brings us back to commit 18a056feccabdfa9764016a615121b194828bc72
("ide: don't enable local IRQs for PIO-in in driver_cmd_intr() (take 2)"):

@@ -638,19 +638,22 @@ static ide_startstop_t drive_cmd_intr (ide_drive_t *drive)
 {
        struct request *rq = HWGROUP(drive)->rq;
        ide_hwif_t *hwif = HWIF(drive);
-       u8 *args = (u8 *) rq->buffer;
-       u8 stat = hwif->INB(IDE_STATUS_REG);
+       u8 *args = (u8 *)rq->buffer, pio_in = (args && args[3]) ? 1 : 0, stat;

-       local_irq_enable_in_hardirq();
-       if (rq->cmd_type == REQ_TYPE_ATA_CMD &&
-           (stat & DRQ_STAT) && args && args[3]) {
+       if (pio_in) {
                u8 io_32bit = drive->io_32bit;
+               stat = hwif->INB(IDE_STATUS_REG);
+               if ((stat & DRQ_STAT) == 0)
+                       goto out;
                drive->io_32bit = 0;
                hwif->ata_input_data(drive, &args[4], args[3] * SECTOR_WORDS);
                drive->io_32bit = io_32bit;
                stat = wait_drive_not_busy(drive);
+       } else {
+               local_irq_enable_in_hardirq();
+               stat = hwif->INB(IDE_STATUS_REG);
        }
-
+out:
        if (!OK_STAT(stat, READY_STAT, BAD_STAT))
                return ide_error(drive, "drive_cmd", stat);
                /* calls ide_end_drive_cmd */

as can be seen before this patch protocol to use was decided basing on DRQ bit
being set - what would you call _that_ if taskfile code is horrible, he? ;-)

[ I tried really hard to make patchset which converted HDIO_DRIVE_CMD to use
  the common code as bisectable and simple as possible (by separating real
  changes in behavior from pure code transformations and making patches of
  small granularity) since potential problems were kind of expected but
  I must admit that I completely overlooked the hidden meaning of DRQ_STAT
  check... ]

Later commit 4d977e43d8ae758434e603cf2455d955f71c77c4 just triggered the bug...

The "real" fix (Anders, please test it):

---
BTW libata seems to have exactly the same problem but it
is hidden by the lack of quirk for "premature PCI IRQs"

 drivers/ide/ide-taskfile.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -771,15 +771,25 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 		tf->lbam  = 0x4f;
 		tf->lbah  = 0xc2;
 		tfargs.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
+
+		/* SMART READ DATA / LOG */
+		if (tf->feature == 0xD0 || tf->feature == 0xD5)
+			tfargs.data_phase = TASKFILE_IN;
+		else
+			tfargs.data_phase = TASKFILE_NO_DATA;
 	} else {
 		tf->nsect = args[1];
 		tfargs.tf_flags = IDE_TFLAG_OUT_FEATURE |
 				  IDE_TFLAG_OUT_NSECT | IDE_TFLAG_IN_NSECT;
+
+		if (args[3])
+			tfargs.data_phase = TASKFILE_IN;
+		else
+			tfargs.data_phase = TASKFILE_NO_DATA;
 	}
 	tf->command = args[0];
-	tfargs.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
 
-	if (args[3]) {
+	if (tfargs.data_phase == TASKFILE_IN) {
 		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
 		bufsize = SECTOR_WORDS * 4 * args[3];
 		buf = kzalloc(bufsize, GFP_KERNEL);
