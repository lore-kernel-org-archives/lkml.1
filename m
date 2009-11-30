Return-Path: <linux-kernel-owner+w=401wt.eu-S1751504AbZK3FMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbZK3FMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 00:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZK3FMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 00:12:13 -0500
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:58573 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZK3FMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 00:12:12 -0500
Date: Mon, 30 Nov 2009 00:11:51 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Problem? intel_iommu=off; perf top shows acpi_os_read_port as
 extremely busy
In-reply-to: <20091129124731.7d0c9b45@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Message-id: <4B135417.1080302@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B106CC0.4050406@majjas.com> <20091128071808.GA32183@elte.hu>
 <20091128094530.0ede7b1a@infradead.org> <4B11678D.8020601@majjas.com>
 <20091129124731.7d0c9b45@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre)
 Gecko/20091109 Fedora/3.0-3.10.b4.fc12 Thunderbird/3.0b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok - one more rather odd (to me) data point...
I started playing around with various settings, and traced the calls to 
acpi_os_read_port.

To summarize:
With intel_iommu=off, I see a large percentage of calls to 
acpi_os_read_port resulting from user apps (portsentry is #1).
With intel_iommu=on, NONE of trace points to any user apps - all derive 
from the idle loop.
To make things more interesting, when I enable intel_iommu and disable 
vt-d in bios, the system performs much better (20% improvement in 
glxgears, for example), perf top looks like this:

------------------------------------------------------------------------------
    PerfTop:    4863 irqs/sec  kernel:62.7% [100000 cycles],  (all, 8 CPUs)
------------------------------------------------------------------------------

              samples    pcnt   kernel function
              _______   _____   _______________

              2213.00 -  5.5% : acpi_idle_enter_bm
              2001.00 -  5.0% : acpi_os_read_port
              1544.00 -  3.9% : _spin_lock_irqsave
              1075.00 -  2.7% : ioread32
               928.00 -  2.3% : find_busiest_group
               851.00 -  2.1% : _spin_unlock_irqrestore
               823.00 -  2.1% : hpet_next_event
               810.00 -  2.0% : tg_shares_up
               655.00 -  1.6% : fget_light
               641.00 -  1.6% : schedule
               639.00 -  1.6% : tick_nohz_stop_sched_tick
               638.00 -  1.6% : sub_preempt_count
               634.00 -  1.6% : add_preempt_count
               548.00 -  1.4% : do_sys_poll
               446.00 -  1.1% : trace_hardirqs_off

And additionally, one recurring boot warning I've seen since I first 
booted this box has disappeared - first boot message of IRQ16 disabled.

I'm thinking that bad VT-D bios is causing trouble even when intel_iommu 
is disabled.

On 11/29/2009 03:47 PM, Arjan van de Ven wrote:
> On Sat, 28 Nov 2009 13:10:21 -0500
> Michael Breuer<mbreuer@majjas.com>  wrote:
>
>    
>> Ok - my only question then is why things appear so different with
>> intel_iommu enabled.
>>      
> something else is even more expensive then :0
>
>
>    

