Return-Path: <linux-kernel-owner+w=401wt.eu-S932377AbZGABSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbZGABSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761636AbZGAAgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:36:02 -0400
Received: from kroah.org ([198.145.64.141]:60770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761623AbZGAAgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:36:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:45 2009
Message-Id: <20090701002445.375631252@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rainer Weikusat <rweikusat@mssgmbh.com>,
       Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 106/108] ide-cd: prevent null pointer deref via cdrom_newpc_intr
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ide-cd-prevent-null-pointer-deref-via-cdrom_newpc_intr.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rainer Weikusat <rweikusat@mssgmbh.com>

commit 39c58f37a10198054c656c28202fb1e6d22fd505 upstream.

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

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=13399.

Signed-off-by: Rainer Weikusat <rweikusat@mssgmbh.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-cd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -758,7 +758,7 @@ out_end:
 				rq->errors = -EIO;
 		}
 
-		if (uptodate == 0)
+		if (uptodate == 0 && rq->bio)
 			ide_cd_error_cmd(drive, cmd);
 
 		/* make sure it's fully ended */


