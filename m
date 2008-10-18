Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYJRC6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYJRC6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 22:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYJRC6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 22:58:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbYJRC57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 22:57:59 -0400
Date: Fri, 17 Oct 2008 19:57:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch] mm: fix anon_vma races
In-Reply-To: <18681.20241.347889.843669@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.2.00.0810171954050.3438@nehalem.linux-foundation.org>
References: <20081016041033.GB10371@wotan.suse.de> <Pine.LNX.4.64.0810172300280.30871@blonde.site> <alpine.LFD.2.00.0810171549310.3438@nehalem.linux-foundation.org> <Pine.LNX.4.64.0810180045370.8995@blonde.site> <20081018015323.GA11149@wotan.suse.de>
 <18681.20241.347889.843669@cargo.ozlabs.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Oct 2008, Paul Mackerras wrote:
> 
> Not sure what you mean by causal consistency, but I assume it's the
> same as saying that barriers give cumulative ordering, as described on
> page 413 of the Power Architecture V2.05 document at:

I'm pretty sure that everybody but alpha is ok.

And alpha needs the smp_read_barrier_depends() not because it doesn't 
really support causality, but because each CPU internally doesn't 
guarantee that they handle the cache invalidates in-order without a 
barrier. 

So without the smp_read_barrier_depends(), alpha will actually have the 
proper causal relationships (cachelines will move to exclusive state on 
CPU0 in the right order and others will see the causality), but because 
CPU2 may see the stale data from not even having invalidated the 
"anon_vma.initialized" because the cache invalidation queue hadn't been 
flushed in order.

Alpha is insane. And the odd man out.

			Linus
