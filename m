Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab0BDR1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:27:11 -0500
Received: from kroah.org ([198.145.64.141]:34911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933349Ab0BDRWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:22 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:22 2010
Message-Id: <20100204171522.037712370@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Magnus Damm <damm@opensource.se>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
       Paul Mundt <lethal@linux-sh.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [60/74] usb: r8a66597-hdc disable interrupts fix
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Magnus Damm <damm@opensource.se>

commit e5ff15bec96ba18698dae5de0bbf7e6a0653ca65 upstream.

This patch improves disable_controller() in the r8a66597-hdc
driver to disable all interrupts and clear status flags. It
also makes sure that disable_controller() is called during
probe(). This fixes the relatively rare case of unexpected
pending interrupts after kexec reboot.

Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/r8a66597-hcd.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -216,8 +216,17 @@ static void disable_controller(struct r8
 {
 	int port;
 
+	/* disable interrupts */
 	r8a66597_write(r8a66597, 0, INTENB0);
-	r8a66597_write(r8a66597, 0, INTSTS0);
+	r8a66597_write(r8a66597, 0, INTENB1);
+	r8a66597_write(r8a66597, 0, BRDYENB);
+	r8a66597_write(r8a66597, 0, BEMPENB);
+	r8a66597_write(r8a66597, 0, NRDYENB);
+
+	/* clear status */
+	r8a66597_write(r8a66597, 0, BRDYSTS);
+	r8a66597_write(r8a66597, 0, NRDYSTS);
+	r8a66597_write(r8a66597, 0, BEMPSTS);
 
 	for (port = 0; port < r8a66597->max_root_hub; port++)
 		r8a66597_disable_port(r8a66597, port);
@@ -2470,6 +2479,12 @@ static int __devinit r8a66597_probe(stru
 	r8a66597->rh_timer.data = (unsigned long)r8a66597;
 	r8a66597->reg = (unsigned long)reg;
 
+	/* make sure no interrupts are pending */
+	ret = r8a66597_clock_enable(r8a66597);
+	if (ret < 0)
+		goto clean_up3;
+	disable_controller(r8a66597);
+
 	for (i = 0; i < R8A66597_MAX_NUM_PIPE; i++) {
 		INIT_LIST_HEAD(&r8a66597->pipe_queue[i]);
 		init_timer(&r8a66597->td_timer[i]);


