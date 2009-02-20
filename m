Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZBTDJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZBTDJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZBTDJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:09:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:44787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZBTDJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:09:48 -0500
Message-ID: <499E1E99.6030508@kernel.org>
Date: Fri, 20 Feb 2009 12:08:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <200902192121.55157.rusty@rustcorp.com.au> <20090219110631.GJ2354@elte.hu> <200902192244.15055.rusty@rustcorp.com.au>
In-Reply-To: <200902192244.15055.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 03:07:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>>>> Rusty, if the fixes are fine with you i can put those two 
>>>> commits into tip/core/urgent straight away, the full string of 
>>>> 10 commits into tip/core/percpu and thus we'd avoid duplicate 
>>>> (or even conflicting) commits.
>>> No, the second one is not .29 material; it's a nice, but 
>>> theoretical, fix.
>> Can it never trigger?
> 
> Actually, checked again.  It's not even necessary AFAICT (tho a comment
> would be nice):
> 
> 	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
> 		/* Extra for alignment requirement. */
> 		extra = ALIGN((unsigned long)ptr, align) - (unsigned long)ptr;
> 		BUG_ON(i == 0 && extra != 0);
> 
> 		if (pcpu_size[i] < 0 || pcpu_size[i] < extra + size)
> 			continue;
> 
> 		/* Transfer extra to previous block. */
> 		if (pcpu_size[i-1] < 0)
> 			pcpu_size[i-1] -= extra;
> 		else
> 			pcpu_size[i-1] += extra;
> 
> pcpu_size[0] is *always* negative: it's marked allocated at initialization
> (it's the static per-cpu allocations).
> 
> Sorry I didn't examine more closely,

Ah... okay.  Right.  I took the code and used it in the chunk area
allocator where 0 isn't guaranteed to be occupied and saw the problem
triggering and then assumed the modalloc allocator shared the same
problem.  So, unnecessary fix but I think it really needs some
explanation.

What to do about #tj-percpu?  Ingo, do you want me to rebase tree sans
the second one?

Thanks.

-- 
tejun
