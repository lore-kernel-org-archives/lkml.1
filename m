Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYGZWqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYGZWqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 18:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbYGZWqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 18:46:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1207 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756181AbYGZWqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 18:46:31 -0400
Date: Sat, 26 Jul 2008 18:46:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       SCSI Kernel <linux-scsi@vger.kernel.org>
Subject: Re: [SCSI] can't plug Nokia 5300 anymore (bisected)
In-Reply-To: <488AEFA6.5030409@belbone.be>
Message-ID: <Pine.LNX.4.44L0.0807261826390.28592-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Cédric Godin wrote:

> Alan Stern wrote:
> > On Fri, 25 Jul 2008, Cédric Godin wrote:
> >
> >   
> >> resending because wrong address of lkml and cc scsi list
> >>
> >> Hello,
> >>
> >> since 2 or 3 -git kernels (Linus tree)  I have a problem with my laptop 
> >> and its connection through USB to a nokia 5300 gsm.
> >>
> >> The logs show me a endless loop (until i unplug my USB cable) of 
> >> following messages :
> >>
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >>
> >> I bisected the kernel and found the following commit as result :
> >>
> >> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
> >> commit 427e59f09fdba387547106de7bab980b7fff77be
> >> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> >> Date:   Sat Mar 8 18:24:17 2008 -0600
> >>
> >>    [SCSI] make use of the residue value
> >>
> >>    USB sometimes doesn't return an error but instead returns a residue
> >>    value indicating part (or all) of the command wasn't completed.  So if
> >>    the driver _done() error processing indicates the command was fully
> >>    processed, subtract off the residue so that this USB error gets
> >>    propagated.
> >>
> >>    Cc: Alan Stern <stern@rowland.harvard.edu>
> >>    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >>
> >> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd 
> >> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
> >>
> >>
> >> When reverting it with 2.6.26-06077-gc010b2f , everything is back to normal.
> >>     
> >
> > Can you post the corresponding dmesg log from a system built with 
> > CONFIG_USB_STORAGE_DEBUG enabled?
> >
> > Alan Stern
> >
> >   
> Sure,
> i attached it

This log doesn't contain an endless loop of error messages.  In fact I 
see only one error, and the commit you found wouldn't have affected 
that error.  More accurately, if the commit magnified the error into an 
endless loop, then without the commit the error would still have been 
present and would have caused data corruption.

Anyway, it would be interesting to see what happens with the commit in 
place and the following patch applied.  (The first part of the patch 
has already been accepted by James.)

Alan Stern




Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -653,6 +653,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd 
 	ses->sdb = scmd->sdb;
 	ses->next_rq = scmd->request->next_rq;
 	ses->result = scmd->result;
+	ses->underflow = scmd->underflow;
 
 	scmd->cmnd = ses->eh_cmnd;
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
@@ -711,6 +712,7 @@ void scsi_eh_restore_cmnd(struct scsi_cm
 	scmd->sdb = ses->sdb;
 	scmd->request->next_rq = ses->next_rq;
 	scmd->result = ses->result;
+	scmd->underflow = ses->underflow;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
Index: usb-2.6/include/scsi/scsi_eh.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_eh.h
+++ usb-2.6/include/scsi/scsi_eh.h
@@ -73,6 +73,7 @@ extern int scsi_reset_provider(struct sc
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	unsigned underflow;
 	enum dma_data_direction data_direction;
 	unsigned char cmd_len;
 	unsigned char *cmnd;
Index: usb-2.6/drivers/usb/storage/transport.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/transport.c
+++ usb-2.6/drivers/usb/storage/transport.c
@@ -663,7 +663,7 @@ void usb_stor_invoke_transport(struct sc
 	}
 
 	/* Did we transfer less than the minimum amount required? */
-	if (srb->result == SAM_STAT_GOOD &&
+	if ((srb->result == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) &&
 			scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
 		srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
 


