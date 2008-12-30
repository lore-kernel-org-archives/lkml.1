Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbYL3Vhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbYL3Vhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 16:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYL3Vhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 16:37:33 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48588 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYL3Vhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 16:37:33 -0500
Date: Tue, 30 Dec 2008 22:37:27 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Subject: Re: [2.6.28] NULL pointer dereference at get_stats()
Message-ID: <20081230213727.GA2001@gambetta>
References: <200812302153.ECH86976.MFLOQFJHtSOOFV@I-love.SAKURA.ne.jp> <20081230155215.GA31531@gambetta> <200812310201.GJH43235.OFFLHFMStOJVOQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812310201.GJH43235.OFFLHFMStOJVOQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trimmed netdev from cc:]
Hello Tetsuo,

On Wed, Dec 31, 2008 at 02:01:56AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Frederik Deweerdt wrote:
> > Does adding maxcpus=0 to the boot parameters solve the problem? Stephen
> > suspected a per-cpu variable related problem.
> 
> No, but I got interestring results.
> 
> Result | # of virtual CPUs | Kernel command line
> -------+-------------------+-----------------------------------------
>  OK    | 2                 | ro root=LABEL=/
>  BUG   | 2                 | ro root=LABEL=/ noapic nolapic
>  BUG   | 2                 | ro root=LABEL=/ noapic nolapic maxcpus=0
>  BUG   | 2                 | ro root=LABEL=/ noapic nolapic nosmp
>  BUG   | 2                 | ro root=LABEL=/ maxcpus=0
>  BUG   | 2                 | ro root=LABEL=/ nosmp
>  OK    | 1                 | ro root=LABEL=/
>  OK    | 1                 | ro root=LABEL=/ nolapic noapic
>  OK    | 1                 | ro root=LABEL=/ nolapic noapic maxcpus=0
>  OK    | 1                 | ro root=LABEL=/ nolapic noapic nosmp
> 
> "OK" means NULL pointer dereference didn't happen.
> "BUG" means NULL pointer dereference happened.
> 
> I was adding "noapic" "nolapic" to command line while assigning 2 vcpus.
> Thus, I encountered this problem. Workaround is to remove "noapic" "nolapic".
> 
> Now, it seems to me that this problem is caused by interaction of
> "noapic" "nolapic" "maxcpus=0" "nosmp" options.

Thanks for the thourough testing. I've reviewed the code, and the only
think that looks weird to me is the case where smp_sanity_check() fails.
The attached patch is an attempt to correct this, Tetsuo, could you
test it?

Ingo, could you please have a look at it? It does what commit
deef325086c3897393b8f7d6bccd0340 "x86: disable preemption in
native_smp_prepare_cpus" was looking to fix, but continuing the APIC
setup in case smp_sanity_check fails.


Regards,
Frederik

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f8500c9..888c6d3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1188,16 +1188,13 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
 		disable_smp();
-		goto out;
 	}
 
-	preempt_disable();
 	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
 		     read_apic_id(), boot_cpu_physical_apicid);
 		/* Or can we switch back to PIC here? */
 	}
-	preempt_enable();
 
 	connect_bsp_APIC();
 
@@ -1230,7 +1227,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	if (is_uv_system())
 		uv_system_init();
-out:
+
 	preempt_enable();
 }
 /*
