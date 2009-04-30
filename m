Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbZD3NtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbZD3NtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763420AbZD3NsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:48:18 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:50412 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763193AbZD3NsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:48:14 -0400
Date: Thu, 30 Apr 2009 09:38:14 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca,
       Andrew Morton <akpm@linux-foundation.org>, thomas.pi@arcor.dea,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430065055.GA16277@elte.hu>
Message-ID: <alpine.DEB.1.10.0904300926530.22262@qirst.com>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Ingo Molnar wrote:

> > I see however that it's only guaranteed to be atomic wrt preemption.
>
> That's really only true for the non-x86 fallback defines. If we so
> decide, we could make the fallbacks in asm-generic/percpu.h irq-safe

The fallbacks have different semantics and therefore we cannot rely on
irq safeness in the core code when using the x86 cpu ops.

> nmi-safe isnt a big issue (we have no NMI code that interacts with
> MM counters) - and we could make them irq-safe by fixing the
> wrapper. (and on x86 they are NMI-safe too.)

There are also context in which you alrady are preempt safe and where the
per cpu ops do not need to go through the prremption hoops.

This means it would be best to have 3 variants for 3 different contexts in
the core code:

1. Need irq safety
2. Need preempt safety
3. We know the operation is safe due to preemption already having been
disabled or irqs are not enabled.

The 3 variants on x86 generate the same instructions. On other platforms
they would need to be able to fallback in various way depending on the
availability of instructions that are atomic vs. preempt or irqs.

http://thread.gmane.org/gmane.linux.kernel.cross-arch/1124
http://lwn.net/Articles/284526/

