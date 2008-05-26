Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYEZOJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYEZOJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYEZOIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:08:55 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:37736 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752071AbYEZOIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:08:54 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] Char: tty_io, fix closecount counting
Date: Mon, 26 May 2008 16:08:43 +0200
Message-Id: <1211810923-3122-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, please N/ACK this.

--

filp->f_op->write never equals to tty_write for the console device, so
closecount++ is never reached and we don't close console device so many
times we open it before. (The closecount is used only for /dev/console.)

This is probably a fix for an issue first reported in 2.6.18.1:
http://lkml.org/lkml/2006/10/20/301
and
http://marc.info/?l=linux-mips&m=118797256328587

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/tty_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index c9e6e24..8c7b6ed 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1434,9 +1434,9 @@ static void do_tty_hangup(struct work_struct *work)
 	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
 		if (filp->f_op->write == redirected_tty_write)
 			cons_filp = filp;
+		closecount++;
 		if (filp->f_op->write != tty_write)
 			continue;
-		closecount++;
 		tty_fasync(-1, filp, 0);	/* can't block */
 		filp->f_op = &hung_up_tty_fops;
 	}
-- 
1.5.4.5

