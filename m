Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZFVSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZFVSrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZFVSrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:47:01 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42676 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZFVSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:47:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 22 Jun 2009 11:40:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3FCDF2.3010903@novell.com>
Message-ID: <alpine.DEB.1.10.0906221132210.10952@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com> <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com>
 <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com>
 <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com>
 <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <4A3FCDF2.3010903@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Gregory Haskins wrote:

> The general thesis is for decoupling of the two subsystems.  In order to
> do this, you need some form of polymorphism and an intermediate "handle"
> mechanism which is userspace friendly.  File-descriptors already fit
> this role neatly, with the "int fd" being the handle, and the f_ops
> being the polymorphic interface.  Eventfd is of course, a subclass of
> this concept in that it has these same general properties but with
> signaling semantics (non-blocking collapsible events, etc).
> 
> Say, for example, you wanted disk IO completion events to generate an
> interrupt into a guest.  One way to do this would, of course, modify all
> the disk-io code so it knows how to directly inject a KVM guest
> interrupt.   While this would work, someone would undoubtedly get flamed
> for such a suggestion ;)
> 
> Another way to do it is to treat the AIO eventfd as the hook point. 
> IIUC AIO already knows how to be an eventfd producer.  KVM, by virtue of
> irqfd, already knows how to be an eventfd consumer.  So now kvm can
> consume AIO, or it can consume userspace events equally well, and
> without modification.  Neither side needs to know about the other per
> se, other than the details on how to use the eventfd interface.
> 
> Don't get me wrong:  We expect userspace to use all this stuff too.  I
> just expect that we will see all permutations of producer/consumer +
> userspace/kernel combinations, so I want to retain that "all producers
> have left" notification feature set.  Today eventfd supports producers
> or consumers in userspace, and producers in the kernel.  This new work
> we are doing adds consumer support in the kernel.  Kernel to kernel is
> just a natural extension of that.

A file* is the VFS link between userspace and the kernel. Is not a magical 
polymorphic interface to be used for whatever kernel side reasons.
Basing a kernel internal API over it is flawed.
On top of that, a single reference count does not put you on cover about 
the possible combinations of producers and consumers. For that, you'd need 
a pipe-like reference handling logic, that is way far from the eventfd scope.
So please stop making hypothetical cases about interface usages, and 
*when* we will have a real case, we'll see what the better handling for it 
will be.



- Davide


