Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbZHRSUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbZHRSUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 14:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZHRSUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 14:20:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZHRSUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:20:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for vbus_driver objects
Date: Tue, 18 Aug 2009 20:20:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <4A8A674E.8070200@redhat.com> <4A8ABEC9.6090006@gmail.com>
In-Reply-To: <4A8ABEC9.6090006@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908182020.11126.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19o7HHjfVj1ZKQcPEio8feOzRdroYblzLDSfcP
 DH2t5vtWhgpM5ZUG4Omb5TqSKY0qIr26m7Otd+xiVpXMgdaSpX
 +FA0AsFBAVshG5WrBMwnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Gregory Haskins wrote:
> Avi Kivity wrote:
> > On 08/17/2009 10:33 PM, Gregory Haskins wrote:
> > 
> > One point of contention is that this is all managementy stuff and should
> > be kept out of the host kernel.  Exposing shared memory, interrupts, and
> > guest hypercalls can all be easily done from userspace (as virtio
> > demonstrates).  True, some devices need kernel acceleration, but that's
> > no reason to put everything into the host kernel.
> 
> See my last reply to Anthony.  My two points here are that:
> 
> a) having it in-kernel makes it a complete subsystem, which perhaps has
> diminished value in kvm, but adds value in most other places that we are
> looking to use vbus.
> 
> b) the in-kernel code is being overstated as "complex".  We are not
> talking about your typical virt thing, like an emulated ICH/PCI chipset.
>  Its really a simple list of devices with a handful of attributes.  They
> are managed using established linux interfaces, like sysfs/configfs.

IMHO the complexity of the code is not so much of a problem. What I
see as a problem is the complexity a kernel/user space interface that
manages a the devices with global state.

One of the greatest features of Michaels vhost driver is that all
the state is associated with open file descriptors that either exist
already or belong to the vhost_net misc device. When a process dies,
all the file descriptors get closed and the whole state is cleaned
up implicitly.

AFAICT, you can't do that with the vbus host model.

> > What performance oriented items have been left unaddressed?
> 
> Well, the interrupt model to name one.

The performance aspects of your interrupt model are independent
of the vbus proxy, or at least they should be. Let's assume for
now that your event notification mechanism gives significant
performance improvements (which we can't measure independently
right now). I don't see a reason why we could not get the
same performance out of a paravirtual interrupt controller
that uses the same method, and it would be straightforward
to implement one and use that together with all the existing
emulated PCI devices and virtio devices including vhost_net.

	Arnd <><
