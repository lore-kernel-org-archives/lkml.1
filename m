Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYEDI51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYEDI51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYEDI5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:57:19 -0400
Received: from saeurebad.de ([85.214.36.134]:46147 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYEDI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:57:18 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC 0/2] Rootmem: boot-time memory allocator
References: <20080503152502.191599824@symbol.fehenstaub.lan>
	<20080503175426.GB5292@elte.hu>
	<86802c440805032106t4d020838v39aaf93309003cdb@mail.gmail.com>
Date: Sun, 04 May 2008 10:57:11 +0200
In-Reply-To: <86802c440805032106t4d020838v39aaf93309003cdb@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 3 May 2008 21:06:02 -0700")
Message-ID: <87hcdev448.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Sat, May 3, 2008 at 10:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>>  * Johannes Weiner <hannes@saeurebad.de> wrote:
>>
>>  > I was spending some time and work on the bootmem allocator the last
>>  > few weeks and came to the conclusion that its current design is not
>>  > appropriate anymore.
>>  >
>>  > As Ingo said in another email, NUMA technologies will become weirder,
>>  > nodes whose PFNs span other nodes for example and it makes bootmem
>>  > code become an unreadable mess.
>>  >
>>  > So I sat down two days ago and rewrote the allocator, here is the
>>  > result: rootmem!
>>
>>  hehe :-)
>>
>>
>>  > The biggest difference to the old design is that there is only one
>>  > bitmap for all PFNs of all nodes together, so the overlapping PFN
>>  > problems simply dissolve and fun like allocations crossing node
>>  > boundaries work implicitely.  The new API requires every node used by
>>  > the allocator to be registered and after that the bitmap gets
>>  > allocated and the allocator enabled.
>>  >
>>  > I chose to add a new allocator rather than replacing bootmem at once
>>  > because that would have required all callsites to switch in one go,
>>  > which would be a lot.  The new allocator can be adopted more slowly
>>  > and I added a compatibility API for everything besides actually
>>  > setting up the allocator.  When the last user dies, bootmem can be
>>  > dropped completely (including pgdat->bdata, whee..)
>>  >
>>  > The main ideas from bootmem have been stolen^W preserved but the new
>>  > design allowed me to shrink the code a lot and express things more
>>  > simple and clear:
>>  >
>>  > $ sloc.awk < mm/bootmem.c
>>  > 455 lines of code, 65 lines of comments (520 lines total)
>>  >
>>  > $ sloc.awk < mm/rootmem.c
>>  > 243 lines of code, 96 lines of comments (339 lines total)
>>
>>  amazing!
>>
>>  i'd still suggest to keep it all named bootmem though :-/ How about
>>  bootmem2.c and then renaming it back to bootmem.c, once the last user is
>>  gone? That would save people from having to rename whole chapters in
>>  entire books ;-)
>
> for spanning support node0:0-2g, 4-6g; node1: 2-4g, 6-8g, could have
> some problem.

Could you eleborate on that?

> +/*
> + * rootmem_register_node - register a node to rootmem
> + * @nid: node id
> + * @start: first pfn on the node
> + * @end: first pfn after the node
> + *
> + * This function must not be called anymore if the allocator
> + * is already up and running (rootmem_setup() has been called).
> + */
> +void __init rootmem_register_node(int nid, unsigned long start,
> +                       unsigned long end)
> +{
> +       BUG_ON(rootmem_functional);
> +
> +       if (start < rootmem_min_pfn)
> +               rootmem_min_pfn = start;
> +       if (end > rootmem_max_pfn)
> +               rootmem_max_pfn = end;
> +
> +       rootmem_node_pages[nid] = end - start;
> +       rootmem_node_offsets[nid] = start;
> +       rootmem_nr_nodes++;
> +}
>
> could change rootmem_node_pages/offsets to be struct array with
> offset, pages, and nid. and every node could several struct. and whole
> array should be sorted with nid.

The whole point is to be agnostic about weird NUMA configs.  Right now,
I am pretty proud of the simple data structures and I would avoid
blowing them up again unless there is a hard reason to do so.

	Hannes
