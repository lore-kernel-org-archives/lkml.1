Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXCTUq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXCTUq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXCTUq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:46:26 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:3358 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbXCTUqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:46:25 -0400
X-AuditID: d80ac287-a246cbb000000de9-c8-460048211a6d 
Date: Tue, 20 Mar 2007 19:42:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: 2.6.21-rc4-mm1: init hangs on tty_mutex
Message-ID: <Pine.LNX.4.64.0703201930060.14654@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 20 Mar 2007 20:46:24.0281 (UTC) FILETIME=[D2D03090:01C76B30]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get a hang at startup or shutdown: tiocsctty() holds tty_mutex, and
now with Eric's tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
it can end up calling con_close(), which tries to take tty_mutex.
So best revert that in hot-fixes, until Eric provides a better.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.21-rc4-mm1/drivers/char/tty_io.c	2007-03-20 12:49:34.000000000 +0000
+++ linux/drivers/char/tty_io.c	2007-03-20 18:14:53.000000000 +0000
@@ -2980,7 +2980,9 @@ static int tiocsctty(struct tty_struct *
 			/*
 			 * Steal it away
 			 */
-			tty_vhangup(tty);
+			read_lock(&tasklist_lock);
+			session_clear_tty(tty->session);
+			read_unlock(&tasklist_lock);
 		} else {
 			ret = -EPERM;
 			goto unlock;
