Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbXF0Tpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbXF0Tpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762164AbXF0Tnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:43:43 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45112 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758925AbXF0Tni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:43:38 -0400
Message-Id: <20070627194328.067493728@goodmis.org>
References: <20070627193633.025544061@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jun 2007 15:36:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH 6/8] Remove DECLARE_TASKLET_DISABLE API
Content-Disposition: inline; filename=remove-declare-tasklet-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's three uses of DECLARE_TASKLET_DISABLE and this patch
removes those uses.  Objective is to remove the declaration completely.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-2.6-test/drivers/input/serio/hil_mlc.c
===================================================================
--- linux-2.6-test.orig/drivers/input/serio/hil_mlc.c
+++ linux-2.6-test/drivers/input/serio/hil_mlc.c
@@ -76,7 +76,7 @@ static struct timer_list	hil_mlcs_kicker
 static int			hil_mlcs_probe;
 
 static void hil_mlcs_process(unsigned long unused);
-DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);
+struct tasklet_struct hil_mlcs_tasklet;
 
 
 /* #define HIL_MLC_DEBUG */
@@ -933,12 +933,13 @@ int hil_mlc_unregister(hil_mlc *mlc) {
 
 static int __init hil_mlc_init(void)
 {
+	tasklet_init(&hil_mlcs_tasklet, hil_mlcs_process, 0);
+
 	init_timer(&hil_mlcs_kicker);
 	hil_mlcs_kicker.expires = jiffies + HZ;
 	hil_mlcs_kicker.function = &hil_mlcs_timer;
 	add_timer(&hil_mlcs_kicker);
 
-	tasklet_enable(&hil_mlcs_tasklet);
 
 	return 0;
 }
Index: linux-2.6-test/drivers/char/keyboard.c
===================================================================
--- linux-2.6-test.orig/drivers/char/keyboard.c
+++ linux-2.6-test/drivers/char/keyboard.c
@@ -1011,7 +1011,7 @@ static void kbd_bh(unsigned long dummy)
 	ledstate = leds;
 }
 
-DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
+struct tasklet_struct keyboard_tasklet;
 
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) ||\
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) ||\
@@ -1376,11 +1376,12 @@ int __init kbd_init(void)
 		kbd_table[i].kbdmode = VC_XLATE;
 	}
 
+	tasklet_init(&keyboard_tasklet, kbd_bh, 0);
+
 	error = input_register_handler(&kbd_handler);
 	if (error)
 		return error;
 
-	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 
 	return 0;
Index: linux-2.6-test/net/tipc/handler.c
===================================================================
--- linux-2.6-test.orig/net/tipc/handler.c
+++ linux-2.6-test/net/tipc/handler.c
@@ -49,7 +49,7 @@ static int handler_enabled = 0;
 
 static void process_signal_queue(unsigned long dummy);
 
-static DECLARE_TASKLET_DISABLED(tipc_tasklet, process_signal_queue, 0);
+static struct tasklet_struct tipc_tasklet;
 
 
 unsigned int tipc_k_signal(Handler routine, unsigned long argument)
@@ -102,7 +102,7 @@ int tipc_handler_start(void)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&signal_queue_head);
-	tasklet_enable(&tipc_tasklet);
+	tasklet_init(&tipc_tasklet, process_signal_queue, 0);
 	handler_enabled = 1;
 	return 0;
 }
Index: linux-2.6-test/include/linux/tasklet.h
===================================================================
--- linux-2.6-test.orig/include/linux/tasklet.h
+++ linux-2.6-test/include/linux/tasklet.h
@@ -33,9 +33,6 @@ struct tasklet_struct
 #define DECLARE_TASKLET(name, func, data) \
 struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
 
-#define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
-
 
 enum
 {

-- 
