Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYCATjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYCATjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYCATjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:39:12 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:42053 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYCATjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:39:11 -0500
Date: Sat, 1 Mar 2008 11:39:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
Message-ID: <20080301193903.GC15887@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com> <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com> <Pine.LNX.4.64.0802291330590.2723@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802291330590.2723@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 01:38:15PM +0100, Roman Zippel wrote:
> Hi
> 
> On Thu, 28 Feb 2008, Paul E. McKenney wrote:
> 
> > > Why got this moved into init/Kconfig?
> > 
> > Because there are some arches that don't have kernel/Kconfig.preempt,
> > its earlier home.  Therefore, putting it into kernel/Kconfig.preempt
> > broke those arches' builds by supplying neither PREEMPT_RCU nor
> > CLASSIC_RCU.
> > 
> > > Now it's somewhere in the root menu, not really belonging to anything.
> > 
> > Do you have a suggested location?
> > 
> > > Also why is this a choice? Are more RCU types planned?
> > 
> > I don't expect additional drop-in replacements for RCU, though people
> > are certainly free to experiment if they wish.  It is a choice because
> > this gives people a very clear idea of the two options and because
> > it makes the implementation a bit cleaner.
> 
> I'd suggest to move PREEMPT_RCU back to Kconfig.preempt and if you really 
> need the second symbol leave this behind (maybe with a comment):
> 
> config CLASSIC_RCU
> 	def_bool !PREEMPT_RCU
> 
> Once there are more options, we can still look for a better place...
> 
> Also could you please add a proper dependency to RCU_TRACE on PREEMPT_RCU, 
> so that this condition isn't needed anymore:
> 
> ifeq ($(CONFIG_PREEMPT_RCU),y)
> obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
> endif

Is this what you had in mind?  I don't have any way to test on a
system not supporting CONFIG_PREEMPT, but seems to work on x86.

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
