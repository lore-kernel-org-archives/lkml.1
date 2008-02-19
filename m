Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYBSUx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYBSUx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYBSUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:53:18 -0500
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:57147
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbYBSUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:53:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=rITDv7nW5hcA:10 a=9W8mKqKTRDSH93Wn9bYA:9
 a=7huEvcTQxGBpNZZ0cE_VagngsNgA:4 a=gi0PWCVxevcA:10
To: linux-kernel@vger.kernel.org
CC: dmitry.torokhov@gmail.com
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
Subject: [PATCH] put ledstate in the keyboard notifier
Date: Tue, 19 Feb 2008 15:53:15 -0500
Message-ID: <20080119155315.eklhad@comcast.net>
Mime-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think there is general agreement, including myself,
that led state should be part of the key event, like shiftstate,
and not grabbed asynchronously after the fact.
So here is the patch that would do this.
I tested it with my keyboard modules and it works.
It only changes a couple lines of code, and will really help.
Thanks.

--- include/linux/keyboard.h	2008-02-19 14:56:02.000000000 -0500
+++ include/linux/keyboard.h.new	2008-02-19 14:55:50.000000000 -0500
@@ -33,6 +33,7 @@ struct keyboard_notifier_param {
 	struct vc_data *vc;	/* VC on which the keyboard press was done */
 	int down;		/* Pressure of the key? */
 	int shift;		/* Current shift mask */
+	int ledstate;		/* Current led state */
 	unsigned int value;	/* keycode, unicode value or keysym */
 };
 
--- drivers/char/keyboard.c	2008-02-18 21:05:23.000000000 -0500
+++ drivers/char/keyboard.c.new	2008-02-19 15:00:58.000000000 -0500
@@ -1238,6 +1238,7 @@ static void kbd_keycode(unsigned int key
 	}
 
 	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
+	param.ledstate = getledstate();
 	key_map = key_maps[shift_final];
 
 	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYCODE, &param) == NOTIFY_STOP || !key_map) {
