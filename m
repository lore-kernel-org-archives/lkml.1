Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZISVry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZISVry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZISVnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:41 -0400
Received: from kroah.org ([198.145.64.141]:40533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbZISVng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Joe Peterson <joe@skyrush.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/79] n_tty: move echoctl check and clean up logic
Date: Sat, 19 Sep 2009 14:37:05 -0700
Message-Id: <1253396244-7885-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Peterson <joe@skyrush.com>

Check L_ECHOCTL before insertting a character in the echo buffer
(rather than as the buffer is processed), to be more consistent with
when all other L_ flags are checked.  Also cleaned up the related logic.

Note that this and the previous patch ("n_tty: honor opost flag for echoes")
were verified together by the reporters of the bug that patch addresses
(http://bugs.linuxbase.org/show_bug.cgi?id=2692), and the test now passes.

Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/n_tty.c |   46 ++++++++++++++++++----------------------------
 1 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index e6eeeb2..2e50f4d 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -576,33 +576,23 @@ static void process_echoes(struct tty_struct *tty)
 				break;
 
 			default:
-				if (iscntrl(op)) {
-					if (L_ECHOCTL(tty)) {
-						/*
-						 * Ensure there is enough space
-						 * for the whole ctrl pair.
-						 */
-						if (space < 2) {
-							no_space_left = 1;
-							break;
-						}
-						tty_put_char(tty, '^');
-						tty_put_char(tty, op ^ 0100);
-						tty->column += 2;
-						space -= 2;
-					} else {
-						if (!space) {
-							no_space_left = 1;
-							break;
-						}
-						tty_put_char(tty, op);
-						space--;
-					}
-				}
 				/*
-				 * If above falls through, this was an
-				 * undefined op.
+				 * If the op is not a special byte code,
+				 * it is a ctrl char tagged to be echoed
+				 * as "^X" (where X is the letter
+				 * representing the control char).
+				 * Note that we must ensure there is
+				 * enough space for the whole ctrl pair.
+				 *
 				 */
+				if (space < 2) {
+					no_space_left = 1;
+					break;
+				}
+				tty_put_char(tty, '^');
+				tty_put_char(tty, op ^ 0100);
+				tty->column += 2;
+				space -= 2;
 				cp += 2;
 				nr -= 2;
 			}
@@ -809,8 +799,8 @@ static void echo_char_raw(unsigned char c, struct tty_struct *tty)
  *	Echo user input back onto the screen. This must be called only when
  *	L_ECHO(tty) is true. Called from the driver receive_buf path.
  *
- *	This variant tags control characters to be possibly echoed as
- *	as "^X" (where X is the letter representing the control char).
+ *	This variant tags control characters to be echoed as "^X"
+ *	(where X is the letter representing the control char).
  *
  *	Locking: echo_lock to protect the echo buffer
  */
@@ -823,7 +813,7 @@ static void echo_char(unsigned char c, struct tty_struct *tty)
 		add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(ECHO_OP_START, tty);
 	} else {
-		if (iscntrl(c) && c != '\t')
+		if (L_ECHOCTL(tty) && iscntrl(c) && c != '\t')
 			add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(c, tty);
 	}
-- 
1.6.4.2

