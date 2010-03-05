Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0CEJtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:49:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0CEJtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:49:35 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] tty: use min_t to calculate room to request
Date: Fri,  5 Mar 2010 10:49:30 +0100
Message-Id: <1267782570-30649-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on ARM TTY_BUFFER_PAGE has the (implicit) type unsigned long
while size - copied is unsigned int resulting in

	drivers/char/tty_buffer.c:251: warning: comparison of distinct pointer types lacks a cast
	drivers/char/tty_buffer.c:288: warning: comparison of distinct pointer types lacks a cast

So explictily convert to unsigned long.

This is a follow-up to

	d9661ad (tty: Keep the default buffering to sub-page units)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_buffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index af8d977..159f238 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -248,7 +248,7 @@ int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
 {
 	int copied = 0;
 	do {
-		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int goal = min_t(unsigned long, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
@@ -285,7 +285,7 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
 {
 	int copied = 0;
 	do {
-		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int goal = min_t(unsigned long, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
-- 
1.7.0

