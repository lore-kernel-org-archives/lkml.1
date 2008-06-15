Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYFOMql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYFOMql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 08:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYFOMqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 08:46:31 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4437 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752234AbYFOMq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 08:46:29 -0400
Message-ID: <48550F0C.8030907@panasas.com>
Date: Sun, 15 Jun 2008 15:46:04 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [regression] CD-DA delay needed after insertion
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jun 2008 12:46:06.0456 (UTC) FILETIME=[C72DCF80:01C8CEE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> We've found another regression in 2.6.25 w.r.t. CD media change on PS3.
> 
> It can easily be reproduced by:
> 
>   1. Inserting an audio CD
>   2. Running the following command as soon as the blue CD/DVD/BD drive LED
>      stops blinking and is lit continuously:
>       
> 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
> 
> On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
> insertion, or it will fail.
> On 2.6.24 and older, it just works immediately.
> 
> It does not matter whether
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
> is applied or not.
> 
> We haven't bisected it yet.
> 
> With kind regards,
> 
> Geert Uytterhoeven
> Software Architect
> 
> Sony Techsoft Centre
> The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
> 
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@sonycom.com
> Internet: http://www.sony-europe.com/
> 
> Sony Technology and Software Centre Europe
> A division of Sony Service Centre (Europe) N.V.
> Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
> VAT BE 0413.825.160 · RPR Brussels
> Fortis 293-0376800-10 GEBA-BE-BB

James hi.

It looks like the same problem as before. Any BLOCK_PC command will 
eat the UNIT_ATTENTION notification. Which is what I was afraid of. 
I was thinking of something like below.

Totally untested, never even booted. It is just to demonstrate the concept.
Please tell me if it is at all desirable and I'll spend some time to see
if it runs, and test it.

Boaz
---
>From 8cd166b76100a2830f0f973df866f5509398f6cc Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 10 Jun 2008 20:09:43 +0300
Subject: [PATCH] scsi: Proccess UNIT_ATTENTION on any type command

Let scsi_check_sense() report UNIT_ATTENTION media
changes for any type of command. Currently only FS
commands are reported.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |    4 ++++
 drivers/scsi/scsi_lib.c   |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 006a959..7039d11 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -370,6 +370,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
+
+		/* Detected disc change.*/
+		if (scmd->device->removable)
+			scmd->device->changed = 1;
 		return SUCCESS;
 
 		/* these three are not supported */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 033c58a..efd3e09 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -903,11 +903,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			if (cmd->device->removable) {
+			if (cmd->device->changed) {
 				/* Detected disc change.  Set a bit
 				 * and quietly refuse further access.
 				 */
-				cmd->device->changed = 1;
 				scsi_end_request(cmd, -EIO, this_count, 1);
 				return;
 			} else {
-- 
1.5.6.rc1.5.gadf6


