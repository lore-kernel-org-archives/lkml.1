Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbYAQXn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbYAQXn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYAQXnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:43:16 -0500
Received: from shadow.wildlava.net ([67.40.138.81]:53315 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbYAQXnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:43:15 -0500
Message-ID: <478FE861.4000705@skyrush.com>
Date: Thu, 17 Jan 2008 16:44:33 -0700
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
CC: alan@lxorguk.ukuu.org.uk
Subject: [PATCH] (*revised*) Fix IXANY and restart after signal (e.g. ctrl-C)
 in n_tty line discipline
References: <476D1D0E.6000302@skyrush.com>
In-Reply-To: <476D1D0E.6000302@skyrush.com>
Content-Type: multipart/mixed;
 boundary="------------050109000506050907000502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050109000506050907000502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here is a revised version of my patch, currently in the -mm kernel as
"fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline".
It fixes a couple of issues with ttys in the stopped state.  See patch
below for more details.

This patch should *replace* the old version of the patch.  It is
cleaner, and its behavior better matches that of other Unix platforms.
It also avoids needless/redundant calls to start_tty() when ctrl-S or
ctrl-Q are hit.

							-Joe

--------------050109000506050907000502
Content-Type: text/plain;
 name="fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-d";
 filename*1="iscipline.patch"

Fix two N_TTY line discipline issues related to resuming a stopped TTY
(typically done with ctrl-S):

1) Fix handling of character that resumes a stopped TTY (with IXANY)

With "stty ixany", the TTY line discipline would lose the first character
after the stop, so typing, for example, "hi^Sthere" resulted in "hihere"
(the 't' would cause the resume after ^S, but it would then be thrown away
rather than processed as an input character).  This was inconsistent with
the behavior of other Unix systems.

2) Fix interrupt signal (e.g. ctrl-C) behavior in stopped TTYs

With "stty -ixany" (often the default), interrupt signals were ignored
in a stopped TTY until the TTY was resumed with the start char (typically
ctrl-Q), which was inconsistent with the behavior of other Unix systems.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -puN drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline	2007-12-20 11:35:05.000000000 -0700
+++ a/drivers/char/n_tty.c	2007-12-20 11:35:36.000000000 -0700
@@ -695,17 +695,16 @@
 		return;
 	}
 	
-	if (tty->stopped && !tty->flow_stopped &&
-	    I_IXON(tty) && I_IXANY(tty)) {
-		start_tty(tty);
-		return;
-	}
-	
 	if (I_ISTRIP(tty))
 		c &= 0x7f;
 	if (I_IUCLC(tty) && L_IEXTEN(tty))
 		c=tolower(c);
 
+	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
+	    ((I_IXANY(tty) && c != START_CHAR(tty) && c != STOP_CHAR(tty)) ||
+	     c == INTR_CHAR(tty) || c == QUIT_CHAR(tty)))
+		start_tty(tty);
+
 	if (tty->closing) {
 		if (I_IXON(tty)) {
 			if (c == START_CHAR(tty))

--------------050109000506050907000502--
