Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYJORgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYJORgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYJORgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:36:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbYJORgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:36:35 -0400
Date: Wed, 15 Oct 2008 10:36:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] SLOB memory ordering issue
In-Reply-To: <alpine.LFD.2.00.0810151028110.3288@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810151033170.3288@nehalem.linux-foundation.org>
References: <200810160334.13082.nickpiggin@yahoo.com.au> <1224089658.3316.218.camel@calx> <200810160410.49894.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0810151028110.3288@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Linus Torvalds wrote:
> 
> If you make an allocation visible to other CPU's, you would need to make 
> sure that allocation is stable with a smp_wmb() before you update the 
> pointer to that allocation.

Just to clarify a hopefully obvious issue..

The assumption here is that you don't protect things with locking. Of 
course, if all people accessing the new pointer always have the 
appropriate lock, then memory ordering never matters, since the locks take 
care of it.

So _most_ allocators obviously don't need to do any smp_wmb() at all. But 
the ones that expose things locklessly (where page tables are just one 
example) need to worry.

Again, this is yet another reason to not put things in the allocator. The 
allocator cannot know, and shouldn't care. For all the exact same reasons 
that the allocator cannot know and shouldn't care whether the ctor results 
in a 'final' version or whether the allocator will do some final fixups.

		Linus
