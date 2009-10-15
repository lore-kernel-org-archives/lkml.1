Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbZJOHtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbZJOHtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZJOHtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:49:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:58515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbZJOHtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:49:01 -0400
Message-ID: <4AD6D3A0.6040706@kernel.org>
Date: Thu, 15 Oct 2009 16:47:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org> <4AD3E23B.8020103@kernel.org> <alpine.DEB.1.10.0910131037420.21608@gentwo.org> <4AD4950A.6050201@kernel.org> <alpine.DEB.1.10.0910131117060.8088@gentwo.org> <4AD53022.2050309@kernel.org> <alpine.DEB.1.10.0910141008440.28461@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910141008440.28461@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 07:47:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 14 Oct 2009, Tejun Heo wrote:
> 
>>> __this_cpu_ptr could be converted to this_cpu_ptr but I think the __ are
>>> useful there too to show that we are in a preempt section.
>> That doesn't make much sense.  __ for this_cpu_ptr() means "bypass
>> sanity check, we're knowingly violating the required conditions" not
>> "we know sanity checks will pass here".
> 
> Are you defining what __ means for this_cpu_ptr?

I was basically stating the different between raw_smp_processor_id()
and smp_processor_id() which I thought applied the same to
__this_cpu_ptr() and this_cpu_ptr().

>>> The calls to raw_smp_processor_id and smp_processor_id() are only useful
>>> in the fallback case. There is no need for those if the arch has a way to
>>> provide the current percpu offset. So we in effect have two meanings of __
>>> right now.
>>>
>>> 1. We do not care about the preempt state (thus we call
>>> raw_smp_processor_id so that the preempt state does not trigger)
>>>
>>> 2. We do not need to disable preempt before the operation.
>>>
>>> __this_cpu_ptr only implies 1. __this_cpu_add uses 1 and 2.
>>
>> Yeah, we need to clean it up.  The naming is too confusing.
> 
> Its consistent if __ means both 1 and 2. If we want to distinguish it then
> we may want to create raw_this_cpu_xx which means that we do not call
> smp_processor_id() on fallback but raw_smp_processor_id(). Does not
> matter if the arch provides a per cpu offset.
> 
> This would mean duplicating all the macros. The use of raw_this_cpu_xx
> should be rare so maybe the best approach is to say that __ means only
> that the macro does not need to disable preempt but it still checks for
> preemption being off. Then audit the __this_cpu_xx uses and see if there
> are any that require a raw_ variant.
> 
> The vm event counters require both no check and no preempt since they can
> be implemented in a racy way.

The biggest grief I have is that the meaning of __ is different among
different accessors.  If that can be cleared up, we would be in much
better shape without adding any extra macros.  Can we just remove all
__'s and use meaningful pre or suffixes like raw or irq or whatever?

Thanks.

-- 
tejun
