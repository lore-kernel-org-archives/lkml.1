Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbXCNTAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbXCNTAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932765AbXCNTAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:00:08 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:65013 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645AbXCNTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:00:05 -0400
Subject: Re: Stolen and degraded time and schedulers
From: Daniel Walker <dwalker@mvista.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Peter Chubb <peterc@gelato.unsw.edu.au>
In-Reply-To: <45F841EE.6060703@goop.org>
References: <45F6D1D0.6080905@goop.org>
	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>
	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>
	 <1173837606.23595.32.camel@imap.mvista.com>  <45F79B9C.20609@goop.org>
	 <1173888673.3101.12.camel@imap.mvista.com>  <45F824BE.1060708@goop.org>
	 <1173891595.3101.17.camel@imap.mvista.com>  <45F82C01.3000704@goop.org>
	 <1173895607.3101.58.camel@imap.mvista.com>  <45F841EE.6060703@goop.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 12:00:00 -0700
Message-Id: <1173898800.3101.81.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 11:41 -0700, Jeremy Fitzhardinge wrote:
> Daniel Walker wrote:
> > >From prior emails I think your suggesting that 1ms (or 5 or 10) of time
> > should actually be a variable X that is changed inside sched_clock().
> > That's not the purpose of that API call, sched_clock() measure real time
> > period.
> >   
> 
> To what purpose?  What is it really measuring?  My understanding is that
> its for the scheduler to work out how much time a process actually ran
> for.  Aside from its use in printk as a general monotonic timestamp,
> this seems to be how it gets used everywhere.  If I change it to return
> cpu-ns (ie, make it not count time that the cpu was stolen by the
> hypervisor), then it will return what its callers actually want to know.

sched_clock is used to bank real time against some specific states
inside the scheduler, and no it doesn't _just_ measure a processes
executing time.

> > After reading your emails it sounds like what you really want is similar
> > to accurate state accounting which is used for scheduling purposes. Part
> > of that has already been implemented at least twice that I know of.
> > Accounting real time against specific states was done in two version of
> > microstate accounting. Those are fine starting points for the changes
> > you are wanting.
> 
> I haven't looked at the microstate accounting patches in any detail, but
> I'm assuming that they take a timestamp at each CPU state transition and
> use that to account time to the appropriate entities (tell me if I'm
> missing something pertinent here).  There are two problems with that
> approach in this case:
> 
>    1. If the cpu is stolen by the hypervisor, the kernel will get no
>       state transition notification.  It can generally find out that
>       some time was stolen after the fact, but there's no specific event
>       at the time it happens.

The hypervisor would need to do it's own accounting I'd imagine then
provide that to the scheduler.

>    2. It doesn't map particularly well to a cpu changing speed.  In
>       particular if a cpu has continuously varying execution speed
>       (Transmeta?), then the best you can hope for is the integration of
>       cpu work done over a time period rather than discrete cpu
>       speed-change events.

True, but as I said in my original email it's not trivial to follow
physical cpu speed changes since the changes are free form and change
potentially per system. Your better off do it just with the hypervisor
since you can control it ..

Daniel

