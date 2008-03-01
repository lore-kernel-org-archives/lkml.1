Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYCAVHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYCAVHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 16:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbYCAVHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 16:07:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbYCAVHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 16:07:42 -0500
X-Greylist: delayed 100749 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 16:07:42 EST
Date: Sat, 1 Mar 2008 16:07:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Roman Zippel <zippel@linux-m68k.org>, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
In-Reply-To: <20080301193903.GC15887@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0803011602300.30335@gandalf.stny.rr.com>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
 <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0802291330590.2723@scrub.home> <20080301193903.GC15887@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 1 Mar 2008, Paul E. McKenney wrote:
> Is this what you had in mind?  I don't have any way to test on a
> system not supporting CONFIG_PREEMPT, but seems to work on x86.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>
>  init/Kconfig           |   34 +++-------------------------------
>  kernel/Kconfig.preempt |   15 +++++++++++++++
>  2 files changed, 18 insertions(+), 31 deletions(-)
>
> diff -urpNa -X dontdiff linux-2.6.25-rc3/init/Kconfig linux-2.6.25-rc3-preempt_rcu/init/Kconfig
> --- linux-2.6.25-rc3/init/Kconfig	2008-02-26 16:58:42.000000000 -0800
> +++ linux-2.6.25-rc3-preempt_rcu/init/Kconfig	2008-03-01 11:30:59.000000000 -0800
> @@ -860,38 +860,10 @@ source "block/Kconfig"
>  config PREEMPT_NOTIFIERS
>  	bool
>
> -choice
> -	prompt "RCU implementation type:"
> -	default CLASSIC_RCU
> -	help
> -	  This allows you to choose either the classic RCU implementation
> -	  that is designed for best read-side performance on non-realtime
> -	  systems, or the preemptible RCU implementation for best latency
> -	  on realtime systems.  Note that some kernel preemption modes
> -	  will restrict your choice.
> -
> -	  Select the default if you are unsure.
> -
>  config CLASSIC_RCU
> -	bool "Classic RCU"
> +	def_bool !PREEMPT_RCU
>  	help
>  	  This option selects the classic RCU implementation that is
>  	  designed for best read-side performance on non-realtime
> -	  systems.

Actually Paul, you don't need to make this an "option". Simply the default
if PREEMPT_RCU is not selected. In otherwords, no prompt.

	config CLASSIC_RCU
	  bool
	  depends on !PREEMPT_RCU
	  default y

Then, have the PREEMPT_RCU defined down below (as you already did), and
have it be the only option. That is, you can have normal RCU or select
to have PREEMPT_RCU.

If the user selects PREEMPT_RCU, CLASSIC_RCU will be unselected.

-- Steve

> -
> -	  Say Y if you are unsure.
> -
> -config PREEMPT_RCU
> -	bool "Preemptible RCU"
> -	depends on PREEMPT
> -	help
> -	  This option reduces the latency of the kernel by making certain
> -	  RCU sections preemptible. Normally RCU code is non-preemptible, if
> -	  this option is selected then read-only RCU sections become
> -	  preemptible. This helps latency, but may expose bugs due to
> -	  now-naive assumptions about each RCU read-side critical section
> -	  remaining on a given CPU through its execution.
> -
> -	  Say N if you are unsure.
> -
> -endchoice
> +	  systems.  Classic RCU is the default.  Note that the
> +	  PREEMPT_RCU symbol is used to select/deselect this option.
> diff -urpNa -X dontdiff linux-2.6.25-rc3/kernel/Kconfig.preempt linux-2.6.25-rc3-preempt_rcu/kernel/Kconfig.preempt
> --- linux-2.6.25-rc3/kernel/Kconfig.preempt	2008-02-26 16:58:42.000000000 -0800
> +++ linux-2.6.25-rc3-preempt_rcu/kernel/Kconfig.preempt	2008-03-01 11:35:39.000000000 -0800
> @@ -52,8 +52,23 @@ config PREEMPT
>
>  endchoice
>
> +config PREEMPT_RCU
> +	bool "Preemptible RCU"
> +	depends on PREEMPT
> +	default n
> +	help
> +	  This option reduces the latency of the kernel by making certain
> +	  RCU sections preemptible. Normally RCU code is non-preemptible, if
> +	  this option is selected then read-only RCU sections become
> +	  preemptible. This helps latency, but may expose bugs due to
> +	  now-naive assumptions about each RCU read-side critical section
> +	  remaining on a given CPU through its execution.
> +
> +	  Say N if you are unsure.
> +
>  config RCU_TRACE
>  	bool "Enable tracing for RCU - currently stats in debugfs"
> +	depends on PREEMPT_RCU
>  	select DEBUG_FS
>  	default y
>  	help
>
