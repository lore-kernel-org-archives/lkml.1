Return-Path: <linux-kernel-owner+w=401wt.eu-S933135AbZGPTqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbZGPTqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933103AbZGPTqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:46:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012AbZGPTqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:46:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction with guests
Date: Thu, 16 Jul 2009 21:46:07 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com, aliguori@us.ibm.com
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <200907161852.42071.arnd@arndb.de> <4A5F6FF4.2090706@novell.com>
In-Reply-To: <4A5F6FF4.2090706@novell.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907162146.07555.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18FwG9RhWBfdUVrlk9mwJIU2IjmVTl+PW7qjZA
 gQld8DzpPXstKaPVlG93tqZlgZTIad8wkWBUdg+7gKd+yDMkUZ
 zXVvPY88JHkJmrurua7qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 July 2009, Gregory Haskins wrote:
> Arnd Bergmann wrote:  

> > Your approach allows passing the vmid from a process that does
> > not own the kvm context. This looks like an intentional feature,
> > but I can't see what this gains us.
> 
> This work is towards the implementation of lockless-shared-memory
> subsystems, which includes ring constructs such as virtio-ring,
> VJ-netchannels, and vbus-ioq.   I find that these designs perform
> optimally when you allow two distinct contexts (producer + consumer) to
> process the ring concurrently, which implies a disparate context from
> the guest in question.  Note that the infrastructure we are discussing
> does not impose a requirement for the contexts to be unique: it will
> work equally well from the same or a different process.
> 
> For an example of this "producer/consumer" dynamic over shared memory in
> action, please refer to my previous posting re: "vbus"
> 
> http://lkml.org/lkml/2009/4/21/408
> 
> I am working on v4 now, and this patch is part of the required support.

Ok. I can see how your approach gives you more flexibility in this
regard, but it does not seem critical.

> But to your point, I suppose the dependency lifetime thing is not a huge
> deal.  I could therefore modify the patch to simply link xinterface.o
> into kvm.ko and still achieve the primary objective by retaining ops->owner.

Right. And even if it's a separate module, holding an extra reference
on kvm.ko will not cause any harm.

> > Can't you simply provide a function call to lookup the kvm context
> > pointer from the file descriptor to achieve the same functionality?
> >   
> You mean so have: struct kvm_xinterface *kvm_xinterface_find(int fd)
> 
> (instead of creating our own vmid namespace) ?
> 
> Or are you suggesting using fget() instead of kvm_xinterface_find()?

I guess they are roughly equivalent. Either you pass a fd to
kvm_xinterface_find, or pass the struct file pointer you get
from fget. The latter is probably more convenient because it
allows you to pass around the struct file in kernel contexts
that don't have that file descriptor open.

> > To take that thought further, maybe the dependency can be turned
> > around: If every user (pci-uio, virtio-net, ...) exposes a file
> > descriptor based interface to user space, you can have a kvm
> > ioctl to register the object behind that file descriptor with
> > an existing kvm context to associate it with a guest.
> 
> FWIW: We do that already for the signaling path (see irqfd and ioeventfd
> in kvm.git).  Each side exposes interfaces that accept eventfds, and the
> fds are passed around that way.
> 
> However, for the functions we are talking about now, I don't think it
> really works well to go the other way.  I could be misunderstanding what
> you mean, though.  What I mean is that it's KVM that is providing a
> service to the other modules (in this case, translating memory
> pointers), so what would an inverse interface look like for that?  And
> even if you came up with one, it seems to me that its just "6 of one,
> half-dozen of the other" kind of thing.

I mean something like 

int kvm_ioctl_register_service(struct file *filp, unsigned long arg)
{
	struct file *service = fget(arg);
	struct kvm *kvm = filp->private_data;

	if (!service->f_ops->new_xinterface_register)
		return -EINVAL;

	return service->f_ops->new_xinterface_register(service, (void*)kvm,
				&kvm_xinterface_ops);
}

This would assume that we define a new file_operation specifically for this,
which would simplify the code, but there are other ways to achieve the same.
It would even mean that you don't need any static code as an interface layer.

	Arnd <><
