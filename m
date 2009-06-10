Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZFJDmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZFJDmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbZFJDfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:35:36 -0400
Received: from kroah.org ([198.145.64.141]:57120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306AbZFJDfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:34 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:47 2009
Message-Id: <20090610002347.533470858@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:14:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 34/60] V4L/DVB (10943): cx88: Prevent general protection fault on rmmod
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-cx88-prevent-general-protection-fault-on-rmmod.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 569b7ec73abf576f9a9e4070d213aadf2cce73cb upstream.

V4L/DVB (10943): cx88: Prevent general protection fault on rmmod

When unloading the cx8800 driver I sometimes get a general protection
fault. Analysis revealed a race in cx88_ir_stop(). It can be solved by
using a delayed work instead of a timer for infrared input polling.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-input.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -48,8 +48,7 @@ struct cx88_IR {
 
 	/* poll external decoder */
 	int polling;
-	struct work_struct work;
-	struct timer_list timer;
+	struct delayed_work work;
 	u32 gpio_addr;
 	u32 last_gpio;
 	u32 mask_keycode;
@@ -143,27 +142,19 @@ static void cx88_ir_handle_key(struct cx
 	}
 }
 
-static void ir_timer(unsigned long data)
-{
-	struct cx88_IR *ir = (struct cx88_IR *)data;
-
-	schedule_work(&ir->work);
-}
-
 static void cx88_ir_work(struct work_struct *work)
 {
-	struct cx88_IR *ir = container_of(work, struct cx88_IR, work);
+	struct cx88_IR *ir = container_of(work, struct cx88_IR, work.work);
 
 	cx88_ir_handle_key(ir);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
 void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
 {
 	if (ir->polling) {
-		setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
-		INIT_WORK(&ir->work, cx88_ir_work);
-		schedule_work(&ir->work);
+		INIT_DELAYED_WORK(&ir->work, cx88_ir_work);
+		schedule_delayed_work(&ir->work, 0);
 	}
 	if (ir->sampling) {
 		core->pci_irqmask |= PCI_INT_IR_SMPINT;
@@ -179,10 +170,8 @@ void cx88_ir_stop(struct cx88_core *core
 		core->pci_irqmask &= ~PCI_INT_IR_SMPINT;
 	}
 
-	if (ir->polling) {
-		del_timer_sync(&ir->timer);
-		flush_scheduled_work();
-	}
+	if (ir->polling)
+		cancel_delayed_work_sync(&ir->work);
 }
 
 /* ---------------------------------------------------------------------- */


