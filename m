Return-Path: <linux-kernel-owner+w=401wt.eu-S1764209AbYCDUc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764209AbYCDUc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762804AbYCDUb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:31:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34070 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbYCDUb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:31:56 -0500
Date: Tue, 4 Mar 2008 12:22:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: ego@in.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, zippel@linux-m68k.org
Subject: [PATCH] move PREEMPT_RCU config option back under PREEMPT
Message-ID: <20080304202207.GA10926@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com> <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com> <Pine.LNX.4.64.0802291330590.2723@scrub.home> <20080301193903.GC15887@linux.vnet.ibm.com> <Pine.LNX.4.64.0803020404040.2723@scrub.home> <20080303185511.GE12453@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303185511.GE12453@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The original preemptible-RCU patch put the choice between classic and
preemptible RCU into kernel/Kconfig.preempt, which resulted in build
failures on machines not supporting CONFIG_PREEMPT.  This choice was
therefore moved to init/Kconfig, which worked, but placed the choice
between classic and preemptible RCU at the top level, a very obtuse choice
indeed.  This patch changes from the Kconfig "choice" mechanism to a pair
of booleans, only one of which (CONFIG_PREEMPT_RCU) is user-visible,
and is located in kernel/Kconfig.preempt, where one would expect it
to be.  The other (CONFIG_CLASSIC_RCU) is in init/Kconfig so that it
is available to all architectures, hopefully avoiding build breakage.
Thanks to Roman Zippel for suggesting this approach.

I have tested this, but sadly do not have access to a machine that does
not support CONFIG_PREEMPT.  However, I did edit my config in an attempt
to simulate this situation.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 init/Kconfig           |   34 +++-------------------------------
 kernel/Kconfig.preempt |   15 +++++++++++++++
 2 files changed, 18 insertions(+), 31 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25-rc3/init/Kconfig linux-2.6.25-rc3-preempt_rcu/init/Kconfig
--- linux-2.6.25-rc3/init/Kconfig	2008-02-26 16:58:42.000000000 -0800
+++ linux-2.6.25-rc3-preempt_rcu/init/Kconfig	2008-03-01 11:30:59.000000000 -0800
@@ -860,38 +860,10 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
-choice
-	prompt "RCU implementation type:"
-	default CLASSIC_RCU
-	help
-	  This allows you to choose either the classic RCU implementation
-	  that is designed for best read-side performance on non-realtime
-	  systems, or the preemptible RCU implementation for best latency
-	  on realtime systems.  Note that some kernel preemption modes
-	  will restrict your choice.
-
-	  Select the default if you are unsure.
-
 config CLASSIC_RCU
-	bool "Classic RCU"
+	def_bool !PREEMPT_RCU
 	help
 	  This option selects the classic RCU implementation that is
 	  designed for best read-side performance on non-realtime
-	  systems.
-
-	  Say Y if you are unsure.
-
-config PREEMPT_RCU
-	bool "Preemptible RCU"
-	depends on PREEMPT
-	help
-	  This option reduces the latency of the kernel by making certain
-	  RCU sections preemptible. Normally RCU code is non-preemptible, if
-	  this option is selected then read-only RCU sections become
-	  preemptible. This helps latency, but may expose bugs due to
-	  now-naive assumptions about each RCU read-side critical section
-	  remaining on a given CPU through its execution.
-
-	  Say N if you are unsure.
-
-endchoice
+	  systems.  Classic RCU is the default.  Note that the
+	  PREEMPT_RCU symbol is used to select/deselect this option.
diff -urpNa -X dontdiff linux-2.6.25-rc3/kernel/Kconfig.preempt linux-2.6.25-rc3-preempt_rcu/kernel/Kconfig.preempt
--- linux-2.6.25-rc3/kernel/Kconfig.preempt	2008-02-26 16:58:42.000000000 -0800
+++ linux-2.6.25-rc3-preempt_rcu/kernel/Kconfig.preempt	2008-03-01 11:35:39.000000000 -0800
@@ -52,8 +52,23 @@ config PREEMPT
 
 endchoice
 
+config PREEMPT_RCU
+	bool "Preemptible RCU"
+	depends on PREEMPT
+	default n
+	help
+	  This option reduces the latency of the kernel by making certain
+	  RCU sections preemptible. Normally RCU code is non-preemptible, if
+	  this option is selected then read-only RCU sections become
+	  preemptible. This helps latency, but may expose bugs due to
+	  now-naive assumptions about each RCU read-side critical section
+	  remaining on a given CPU through its execution.
+
+	  Say N if you are unsure.
+
 config RCU_TRACE
 	bool "Enable tracing for RCU - currently stats in debugfs"
+	depends on PREEMPT_RCU
 	select DEBUG_FS
 	default y
 	help
