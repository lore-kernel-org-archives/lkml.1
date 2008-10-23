Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbYJWBgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbYJWBgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYJWBfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:35:54 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35559 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYJWBfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:35:54 -0400
Message-ID: <48FFD4F9.6090105@skyrush.com>
Date: Wed, 22 Oct 2008 19:35:53 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] n-tty-output-bells-immediately
References: <48F2E450.1070508@skyrush.com> <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050601010105060107010901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050601010105060107010901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------050601010105060107010901
Content-Type: text/plain;
 name="n-tty-output-bells-immediately.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="n-tty-output-bells-immediately.patch"

This patch causes "bell" (^G) characters (invoked when the input buffer
is full) to be immediately output rather than filling the echo buffer.

This is especially a problem when the tty is stopped and buffers fill, since
the bells do not serve their purpose of immediate notification that the
buffer cannot take further input, and they will flush all at once when the
tty is restarted.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp b/drivers/char/n_tty.c c/drivers/char/n_tty.c
--- b/drivers/char/n_tty.c	2008-10-22 18:14:38.083337970 -0600
+++ c/drivers/char/n_tty.c	2008-10-22 18:14:56.573340597 -0600
@@ -872,7 +872,7 @@ static void eraser(unsigned char c, stru
 
 	/* FIXME: locking needed ? */
 	if (tty->read_head == tty->canon_head) {
-		/* echo_char_raw('\a', tty); */ /* what do you think? */
+		/* process_output('\a', tty); */ /* what do you think? */
 		return;
 	}
 	if (c == ERASE_CHAR(tty))
@@ -1148,10 +1148,8 @@ static inline void n_tty_receive_char(st
 		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
 		if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk - 1)) {
 			/* beep if no space */
-			if (L_ECHO(tty)) {
-				echo_char_raw('\a', tty);
-				process_echoes(tty);
-			}
+			if (L_ECHO(tty))
+				process_output('\a', tty);
 			return;
 		}
 		if (L_ECHO(tty)) {
@@ -1255,10 +1253,8 @@ send_signal:
 		}
 		if (c == '\n') {
 			if (tty->read_cnt >= N_TTY_BUF_SIZE) {
-				if (L_ECHO(tty)) {
-					echo_char_raw('\a', tty);
-					process_echoes(tty);
-				}
+				if (L_ECHO(tty))
+					process_output('\a', tty);
 				return;
 			}
 			if (L_ECHO(tty) || L_ECHONL(tty)) {
@@ -1280,10 +1276,8 @@ send_signal:
 			parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty))
 				 ? 1 : 0;
 			if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk)) {
-				if (L_ECHO(tty)) {
-					echo_char_raw('\a', tty);
-					process_echoes(tty);
-				}
+				if (L_ECHO(tty))
+					process_output('\a', tty);
 				return;
 			}
 			/*
@@ -1320,10 +1314,8 @@ handle_newline:
 	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
 	if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk - 1)) {
 		/* beep if no space */
-		if (L_ECHO(tty)) {
-			echo_char_raw('\a', tty);
-			process_echoes(tty);
-		}
+		if (L_ECHO(tty))
+			process_output('\a', tty);
 		return;
 	}
 	if (L_ECHO(tty)) {

--------------050601010105060107010901--
