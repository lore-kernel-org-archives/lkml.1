Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZFWBYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZFWBYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZFWBYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:24:06 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58158 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbZFWBYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:24:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 22 Jun 2009 18:17:56 -0700 (PDT)
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
In-Reply-To: <4A4029F7.6070502@gmail.com>
Message-ID: <alpine.DEB.1.10.0906221808010.10952@makko.or.mcafeemobile.com>
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com>
 <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com>
 <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com> <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com> <4A3FE445.4090204@gmail.com> <alpine.DEB.1.10.0906221418510.10952@makko.or.mcafeemobile.com> <4A4029F7.6070502@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Mon, 22 Jun 2009, Gregory Haskins wrote:
> >
> >   
> >> So up in userspace, the vbus pci-device would have an open reference to
> >> the kvm guest (derived from /dev/kvm) and an open reference to a vbus
> >> (derived from /dev/vbus).  Lets call these kvmfd, and vbusfd,
> >> respectively.  For something like an interrupt, we would hook the point
> >> where the PCI-MSI interrupt is assigned, and would do the following:
> >>
> >> gsi = kvm_irq_route_gsi();
> >> fd = eventfd(0, 0);
> >> ioctl(kvmfd, KVM_IRQFD_ASSIGN, {fd, gsi});
> >> ioctl(vbusfd, VBUS_SHMSIGNAL_ASSIGN, {sigid, fd});
> >>
> >> So userspace orchestrated the assignment of this one eventfd to a KVM
> >> consumer, and a VBUS producer.  The two subsystems do not care about the
> >> details of the other side of the link, per se.  VBUS just knows that it
> >> can eventfd_signal() its memory region to tell whomever is listening
> >> that it changed.  Likewise, KVM just knows to inject "gsi" when it gets
> >> signalled.  You could equally have given "fd" to a userspace thread for
> >> either producer or consumer roles, or any other combination.
> >>
> >> If we were doing PCI-passthough, substitute the last SHMSIGNAL_ASSIGN
> >> ioctl call with some PCI_PASSTHROUGH_ASSIGN verb and you get the idea.
> >>
> >> The important thing is that once this is established, userspace doesn't
> >> necessarily care about the fd anymore.  So now the question is: do we
> >> keep it around for other things?  Do we keep it around because we don't
> >> want KVM to see the POLLHUP, or do we address the "release" code so that
> >> it works even if userspace issued close(fd) at this point.  I am not
> >> sure what the answer is, but this is the scenario we are concerned with
> >> in this thread.  In the example above, vbus is free to produce events on
> >> its eventfd until it gets a SHMSIGNAL_DEASSIGN request.
> >>     
> >
> > I see.
> > The thing remains, that in order to reliably handle generic 
> > producer/consumer scenarios you'd need a reference counting similar to 
> > pipes, where the notion of producer and consumer is very well defined.
> >   
> 
> I see your point.
> 
> Well, I think the more important thing here is that we address the
> races, and add support for DEASSIGN.  We can do both of those things
> with any of the patches that you and I have been kicking around.  So
> what I propose is that we move forward with whatever patch you bless as
> proper for now.  This producer-release issue is pretty minor in the
> grand scheme of things.  We can always just have userspace hold the fd.

Is it a real problem? Can it be decently handled on the KVM side?
Reason I'm asking, is that I wouldn't want to change the interface, only 
to find it unsuitable a few weeks later.




> I can either take in the last one you sent, or it sounds like you wanted
> to possibly do another round of cleanup?  Whatever the case may be, let
> me know and we can coordinate with Andrew/Avi on what tree to pull it
> into.  It sounds like riding in kvm.git is the perhaps the most logical.

Yes, I'd like to drop the pollcb bits (that you can implement KVM-side), 
at least.
And yes, going kvm.git is probably the best path.



- Davide


