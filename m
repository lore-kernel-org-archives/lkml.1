Return-Path: <linux-kernel-owner+w=401wt.eu-S1763109AbXGMXp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763109AbXGMXp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbXGMXpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:45:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757572AbXGMXpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:45:21 -0400
Date: Fri, 13 Jul 2007 16:45:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: darnok@68k.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Inhibit NMI watchdog when Alt-SysRq-T operation is
 underway.
Message-Id: <20070713164504.66b72e74.akpm@linux-foundation.org>
In-Reply-To: <20070709155302.GB26570@andromeda.dapyr.net>
References: <20070709140242.GA18098@andromeda.dapyr.net>
	<20070709155302.GB26570@andromeda.dapyr.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 11:53:02 -0400
darnok@68k.org wrote:

>  static void print_trace_address(void *data, unsigned long addr)
>  {
> +	static int i = 0;		
> +	if (i && ((i % 8) == 0)) 
> +		touch_nmi_watchdog();
> +	i++;
>  	printk_address(addr);
>  }

I doubt if the "% 8" thing is really needed?  printk_address() is pretty
slow and touch_nmi_watchdog is _reasonably_ fast.  It could be made heaps
faster by:

From: Andrew Morton <akpm@linux-foundation.org>

Avoid dirtying remote cpu's memory if it already has the correct value.

Cc: Andi Kleen <ak@suse.de>
Cc: Konrad Rzeszutek <konrad@darnok.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/nmi.c |    8 +++++---
 x86_64/kernel/nmi.c    |    0 
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/nmi.c~i386-speedup-touch_nmi_watchdog arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~i386-speedup-touch_nmi_watchdog
+++ a/arch/i386/kernel/nmi.c
@@ -298,7 +298,7 @@ static unsigned int
 	last_irq_sums [NR_CPUS],
 	alert_counter [NR_CPUS];
 
-void touch_nmi_watchdog (void)
+void touch_nmi_watchdog(void)
 {
 	if (nmi_watchdog > 0) {
 		unsigned cpu;
@@ -307,8 +307,10 @@ void touch_nmi_watchdog (void)
 		 * Just reset the alert counters, (other CPUs might be
 		 * spinning on locks we hold):
 		 */
-		for_each_present_cpu (cpu)
-			alert_counter[cpu] = 0;
+		for_each_present_cpu(cpu) {
+			if (alert_counter[cpu])
+				alert_counter[cpu] = 0;
+		}
 	}
 
 	/*

So I'd be inclined to simplify your patch to a bare

From: Konrad Rzeszutek <konrad@darnok.org>

On large memory configuration with not so fast CPUs the NMI watchdog is
triggered when memory addresses are being gathered and printed.  The code
paths for Alt-SysRq-t are sprinkled with touch_nmi_watchdog in various
places but not in this routine (or in the loop that utilizes this
function).  The patch has been tested for regression on large CPU+memory
configuration (128 logical CPUs + 224 GB) and 1,2,4,16-CPU sockets with
various memory sizes (1,2,4,6,20).

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/traps.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/traps.c~inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway
+++ a/arch/x86_64/kernel/traps.c
@@ -397,6 +397,7 @@ static int print_trace_stack(void *data,
 
 static void print_trace_address(void *data, unsigned long addr)
 {
+	touch_nmi_watchdog();
 	printk_address(addr);
 }
 
_


OK?
