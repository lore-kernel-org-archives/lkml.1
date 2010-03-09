Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0CIAXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:23:00 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47919 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0CIAW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:22:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Mar 2010 09:19:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
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
Message-Id: <20100309091914.4b5f6661.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100309001252.GB13490@linux>
References: <1267995474-9117-1-git-send-email-arighi@develer.com>
	<1267995474-9117-4-git-send-email-arighi@develer.com>
	<20100308104447.c124c1ff.nishimura@mxp.nes.nec.co.jp>
	<20100308105641.e2e714f4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100308111724.3e48aee3.nishimura@mxp.nes.nec.co.jp>
	<20100308113711.d7a249da.kamezawa.hiroyu@jp.fujitsu.com>
	<20100308170711.4d8b02f0.nishimura@mxp.nes.nec.co.jp>
	<20100308173100.b5997fd4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100309001252.GB13490@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010 01:12:52 +0100
Andrea Righi <arighi@develer.com> wrote:

> On Mon, Mar 08, 2010 at 05:31:00PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Mon, 8 Mar 2010 17:07:11 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > On Mon, 8 Mar 2010 11:37:11 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > On Mon, 8 Mar 2010 11:17:24 +0900
> > > > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > > 
> > > > > > But IIRC, clear_writeback is done under treelock.... No ?
> > > > > > 
> > > > > The place where NR_WRITEBACK is updated is out of tree_lock.
> > > > > 
> > > > >    1311 int test_clear_page_writeback(struct page *page)
> > > > >    1312 {
> > > > >    1313         struct address_space *mapping = page_mapping(page);
> > > > >    1314         int ret;
> > > > >    1315
> > > > >    1316         if (mapping) {
> > > > >    1317                 struct backing_dev_info *bdi = mapping->backing_dev_info;
> > > > >    1318                 unsigned long flags;
> > > > >    1319
> > > > >    1320                 spin_lock_irqsave(&mapping->tree_lock, flags);
> > > > >    1321                 ret = TestClearPageWriteback(page);
> > > > >    1322                 if (ret) {
> > > > >    1323                         radix_tree_tag_clear(&mapping->page_tree,
> > > > >    1324                                                 page_index(page),
> > > > >    1325                                                 PAGECACHE_TAG_WRITEBACK);
> > > > >    1326                         if (bdi_cap_account_writeback(bdi)) {
> > > > >    1327                                 __dec_bdi_stat(bdi, BDI_WRITEBACK);
> > > > >    1328                                 __bdi_writeout_inc(bdi);
> > > > >    1329                         }
> > > > >    1330                 }
> > > > >    1331                 spin_unlock_irqrestore(&mapping->tree_lock, flags);
> > > > >    1332         } else {
> > > > >    1333                 ret = TestClearPageWriteback(page);
> > > > >    1334         }
> > > > >    1335         if (ret)
> > > > >    1336                 dec_zone_page_state(page, NR_WRITEBACK);
> > > > >    1337         return ret;
> > > > >    1338 }
> > > > 
> > > > We can move this up to under tree_lock. Considering memcg, all our target has "mapping".
> > > > 
> > > > If we newly account bounce-buffers (for NILFS, FUSE, etc..), which has no ->mapping,
> > > > we need much more complex new charge/uncharge theory.
> > > > 
> > > > But yes, adding new lock scheme seems complicated. (Sorry Andrea.)
> > > > My concerns is performance. We may need somehing new re-implementation of
> > > > locks/migrate/charge/uncharge.
> > > > 
> > > I agree. Performance is my concern too.
> > > 
> > > I made a patch below and measured the time(average of 10 times) of kernel build
> > > on tmpfs(make -j8 on 8 CPU machine with 2.6.33 defconfig).
> > > 
> > > <before>
> > > - root cgroup: 190.47 sec
> > > - child cgroup: 192.81 sec
> > > 
> > > <after>
> > > - root cgroup: 191.06 sec
> > > - child cgroup: 193.06 sec
> > > 
> > > Hmm... about 0.3% slower for root, 0.1% slower for child.
> > > 
> > 
> > Hmm...accepatable ? (sounds it's in error-range)
> > 
> > BTW, why local_irq_disable() ? 
> > local_irq_save()/restore() isn't better ?
> 
> Probably there's not the overhead of saving flags? 
maybe.

> Anyway, it would make the code much more readable...
> 
ok.

please go ahead in this direction. Nishimura-san, would you post an
independent patch ? If no, Andrea-san, please.

Thanks,
-Kame

