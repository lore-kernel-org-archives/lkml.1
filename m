Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0CKJ2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:28:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39614 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0CKJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:28:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Mar 2010 18:25:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
Message-Id: <20100311182500.0f3ba994.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1268298865.5279.997.camel@twins>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
	<20100311093913.07c9ca8a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100311101726.f58d24e9.kamezawa.hiroyu@jp.fujitsu.com>
	<1268298865.5279.997.camel@twins>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 10:14:25 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-03-11 at 10:17 +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 11 Mar 2010 09:39:13 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > The performance overhead is not so huge in both solutions, but the impact on
> > > > performance is even more reduced using a complicated solution...
> > > > 
> > > > Maybe we can go ahead with the simplest implementation for now and start to
> > > > think to an alternative implementation of the page_cgroup locking and
> > > > charge/uncharge of pages.
> 
> FWIW bit spinlocks suck massive.
> 
> > > 
> > > maybe. But in this 2 years, one of our biggest concerns was the performance.
> > > So, we do something complex in memcg. But complex-locking is , yes, complex.
> > > Hmm..I don't want to bet we can fix locking scheme without something complex.
> > > 
> > But overall patch set seems good (to me.) And dirty_ratio and dirty_background_ratio
> > will give us much benefit (of performance) than we lose by small overheads.
> 
> Well, the !cgroup or root case should really have no performance impact.
> 
> > IIUC, this series affects trgger for background-write-out.
> 
> Not sure though, while this does the accounting the actual writeout is
> still !cgroup aware and can definately impact performance negatively by
> shrinking too much.
> 

Ah, okay, your point is !cgroup (ROOT cgroup case.)
I don't think accounting these file cache status against root cgroup is necessary.


BTW, in other thread, I'm now proposing this style. 
==
+void mem_cgroup_update_stat(struct page *page, int idx, bool charge)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(page);
+	if (unlikely(!pc))
+		return;
+
+	if (trylock_page_cgroup(pc)) {
+		__mem_cgroup_update_stat(pc, idx, charge);
+		unlock_page_cgroup(pc);
+	}
+	return;
==

Then, it's not problem that check pc->mem_cgroup is root cgroup or not
without spinlock.
==
void mem_cgroup_update_stat(struct page *page, int idx, bool charge)
{
	pc = lookup_page_cgroup(page);
	if (unlikely(!pc) || mem_cgroup_is_root(pc->mem_cgroup))
		return;	
	...
}
==
This can be handle in the same logic of "lock failure" path.
And we just do ignore accounting.

There are will be no spinlocks....to do more than this,
I think we have to use "struct page" rather than "struct page_cgroup".

Thanks,
-Kame








