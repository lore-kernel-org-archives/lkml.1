Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXKXGnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXKXGnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 01:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXKXGmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 01:42:55 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:36723 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751597AbXKXGmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 01:42:54 -0500
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <4747135C.60205@free.fr>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <4744A6F2.4030302@free.fr>
	 <20071121144116.c932727b.akpm@linux-foundation.org>
	 <4746814F.80502@free.fr> <4746866B.5070207@suse.de>
	 <4746BB9D.2030508@suse.de>  <4747135C.60205@free.fr>
Content-Type: text/plain; charset=utf-8
Date: Sat, 24 Nov 2007 08:42:49 +0200
Message-Id: <1195886569.3195.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-23 at 18:52 +0100, Laurent Riffard wrote:
> Le 23.11.2007 12:38, Hannes Reinecke a écrit :
> > Hannes Reinecke wrote:
> >> Laurent Riffard wrote:
> >>> Le 21.11.2007 23:41, Andrew Morton a écrit :
> >>>> On Wed, 21 Nov 2007 22:45:22 +0100
> >>>> Laurent Riffard <laurent.riffard@free.fr> wrote:
> >>>>
> >>>>> Le 21.11.2007 05:45, Andrew Morton a écrit :
> >>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/
> >>>>> Hello, 
> >>>>>
> >>>>> My system hangs shortly after I logged in Gnome desktop. SysRq-W shows
> >>>>> that a bunch of task are blocked in "D" state, they seem to wait for
> >>>>> some I/O completion. I can try to hand-copy some data if requested.
> >>>>>
> >>>>> I found these messages in dmesg:
> >>>>>
> >>>>> ~$ grep -C2 end_request dmesg-2.6.24-rc3-mm1 
> >>>>> EXT3-fs: mounted filesystem with ordered data mode.
> >>>>> sd 0:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> >>>>> end_request: I/O error, dev sda, sector 16460
> >>>>> ReiserFS: sda7: found reiserfs format "3.6" with standard journal
> >>>>> ReiserFS: sda7: using ordered data mode
> >>>>> --
> >>>>> ReiserFS: sda7: Using r5 hash to sort names
> >>>>> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> >>>>> end_request: I/O error, dev sdb, sector 19632
> >>>>> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> >>>>> end_request: I/O error, dev sdb, sector 40037363
> >>>>> Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 extents:1 across:1048568k
> >>>>> lp0: using parport0 (interrupt-driven).
> >>>>>
> >>>>> These errors occur *only* with 2.6.24-rc3-mm1, they are 100% reproducible.
> >>>>> 2.6.24-rc3 and 2.6.24-rc2-mm1 are fine.
> >>>>>
> >>>>> Maybe something is broken in pata_via driver ?
> >>>>>
> >>>> Could be - libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
> >>>> and pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
> >>>> touch pata_via.c.
> >>> None of the above...
> >>>
> >>> I did a bisection, it spotted git-scsi-misc.patch. 
> >>> I just run 2.6.24-rc3-mm1 + revert-git-scsi-misc.patch, and it works fine.
> >>>
> >>> I guess commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0 "[SCSI] Do not 
> >>> requeue requests if REQ_FAILFAST is set" is the real culprit. The other 
> >>> commits are touching documentation or drivers I don't use. I'll try 
> >>> to revert only this one this evening.
> 
> I can confirm : reverting commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0 
> does fix the problem.
> 
> >> Hmm. Weird. I'll have a look into it. Apparently I'll be returning an error where
> >> I shouldn't. Checking ...
> >>
> > Ok, found it. We are blocking even special commands (ie requests with PREEMPT not set)
> > when FAILFAST is set. Which is clearly wrong. The attached patch fixes this.
> 
> Sorry, it's not enough. 2.6.24-rc3-mm1 + your patch still hangs with I/O errors.

I think the problem is the way we treat BLOCKED and QUIESCED (the latter
is the state that the domain validation uses and which we cannot kill
fastfail on).  It's definitely wrong to kill fastfail requests when the
state is QUIESCE.

This patch (which is applied on top of Hannes original) separates the
BLOCK and QUIESCE states correctly ... does this fix the problem?

James

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 13e7e09..a7cf23a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1279,18 +1279,21 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 				    "rejecting I/O to dead device\n");
 			ret = BLKPREP_KILL;
 			break;
-		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
 			/*
-			 * If the devices is blocked we defer normal commands.
-			 */
-			if (!(req->cmd_flags & REQ_PREEMPT))
-				ret = BLKPREP_DEFER;
-			/*
 			 * Return failfast requests immediately
 			 */
 			if (req->cmd_flags & REQ_FAILFAST)
 				ret = BLKPREP_KILL;
+
+			/* fall through */
+
+		case SDEV_QUIESCE:
+			/*
+			 * If the devices is blocked we defer normal commands.
+			 */
+			if (!(req->cmd_flags & REQ_PREEMPT))
+				ret = BLKPREP_DEFER;
 			break;
 		default:
 			/*


