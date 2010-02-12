Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab0BLITF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:19:05 -0500
Received: from ozlabs.org ([203.10.76.45]:35153 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab0BLITE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:19:04 -0500
Date: Fri, 12 Feb 2010 19:17:24 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: perf annotate SEGVs
Message-ID: <20100212081724.GA13355@kryten>
References: <20100212052427.GK3399@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212052427.GK3399@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I think I understand a problem in perf annotate where I see random corruption
(rb tree issues, glibc malloc failures etc).

The issue happens with zero length symbols, in this particular case they
are kernel functions written entirely in assembly, eg .copy_4K_page,
.__copy_tofrom_user and .memcpy:

   Num:    Value          Size Type    Bind   Vis      Ndx Name
 63516: c00000000004a774   212 FUNC    GLOBAL DEFAULT    1 .devm_ioremap_prot
 69095: c00000000004a848     0 FUNC    GLOBAL DEFAULT    1 .copy_4K_page
 62002: c00000000004aa00     0 FUNC    GLOBAL DEFAULT    1 .__copy_tofrom_user
 50576: c00000000004b000     0 FUNC    GLOBAL DEFAULT    1 .memcpy
 69557: c00000000004b278   176 FUNC    GLOBAL DEFAULT    1 .copy_in_user
 51841: c00000000004b328   144 FUNC    GLOBAL DEFAULT    1 .copy_to_user

In symbol_filter we look at the length of each symbol:

static int symbol_filter(struct map *map __used, struct symb
...
                const int size = (sizeof(*priv->hist) +
                                 (sym->end - sym->start) * sizeof(u64));
 
And since start == end we create 0 bytes of space for the ip[] array.

Later on in hist_hit we then start indexing off this array:

       h->ip[offset]++;

Which then corrupts whatever is next in memory. With large assembly functions
we corrupt a lot :)

How should we fix this? Do we need to do a first pass through our symbols
to fixup ->end before allocating the ->ip[] arrays?

Anton
