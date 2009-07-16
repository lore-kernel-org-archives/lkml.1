Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbZGPQwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbZGPQwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932577AbZGPQws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:52:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbZGPQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:52:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction with guests
Date: Thu, 16 Jul 2009 18:52:41 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com, aliguori@us.ibm.com
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net>
In-Reply-To: <20090716151945.29318.10882.stgit@dev.haskins.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200907161852.42071.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/9DW37A6UFEfKCbThwIHClzv5Mv7GsqaMJ7BF
 1B2RyoR3OYv2gou9PNh5yYICWkfs6t/yYeVkF60vQ8E1zmqcYF
 E1c37YGzL1j8SMPpsae4N078o4/nj4Q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 July 2009, Gregory Haskins wrote:
> Background: The original vbus code was tightly integrated with kvm.ko.  Avi
> suggested that we abstract the interfaces such that it could live outside
> of kvm.

The code is still highly kvm-specific, you would not be able to use
it with another hypervisor like lguest or vmware player, right?

> Example usage: QEMU instantiates a guest, and an external module "foo"
> that desires the ability to interface with the guest (say via
> open("/dev/foo")).  QEMU may then issue a KVM_GET_VMID operation to acquire
> the u64-based vmid, and pass it to ioctl(foofd, FOO_SET_VMID, &vmid).
> Upon receipt, the foo module can issue kvm_xinterface_find(vmid) to acquire
> the proper context.  Internally, the struct kvm* and associated
> struct module* will remain pinned at least until the foo module calls
> kvm_xinterface_put().

Your approach allows passing the vmid from a process that does
not own the kvm context. This looks like an intentional feature,
but I can't see what this gains us. 

> As a final measure, we link the xinterface code statically
> into the kernel so that callers are guaranteed a stable interface to
> kvm_xinterface_find() without implicitly pinning kvm.ko or racing against
> it.

I also don't understand this. Are you worried about driver modules
breaking when an externally-compiled kvm.ko is loaded? The same could
be achieved by defining your data structures kvm_xinterface_ops and
kvm_xinterface in a kernel header that is not shipped by kvm-kmod but
always taken from the kernel headers.
It does not matter if the entry points are build into the kernel or
exported from a kvm.ko as long as you define a fixed ABI.

What is the problem with pinning kvm.ko from another module using
its features?

Can't you simply provide a function call to lookup the kvm context
pointer from the file descriptor to achieve the same functionality?

To take that thought further, maybe the dependency can be turned
around: If every user (pci-uio, virtio-net, ...) exposes a file
descriptor based interface to user space, you can have a kvm
ioctl to register the object behind that file descriptor with
an existing kvm context to associate it with a guest. That would
nicely solve the life time questions by pinning the external
object for the life time of the kvm context rather than the other
way round, and it would be completely separate from kvm in that
each such object could be used by other subsystems independent
of kvm.

	Arnd <><
