Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYD3Oub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYD3Oub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbYD3OuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:50:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:54326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801AbYD3OuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:50:19 -0400
Date: Wed, 30 Apr 2008 16:51:31 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Gabor Gombas <gombasg@sztaki.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080430165131.7426d5d3@strauss.suse.de>
In-Reply-To: <20080430133824.GC18711@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
	<20080428092513.495378af.akpm@linux-foundation.org>
	<20080429175419.6c8a0ebf@strauss.suse.de>
	<20080430133824.GC18711@boogie.lpds.sztaki.hu>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Gabor Gombas [2008-04-30 15:38]:
>
> On Tue, Apr 29, 2008 at 05:54:19PM +0200, Bernhard Walle wrote:
> 
> > Hm ..., can you mail /proc/interrupts of the affected system? According
> > to the HPET specification 
> 
> The Intel box:
> 
>            CPU0       CPU1       
>   0:      27346      29145   IO-APIC-edge      timer
>   1:        842        819   IO-APIC-edge      i8042
>   4:          2          2   IO-APIC-edge    
>   6:          0          3   IO-APIC-edge      floppy
>   8:          2          3   IO-APIC-edge      rtc0

Well, looks fine. It's edge triggered. My assumption that the
T1_INT_STS must be cleared is wrong since the complete HPET code
assumes edge-triggered interrupts. To use level-triggered interrupts,
the HPET must be programmed in level triggered mode, i.e. the
Tn_INT_TYPE_CNF bit must be set. Which is never done.

Back to the original problem. Can you please watch the interrupts from
the RTC until the lockup happens with something like

------------------------- 8< -----------------------------------
function get_total_irqs()
{
	sum=0
	for n in $(grep rtc /proc/interrupts | \
				 sed -e 's/.*://g' | \
				 sed -e 's/[a-zA-Z].*//g' ) ; 
		do sum=$[$sum+$n]
	done

	echo $sum
}

last=$(get_total_irqs)
while true ; do
	sum=$(get_total_irqs)
	echo $[$sum-$last]
	last=$sum

	sleep 1
done
------------------------- >8 -----------------------------------

Also, please send the full .config (maybe via private mail if that's
too large for LKML, or upload it).

> > Can you try that patch and see if the IRQ handler is really called
> > repeatedly in that case?
> 
> Unfortunately I won't have time today and will be traveling till the end
> of the week. I'll give it a shot next week.

Ok. Maybe don't use the patch I sent, instead use:



	Bernhard


--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -680,6 +680,12 @@ irqreturn_t hpet_rtc_interrupt(int irq,
        struct rtc_time curr_time;
        unsigned long rtc_int_flag = 0;
 
+       if (printk_ratelimit())
+               printk(KERN_DEBUG "hpet_rtc_interrupt %s%s%s\n",
+                               (hpet_rtc_flags & RTC_UIE) ? "RTC_UIE " : "",
+                               (hpet_rtc_flags & RTC_AIE) ? "RTC_AIE " : "",
+                               (hpet_rtc_flags & RTC_PIE) ? "RTC_PIE " : "");
+
        hpet_rtc_timer_reinit();
        memset(&curr_time, 0, sizeof(struct rtc_time));


