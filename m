Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbXCNToa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbXCNToa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXCNToa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:44:30 -0400
Received: from gw.goop.org ([64.81.55.164]:37470 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbXCNTo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:44:29 -0400
Message-ID: <45F8508F.3070109@goop.org>
Date: Wed, 14 Mar 2007 12:44:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>	 <1173837606.23595.32.camel@imap.mvista.com>  <45F79B9C.20609@goop.org>	 <1173888673.3101.12.camel@imap.mvista.com>  <45F824BE.1060708@goop.org>	 <1173891595.3101.17.camel@imap.mvista.com>  <45F82C01.3000704@goop.org>	 <1173895607.3101.58.camel@imap.mvista.com>  <45F841EE.6060703@goop.org> <1173898800.3101.81.camel@imap.mvista.com>
In-Reply-To: <1173898800.3101.81.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> sched_clock is used to bank real time against some specific states
> inside the scheduler, and no it doesn't _just_ measure a processes
> executing time.
>   

Could you point these places out?  All uses of sched_clock() that I
could see in kernel/sched.c seemed to be related to working out how long
something spent executing, either in the scheduler proper, or
benchmarking cache characteristics.

>>    1. If the cpu is stolen by the hypervisor, the kernel will get no
>>       state transition notification.  It can generally find out that
>>       some time was stolen after the fact, but there's no specific event
>>       at the time it happens.
>>     
>
> The hypervisor would need to do it's own accounting I'd imagine then
> provide that to the scheduler.
>   

Yes.  Xen, at least, provides nanosecond resolution information about
how long each vcpu spent in its various states.  But the question is how
this information should be exposed to the scheduler.  I could provide a
raw dump of the info, but in general the scheduler doesn't care and
other hypervisors might not be able to produce the same information. 
The essential information is "how long did process X actually run on a
real CPU"?  And that, as far as I can tell, is the question
sched_clock() is already designed to answer.

>>    2. It doesn't map particularly well to a cpu changing speed.  In
>>       particular if a cpu has continuously varying execution speed
>>       (Transmeta?), then the best you can hope for is the integration of
>>       cpu work done over a time period rather than discrete cpu
>>       speed-change events.
>>     
>
> True, but as I said in my original email it's not trivial to follow
> physical cpu speed changes since the changes are free form and change
> potentially per system. Your better off do it just with the hypervisor
> since you can control it ..
>   

No, I'm talking about cpu speed changes as a completely separate case,
which is primarily an issue while running a kernel on bare hardware. 
But it is, in some ways, more complex than running on a hypervisor. 
There are numerous mechanisms for cpu speed control, some kernel driven,
some autonomous, some stepwise, some continuous.  I'm arguing that its
the cpufreq subsystem's job to keep track of all that detail, but the
only information it needs to provide to the scheduler is, again, "how
much work did my process get done on the CPU"?


    J
