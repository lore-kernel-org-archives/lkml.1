Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZFVXAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZFVXAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZFVXAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:00:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49800 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZFVXAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:00:08 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 22 Jun 2009 15:53:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: Gregory Haskins <ghaskins@novell.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3FE445.4090204@gmail.com>
Message-ID: <alpine.DEB.1.10.0906221418510.10952@makko.or.mcafeemobile.com>
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com>
 <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com>
 <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com> <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com> <4A3FE445.4090204@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Gregory Haskins wrote:

> So up in userspace, the vbus pci-device would have an open reference to
> the kvm guest (derived from /dev/kvm) and an open reference to a vbus
> (derived from /dev/vbus).  Lets call these kvmfd, and vbusfd,
> respectively.  For something like an interrupt, we would hook the point
> where the PCI-MSI interrupt is assigned, and would do the following:
> 
> gsi = kvm_irq_route_gsi();
> fd = eventfd(0, 0);
> ioctl(kvmfd, KVM_IRQFD_ASSIGN, {fd, gsi});
> ioctl(vbusfd, VBUS_SHMSIGNAL_ASSIGN, {sigid, fd});
> 
> So userspace orchestrated the assignment of this one eventfd to a KVM
> consumer, and a VBUS producer.  The two subsystems do not care about the
> details of the other side of the link, per se.  VBUS just knows that it
> can eventfd_signal() its memory region to tell whomever is listening
> that it changed.  Likewise, KVM just knows to inject "gsi" when it gets
> signalled.  You could equally have given "fd" to a userspace thread for
> either producer or consumer roles, or any other combination.
> 
> If we were doing PCI-passthough, substitute the last SHMSIGNAL_ASSIGN
> ioctl call with some PCI_PASSTHROUGH_ASSIGN verb and you get the idea.
> 
> The important thing is that once this is established, userspace doesn't
> necessarily care about the fd anymore.  So now the question is: do we
> keep it around for other things?  Do we keep it around because we don't
> want KVM to see the POLLHUP, or do we address the "release" code so that
> it works even if userspace issued close(fd) at this point.  I am not
> sure what the answer is, but this is the scenario we are concerned with
> in this thread.  In the example above, vbus is free to produce events on
> its eventfd until it gets a SHMSIGNAL_DEASSIGN request.

I see.
The thing remains, that in order to reliably handle generic 
producer/consumer scenarios you'd need a reference counting similar to 
pipes, where the notion of producer and consumer is very well defined.
In your case, it'd be sufficent to expose an:

	int eventfd_wakeup(struct eventfd_ctx *ctx, void *key);

So that each end can signal, in an file* f_count independent way, when 
they're about to leave. Say with a new status bit.
The problem, that I felt coming since when I introduced the key-based 
wakeups, is that right now the "key" start to become a little restrictive 
in terms of amount of information carried by it.
If there are other key-aware waiters on "wqh", your new bit cannot 
conflict with existing ones, and you (and future users of the interface) 
will be polluting the global bit namespace.
Probably turning "key" into a pointer to a structure like:

	struct wakeup_key {
		unsigned long type;
		void *key;
	};

So the current:

	wake_up_poll(wq, POLLIN);

Would become:

	key.type = KT_POLLMASK;
	key.key = POLLIN;
	wake_up_key(wq, &key);

At that point the waiters (like poll/epoll) can simply discard the wakeup 
types they are not interested into (poll/epoll would care only about 
KT_POLLMASK), and something more than a simple bitmask can be carried by 
the wakups. Like:

	key.type = KT_SOMEDATA;
	key.key = &data;
	wake_up_key(wq, &key);

Of course, we could build another layer on top, to fit this model, but 
then we'd have the dual citizenship among normal wakeups and new-interface 
wakeups/signaling.
Another thing. Now that the interface exposes the eventfd_ctx context 
directly, the pollcb register/unregister does not have any reason to be 
inside eventfd (they're totally generic bits at that point), so my thought 
was about to drop them.



- Davide


