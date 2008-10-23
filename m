Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYJWBel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYJWBel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYJWBed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:34:33 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35553 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYJWBed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:34:33 -0400
Message-ID: <48FFD4A8.7050109@skyrush.com>
Date: Wed, 22 Oct 2008 19:34:32 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] n-tty-fix-cont-and-ctrl-output
References: <48F2E450.1070508@skyrush.com> <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010107020604040508000308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010107020604040508000308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------010107020604040508000308
Content-Type: text/plain;
 name="n-tty-fix-cont-and-ctrl-output.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="n-tty-fix-cont-and-ctrl-output.patch"

Fix process_output_block to detect continuation characters correctly
and to handle control characters even when O_OLCUC is enabled.  Make
similar change to do_output_char().

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2008-10-22 17:36:05.443340314 -0600
+++ b/drivers/char/n_tty.c	2008-10-22 17:34:38.063341826 -0600
@@ -351,10 +351,12 @@ static int do_output_char(unsigned char 
 			tty->column--;
 		break;
 	default:
-		if (O_OLCUC(tty))
-			c = toupper(c);
-		if (!iscntrl(c) && !is_continuation(c, tty))
-			tty->column++;
+		if (!iscntrl(c)) {
+			if (O_OLCUC(tty))
+				c = toupper(c);
+			if (!is_continuation(c, tty))
+				tty->column++;
+		}
 		break;
 	}
 
@@ -425,7 +427,9 @@ static ssize_t process_output_block(stru
 		nr = space;
 
 	for (i = 0, cp = buf; i < nr; i++, cp++) {
-		switch (*cp) {
+		unsigned char c = *cp;
+		
+		switch (c) {
 		case '\n':
 			if (O_ONLRET(tty))
 				tty->column = 0;
@@ -447,10 +451,12 @@ static ssize_t process_output_block(stru
 				tty->column--;
 			break;
 		default:
-			if (O_OLCUC(tty))
-				goto break_out;
-			if (!iscntrl(*cp))
-				tty->column++;
+			if (!iscntrl(c)) {
+				if (O_OLCUC(tty))
+					goto break_out;
+				if (!is_continuation(c, tty))
+					tty->column++;
+			}
 			break;
 		}
 	}

--------------010107020604040508000308--
