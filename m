Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYHMIvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYHMIvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYHMIur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:50:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37159
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbYHMIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:50:46 -0400
Date: Wed, 13 Aug 2008 01:50:47 -0700 (PDT)
Message-Id: <20080813.015047.193705212.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: console handover badness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080812.184052.193693538.davem@davemloft.net>
References: <20080811.233013.49328708.davem@davemloft.net>
	<Pine.LNX.4.64.0808122053280.31704@hs20-bc2-1.build.redhat.com>
	<20080812.184052.193693538.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 12 Aug 2008 18:40:52 -0700 (PDT)

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Tue, 12 Aug 2008 21:11:53 -0400 (EDT)
> 
> > and then boot failure of 2.6.27-rc[12] because of bad memory 
> > migratetype. Is this migratetype crash a known problem? --- the problem is 
> > that starting with 2.6.27rc1, I'm getting crash with this backtrace:
> > __list_add
> > __free_pages_ok
> > __free_pages
> > __free_pages_bootmem
> > __free_all_bootmem
> > mem_init
> > start_kernel_tlb_fixup_code
> > --- the crash is due to migratetype == 5 in __free_one_page (inlined into 
> > __free_pages_ok) and because there are only 5 migratettypes, it attempts 
> > to add to a non-existent list.
> 
> Mikulas can you send me the .config you're using in 2.6.27 to trigger
> this?

Meanwhile I tried to figure out how this can go wrong like this.

The way this stuff works this early is very simple.

The pageblock bitmaps get allocated by sparse_init() as it iterates over
each mem section, via sparse_early_usemap_alloc().  These use the
various bootmem allocators, which will zero initialize the bitmap.

I added some debugging to sparse_early_usemap_alloc() to make sure
the size was correct and that the pointer looked sane.

What happens next is that memmap_init_zone() walks over each zone's
page and initializes their pageblock migrate type to MIGRATE_MOVABLE
which is "2".

So given the simplicity of that stuff, I can only imagine that something
is writing all over the bitmaps, clobbering them somehow.

I'll try to reproduce this here so I can try to narrow down the cause
a bit more, but so far my attempts have not been successful.
