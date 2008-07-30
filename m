Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYG3Boj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYG3Boj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYG3Bny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:43:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38284 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbYG3Bnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:43:52 -0400
Message-Id: <20080730014350.847388842@goodmis.org>
References: <20080730012939.885172468@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 21:29:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Corey Minyard <minyard@acm.org>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: [PATCH 2/5] ftrace: do not trace nmi callers in drivers
Content-Disposition: inline; filename=ftrace-notrace-nmi-drivers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic ftrace code performs run time modification of the code text
section. This is not safe to do unless all other CPUS are halted. Because
there is no good way to halt NMIs while doing the modification, we must
make sure that the NMIs will not execute code that will be modified.

This patch adds notrace annotation to functions called by NMIs in the
drivers section.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
CC: Corey Minyard <minyard@acm.org>
CC: Thomas Mingarelli <thomas.mingarelli@hp.com>
---
 drivers/char/ipmi/ipmi_watchdog.c |    2 +-
 drivers/misc/sgi-xp/xpc_main.c    |    4 ++--
 drivers/watchdog/hpwdt.c          |    5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-tip.git/drivers/char/ipmi/ipmi_watchdog.c
===================================================================
--- linux-tip.git.orig/drivers/char/ipmi/ipmi_watchdog.c	2008-07-29 20:03:09.000000000 -0400
+++ linux-tip.git/drivers/char/ipmi/ipmi_watchdog.c	2008-07-29 20:03:20.000000000 -0400
@@ -1051,7 +1051,7 @@ static void ipmi_unregister_watchdog(int
 }
 
 #ifdef HAVE_DIE_NMI
-static int
+static notrace int
 ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct die_args *args = data;
Index: linux-tip.git/drivers/misc/sgi-xp/xpc_main.c
===================================================================
--- linux-tip.git.orig/drivers/misc/sgi-xp/xpc_main.c	2008-07-29 20:03:09.000000000 -0400
+++ linux-tip.git/drivers/misc/sgi-xp/xpc_main.c	2008-07-29 20:03:20.000000000 -0400
@@ -1004,7 +1004,7 @@ xpc_system_reboot(struct notifier_block 
 /*
  * Notify other partitions to disengage from all references to our memory.
  */
-static void
+static notrace void
 xpc_die_disengage(void)
 {
 	struct xpc_partition *part;
@@ -1083,7 +1083,7 @@ xpc_die_disengage(void)
  * for a time. In this case we need to notify other partitions to not worry
  * about the lack of a heartbeat.
  */
-static int
+static notrace int
 xpc_system_die(struct notifier_block *nb, unsigned long event, void *unused)
 {
 	switch (event) {
Index: linux-tip.git/drivers/watchdog/hpwdt.c
===================================================================
--- linux-tip.git.orig/drivers/watchdog/hpwdt.c	2008-07-29 20:03:09.000000000 -0400
+++ linux-tip.git/drivers/watchdog/hpwdt.c	2008-07-29 20:03:20.000000000 -0400
@@ -417,8 +417,9 @@ static int __devinit detect_cru_service(
 /*
  *	NMI Handler
  */
-static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
-			    void *data)
+static notrace int
+hpwdt_pretimeout(struct notifier_block *nb,
+				unsigned long ulReason, void *data)
 {
 	static unsigned long rom_pl;
 	static int die_nmi_called;

-- 
