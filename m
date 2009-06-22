Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbZFVSKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbZFVSKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbZFVSJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:09:49 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59486 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439AbZFVSJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:09:48 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 22 Jun 2009 11:03:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3FC2B1.4050107@novell.com>
Message-ID: <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
 <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
 <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com>
 <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Gregory Haskins wrote:

> I am probably confused or perhaps have the wrong terminology, but isnt
> that "ok".  I am concerned about the consumer (the guy getting the
> POLLINs) to be able to detect POLLHUP when the last producer
> (f_ops->write() from userspace, eventfd_signal() from kernel) goes away.
> 
> Consider the following sequence:
> 
> -------------------
> 
> userspace calls "fd = eventfd()", and gives one to KVM as an irqfd, and
> the other to some PCI-passthrough device.
> 
> The kvm/irqfd side acquires a kref, the pci side acquires a file.  At
> this moment, userspace has the fd, and the pci device has the file (for
> eventfd_signal()).  The fget() count is 2.  Userspace closes the fd
> because its done with it, and the count drops to 1.
> 
> Some time later, pci does an fput(), and KVM sees the POLLHUP and cleans up.
> 
> -------------------
> 
> In this new model, the POLLHUP would have gone out as soon as userspace
> closed the fd, even though the intended producer (the PCI device) and
> the consumer (the KVM guest) are still up and running.  This doesnt seem
> right to me.  Or am I missing something?

What you're doing there, is setting up a kernel-to-kernel (since 
userspace only role is to create the eventfd) communication, using a file* 
as accessory. That IMO is plain wrong.
If userspace is either the producer, or the consumer, and you need to 
handle userspace leaving the building, you need to:

	file = eventfd_fget(fd);
	ctx = eventfd_ctx_get(file); /* Eventually, if producer */
	eventfd_pollcb_register(file, ...);
	fput(file);

In your case of kernel-to-kernel scenario, why would you need eventfd at 
all, if userspace role in that model is simply to create it?
There are more effective ways to have in kernel communication channels, 
than resorting to userspace link facilities like eventfd.



- Davide


