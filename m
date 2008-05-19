Return-Path: <linux-kernel-owner+w=401wt.eu-S1760490AbYESPDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490AbYESPDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbYESPCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:02:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39694 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758534AbYESPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:02:45 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/20] tty: Clean up tiocmset
To: linux-kernel@vger.kernel.org, akpm@osdl.org, greg@kroah.com
Date: Mon, 19 May 2008 15:50:18 +0100
Message-ID: <20080519145018.19326.15853.stgit@core>
In-Reply-To: <20080519144557.19326.74313.stgit@core>
References: <20080519144557.19326.74313.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Reverse the order of one test and it gets much more readable
---

 drivers/char/tty_io.c |   48 ++++++++++++++++++++++--------------------------
 1 files changed, 22 insertions(+), 26 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index fb17b18..31ab8f0 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3402,35 +3402,31 @@ static int tty_tiocmget(struct tty_struct *tty, struct file *file, int __user *p
 static int tty_tiocmset(struct tty_struct *tty, struct file *file, unsigned int cmd,
 	     unsigned __user *p)
 {
-	int retval = -EINVAL;
-
-	if (tty->ops->tiocmset) {
-		unsigned int set, clear, val;
-
-		retval = get_user(val, p);
-		if (retval)
-			return retval;
-
-		set = clear = 0;
-		switch (cmd) {
-		case TIOCMBIS:
-			set = val;
-			break;
-		case TIOCMBIC:
-			clear = val;
-			break;
-		case TIOCMSET:
-			set = val;
-			clear = ~val;
-			break;
-		}
+	int retval;
+	unsigned int set, clear, val;
 
-		set &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
-		clear &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
+	if (tty->ops->tiocmset == NULL)
+		return -EINVAL;
 
-		retval = tty->ops->tiocmset(tty, file, set, clear);
+	retval = get_user(val, p);
+	if (retval)
+		return retval;
+	set = clear = 0;
+	switch (cmd) {
+	case TIOCMBIS:
+		set = val;
+		break;
+	case TIOCMBIC:
+		clear = val;
+		break;
+	case TIOCMSET:
+		set = val;
+		clear = ~val;
+		break;
 	}
-	return retval;
+	set &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
+	clear &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
+	return tty->ops->tiocmset(tty, file, set, clear);
 }
 
 /*

