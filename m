Return-Path: <linux-kernel-owner+w=401wt.eu-S1761343AbZFPRyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbZFPRyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZFPRy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:54:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38401 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761249AbZFPRy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:54:27 -0400
Date: Tue, 16 Jun 2009 20:54:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based
	notifier interface
Message-ID: <20090616175300.GA24514@redhat.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37C592.2030407@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 12:17:22PM -0400, Gregory Haskins wrote:
> > Maybe I misunderstand what iosignalfd is - isn't it true that you get eventfd
> > and kvm will signal that when guest performs io write to a specific
> > address, and then drivers can get eventfd and poll it to detect
> > these writes?
> >   
> 
> Correct.
> 
> > If yes, you have no way to know that the other end of eventfd
> > is connected to kvm, so you don't know you can access current->mm.
> >   
> 
> Well, my intended use for them *does* know its connected to KVM. 

How does it know? You get a file descriptor and you even figure out it's an
eventfd. Now what? Any process can write there.

> Perhaps there will be others that do not in the future, but like I said
> it could be addressed as those actually arise.
> 
> 
> >   
> >> So since I cannot use it accurately for the hardirq/threaded-irq type
> >> case, and I don't actually need it for the iosignalfd case, I am not
> >> sure its the right direction (at least for now).  I do think it might
> >> have merit for syscal/vmexit uses outside of iosignalfd, but I do not
> >> see a current use-case for it so perhaps it can wait until one arises.
> >>
> >> -Greg
> >>     
> >
> > But, it addresses the CONFIG_PREEMPT off case, which your design doesn't
> > seem to.
> >   
> 
> Well, the problem is that it only addresses it partially in a limited
> set of circumstances, and doesn't address the broader problem.  I'll
> give you an example:
> 
> (First off, lets assume that we are not going to have
> eventfd_signal_task(), but rather eventfd_signal() with two option
> flags: EVENTFD_SIGNAL_CANSLEEP, and EVENTFD_SIGNAL_CURRENTVALID
> 
> Today vbus-enet has a rx-thread and a tx-thread at least partially
> because I need process-context to do the copy_to_user(other->mm) type
> stuff (and we will need similar for our virtio-net backend as well).  I
> also utilize irqfd to do interrupt injection.  Now, since I know that I
> have kthread_context, I could modify vbus-enet to inject interrupts with
> EVENTFD_SIGNAL_CANSLEEP set, and this is fine.  I know that is safe.
> 
> However, the problem is above that!  I would like to optimize out the
> tx-thread to begin with with a similar "can_sleep()" pattern whenever
> possible.
> 
> For instance, if the netif stack calls me to do a transmit and it
> happens to be in a sleepable context, it would be nice to just skip
> waking up the tx-thread.  I would therefore just do the
> copy_to_user(other->mm) + irqfd directly in the netif callback, thereby
> skipping the context switch.

What do you mean by copy_to_user(other->mm) here?  If you are going to switch
to another mm, then I think current->mm must be valid (I think it's not enough
that you can sleep). So preemptible() might not be enough.

-- 
MST
