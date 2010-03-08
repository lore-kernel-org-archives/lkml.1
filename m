Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0CHClB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 21:41:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46312 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0CHCkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 21:40:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 8 Mar 2010 11:37:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 3/4] memcg: dirty pages accounting and limiting
 infrastructure
Message-Id: <20100308113711.d7a249da.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100308111724.3e48aee3.nishimura@mxp.nes.nec.co.jp>
References: <1267995474-9117-1-git-send-email-arighi@develer.com>
	<1267995474-9117-4-git-send-email-arighi@develer.com>
	<20100308104447.c124c1ff.nishimura@mxp.nes.nec.co.jp>
	<20100308105641.e2e714f4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100308111724.3e48aee3.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010 11:17:24 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > But IIRC, clear_writeback is done under treelock.... No ?
> > 
> The place where NR_WRITEBACK is updated is out of tree_lock.
> 
>    1311 int test_clear_page_writeback(struct page *page)
>    1312 {
>    1313         struct address_space *mapping = page_mapping(page);
>    1314         int ret;
>    1315
>    1316         if (mapping) {
>    1317                 struct backing_dev_info *bdi = mapping->backing_dev_info;
>    1318                 unsigned long flags;
>    1319
>    1320                 spin_lock_irqsave(&mapping->tree_lock, flags);
>    1321                 ret = TestClearPageWriteback(page);
>    1322                 if (ret) {
>    1323                         radix_tree_tag_clear(&mapping->page_tree,
>    1324                                                 page_index(page),
>    1325                                                 PAGECACHE_TAG_WRITEBACK);
>    1326                         if (bdi_cap_account_writeback(bdi)) {
>    1327                                 __dec_bdi_stat(bdi, BDI_WRITEBACK);
>    1328                                 __bdi_writeout_inc(bdi);
>    1329                         }
>    1330                 }
>    1331                 spin_unlock_irqrestore(&mapping->tree_lock, flags);
>    1332         } else {
>    1333                 ret = TestClearPageWriteback(page);
>    1334         }
>    1335         if (ret)
>    1336                 dec_zone_page_state(page, NR_WRITEBACK);
>    1337         return ret;
>    1338 }

We can move this up to under tree_lock. Considering memcg, all our target has "mapping".

If we newly account bounce-buffers (for NILFS, FUSE, etc..), which has no ->mapping,
we need much more complex new charge/uncharge theory.

But yes, adding new lock scheme seems complicated. (Sorry Andrea.)
My concerns is performance. We may need somehing new re-implementation of
locks/migrate/charge/uncharge.

Thanks,
-Kame



