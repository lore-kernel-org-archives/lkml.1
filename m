Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbZHDUig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbZHDUig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932399AbZHDUif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:38:35 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:42135 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbZHDUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:38:34 -0400
Message-ID: <4A789AB0.1000506@skyrush.com>
Date: Tue, 04 Aug 2009 14:31:44 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090616)
MIME-Version: 1.0
To: gregkh@suse.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] n_tty: move echoctl check and clean up logic
Content-Type: multipart/mixed;
 boundary="------------030403000801010301090408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030403000801010301090408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------030403000801010301090408
Content-Type: text/plain;
 name="n_tty-move-echoctl-check-and-clean-up-logic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="n_tty-move-echoctl-check-and-clean-up-logic.patch"

Check L_ECHOCTL before insertting a character in the echo buffer
(rather than as the buffer is processed), to be more consistent with
when all other L_ flags are checked.  Also cleaned up the related logic.

Note that this and the previous patch ("n_tty: honor opost flag for echoes")
were verified together by the reporters of the bug that patch addresses
(http://bugs.linuxbase.org/show_bug.cgi?id=2692), and all tty tests now pass.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2009-08-04 12:41:27.445263301 -0600
+++ b/drivers/char/n_tty.c	2009-08-04 12:40:11.905246260 -0600
@@ -578,33 +578,23 @@ static void process_echoes(struct tty_st
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
@@ -805,8 +795,8 @@ static void echo_char_raw(unsigned char 
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
@@ -819,7 +809,7 @@ static void echo_char(unsigned char c, s
 		add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(ECHO_OP_START, tty);
 	} else {
-		if (iscntrl(c) && c != '\t')
+		if (L_ECHOCTL(tty) && iscntrl(c) && c != '\t')
 			add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(c, tty);
 	}

--------------030403000801010301090408--
