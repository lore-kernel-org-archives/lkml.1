Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYAHGbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYAHGbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYAHGbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:31:16 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:42690 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYAHGbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:31:15 -0500
Date: Tue, 8 Jan 2008 01:31:13 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH] call sysrq_timer_list_show from a workqueue
Message-ID: <20080108063113.GA21287@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_sysrq can be called from interrupt context. sysrq_timer_list_show
eventually starts poking at module symbols which take the module mutex.

so instead, let's just kick off a workqueue.

[ doesn't happen on my laptop with the keyboard, but does when
  triggered from /proc/sysrq-trigger ]

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index de60e1e..09bb030 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -159,10 +159,16 @@ static struct sysrq_key_op sysrq_sync_op = {
 	.enable_mask	= SYSRQ_ENABLE_SYNC,
 };
 
-static void sysrq_handle_show_timers(int key, struct tty_struct *tty)
+static void sysrq_show_timers_callback(struct work_struct *whocares)
 {
 	sysrq_timer_list_show();
 }
+static DECLARE_WORK(show_timers_work, sysrq_show_timers_callback);
+
+static void sysrq_handle_show_timers(int key, struct tty_struct *tty)
+{
+	schedule_work(&show_timers_work);
+}
 
 static struct sysrq_key_op sysrq_show_timers_op = {
 	.handler	= sysrq_handle_show_timers,
