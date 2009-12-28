Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbZL1BWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbZL1BWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 20:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZL1BWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 20:22:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54792 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZL1BWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 20:22:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 10:19:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
Subject: Re: [RFC PATCH] asynchronous page fault.
Message-Id: <20091228101902.4a7feac1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	<1261915391.15854.31.camel@laptop>
	<20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 09:36:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> == one vma ==
> # Samples: 1338964273489
> #
> # Overhead          Command             Shared Object  Symbol
> # ........  ...............  ........................  ......
> #
>     26.90%  multi-fault-all  [kernel]                  [k] clear_page_c
>             |
>             --- clear_page_c
>                 __alloc_pages_nodemask
>                 handle_mm_fault
>                 do_page_fault
>                 page_fault
>                 0x400940
>                |
>                 --100.00%-- (nil)
> 
>     20.65%  multi-fault-all  [kernel]                  [k] _raw_spin_lock
>             |
>             --- _raw_spin_lock
>                |
>                |--85.07%-- free_pcppages_bulk
>                |          free_hot_cold_page
> 
>     ....<snip>
>     3.94%  multi-fault-all  [kernel]                  [k] find_vma_speculative
>             |
>             --- find_vma_speculative
>                |
>                |--99.40%-- do_page_fault
>                |          page_fault
>                |          0x400940
>                |          |
>                |           --100.00%-- (nil)
>                |
>                 --0.60%-- page_fault
>                           0x400940
>                           |
>                            --100.00%-- (nil)
> ==
> 
A small modification for avoiding atomic_add_unless() makes following score.
(used atomic_inc()->atomic_read() instead of that.)
==
     2.55%  multi-fault-all  [kernel]                  [k] vma_put
            |
            --- vma_put
               |
               |--98.87%-- do_page_fault
               |          page_fault
               |          0x400940
               |          (nil)
               |
                --1.13%-- page_fault
                          0x400940
                          (nil)
     0.65%  multi-fault-all  [kernel]                  [k] find_vma_speculative
            |
            --- find_vma_speculative
               |
               |--95.55%-- do_page_fault
               |          page_fault
               |          0x400940
               |          |
               |           --100.00%-- (nil)
               |
                --4.45%-- page_fault
                          0x400940
                          (nil)
==
Hmm...maybe worth to consider some.
I hope something good pops up to me after new year vacation.

Regards,
-Kame





