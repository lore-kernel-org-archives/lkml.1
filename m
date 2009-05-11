Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZEKOyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZEKOyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZEKOyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:54:41 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:50250 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbZEKOyk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:54:40 -0400
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
X-IronPort-AV: E=Sophos;i="4.40,328,1238968800";   d="scan'208";a="5629239"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: "'Andi Kleen'" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       linux-numa@vger.kernel.org, brice.goglin@inria.fr,
       "'Terboven, Christian'" <terboven@rz.rwth-aachen.de>,
       anmey@rz.rwth-aachen.de, "'Boris Bierbaum'" <boris@lfbs.rwth-aachen.de>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
In-reply-to: <87zldjn597.fsf@basil.nowhere.org>
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
Date: Mon, 11 May 2009 16:54:40 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <001501c9d248$69e2a870$3da7f950$@rwth-aachen.de>
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnSO5HuYG95Ox0vSfOQ9r4UBh4c3gAA7bZQ
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen [mailto:andi@firstfloor.org]
> 
> Stefan Lankes <lankes@lfbs.rwth-aachen.de> writes:
> >
> > [Patch 1/4]: Extend the system call madvise with a new parameter
> > MADV_ACCESS_LWP (the same as used in Solaris). The specified memory
> area
> 
> Linux does NUMA memory policies in mbind(), not madvise()
> Also if there's a new NUMA policy it should be in the standard
> Linux NUMA memory policy frame work, not inventing a new one

By default, mbind only has an effect on new allocations. I think that this
is different from what we need for applications with dynamic memory access
patterns. The app gives the kernel a hint that the access pattern has been
changed and the kernel has to redistribute the pages which are already
allocated.

> > [Patch 4/4]: This part of the patch adds some counters to detect
> migration
> > errors and publishes these counters via /proc/vmstat. Besides this,
> the
> > Kconfig file is extend with the parameter
> CONFIG_AFFINITY_ON_NEXT_TOUCH.
> >
> > With this patch, the kernel reduces the overhead of page distribution
> via
> > "affinity-on-next-touch" from 2518ms to 366ms compared to the user-
> level
> 
> The interesting part is less how much faster it is compared to an user
> space implementation, but how much this migrate on touch approach
> helps in general compared to already existing policies. Some hard
> numbers on that would appreciated.
> 
> Note that for the OpenMP case old kernels sometimes had trouble because
> the threads tended to be not scheduled to the final target CPU
> on the first time slice so the memory was often first-touched
> on the wrong node. Later kernels avoided that by more aggressively
> moving the threads early.
> 

"affinity-on-next-touch" is not a data distribution strategy for
applications with a static access pattern. If the access pattern changed,
you could initialize the "affinity-on-next-touch" mechanism and afterwards
the kernel redistributes the pages. 

For instance, Norden's PDE solvers using adaptive mesh refinements (AMR) [1]
is an application with a dynamic access pattern. We use this example to
evaluate the performance of our patch. We ran this solver on our
quad-socket, dual-core Opteron 875 (2.2GHz) system running CentOS 5.2. The
code was already optimized for NUMA architectures. Before the arrays are
initialized, the threads are bound to one core. In our test case, the solver
needs 5318s. If we use our kernel extension, the solver needs 4489s. 

Currently, we are testing some other apps.

Stefan

[1] Norden, M., Löf, H., Rantakokko, J., Holmgren, S.: Geographical Locality
and Dynamic Data Migration for OpenMP Implementations of Adaptive PDE
Solvers. In: Proceedings of the 2nd International Workshop on OpenMP
(IWOMP), Reims, France (June 2006) 382–393


