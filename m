Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbXCUN1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbXCUN1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXCUN1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:27:25 -0400
Received: from mx10.go2.pl ([193.17.41.74]:43208 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752829AbXCUN1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:27:21 -0400
Date: Wed, 21 Mar 2007 14:31:51 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       Christoph Lameter <clameter@sgi.com>, "ast\@domdv\.de" <ast@domdv.de>,
       "linux-kernel\@vger\.kernel\.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <20070321133151.GC1939@ff.dom.local>
References: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI> <20070321101143.GB1939@ff.dom.local> <84144f020703210513i37d1576erb7814483bcaad505@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020703210513i37d1576erb7814483bcaad505@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 02:13:52PM +0200, Pekka Enberg wrote:
> On 3/21/07, Jarek Poplawski <jarkao2@o2.pl> wrote:
> >I think Pekka was right (it looks he changed his mind now) something
> >should be done here. I think something like this should be a minimum:
> >
> >BUG_ON(!objp || virt_to_cache(objp) != cachep);
> >
> >to show distinctly what's going on.
> 
> No, if we were to add a NULL check in kmem_cache_free(), it should
> behave like kfree() does. Anyway, if you feel about this strongly I
> suspect the best solution is to add a __kmem_cache_free which does
> _not_ have the NULL check and convert those super-hot paths to use it.
> Sort of what Andrew suggested already.
> 

Are you sure there is no difference? Would this message
below be written? Would you waste youre time to write
the patch in this thread? Maybe even repostal of this
bug would be unnecessary - because somebody would have
seen in a minute something you analyzed at least 0,5h.

I don't say it's the best proposal - but at least:

1. we know the rules,
2. we save the diagnosing time for the real problem.

With  __kmem_cache_free you would set #1 I hope, but if
nobody would use this - debugging time wouldn't change.
This could be acceptable, if there were no problems
with fixing the errors. But there are problems - bugs
like this aren't fixed on time - maybe because people
waste too much time per bug?

If this path is so hot, there is other possibility:
- to write a comment about NULLs here,
- to require such checks were inserted earlier.

Why after this all there is no change in the bio_free?
This bio_free still is waiting to pass NULL bi_io_vecs
without any warning!
Why still no "nr_pages > 0" check in scsi_req_map_sg?
Was this patch so obvious - authors weren't so sure
(not talking about time)?

I think optimizations are good and possible: if there
is no bug in some place for 2 or 3 years - then OK.
But until there are such bugs - let from 1 driver only -
checks should definitely be added, even at a cost of
speed.

Cheers,
Jarek P. 
 

On 19-03-2007 09:00, Pekka Enberg wrote:
> On 3/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>         BUG_ON(!PageSlab(page));
>>
>> that's seriously screwed up.  Do you have CONFIG_DEBUG_SLAB enabled?  If
>> not, please enable it and retest.
> 
> This is scary. Looking at disassembly of the OOPS:
> 
> Disassembly of section .text:
> 
> 00000000 <.text>:
>   0:   5f                      pop    %edi
>   1:   c3                      ret
>   2:   57                      push   %edi
>   3:   89 c1                   mov    %eax,%ecx
>   5:   89 d7                   mov    %edx,%edi
>   7:   8d 92 00 00 00 40       lea    0x40000000(%edx),%edx
>   d:   56                      push   %esi
>   e:   c1 ea 0c                shr    $0xc,%edx
>  11:   53                      push   %ebx
>  12:   c1 e2 05                shl    $0x5,%edx
>  15:   03 15 40 5d 5a c0       add    0xc05a5d40,%edx
> 
> At this point, edx has the result of virt_to_page().
> 
>  1b:   8b 02                   mov    (%edx),%eax
>  1d:   f6 c4 40                test   $0x40,%ah
>  20:   74 03                   je     0x25
> 
> If it's a compound page, look up the real page from ->private.
> 
>  22:   8b 52 0c                mov    0xc(%edx),%edx
> 
> Now, reload page flags.
> 
>  25:   8b 02                   mov    (%edx),%eax
> 
> And test...
> 
>  27:   a8 80                   test   $0x80,%al
>  29:   75 04                   jne    0x2f
>  2b:   0f 0b                   ud2a
>  2d:   eb fe                   jmp    0x2d
>  2f:   39 4a 18                cmp    %ecx,0x18(%edx)
> 
> [snip, snip]
> 
> EIP is at kmem_cache_free+0x29/0x5a
> eax: c1800000   ebx: f0ae12c0   ecx: c18f73c0   edx: c1800000
> esi: c1919de0   edi: 00000000   ebp: 00001000   esp: f1fe7e14
> ds: 007b   es: 007b   ss: 0068
> 
> But somehow eax and edx have the same value 0xc1800000 here. Hmm?
> 
>                                   Pekka
