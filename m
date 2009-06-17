Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbZFQRuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbZFQRuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZFQRup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:50:45 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:36252 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZFQRuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:50:44 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 17 Jun 2009 10:44:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
In-Reply-To: <4A3927C0.5060607@novell.com>
Message-ID: <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com>
 <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com>
 <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Gregory Haskins wrote:

> Can you elaborate?  I currently do not see how I could do the proposed
> concept inside of irqfd while still using eventfd.  Of course, that
> would be possible if we fork irqfd from eventfd,  and perhaps this is
> what you are proposing.  As previously stated I don't want to give up on
> the prospect of re-using it quite yet, so bear with me. :)
> 
> The issue with eventfd, as I see it, is that eventfd uses a
> spin_lock_irqsave (by virtue of the wait-queue stuff) across the
> "signal" callback (which today is implemented as a wake-up).  This
> spin_lock implicitly creates a non-preemptible critical section that
> occurs independently of whether eventfd_signal() itself is invoked from
> a sleepable context or not.
> 
> What I strive to achieve is to remove the creation of this internal
> critical section.  If eventfd_signal() is called from atomic context, so
> be it.  We will detect this in the callback and be forced to take the
> slow-path, and I am ok with that.  *But*, if eventfd_signal() (or
> f_ops->write(), for that matter) are called from a sleepable context
> *and* eventfd doesn't introduce its own critical section (such as with
> my srcu patch), we can potentially optimize within the callback by
> executing serially instead of deferring (e.g. via a workqueue).

Since when the scheduling (assuming it's not permanently running on 
another core due to high frequency work post) of a kernel thread is such 
a big impact that interfaces need to be redesigned for that?
How much the (possible, but not certain) kernel thread context switch time 
weighs in the overall KVM IRQ service time?



> It can!  :) This is not changing from whats in mainline today (covered
> above).

It can/could, if the signal() function takes very accurate care of doing 
the magic atomic check.



- Davide


