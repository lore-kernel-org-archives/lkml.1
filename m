Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbZFYUXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbZFYUXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZFYUW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:22:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754422AbZFYUW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:22:57 -0400
Date: Thu, 25 Jun 2009 13:22:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <alpine.LFD.2.01.0906251259430.3605@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906251317570.3605@localhost.localdomain>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.LFD.2.01.0906251259430.3605@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, Linus Torvalds wrote:
> 
> Whether these are important to you or not, I dunno. I actually suspect 
> that we might want a combination of "high priority + allow memory 
> freeing", which would be
> 
> 	#define GFP_CRITICAL (__GFP_HIGH | __GFP_WAIT)

Actually, that doesn't work quite the way I intended.

The current page allocator screws up, and doesn't allow us to do this 
(well, you _can_ combine the flags, but they don't mean what they mean on 
their own). If you have the WAIT flag set, the page allocator will not set 
the ALLOC_HARDER bit, so it turns out that GFP_ATOMIC (__GFP_HIGH on its 
own) sometimes actually allows more allocations than the above 
GFP_CRITICAL would.

It might make more sense to make a __GFP_WAIT allocation set the 
ALLOC_HARDER bit _if_ it repeats. The problem with doing a loop of 
allocations outside of the page allocator is that you then miss the 
subtlety of "try increasingly harder" that the page allocator internally 
does (well, right now, the "increasingly harder" only exists for the 
try-to-free path, but we could certainly have it for the try-to-allocate 
side too)

			Linus
