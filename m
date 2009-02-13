Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbZBMBjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbZBMBjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 20:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZBMBjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 20:39:06 -0500
Received: from gw.goop.org ([64.81.55.164]:60124 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZBMBjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 20:39:04 -0500
Message-ID: <4994CF35.60507@goop.org>
Date: Thu, 12 Feb 2009 17:39:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org
Subject: Re: [PATCH] mm: disable preemption in apply_to_pte_range
References: <4994BCF0.30005@goop.org>	<4994C052.9060907@goop.org> <20090212165539.5ce51468.akpm@linux-foundation.org>
In-Reply-To: <20090212165539.5ce51468.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> This weakens the apply_to_page_range() utility by newly requiring that
> the callback function be callable under preempt_disable() if the target
> mm is init_mm.  I guess we can live with that.
>
> It's OK for the two present in-tree callers.  There might of course be
> out-of-tree callers which break, but it is unlikely.
>
> The patch should include a comment explaining why there is a random
> preempt_disable() in this function.
>   

I cuddled them up to their corresponding arch_X_lazy_mmu_mode calls to 
get this across, but I guess some prose would be helpful here.

> Why is apply_to_page_range() exported to modules, btw?  I can find no
> modules which need it.  Unexporting that function would make the
> proposed weakening even less serious.
>   

I have some yet-to-be upstreamed code that can use it from modules.

> The patch assumes that
> arch_enter_lazy_mmu_mode()/arch_leave_lazy_mmu_mode() must have
> preemption disabled for all architectures.  Is this a sensible
> assumption?
>   

In general the model for lazy updates is that you're batching the 
updates in some queue somewhere, which is almost certainly a piece of 
percpu state being maintained by someone.  Its therefore broken and/or 
meaningless to have the code making the updates wandering between cpus 
for the duration of the lazy updates.

> If so, should we do the preempt_disable/enable within those functions? 
> Probably not worth the cost, I guess.

The specific rules are that 
arch_enter_lazy_mmu_mode()/arch_leave_lazy_mmu_mode() require you to be 
holding the appropriate pte locks for the ptes you're updating, so 
preemption is naturally disabled in that case.

This all goes a bit strange with init_mm's non-requirement for taking 
pte locks.  The caller has to arrange for some kind of serialization on 
updating the range in question, and that could be a mutex.  Explicitly 
disabling preemption in enter_lazy_mmu_mode would make sense for this 
case, but it would be redundant for the common case of batched updates 
to usermode ptes.

    J
