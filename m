Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbZFRPET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbZFRPET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZFRPEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:04:07 -0400
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:37728 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbZFRPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:04:06 -0400
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 11:04:05 EDT
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
In-Reply-To: <9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com> (Borislav Petkov's message of "Thu\, 18 Jun 2009 16\:39\:40 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
References: <87zlc58xgd.fsf@fever.mssgmbh.com>
	<9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com>
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Thu, 18 Jun 2009 17:04:00 +0200
Message-ID: <87r5xh8ty7.fsf@fever.mssgmbh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (mss-uk.mssgmbh.com [217.174.251.109]); Thu, 18 Jun 2009 17:04:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mssgmbh.com>

With 2.6.30, the error handling code in cdrom_newpc_intr was changed
to deal with partial request failures by normally completing the 'good'
parts of a request and only 'error' the last (and presumably,
incompletely transferred) bio associated with a particular
request. In order to do this, ide_complete_rq is called over
ide_cd_error_cmd() to partially complete the rq. The block layer
does partial completion only for requests with bio's and if the
rq doesn't have one (eg 'GPCMD_READ_DISC_INFO') the request is
completed as a whole and the drive->hwif->rq pointer set to NULL
afterwards. When calling ide_complete_rq again to report
the error, this null pointer is derefenced, resulting in a kernel
crash.

Signed-Off-By: Rainer Weikusat <rweikusat@mssgmbh.com>

---

--- drivers/ide/ide-cd.c.orig	2009-06-18 15:10:24.000000000 +0200
+++ drivers/ide/ide-cd.c	2009-06-18 14:10:16.000000000 +0200
@@ -758,7 +758,7 @@ out_end:
 				rq->errors = -EIO;
 		}
 
-		if (uptodate == 0)
+		if (uptodate == 0 && rq->bio)
 			ide_cd_error_cmd(drive, cmd);
 
 		/* make sure it's fully ended */
