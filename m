Return-Path: <linux-kernel-owner+w=401wt.eu-S1767814AbXCJEcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767814AbXCJEcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767815AbXCJEcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:32:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33126 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767814AbXCJEcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:32:14 -0500
Subject: [RFC PATCH 3/3] Update dvb use of symbol_(get|put)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: rusty@rustcorp.com.au
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 02:32:08 -0200
Message-Id: <1173501128.26213.407.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trent Piepho <xyzzy@speakeasy.org>

Make the dvb sub-system use the ability of symbol_(put|get) to keep track
of what module did the putting or getting.  In the dvb sub-system,
symbol_put is called through the macro dvb_attach().  A driver for a
bridge or card will attach frontends, tuners, or other helper drivers,
and this card driver will be listed as the user of the helper drivers.

When the card driver unloads, a single function in dvb-core,
dvb_frontend_detach(), will release all the helper drivers.  Since the
get() happened in the card driver, but the put() is happening in
dvb-core, it is necessary to use __symbol_put_addr() so that a user other
than THIS_MODULE (which would be dvb-core, while we want the card driver)
can be specified.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -1718,12 +1718,9 @@ static void dst_release(struct dvb_front
 	if (state->dst_ca) {
 		dvb_unregister_device(state->dst_ca);
 #ifdef CONFIG_DVB_CORE_ATTACH
-		symbol_put(dst_ca_attach);
+		symbol_put_user(dst_ca_attach, fe->dvb->module);
 #endif
 	}
-#ifdef CONFIG_DVB_CORE_ATTACH
-	symbol_put(dst_attach);
-#endif
 	kfree(state);
 }
 
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1127,19 +1127,20 @@ void dvb_frontend_detach(struct dvb_fron
 void dvb_frontend_detach(struct dvb_frontend* fe)
 {
 	void *ptr;
+	struct module *mod = fe->dvb->module;
 
 	if (fe->ops.release_sec) {
 		fe->ops.release_sec(fe);
-		symbol_put_addr(fe->ops.release_sec);
+		__symbol_put_addr(fe->ops.release_sec, mod);
 	}
 	if (fe->ops.tuner_ops.release) {
 		fe->ops.tuner_ops.release(fe);
-		symbol_put_addr(fe->ops.tuner_ops.release);
+		__symbol_put_addr(fe->ops.tuner_ops.release, mod);
 	}
 	ptr = (void*)fe->ops.release;
 	if (ptr) {
-		fe->ops.release(fe);
-		symbol_put_addr(ptr);
+		fe->ops.release(fe); /* This call will de-allocate fe! */
+		__symbol_put_addr(ptr, mod);
 	}
 }
 #else



