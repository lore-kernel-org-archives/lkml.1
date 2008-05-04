Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYEDIzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYEDIzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYEDIyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:54:54 -0400
Received: from saeurebad.de ([85.214.36.134]:46131 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYEDIyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:54:53 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC 0/2] Rootmem: boot-time memory allocator
References: <20080503152502.191599824@symbol.fehenstaub.lan>
	<20080503175426.GB5292@elte.hu>
Date: Sun, 04 May 2008 10:54:45 +0200
In-Reply-To: <20080503175426.GB5292@elte.hu> (Ingo Molnar's message of "Sat, 3
	May 2008 19:54:26 +0200")
Message-ID: <87lk2qv48a.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar <mingo@elte.hu> writes:

> * Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> I was spending some time and work on the bootmem allocator the last 
>> few weeks and came to the conclusion that its current design is not 
>> appropriate anymore.
>> 
>> As Ingo said in another email, NUMA technologies will become weirder, 
>> nodes whose PFNs span other nodes for example and it makes bootmem 
>> code become an unreadable mess.
>> 
>> So I sat down two days ago and rewrote the allocator, here is the 
>> result: rootmem!
>
> hehe :-)
>
>> The biggest difference to the old design is that there is only one 
>> bitmap for all PFNs of all nodes together, so the overlapping PFN 
>> problems simply dissolve and fun like allocations crossing node 
>> boundaries work implicitely.  The new API requires every node used by 
>> the allocator to be registered and after that the bitmap gets 
>> allocated and the allocator enabled.
>> 
>> I chose to add a new allocator rather than replacing bootmem at once 
>> because that would have required all callsites to switch in one go, 
>> which would be a lot.  The new allocator can be adopted more slowly 
>> and I added a compatibility API for everything besides actually 
>> setting up the allocator.  When the last user dies, bootmem can be 
>> dropped completely (including pgdat->bdata, whee..)
>> 
>> The main ideas from bootmem have been stolen^W preserved but the new 
>> design allowed me to shrink the code a lot and express things more 
>> simple and clear:
>> 
>> $ sloc.awk < mm/bootmem.c
>> 455 lines of code, 65 lines of comments (520 lines total)
>> 
>> $ sloc.awk < mm/rootmem.c
>> 243 lines of code, 96 lines of comments (339 lines total)
>
> amazing!
>
> i'd still suggest to keep it all named bootmem though :-/ How about 
> bootmem2.c and then renaming it back to bootmem.c, once the last user is 
> gone? That would save people from having to rename whole chapters in 
> entire books ;-)

Hehe, I still have bootmem2.c flying around...  I was not sure if the
migration is easier with the same name or with a different name but the
API is mostly compatible in the end, so staying with bootmem should be
possible and it sounds way better...

	Hannes
