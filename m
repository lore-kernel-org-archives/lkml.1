Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZJLIVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZJLIVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZJLIVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:21:43 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:40220 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbZJLIVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:21:42 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: Regression?: keyboard state/LED inconsistency in 2.6.32-rc1/2,3,4
Date: Mon, 12 Oct 2009 11:18:28 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc4; KDE/4.2.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Vojtech Pavlik <vojtech@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910121118.29415.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm testing 2.6.32-rc1/2,3,4 and I'm using 2.6.31.3.
There is a difference in keyboard/LED behavior.
If in BIOS NumLock is set on, when the kernel starts
it puts NumLock off and the LED state is off in 2.6.31.3
(which is consistent), but in 2.6.32-rc1/2,3,4 the LED
stays on (and this is not consistent with keyboard's state).

Comparing drivers/input/keyboard/atkbd.c (I'm using it)
in 2.6.31.3 and 2.6.32-rc1/2,3,4 among others changes I
found the following lines (see the patch bellow) deleted,
so I propose either to add them again (this will restore 
keyboard/LED consistency) or revert the patch that has 
deleted them.

The better solution will be if the kernel preserves the state
of the keyboard as set by BIOS.

Best regards.

Marin Mitov

P.S. The lines in the patch concerning "repeat rate" are
not related with the "keyboard state/LED inconsistency",
but have been also deleted (by mistake/intentionally) too.
Could be dropped if necessary.

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

======================================================
--- a/drivers/input/keyboard/atkbd.c	2009-10-11 20:15:27.000000000 +0300
+++ b/drivers/input/keyboard/atkbd.c	2009-10-11 20:17:34.000000000 +0300
@@ -773,6 +773,23 @@
 static int atkbd_activate(struct atkbd *atkbd)
 {
 	struct ps2dev *ps2dev = &atkbd->ps2dev;
+	unsigned char param[1];
+
+/*
+ * Set the LEDs to a defined state.
+ */
+
+	param[0] = 0;
+	if (ps2_command(ps2dev, param, ATKBD_CMD_SETLEDS))
+		return -1;
+
+/*
+ * Set autorepeat to fastest possible.
+ */
+
+	param[0] = 0;
+	if (ps2_command(ps2dev, param, ATKBD_CMD_SETREP))
+		return -1;
 
 /*
  * Enable the keyboard to receive keystrokes.
@@ -1141,6 +1158,14 @@
 			return -1;
 
 		atkbd_activate(atkbd);
+
+/*
+ * Restore repeat rate and LEDs (that were reset by atkbd_activate)
+ * to pre-resume state
+ */
+		if (!atkbd->softrepeat)
+			atkbd_set_repeat_rate(atkbd);
+		atkbd_set_leds(atkbd);
 	}
 
 	atkbd_enable(atkbd);
