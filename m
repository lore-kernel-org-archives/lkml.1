Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZISVnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZISVnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZISVnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:37 -0400
Received: from kroah.org ([198.145.64.141]:40529 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbZISVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Joe Peterson <joe@skyrush.com>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 59/79] n_tty: honor opost flag for echoes
Date: Sat, 19 Sep 2009 14:37:04 -0700
Message-Id: <1253396244-7885-59-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Peterson <joe@skyrush.com>

Fixes the following bug:

      http://bugs.linuxbase.org/show_bug.cgi?id=2692

Causes processing of echoed characters (output from the echo buffer) to
honor the O_OPOST flag, which is consistent with the old behavior.

Note that this and the next patch ("n_tty: move echoctl check and
clean up logic") were verified together by the bug reporters, and
the test now passes.

Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Linux Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/n_tty.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 4e28b35..e6eeeb2 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -272,7 +272,8 @@ static inline int is_continuation(unsigned char c, struct tty_struct *tty)
  *
  *	This is a helper function that handles one output character
  *	(including special characters like TAB, CR, LF, etc.),
- *	putting the results in the tty driver's write buffer.
+ *	doing OPOST processing and putting the results in the
+ *	tty driver's write buffer.
  *
  *	Note that Linux currently ignores TABDLY, CRDLY, VTDLY, FFDLY
  *	and NLDLY.  They simply aren't relevant in the world today.
@@ -350,8 +351,9 @@ static int do_output_char(unsigned char c, struct tty_struct *tty, int space)
  *	@c: character (or partial unicode symbol)
  *	@tty: terminal device
  *
- *	Perform OPOST processing.  Returns -1 when the output device is
- *	full and the character must be retried.
+ *	Output one character with OPOST processing.
+ *	Returns -1 when the output device is full and the character
+ *	must be retried.
  *
  *	Locking: output_lock to protect column state and space left
  *		 (also, this is called from n_tty_write under the
@@ -377,8 +379,11 @@ static int process_output(unsigned char c, struct tty_struct *tty)
 /**
  *	process_output_block		-	block post processor
  *	@tty: terminal device
- *	@inbuf: user buffer
- *	@nr: number of bytes
+ *	@buf: character buffer
+ *	@nr: number of bytes to output
+ *
+ *	Output a block of characters with OPOST processing.
+ *	Returns the number of characters output.
  *
  *	This path is used to speed up block console writes, among other
  *	things when processing blocks of output data. It handles only
@@ -605,12 +610,18 @@ static void process_echoes(struct tty_struct *tty)
 			if (no_space_left)
 				break;
 		} else {
-			int retval;
-
-			retval = do_output_char(c, tty, space);
-			if (retval < 0)
-				break;
-			space -= retval;
+			if (O_OPOST(tty) &&
+			    !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
+				int retval = do_output_char(c, tty, space);
+				if (retval < 0)
+					break;
+				space -= retval;
+			} else {
+				if (!space)
+					break;
+				tty_put_char(tty, c);
+				space -= 1;
+			}
 			cp += 1;
 			nr -= 1;
 		}
-- 
1.6.4.2

