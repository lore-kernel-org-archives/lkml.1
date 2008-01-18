Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbYARAMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbYARAMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYARAMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:12:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577AbYARAMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:12:07 -0500
Date: Thu, 17 Jan 2008 16:11:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Peterson <joe@skyrush.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] (*revised*) Fix IXANY and restart after signal (e.g.
 ctrl-C) in n_tty line discipline
Message-Id: <20080117161156.92737c80.akpm@linux-foundation.org>
In-Reply-To: <478FE861.4000705@skyrush.com>
References: <476D1D0E.6000302@skyrush.com>
	<478FE861.4000705@skyrush.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 16:44:33 -0700
Joe Peterson <joe@skyrush.com> wrote:

> Here is a revised version of my patch, currently in the -mm kernel as
> "fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline".
> It fixes a couple of issues with ttys in the stopped state.  See patch
> below for more details.

What were the "couple of issues"?

> This patch should *replace* the old version of the patch.

I don't like replacements a lot.  It forces one to re-review the whole
thing from scratch.  Which is why I almost always turn the replacement
into an incremental patch, as below.

>  It is
> cleaner, and its behavior better matches that of other Unix platforms.
> It also avoids needless/redundant calls to start_tty() when ctrl-S or
> ctrl-Q are hit.
> 

--- a/drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update
+++ a/drivers/char/n_tty.c
@@ -695,14 +695,16 @@ static inline void n_tty_receive_char(st
 		return;
 	}
 	
-	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) && I_IXANY(tty))
-		start_tty(tty);
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
@@ -766,8 +768,6 @@ static inline void n_tty_receive_char(st
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
-			if (tty->stopped && !tty->flow_stopped && I_IXON(tty))
-				start_tty(tty);
 			/*
 			 * Echo character, and then send the signal.
 			 * Note that we do not use isig() here because we want
_

