Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbZEOD1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbZEOD1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZEOD1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:27:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54332 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbZEOD1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:27:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 14 May 2009 20:22:20 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, viro@ZenIV.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v7 2/3] kvm: add support for irqfd via eventfd-notification
 interface
In-Reply-To: <4A0C3E54.1090109@novell.com>
Message-ID: <alpine.DEB.1.10.0905142016590.7574@makko.or.mcafeemobile.com>
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182655.26131.53824.stgit@dev.haskins.net> <4A0BFF13.9090802@redhat.com> <4A0C3E54.1090109@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Gregory Haskins wrote:

> Avi Kivity wrote:
> > Gregory Haskins wrote:
> >> KVM provides a complete virtual system environment for guests, including
> >> support for injecting interrupts modeled after the real
> >> exception/interrupt
> >> facilities present on the native platform (such as the IDT on x86).
> >> Virtual interrupts can come from a variety of sources (emulated devices,
> >> pass-through devices, etc) but all must be injected to the guest via
> >> the KVM infrastructure.  This patch adds a new mechanism to inject a
> >> specific
> >> interrupt to a guest using a decoupled eventfd mechnanism:  Any legal
> >> signal
> >> on the irqfd (using eventfd semantics from either userspace or
> >> kernel) will
> >> translate into an injected interrupt in the guest at the next available
> >> interrupt window.
> >>
> >> +
> >> +static void
> >> +irqfd_inject(struct work_struct *work)
> >> +{
> >> +    struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
> >> +    struct kvm *kvm = irqfd->kvm;
> >> +
> >>   
> >
> >
> > I think you need to ->read() from the irqfd, otherwise the count will
> > never clear.
> 
> Yeah, and this is a disavantage to using eventfd vs a custom anon-fd
> implementation.
> 
> However, the count is really only there for deciding whether to sleep a
> traditional eventfd recipient which doesn't really apply in this
> application.  I suppose we could try to invoke the read method (or add a
> new method to eventfd to allow it to be cleared independent of the
> f_ops->read() (ala eventfd_signal() vs f_ops->write()).  I'm not
> convinced we really need to worry about it, though.  IMO we can just let
> the count accumulate.
> 
> But if you insist this loose end should be addressed, perhaps Davide has
> some thoughts on how to best do this?

The counter is 64bit, so at 1M IRQ/s will take about 585K years to 
saturate. But from a symmetry POV, it may be better to clear it. Maybe 
with a kernel-side eventfd_read()?


- Davide


