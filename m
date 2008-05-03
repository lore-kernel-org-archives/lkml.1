Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbYECRyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbYECRyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYECRyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:54:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbYECRym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:54:42 -0400
Date: Sat, 3 May 2008 19:54:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC 0/2] Rootmem: boot-time memory allocator
Message-ID: <20080503175426.GB5292@elte.hu>
References: <20080503152502.191599824@symbol.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503152502.191599824@symbol.fehenstaub.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@saeurebad.de> wrote:

> I was spending some time and work on the bootmem allocator the last 
> few weeks and came to the conclusion that its current design is not 
> appropriate anymore.
> 
> As Ingo said in another email, NUMA technologies will become weirder, 
> nodes whose PFNs span other nodes for example and it makes bootmem 
> code become an unreadable mess.
> 
> So I sat down two days ago and rewrote the allocator, here is the 
> result: rootmem!

hehe :-)

> The biggest difference to the old design is that there is only one 
> bitmap for all PFNs of all nodes together, so the overlapping PFN 
> problems simply dissolve and fun like allocations crossing node 
> boundaries work implicitely.  The new API requires every node used by 
> the allocator to be registered and after that the bitmap gets 
> allocated and the allocator enabled.
> 
> I chose to add a new allocator rather than replacing bootmem at once 
> because that would have required all callsites to switch in one go, 
> which would be a lot.  The new allocator can be adopted more slowly 
> and I added a compatibility API for everything besides actually 
> setting up the allocator.  When the last user dies, bootmem can be 
> dropped completely (including pgdat->bdata, whee..)
> 
> The main ideas from bootmem have been stolen^W preserved but the new 
> design allowed me to shrink the code a lot and express things more 
> simple and clear:
> 
> $ sloc.awk < mm/bootmem.c
> 455 lines of code, 65 lines of comments (520 lines total)
> 
> $ sloc.awk < mm/rootmem.c
> 243 lines of code, 96 lines of comments (339 lines total)

amazing!

i'd still suggest to keep it all named bootmem though :-/ How about 
bootmem2.c and then renaming it back to bootmem.c, once the last user is 
gone? That would save people from having to rename whole chapters in 
entire books ;-)

	Ingo
