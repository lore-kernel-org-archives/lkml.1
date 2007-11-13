Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbXKMN4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbXKMN4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXKMN4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:56:42 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33634 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829AbXKMN4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:56:41 -0500
Subject: Re: Use of virtio device IDs
From: Zachary Amsden <zach@vmware.com>
To: Gregory Haskins <gregory.haskins.ml@gmail.com>
Cc: Avi Kivity <avi@qumranet.com>, Gregory Haskins <gregory.haskins@gmail.com>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4739A41F.5010802@gmail.com>
References: <4730A15A.6070001@us.ibm.com> <4730B753.2000901@us.ibm.com>
	 <4731334A.6090405@gmail.com> <47314FBD.1070505@qumranet.com>
	 <47322262.8000101@gmail.com> <4732AE9A.4070701@qumranet.com>
	 <4739A41F.5010802@gmail.com>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 05:59:45 -0800
Message-Id: <1194962385.6352.83.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-13 at 08:18 -0500, Gregory Haskins wrote:

> Since PCI was designed as a hardware solution it has all kinds of stuff
> specifically geared towards hardware constraints.   Those constraints
> are different in a virtualized platform, so some things do not translate
> well to an optimal solution.  Half of the stuff wouldn't be used, and
> the other half has some nasty baggage associated with it (like still
> requiring partial emulation in a PV environment).
> 
> The point of PV, of course, is high performance guest/host interfaces,
> and PCI baggage just gets in the way in many respects.  Once a

I would tend to disagree with that statement.  The point of PV is a
simpler to implement guest/host interface, which sometimes results in a
higher performance interface.  PV does not always mean high performance,
nor does high performance imply PV is necessary.

> particular guest's subsystem is HV aware we no longer strictly require
> legacy emulation.  It should know how to talk to the host using whatever
> is appropriate.  I aim to strip out all of those emulation points
> whenever possible.  Once you do that, all of the PCI features that we
> would use drops to zero.

Device discovery, bus enumeration and shared memory configuration space
mapping are all very useful features that require complex negotiation
with the hypervisor.  Those are provided implicitly in a standardized
way by PCI (or by any good hardware bus protocol).

> On the flip side, we have full emulation if you want broader
> compatibility with legacy, at the expense of performance.

There is no reason you need to sacrifice performance for broader
compatibility with well designed virtual devices on modern hardware.

> 
> > 
> >> You are
> >> probably better off designing something that is PV specific instead of
> >> shoehorning it in to fit a different model (at least for the things I
> >> have in mind).  
> > 
> > Well, if we design our pv devices to look like hardware, they will fit
> > quite well.  Both to the guest OS and to user's expectations.
> 
> Like what hardware?  Like PCI hardware?  What if the platform in
> question doesn't have PCI?  Also note that devices don't have to look
> like emulated PCI devices per se to look like hardware to the
> guest-OS/user.  That is just one way to do it.

What if the platform in question does have PCI.  How are you going to
write drivers for non-Linux guests?  Design a new bus protocol and
driver system for pv-only devices which can't run anywhere except for a
couple selected guests, or design along the lines of what the physical
hardware on your platform actually looks like?  It's not like you can
construct a full-featured virtualization of x86 without implenting PCI
at some level anyway.

Note this is not an argument for PCI.  It is an argument for devices
that look like hardware on whatever platform you are virtualizing.  On
s390, that might be a bit different than on x86.  But the key idea is
re-use the platform architecture as much as possible.  This gets you far
more code sharing and interoperability for devices.

Just because you can paravirtualize everything does not mean it is a
good idea or more efficient.  A good high performance "paravirtualized"
network driver only needs one efficient place to trap to the hypervisor,
that is to kick off a TX queue.  Nothing else needs to be
paravirtualized to make this efficient, and now you have a driver that
is fairly easily ported among different operating systems because it
reuses many architectural primitives.

So I think it is a good thing for virtio to allow coupling to a PCI
device backend for x86, but be generic enough to allow coupling to other
backends for non-PCI architectures.  Perhaps the top-level device code
and TX/RX queues can be re-used, although I'm not convinced sharing at
this layer gives so much benefit in terms of raw lines of code.

> 
> > 
> >> Its not a heck of a lot of code to write a pv-centric
> >> version of these facilities.
> >>
> >>   
> > 
> > It is.  
> 
> After having done it in the past, I disagree.   But it sounds like you

What about XenBus?  Device discovery and configuration are a huge amount
of work, especially when done without a standard to work from.

Just my $0.02.

Zach

