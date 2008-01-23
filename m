Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYAWVbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYAWVbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYAWVbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:31:42 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:46109 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbYAWVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:31:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAB5Bl0dMQWYq/2dsb2JhbACBV6xi
Date: Wed, 23 Jan 2008 16:31:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 06/20 -v5] add notrace annotations for NMI routines
Message-ID: <20080123213139.GB2282@Krystal>
References: <20080123160236.969334052@goodmis.org> <20080123160442.063076557@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080123160442.063076557@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:31:21 up 81 days,  2:36,  5 users,  load average: 0.57, 0.40,
	0.20
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> This annotates NMI functions with notrace. Some tracers may be able
> to live with this, but some cannot. So we turn off NMI tracing.
> 
> One solution might be to make a notrace_nmi which would only turn
> off NMI tracing if a trace utility needed it off.
> 
Is this still needed with the atomic clocksource read ?

> Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> ---
>  arch/x86/kernel/nmi_32.c   |    2 +-
>  arch/x86/kernel/nmi_64.c   |    2 +-
>  arch/x86/kernel/traps_32.c |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-mcount.git/arch/x86/kernel/nmi_32.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/nmi_32.c	2008-01-23 10:26:11.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/nmi_32.c	2008-01-23 10:26:53.000000000 -0500
> @@ -323,7 +323,7 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
>  
>  extern void die_nmi(struct pt_regs *, const char *msg);
>  
> -__kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
> +notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
>  {
>  
>  	/*
> Index: linux-mcount.git/arch/x86/kernel/nmi_64.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/nmi_64.c	2008-01-23 10:26:11.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/nmi_64.c	2008-01-23 10:26:53.000000000 -0500
> @@ -314,7 +314,7 @@ void touch_nmi_watchdog(void)
>   	touch_softlockup_watchdog();
>  }
>  
> -int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
> +notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
>  {
>  	int sum;
>  	int touched = 0;
> Index: linux-mcount.git/arch/x86/kernel/traps_32.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/traps_32.c	2008-01-23 10:26:11.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/traps_32.c	2008-01-23 10:26:53.000000000 -0500
> @@ -723,7 +723,7 @@ void __kprobes die_nmi(struct pt_regs *r
>  	do_exit(SIGSEGV);
>  }
>  
> -static __kprobes void default_do_nmi(struct pt_regs * regs)
> +static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  {
>  	unsigned char reason = 0;
>  
> @@ -763,7 +763,7 @@ static __kprobes void default_do_nmi(str
>  
>  static int ignore_nmis;
>  
> -fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
> +notrace fastcall __kprobes void do_nmi(struct pt_regs *regs, long error_code)
>  {
>  	int cpu;
>  
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
