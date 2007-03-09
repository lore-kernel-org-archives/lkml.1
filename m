Return-Path: <linux-kernel-owner+w=401wt.eu-S1767464AbXCISxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767464AbXCISxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767466AbXCISxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:53:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:40584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767464AbXCISxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:53:17 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Date: Fri, 9 Mar 2007 19:28:26 +0100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070309180230.GA17988@elte.hu>
In-Reply-To: <20070309180230.GA17988@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091928.26919.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 19:02, Ingo Molnar wrote:

> _1463_ hooks, spread out all around the x86 arch.

They are not all different hooks though, just many call site of the same.
Also most of them are well defined to just match what the instructions
do.

paravirt_ops has under hundred entries right now and i intend to not
expand it much further after the Xen bits are in.
 
> Let me demonstrate some of the bad effects, and how far we've _already_ 
> deviated from the 'hardware ABI'. An example: one assumes that 
> paravirt_ops.safe_halt() 

The vmi maintainers already agreed to fix that.

> i claim that when the 'API cut' is done at the right level 

Can you make a proposal?  Would you be willing to write code for that?

> then no more  
> than say 100 hooks would be needed 

Well we have less than 100 hooks right now, just with many call sites @)

> - with virtually zero kernel size  
> increase. 

I'll believe that when I see it.

> We've got all the right highlevel abstractions: genirq, gtod,  
> clockevents. Whatever is missing at the moment from the framework (say 
> smp_send_reschedule()) we can abstract away. 

smp_send_reschedule() is just an IPI instance which is already
abstracted with genapic. Xen has a genapic_xen.

VMI is still where ->apic_read/->apic_write and their relatively
harmless timer interrupt change make sense -- if they needed
more changes they would just need to bite the bullet and 
provide a custom genapic vmware apic driver.

> Unfortunately, with the current paravirt_ops policy we might end up 
> seeing none of that unification. 

I am open to concrete incremental proposals for improvements.

> 
> And that is why the "paravirt_ops is just virtual hardware" argument is 
> totally wrong. _Nothing_ limits hypervisors from adding arbitrary ABI 
> bindings to Linux. For example, VMI does this already and none of the 
> following are hardware ABIs:
> 
>  #define VMI_CALL_SetAlarm               68
>  #define VMI_CALL_CancelAlarm            69
>  #define VMI_CALL_GetWallclockTime       70
>  #define VMI_CALL_WallclockUpdated       71

That's VMI internal, not exposed above paravirt ops.
  
> Firstly, i think this has been over-rushed. After years of being happy 
> with forks of the Linux kernel, 

The code has been posted for a long time, open for review for everybody.

> Secondly, i'd like to see a paravirt approach that has /implicit/ 
> safeguards against the following type of crap:

I don't think you can use an API to force the underlying implementation
in a practical way. If code wants to do something wrong it no API 
in the world will stop it. That is why we have code review instead.

>    it has a hardwired assumption that 'cycles' makes a sense as a way to 
>    communicate time units:
> 
>         vmi_timer_ops.set_alarm(
>                       VMI_ALARM_WIRED_LVTT | VMI_ALARM_IS_PERIODIC | VMI_CYCLES_AVAILABLE,
>                       per_cpu(process_times_cycles_accounted_cpu, cpu) + cycles_per_alarm,
>                       cycles_per_alarm);

That's because VMI is defined this way? If paravirt chosed to not pass cycles
anymore they would just add a simple conversion function. SMOP.

 
>    it has a hardwired assumption that Linux keeps time in units of 
>    'jiffies':

Well a lot of drivers have that, but it can be all fixed.

> Granted, some of these are just harmless quirks that are fixable in 
> Linux only,

All of them.

> but some of these are stiffling because they bind Linux to  
> the hypervisor ABI.

I haven't seen a concrete example of that yet to be honest and I don't
really believe it.
 
-Andi
