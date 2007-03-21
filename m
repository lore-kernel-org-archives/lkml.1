Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbXCUBR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbXCUBR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 21:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXCUBR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 21:17:58 -0400
Received: from holomorphy.com ([66.93.40.71]:43146 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXCUBR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 21:17:58 -0400
Date: Tue, 20 Mar 2007 18:17:57 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Adam Litke <agl@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] [RFC] hugetlb: pagetable_operations API (V2)
Message-ID: <20070321011757.GD2986@holomorphy.com>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319200502.17168.17175.stgit@localhost.localdomain>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 01:05:02PM -0700, Adam Litke wrote:
> Andrew, given the favorable review of these patches the last time
> around, would you consider them for the -mm tree?  Does anyone else
> have any objections?

We need a new round of commentary for how it should integrate with
Nick Piggin's fault handling patches given that both introduce very
similar ->fault() methods, albeit at different places and for different
purposes.

I think things weren't entirely wrapped up last time but there was
general approval in concept and code-level issues had been gotten past.
I've forgotten the conclusion of hch and arjan's commentary on making
the pagetable operations mandatory. ISTR they were all cosmetic affairs
like that or whether they should be part of ->vm_ops as opposed to
fundamental issues.

The last thing I'd want to do is hold things back, so by no means
delay merging etc. on account of this, but I am curious on several
points. First, is there any demonstrable overhead to mandatory indirect
calls for the pagetable operations? Second, can case analysis for e.g.
file-backed vs. anon and/or COW vs. shared be avoided by the use of
the indirect function call, or more specifically, to any beneficial
effect? Well, I rearranged the code in such a manner ca. 2.6.6 so I
know the rearrangement is possible, but not the performance impact vs.
modern kernels, if any, never mind how the code ends up looking in
modern kernels. Third, could you use lmbench or some such to get direct
fork() and fault handling microbenchmarks? Kernel compiles are too
close to macrobenchmarks to say anything concrete there apart from that
other issues (e.g. SMP load balancing, NUMA, lock contention, etc.)
dominate indirect calls. If you have the time or interest to explore
any of these areas, I'd be very interested in hearing the results.

One thing I would like to see for sure is dropping the has_pt_op()
and pt_op() macros. The Linux-native convention is to open-code the
function pointer fetches, and the non-native convention is to wrap
things like defaulting (though they actually do something more involved)
in the analogue of pt_op() for the purposes of things like extensible
sets of operations bordering on OOP-ish method tables. So this ends up
as some sort of hybrid convention without the functionality of the
non-native call wrappers and without the clarity of open-coding. My
personal preference is that the function pointer table be mandatory and
the call to the the function pointer be unconditional and the type
dispatch accomplished entirely through the function pointers, but I'm
not particularly insistent about that.


-- wli
