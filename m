Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbXCHHWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbXCHHWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXCHHWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:22:40 -0500
Received: from www.osadl.org ([213.239.205.134]:39858 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932878AbXCHHWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:22:38 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Arai <arai@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45EF6077.9090302@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>
	 <45EF0CF5.5090305@goop.org>  <45EF175D.6030609@vmware.com>
	 <1173302503.24738.795.camel@localhost.localdomain>
	 <45EF372E.7030600@goop.org>
	 <1173308717.24738.898.camel@localhost.localdomain>
	 <45EF49E9.7040509@vmware.com>
	 <1173313373.24738.937.camel@localhost.localdomain>
	 <45EF6077.9090302@vmware.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 08:28:48 +0100
Message-Id: <1173338928.24738.979.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 17:01 -0800, Daniel Arai wrote:
> Thomas Gleixner wrote:
> 
> > You managed to avoid the usage of other code (i.e. PIT / HPET) already,
> > so why is it sooo desireable to emulate apics instead of substituting it
> > by a small and sane replacement ? Just because you happen to have an
> > LAPIC emulator ? That's no reason to wire yourself into the kernel code
> > and make it harder to change and maintain.
> 
> There are several reasons why it's desirable to emulate the APIC.  As you 
> mentioned, we already have APIC emulation, and APIC emulation isn't a huge 
> bottleneck on most workloads.  Our code works, the Linux code works, and 
> replacing both pieces of code with something "small and sane" isn't going to 
> improve performance very much, so why bother?  Any hypervisor implementation is 
> going to be a tradeoff between what's easy to implement in the hypervisor, 
> what's easy to implement in the guest operating system, and what's performance 
> critical.

It is not about performance. It is about maintainability. 

> Secondly, not all (para-)virtualized operating systems will want to use 
> abstracted devices.  Some virtual operating systems will be given direct access 
> to hardware devices, and will need to run the actual driver for that device and 
> not some abstracted device driver.  So I don't buy your argument that every 
> piece of the kernel that interacts with a paravirtualized driver should have a 
> "small and sane replacement."

Err. We talk about paravirtualized Linux and not about what you have to
emulate to get Windows running. I don't care at all. Do you really
expect that we have to accept your design decisions, just because they
allow you to make your life easy ? This is exactly what you are using
paravirt ops for: a backdoor to throw your hackery at the kernel and
leave us with the mess of hardwired crap.

> But more importantly, we want a kernel that can run both on native hardware and 
> in a paravirtualized environment.  Linux doesn't really provide abstractions for 
>   replacing the appropriate code.  We tried to hook into the source code at a 
> level that seemed possible.

Again. You just refuse to change your implementation and you want to
keep it by arguing how hard it is because there are no abstractions.

I went through the business of creating abstractions into hardwired
hairballs twice. I know exactly what I'm talking about. It _IS_ hard
work, but at the end it makes the code better and more maintainable. You
do nothing for that, but expect that we live with your addons to the
hairball.

> There's no good way to override __send_IPI_shortcut.  I suppose we could add 
> paravirt ops for __send_IPI_shortcut and every other op that touches the APIC. 
> But there are dozens of functions in apic.c that would need to be included in 
> paravirt ops.  And for our implementation, we really just want to override 
> apic_read and apic_write, since we can make these faster when done through 
> hypercalls than through memory accesses.  If we were to make these paravirt ops, 
> their implementations would be the same, except with a different apic_read and 
> apic_write.  This is a whole lot of useless code duplication.

No it is not. #include <linux/smp.h> is an abstraction and
__send_IPI ... is the i386 low level implementation.

You insist to hook yourself into the low level code instead of hooking
into the high level code, because it is _YOUR_ implementation and we
have to accept it as is.

This is the completely wrong way. We get the same crap and discussion
for every other architecture we are going to support with paravirt ops.
And probably for every other hypervisor implementation, which has a
different way of doing things.

> Most of the interrupt system is not written in such a way that multiple APICs 
> implementations can be selected from at boot time.  This is an absolute 
> requirement so that the same kernel can boot on native and in a paravirtualized 
> environment.  While this could be implemented, it seems like a waste of time, 
> since we can just emulate something similar to a real interrupt system and not 
> change things very much.

Waste of your precious time. I'm working on low level code and
abstractions and from now on I have also to take care not to break
_YOUR_ implementation. You are going to waste _MY_ time and I'm going to
fight that forever.

Your prayer wheel argument of missing abstractions and easiness of
emulating things is annoying. If you think it is better to emulate APIC,
please emulate it without paravirt ops. If you want the speed
improvement, work with us to create the interfaces and abstractions
which are necessary to have a sane, maintainable and useful for all
hypervisors implementation.

	tglx


