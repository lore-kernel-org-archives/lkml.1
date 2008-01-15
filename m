Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYAOUNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYAOUNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYAOUNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:13:06 -0500
Received: from smtp111.plus.mail.re1.yahoo.com ([69.147.102.74]:45230 "HELO
	smtp111.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751415AbYAOUND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:13:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=EcPvlXKJfXsSGV58zh/m5wZPPwpuRS4yvcXHWERG42okY11RU0jmQxkjwEICwtZM1Q7faro2rUhk9s6nsppe2UeoBT9Krd5ubiOy5J/yXzRqiADwnWZWJhSvt3xI1HoU3OEnolUrGyTxnkGp+Bho7D57G1BaaysDfsD7Tv2toWk=  ;
X-YMail-OSG: vBs_JYUVM1n3VASQbUaMnwv8iDLd..Vv6Psryt18KpkUzlzJL0iMC7oIfNFfJ09WAhhrrgWVrQ--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 15 Jan 2008 21:09:21 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 10/12] ide-floppy: remove atomic test_*bit macros
Message-ID: <20080115200921.GA5699@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de> <200801142250.58201.bzolnier@gmail.com> <200801142332.58341.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801142332.58341.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 11:32:58PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Monday 14 January 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 13 January 2008, Borislav Petkov wrote:
> > > ..and replace them with flag enums.
> > > 
> > > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> 
> small update:
> 
> PC_ABORT is never set and may as well be removed in a pre-patch

Here you go, the one below should be pushed first...

--
From: Borislav Petkov <bbpetkov@yahoo.de>
Date: Tue, 15 Jan 2008 20:34:50 +0100
Subject: ide-floppy: remove unused flag PC_ABORT

This flag was never being set in the code so remove it. By the way, the
code in the second patch was being executed unconditionally, i.e. in case
pc->retries > IDEFLOPPY_MAX_PC_RETRIES is true (actually that is the only case
when the outer if-test passed), !test_bit(PC_ABORT, &pc->flags)
was always true so the comment is now incorrect and has to go.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 790e33f..8e9063f 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -110,7 +110,6 @@ typedef struct idefloppy_packet_command_s {
 /*
  *	Packet command flag bits.
  */
-#define	PC_ABORT			0	/* Set when an error is considered normal - We won't retry */
 #define PC_DMA_RECOMMENDED		2	/* 1 when we prefer to use DMA if possible */
 #define	PC_DMA_IN_PROGRESS		3	/* 1 while DMA in progress */
 #define	PC_DMA_ERROR			4	/* 1 when encountered problem during DMA */
@@ -737,18 +736,12 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	/* Set the current packet command */
 	floppy->pc = pc;
 
-	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES ||
-	    test_bit(PC_ABORT, &pc->flags)) {
-		/*
-		 *	We will "abort" retrying a packet command in case
-		 *	a legitimate error code was received.
-		 */
-		if (!test_bit(PC_ABORT, &pc->flags)) {
-			if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags))
-				ide_floppy_report_error(floppy, pc);
-			/* Giving up */
-			pc->error = IDEFLOPPY_ERROR_GENERAL;
-		}
+	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES) {
+		if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags))
+			ide_floppy_report_error(floppy, pc);
+		/* Giving up */
+		pc->error = IDEFLOPPY_ERROR_GENERAL;
+
 		floppy->failed_pc = NULL;
 		pc->callback(drive);
 		return ide_stopped;
-- 
1.5.3.7


-- 
Regards/Gruﬂ,
    Boris.
