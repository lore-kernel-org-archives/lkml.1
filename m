Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbZACVjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbZACVjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZACVj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:39:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZACVj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:39:26 -0500
Date: Sat, 3 Jan 2009 22:38:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] cpus4096 tree, part 3
Message-ID: <20090103213856.GA24138@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu> <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain> <20090103203621.GA2491@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103203621.GA2491@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> The test is underway with:
> 
>  CONFIG_64BIT=y
>  CONFIG_NR_CPUS=4096
>  CONFIG_MAXSMP=y

the worst-case stack footprint i was able to trigger on an allyesconfig 
bootup (instrumented via CONFIG_STACK_TRACER=y and the 'stacktrace' boot 
option) was 5.6K:

 # ls -l /debug/tracing/*stack*
 -rw-r--r-- 1 root root 0 2009-01-03 22:42 /debug/tracing/stack_max_size
 -r--r--r-- 1 root root 0 2009-01-03 22:42 /debug/tracing/stack_trace

 # cat /debug/tracing/*stack*
 5624
        Depth   Size      Location    (38 entries)
        -----   ----      --------
  0)     5496     232   lookup_address+0x51/0x20e
  1)     5264     496   __change_page_attr_set_clr+0xa7/0xa15
  2)     4768     128   kernel_map_pages+0x121/0x140
  3)     4640     224   get_page_from_freelist+0x4bb/0x6ec
  4)     4416     160   __alloc_pages_internal+0x150/0x4af
  5)     4256      48   alloc_pages_current+0xbe/0xc7
  6)     4208      16   alloc_slab_page+0x1e/0x6e
  7)     4192      64   new_slab+0x51/0x1e2
  8)     4128      96   __slab_alloc+0x260/0x3fa
  9)     4032      80   kmem_cache_alloc+0xa8/0x120
 10)     3952      48   radix_tree_preload+0x38/0x86
 11)     3904      64   add_to_page_cache_locked+0x51/0xed
 12)     3840      32   add_to_page_cache_lru+0x31/0x6b
 13)     3808      64   find_or_create_page+0x56/0x7d
 14)     3744      80   __getblk+0x136/0x262
 15)     3664      32   __bread+0x13/0x82
 16)     3632      64   ext3_get_branch+0x7b/0xef
 17)     3568     368   ext3_get_blocks_handle+0xa2/0x907
 18)     3200      96   ext3_get_block+0xc3/0x101
 19)     3104     224   do_mpage_readpage+0x1ad/0x4d0
 20)     2880     240   mpage_readpages+0xb6/0xf9
 21)     2640      16   ext3_readpages+0x1f/0x21
 22)     2624     144   __do_page_cache_readahead+0x147/0x1bd
 23)     2480      48   do_page_cache_readahead+0x5b/0x68
 24)     2432     112   filemap_fault+0x176/0x34b
 25)     2320     160   __do_fault+0x58/0x410
 26)     2160     176   handle_mm_fault+0x4b2/0xa3e
 27)     1984     800   do_page_fault+0x86d/0xcec
 28)     1184     208   page_fault+0x25/0x30
 29)      976      16   clear_user+0x30/0x38
 30)      960     288   load_elf_binary+0x61c/0x18f0
 31)      672      80   search_binary_handler+0xd9/0x279
 32)      592     176   load_script+0x1b3/0x1c8
 33)      416      80   search_binary_handler+0xd9/0x279
 34)      336      96   do_execve+0x1df/0x296
 35)      240      64   sys_execve+0x43/0x5e
 36)      176     176   stub_execve+0x6a/0xc0

None of the cpumask_t callsites showed up - but i agree that they should 
be fixed, 512 bytes of cpumask_t on the stack is not good no matter how 
one looks at it, it will only make an already strained kernel stack 
footprint situation worse.

This one looks a bit high:

  1)     5264     496   __change_page_attr_set_clr+0xa7/0xa15

(Venki, Suresh and Arjan Cc:-ed)

This one isnt too nice either:

 27)     1984     800   do_page_fault+0x86d/0xcec

not sure why it happens - will investigate tomorrow, it's getting late 
here.

	Ingo
