Return-Path: <linux-kernel-owner+w=401wt.eu-S935749AbXGMNu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749AbXGMNu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935338AbXGMNui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:50:38 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:37991 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935319AbXGMNuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:50:37 -0400
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@mail.ru>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] input: Fix interrupt enable in i8042_ctr when enabling interrupt fails
From: Markus Armbruster <armbru@pond.sub.org>
Date: Fri, 13 Jul 2007 15:50:34 +0200
Message-ID: <87fy3sxvit.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling interrupts fails, the interrupt enable bit remains set
in i8042_ctr.  Later writes of i8042_ctr to the hardware could
accidentally retry enabling interrupts.  Clear the bit on failure.

Signed-off-by: Markus Armbruster <armbru@redhat.com>

---

Some time ago Steven Rostedt and I went over this changeset:

    commit de9ce703c6b807b1dfef5942df4f2fadd0fdb67a
    Author: Dmitry Torokhov <dtor@insightbb.com>
    Date:   Sun Sep 10 21:57:21 2006 -0400

        Input: i8042 - get rid of polling timer

        Remove polling timer that was used to detect keybord/mice hotplug and
        register both IRQs right away instead of waiting for a driver to
        attach to a port.

        Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Steven pointed out to me that it changes behavior when enabling IRQ
fails.

The old code enabled IRQs this way:

	i8042_ctr |= port->irqen;

	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
		i8042_ctr &= ~port->irqen;
		return -1;
	}

i8042_ctr shadows the 8042's CTR.  So, when enabling fails, the bit is
cleared in the shadow.

The new code does not clear the bit on the error path:

static int i8042_enable_kbd_port(void)
{
	i8042_ctr &= ~I8042_CTR_KBDDIS;
	i8042_ctr |= I8042_CTR_KBDINT;

	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
		printk(KERN_ERR "i8042.c: Failed to enable KBD port.\n");
		return -EIO;
	}

	return 0;
}

Same for i8042_enable_aux_port().

This leads to the question whether there are later writes of i8042_ctr
(possibly with other bits altered) to the hardware, which could
accidentally retry enabling interrupts.

I believe this possible, but unlikely.  Scenarios involve enable
succeeding the first time, failing the second time, and succeeding the
third time.  I can provide details, but the point I'd like to make is
not that this is broken (although it is, strictly speaking), but that
it is not obviously correct where it easily could be: just clear the
interrupt enable bits when writing them to the hardware failed, like
the old code did.

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index db9cca3..71a7e39 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -385,6 +385,7 @@ static int i8042_enable_kbd_port(void)
 	i8042_ctr |= I8042_CTR_KBDINT;
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
+		i8042_ctr &= ~I8042_CTR_KBDINT;
 		printk(KERN_ERR "i8042.c: Failed to enable KBD port.\n");
 		return -EIO;
 	}
@@ -402,6 +403,7 @@ static int i8042_enable_aux_port(void)
 	i8042_ctr |= I8042_CTR_AUXINT;
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
+		i8042_ctr &= ~I8042_CTR_AUXINT;
 		printk(KERN_ERR "i8042.c: Failed to enable AUX port.\n");
 		return -EIO;
 	}
