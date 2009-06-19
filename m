Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbZFSWxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbZFSWxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759531AbZFSWxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:53:20 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51465 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbZFSWxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:53:19 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 19 Jun 2009 15:47:11 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com>
Message-ID: <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
 <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Davide Libenzi wrote:

> On Fri, 19 Jun 2009, Gregory Haskins wrote:
> 
> > I am fairly confident it is not that simple after having thought about
> > this issue over the last few days.  But I've been wrong in the past. 
> > Propose a patch and I will review it for races/correctness, if you
> > like.  Perhaps a combination of that plus your asymmetrical locking
> > scheme would work.  One of the challenges you will hit is avoiding ABBA
> > between your "get" lock and the wqh, but good luck!
> 
> A patch for what? The eventfd patch is a one-liner.
> It seems hard to believe that the thing cannot be handled on your side. 
> Once the wake_up_locked() is turned into a wake_up(), what other races are 
> there?

AFAICS, the IRQfd code simply registers the callback to ->poll() and waits 
for two events.
In the POLLIN event, you schedule_work(&irqfd->inject) and there are no 
races there AFAICS (you basically do not care of anything eventfd memory 
related at all).
For POLLHUP, you do:

	spin_lock(irqfd->slock);
	if (irqfd->wqh)
		schedule_work(&irqfd->inject);
	irqfd->wqh = NULL;
	spin_unlock(irqfd->slock);

In your work function you notice the POLLHUP condition and take proper 
action (dunno what it is in your case).
In your kvm_irqfd_release() function:

	spin_lock(irqfd->slock);
	if (irqfd->wqh)
		remove_wait_queue(irqfd->wqh, &irqfd->wait);
	irqfd->wqh = NULL;
	spin_unlock(irqfd->slock);

Any races in there?



- Davide


