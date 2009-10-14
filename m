Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbZJNOW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbZJNOW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbZJNOWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:22:25 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:37223 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756415AbZJNOWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:22:24 -0400
Date: Wed, 14 Oct 2009 10:14:25 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
In-Reply-To: <4AD53022.2050309@kernel.org>
Message-ID: <alpine.DEB.1.10.0910141008440.28461@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org> <4AD3E23B.8020103@kernel.org> <alpine.DEB.1.10.0910131037420.21608@gentwo.org>
 <4AD4950A.6050201@kernel.org> <alpine.DEB.1.10.0910131117060.8088@gentwo.org> <4AD53022.2050309@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Tejun Heo wrote:

> > __this_cpu_ptr could be converted to this_cpu_ptr but I think the __ are
> > useful there too to show that we are in a preempt section.
>
> That doesn't make much sense.  __ for this_cpu_ptr() means "bypass
> sanity check, we're knowingly violating the required conditions" not
> "we know sanity checks will pass here".

Are you defining what __ means for this_cpu_ptr?

> > The calls to raw_smp_processor_id and smp_processor_id() are only useful
> > in the fallback case. There is no need for those if the arch has a way to
> > provide the current percpu offset. So we in effect have two meanings of __
> > right now.
> >
> > 1. We do not care about the preempt state (thus we call
> > raw_smp_processor_id so that the preempt state does not trigger)
> >
> > 2. We do not need to disable preempt before the operation.
> >
> > __this_cpu_ptr only implies 1. __this_cpu_add uses 1 and 2.
>
> Yeah, we need to clean it up.  The naming is too confusing.

Its consistent if __ means both 1 and 2. If we want to distinguish it then
we may want to create raw_this_cpu_xx which means that we do not call
smp_processor_id() on fallback but raw_smp_processor_id(). Does not
matter if the arch provides a per cpu offset.

This would mean duplicating all the macros. The use of raw_this_cpu_xx
should be rare so maybe the best approach is to say that __ means only
that the macro does not need to disable preempt but it still checks for
preemption being off. Then audit the __this_cpu_xx uses and see if there
are any that require a raw_ variant.

The vm event counters require both no check and no preempt since they can
be implemented in a racy way.




