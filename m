Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbXJ3NxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbXJ3NxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXJ3NxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:53:06 -0400
Received: from alnrmhc16.comcast.net ([206.18.177.56]:38024 "EHLO
	alnrmhc16.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbXJ3NxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:53:06 -0400
Date: Tue, 30 Oct 2007 06:53:04 -0700
From: "H.J. Lu" <hjl@lucon.org>
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: PATCH: PR Input Devives/2082: PS/2 mouse out of sync after
	switching with KVM switch
Message-ID: <20071030135304.GA24688@lucon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The bug report is at

http://bugzilla.kernel.org/show_bug.cgi?id=2082

Problem Description: When switching to another machine with a KVM
switch and back, the mouse is out of control, with X.Org.  To recover,
 I have to unplug the mouse cable and plug it back.

Steps to reproduce: Have a wheel mouse connected and X.Org.  Keyboard,
Mouse and Video are connected to a KVM switch. Switch to another
machine and back.  You have lost the usage of wheel on mouse.

This patch for 2.6.23 tries to reconnect the mouse after KVM switch.
It doesn't completely solve the problem. Mouse still got a few random
bytes after KVM switch. But it recovers with kernel message:

psmouse.c: Wheel Mouse at isa0060/serio1/input0 lost synchronization, issuing reconnect request.

instead of

psmouse.c: Wheel Mouse at isa0060/serio1/input0 lost synchronization, throwing 3 bytes away.

and never recovering from it.

BTW, please CC me when reply.  Thanks.


H.J.
----
--- linux-2.6.23.x86_64/drivers/input/mouse/psmouse-base.c.reset	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23.x86_64/drivers/input/mouse/psmouse-base.c	2007-10-26 23:27:55.000000000 -0700
@@ -302,11 +302,11 @@ static irqreturn_t psmouse_interrupt(str
 
 	if (psmouse->state == PSMOUSE_ACTIVATED &&
 	    psmouse->pktcnt && time_after(jiffies, psmouse->last + HZ/2)) {
-		printk(KERN_INFO "psmouse.c: %s at %s lost synchronization, throwing %d bytes away.\n",
-		       psmouse->name, psmouse->phys, psmouse->pktcnt);
+		printk(KERN_INFO "psmouse.c: %s at %s lost synchronization, issuing reconnect request.\n",
+		       psmouse->name, psmouse->phys);
 		psmouse->badbyte = psmouse->packet[0];
-		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
-		queue_work(kpsmoused_wq, &psmouse->resync_work);
+		__psmouse_set_state(psmouse, PSMOUSE_IGNORE);
+		serio_reconnect(psmouse->ps2dev.serio);
 		goto out;
 	}
 
