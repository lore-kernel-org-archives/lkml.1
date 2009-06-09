Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbZFIKbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbZFIKbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932090AbZFIKUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:43 -0400
Received: from kroah.org ([198.145.64.141]:55208 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084AbZFIKUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:42 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:05 2009
Message-Id: <20090609094105.427022347@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 57/87] ide-tape: remove back-to-back REQUEST_SENSE detection
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ide-tape-remove-back-to-back-request_sense-detection.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 36999a5af1b6c5379e59f0ddf434db08d03c19e4 upstream.

Impact: fix an oops which always triggers

ide_tape_issue_pc() assumed drive->pc isn't NULL on invocation when
checking for back-to-back request sense issues but drive->pc can be
NULL and even when it's not NULL, it's not safe to dereference it once
the previous command is complete because pc could have been freed or
was on stack.  Kill back-to-back REQUEST_SENSE detection.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-tape.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -654,12 +654,6 @@ static ide_startstop_t idetape_issue_pc(
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	if (drive->pc->c[0] == REQUEST_SENSE &&
-	    pc->c[0] == REQUEST_SENSE) {
-		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
-			"Two request sense in serial were issued\n");
-	}
-
 	if (tape->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
 		tape->failed_pc = pc;
 


