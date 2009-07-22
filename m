Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZGVKyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZGVKyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZGVKyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:54:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52105 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZGVKyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:54:03 -0400
Subject: GFS2: Add LED support to GFS2
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 22 Jul 2009 11:56:38 +0100
Message-Id: <1248260198.3456.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e1fac35b9c2af276473db50fae581ef56626240c Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 22 Jul 2009 11:40:16 +0100
Subject: [PATCH] GFS2: Add LED support to GFS2

This adds a standalone module which uses the GFS2 tracepoints
as a hook to provide LED trigger events. Events can be sent
when glocks change state, when glock demote requests are
received (both local and remote events are included) and also
when the log is flushed.

The log flush event lights the LED during the duration of the
log flush event. The other two triggers light the LED for 1/10th
second after the event has occurred.

I've tested this by using GFS2 in "nolock" mode on my laptop
by getting it to flash the thinkpad battery LED on the various
events and verified that it occurs when expected.

One possible future development is to introduce an event for
filesystem errors, but that is not included in the current
patch.

There is currently no way to filter events per-filesystem so
events will be reported for all GFS2 filesystems which are
mounted.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 7c8e712..5dc598e 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -297,4 +297,7 @@ config LEDS_TRIGGER_DEFAULT_ON
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
+comment "The gfs2 events trigger is under the File systems config"
+	depends on LEDS_TRIGGERS
+
 endif # NEW_LEDS
diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 5971359..d6ad86f 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -36,3 +36,14 @@ config GFS2_FS_LOCKING_DLM
 	  Most users of GFS2 will require this. It provides the locking
 	  interface between GFS2 and the DLM, which is required to use GFS2
 	  in a cluster environment.
+
+config GFS2_FS_LEDS
+	tristate "GFS2 Event LED Driver"
+	depends on GFS2_FS && LEDS_TRIGGERS
+	help
+	 A driver which allows various interesting GFS2 filesystem events
+	 to trigger LEDs via the LED subsystem. Currently available events
+	 are glock activity, glock demote requests and log flushing. The
+	 LEDs are configured the /sys/class/leds/*/trigger files.
+
+
diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index 3da2f1f..b3f1117 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -7,4 +7,4 @@ gfs2-y := acl.o bmap.o dir.o eaops.o eattr.o glock.o \
 	recovery.o rgrp.o super.o sys.o trans.o util.o
 
 gfs2-$(CONFIG_GFS2_FS_LOCKING_DLM) += lock_dlm.o
-
+obj-$(CONFIG_GFS2_FS_LEDS) += ledtrig-gfs2.o
diff --git a/fs/gfs2/ledtrig-gfs2.c b/fs/gfs2/ledtrig-gfs2.c
new file mode 100644
index 0000000..e18aa89
--- /dev/null
+++ b/fs/gfs2/ledtrig-gfs2.c
@@ -0,0 +1,124 @@
+/*
+ * GFS2 Event LED driver
+ *
+ * Copyright (C) 2009 Red Hat Inc.
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License version 2.
+ *
+ * Author: Steven Whitehouse <swhiteho@redhat.com>
+ *
+ * Allows triggering of LEDs by various interesting GFS2 filesystem
+ * events. Currently supported events are:
+ *  1) Glock state changes
+ *  2) Demote requests (local & remote)
+ *  3) Log flushing
+ *
+ * References:
+ * ledtrig-ide-disk.c by Richard Purdie <rpurdie@openedhand.com>
+ * blktrace.c (as an example of registering/using tracepoints)
+ */
+
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/leds.h>
+#include <linux/gfs2_ondisk.h>
+#include "incore.h"
+#include "glock.h"
+#include "trace_gfs2.h"
+
+struct gfs2_led_timer {
+	struct led_trigger *trigger;
+	struct timer_list timer;
+	int events;
+};
+
+DEFINE_LED_TRIGGER(led_log_flush);
+
+static struct gfs2_led_timer gfs2_led_state_change;
+static struct gfs2_led_timer gfs2_led_demote_rq;
+
+static void ledtrig_mod_timer(struct gfs2_led_timer *t)
+{
+	t->events++;
+	if (!timer_pending(&t->timer))
+		mod_timer(&t->timer, jiffies + msecs_to_jiffies(10));
+}
+
+static void ledtrig_state_change(const struct gfs2_glock *gl,
+				 unsigned int new_state)
+{
+	ledtrig_mod_timer(&gfs2_led_state_change);
+}
+
+static void ledtrig_demote_rq(const struct gfs2_glock *gl)
+{
+	ledtrig_mod_timer(&gfs2_led_demote_rq);
+}
+
+static void ledtrig_log_flush(const struct gfs2_sbd *sdp, int start)
+{
+	if (start)
+		led_trigger_event(led_log_flush, LED_FULL);
+	else
+		led_trigger_event(led_log_flush, LED_OFF);
+}
+
+static void ledtrig_timerfunc(unsigned long data)
+{
+	struct gfs2_led_timer *t = (struct gfs2_led_timer *)data;
+	if (t->events) {
+		t->events = 0;
+		led_trigger_event(t->trigger, LED_FULL);
+		mod_timer(&t->timer, jiffies + msecs_to_jiffies(10));
+		return;
+	}
+	led_trigger_event(t->trigger, LED_OFF);
+}
+
+static int __init ledtrig_gfs2_init(void)
+{
+	int ret;
+
+	init_timer(&gfs2_led_state_change.timer);
+	init_timer(&gfs2_led_demote_rq.timer);
+	setup_timer(&gfs2_led_state_change.timer, ledtrig_timerfunc,
+		    (unsigned long)&gfs2_led_state_change);
+	setup_timer(&gfs2_led_demote_rq.timer, ledtrig_timerfunc,
+		    (unsigned long)&gfs2_led_demote_rq);
+
+	ret = register_trace_gfs2_glock_state_change(ledtrig_state_change);
+	WARN_ON(ret);
+	ret = register_trace_gfs2_demote_rq(ledtrig_demote_rq);
+	WARN_ON(ret);
+	ret = register_trace_gfs2_log_flush(ledtrig_log_flush);
+	WARN_ON(ret);
+
+	led_trigger_register_simple("gfs2-glock-state", &gfs2_led_state_change.trigger);
+	led_trigger_register_simple("gfs2-glock-demote", &gfs2_led_demote_rq.trigger);
+	led_trigger_register_simple("gfs2-log-flush", &led_log_flush);
+	return 0;
+}
+
+static void __exit ledtrig_gfs2_exit(void)
+{
+	del_timer_sync(&gfs2_led_state_change.timer);
+	del_timer_sync(&gfs2_led_demote_rq.timer);
+
+	unregister_trace_gfs2_glock_state_change(ledtrig_state_change);
+	unregister_trace_gfs2_demote_rq(ledtrig_demote_rq);
+	led_trigger_unregister_simple(gfs2_led_state_change.trigger);
+	led_trigger_unregister_simple(gfs2_led_demote_rq.trigger);
+	led_trigger_unregister_simple(led_log_flush);
+}
+
+module_init(ledtrig_gfs2_init);
+module_exit(ledtrig_gfs2_exit);
+
+MODULE_AUTHOR("Steven Whitehouse <swhiteho@redhat.com>");
+MODULE_DESCRIPTION("GFS2 Event LED Driver");
+MODULE_LICENSE("GPL");
+
-- 
1.6.0.6



