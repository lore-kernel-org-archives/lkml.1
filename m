Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0BLMAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:00:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59326 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0BLMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:00:05 -0500
Date: Fri, 12 Feb 2010 09:59:47 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: perf annotate SEGVs
Message-ID: <20100212115947.GC8589@ghostprotocols.net>
References: <20100212052427.GK3399@kryten> <20100212081724.GA13355@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212081724.GA13355@kryten>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 12, 2010 at 07:17:24PM +1100, Anton Blanchard escreveu:
> I think I understand a problem in perf annotate where I see random corruption
> (rb tree issues, glibc malloc failures etc).
> 
> The issue happens with zero length symbols, in this particular case they
> are kernel functions written entirely in assembly, eg .copy_4K_page,
> .__copy_tofrom_user and .memcpy:
> 
>    Num:    Value          Size Type    Bind   Vis      Ndx Name
>  63516: c00000000004a774   212 FUNC    GLOBAL DEFAULT    1 .devm_ioremap_prot
>  69095: c00000000004a848     0 FUNC    GLOBAL DEFAULT    1 .copy_4K_page
>  62002: c00000000004aa00     0 FUNC    GLOBAL DEFAULT    1 .__copy_tofrom_user
>  50576: c00000000004b000     0 FUNC    GLOBAL DEFAULT    1 .memcpy
>  69557: c00000000004b278   176 FUNC    GLOBAL DEFAULT    1 .copy_in_user
>  51841: c00000000004b328   144 FUNC    GLOBAL DEFAULT    1 .copy_to_user
> 
> In symbol_filter we look at the length of each symbol:
> 
> static int symbol_filter(struct map *map __used, struct symb
> ...
>                 const int size = (sizeof(*priv->hist) +
>                                  (sym->end - sym->start) * sizeof(u64));
>  
> And since start == end we create 0 bytes of space for the ip[] array.
> 
> Later on in hist_hit we then start indexing off this array:
> 
>        h->ip[offset]++;
> 
> Which then corrupts whatever is next in memory. With large assembly functions
> we corrupt a lot :)
> 
> How should we fix this? Do we need to do a first pass through our symbols
> to fixup ->end before allocating the ->ip[] arrays?

We have already symbols__fixup_end() for doing that:

        /*
         * For misannotated, zeroed, ASM function sizes.
         */
        if (nr > 0) {
                symbols__fixup_end(&self->symbols[map->type]);
                if (kmap) {
                        /*
                         * We need to fixup this here too because we create new
                         * maps here, for things like vsyscall sections.
                         */
                        __map_groups__fixup_end(kmap->kmaps, map->type);
                }
        }

but, as you show, there are code paths that don't reach this part...

Investigating.

- Arnaldo
