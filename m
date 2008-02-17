Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYBQV5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYBQV5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYBQV4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:56:50 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:11294 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbYBQV4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:56:43 -0500
Date: Sun, 17 Feb 2008 16:56:42 -0500 (EST)
Message-Id: <6gr00g$g7cmat@smtp01.lnh.mail.rcn.net>
From: "David P. Reed" <dpreed@reed.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "David P. Reed" <dpreed@reed.com>
Subject: [PATCH 3/3] x86: fix pcspkr to not use inb_p/outb_p calls.
Content-Disposition: inline; filename=fix-pcspkr-iodelay.patch
X-Junkmail-Status: score=10/50, host=mr02.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010207.47B8AD9A.0089,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2007-11-16
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix pcspkr driver to use explicit timing delay for access to PIT,
rather than inb_p/outb_p calls, which use insufficiently explicit
delays (defaulting to port 80 writes) that can cause freeze problems
on some machines, such as Quanta moterboard  machines using ENE EC's.
The explicit timing delay is only needed for accesses to the 8253 PIT.
The standard requirement for the 8253 to respond to successive writes
is 1 microsecond.  The 8253 has never been on the expansion bus, so 
a proper delay has nothing to do with expansion bus timing, but instead
its internal logic's capability to react to input.  Since udelay is correctly
calibrated by the time the pcspkr driver is initialized, we use 1 microsecond
as the timing.

Also shorten lines to less than 80 characters.

Signed-off-by: David P. Reed <dpreed@reed.com>

Index: linux-2.6/drivers/input/misc/pcspkr.c
===================================================================
--- linux-2.6.orig/drivers/input/misc/pcspkr.c
+++ linux-2.6/drivers/input/misc/pcspkr.c
@@ -32,9 +32,11 @@ MODULE_ALIAS("platform:pcspkr");
 static DEFINE_SPINLOCK(i8253_lock);
 #endif
 
-static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
+static int pcspkr_event(struct input_dev *dev, unsigned int type,
+			unsigned int code, int value)
 {
 	unsigned int count = 0;
+	unsigned char mask;
 	unsigned long flags;
 
 	if (type != EV_SND)
@@ -51,17 +53,21 @@ static int pcspkr_event(struct input_dev
 
 	spin_lock_irqsave(&i8253_lock, flags);
 
+	mask = inb(0x61);
 	if (count) {
 		/* enable counter 2 */
-		outb_p(inb_p(0x61) | 3, 0x61);
+		outb(mask | 3, 0x61);
+		/* some 8253's may require 1 usec. between accesses */
 		/* set command for counter 2, 2 byte write */
-		outb_p(0xB6, 0x43);
+		outb(0xB6, 0x43);
+		udelay(1);
 		/* select desired HZ */
-		outb_p(count & 0xff, 0x42);
+		outb(count & 0xff, 0x42);
+		udelay(1);
 		outb((count >> 8) & 0xff, 0x42);
 	} else {
 		/* disable counter 2 */
-		outb(inb_p(0x61) & 0xFC, 0x61);
+		outb(mask & 0xFC, 0x61);
 	}
 
 	spin_unlock_irqrestore(&i8253_lock, flags);

-- 
