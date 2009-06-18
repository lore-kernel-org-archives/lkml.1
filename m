Return-Path: <linux-kernel-owner+w=401wt.eu-S1763777AbZFRN4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777AbZFRN4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbZFRN43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:56:29 -0400
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:40133 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbZFRN42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:56:28 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 09:56:27 EDT
To: linux-kernel@vger.kernel.org
Cc: petkovbb@gmail.com
Subject: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Thu, 18 Jun 2009 15:48:18 +0200
Message-ID: <87zlc58xgd.fsf@fever.mssgmbh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (mss-uk.mssgmbh.com [217.174.251.109]); Thu, 18 Jun 2009 15:48:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mssgmbh.com>

With 2.6.30, the error handling code in cdrom_newpc_intr was changed
to deal with partial request failures by normally completing the 'good'
parts of a request and only 'error' the last (and presumably,
incompletely transferred) bio associated with a particular
request. This doesn't work for requests which don't have bios
associated with them ('GPCMD_READ_DISC_INFO'), because the first call
to ide_end_rq, done via ide_complete_rq in order to do the
partial completion part, returns with a code of zero for all non-bio
requests, causing the drive->hwif->rq pointer to be set to NULL. Upon
calling ide_complete_rq a second time, it is attempted to de-reference
this null pointer, resulting in a kernel crash.

Signed-Off-By: Rainer Weikusat <rweikusat@mssgmbh.com>

---

This is fixed in the linux-ide tree since at about 2009/06/10 [Bug
13399, also happens w/ TSSTcorpDVD-ROM SH-D162C], but a patch
against 2.6.30 AFAIK doesn't exist (and I didn't find the
corresponding thread before digging through all of this ...).

--- drivers/ide/ide-cd.c.orig	2009-06-18 15:10:24.000000000 +0200
+++ drivers/ide/ide-cd.c	2009-06-18 14:10:16.000000000 +0200
@@ -758,7 +758,7 @@ out_end:
 				rq->errors = -EIO;
 		}
 
-		if (uptodate == 0)
+		if (uptodate == 0 && rq->bio)
 			ide_cd_error_cmd(drive, cmd);
 
 		/* make sure it's fully ended */
