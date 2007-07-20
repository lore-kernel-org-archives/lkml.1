Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbXGTLSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbXGTLSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbXGTLSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:18:25 -0400
Received: from andromeda.dapyr.net ([69.45.6.100]:33097 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbXGTLSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:18:24 -0400
Date: Fri, 20 Jul 2007 07:18:23 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: darnok@68k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Inhibit NMI watchdog when Alt-SysRq-T operation is underway.
Message-ID: <20070720111823.GA2334@andromeda.dapyr.net>
References: <20070709140242.GA18098@andromeda.dapyr.net> <20070709155302.GB26570@andromeda.dapyr.net> <20070713164504.66b72e74.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713164504.66b72e74.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew,

I tested your patch along with mine and found two things out:

 1). Missing this patch (for i386 platform)

diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 90da057..9f3a7ff 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -207,6 +207,7 @@ static void print_trace_address(void *da
 {
 	printk("%s [<%08lx>] ", (char *)data, addr);
 	print_symbol("%s\n", addr);
+	touch_nmi_watchdog();
 }
 
 static struct stacktrace_ops print_trace_ops = {


  2). If I run Alt-SysRq-t about 5000 times in a loop, the slow down 
      with this change is about 5%. Is this a big issue? (This was
      testing both i686 and x86_64).

On Fri, Jul 13, 2007 at 04:45:04PM -0700, Andrew Morton wrote:
> On Mon, 9 Jul 2007 11:53:02 -0400
> darnok@68k.org wrote:
> 
> >  static void print_trace_address(void *data, unsigned long addr)
> >  {
> > +	static int i = 0;		
> > +	if (i && ((i % 8) == 0)) 
> > +		touch_nmi_watchdog();
> > +	i++;
> >  	printk_address(addr);
> >  }
> 
> I doubt if the "% 8" thing is really needed?  printk_address() is pretty
> slow and touch_nmi_watchdog is _reasonably_ fast.  It could be made heaps
> faster by:
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Avoid dirtying remote cpu's memory if it already has the correct value.
> 
> Cc: Andi Kleen <ak@suse.de>
> Cc: Konrad Rzeszutek <konrad@darnok.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/kernel/nmi.c |    8 +++++---
>  x86_64/kernel/nmi.c    |    0 
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff -puN arch/i386/kernel/nmi.c~i386-speedup-touch_nmi_watchdog arch/i386/kernel/nmi.c
> --- a/arch/i386/kernel/nmi.c~i386-speedup-touch_nmi_watchdog
> +++ a/arch/i386/kernel/nmi.c
> @@ -298,7 +298,7 @@ static unsigned int
>  	last_irq_sums [NR_CPUS],
>  	alert_counter [NR_CPUS];
>  
> -void touch_nmi_watchdog (void)
> +void touch_nmi_watchdog(void)
>  {
>  	if (nmi_watchdog > 0) {
>  		unsigned cpu;
> @@ -307,8 +307,10 @@ void touch_nmi_watchdog (void)
>  		 * Just reset the alert counters, (other CPUs might be
>  		 * spinning on locks we hold):
>  		 */
> -		for_each_present_cpu (cpu)
> -			alert_counter[cpu] = 0;
> +		for_each_present_cpu(cpu) {
> +			if (alert_counter[cpu])
> +				alert_counter[cpu] = 0;
> +		}
>  	}
>  
>  	/*
> 
> So I'd be inclined to simplify your patch to a bare
> 
> From: Konrad Rzeszutek <konrad@darnok.org>
> 
> On large memory configuration with not so fast CPUs the NMI watchdog is
> triggered when memory addresses are being gathered and printed.  The code
> paths for Alt-SysRq-t are sprinkled with touch_nmi_watchdog in various
> places but not in this routine (or in the loop that utilizes this
> function).  The patch has been tested for regression on large CPU+memory
> configuration (128 logical CPUs + 224 GB) and 1,2,4,16-CPU sockets with
> various memory sizes (1,2,4,6,20).
> 
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86_64/kernel/traps.c |    1 +
>  1 files changed, 1 insertion(+)
> 
> diff -puN arch/x86_64/kernel/traps.c~inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway arch/x86_64/kernel/traps.c
> --- a/arch/x86_64/kernel/traps.c~inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway
> +++ a/arch/x86_64/kernel/traps.c
> @@ -397,6 +397,7 @@ static int print_trace_stack(void *data,
>  
>  static void print_trace_address(void *data, unsigned long addr)
>  {
> +	touch_nmi_watchdog();
>  	printk_address(addr);
>  }
>  
> _
> 
> 
> OK?
