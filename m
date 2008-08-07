Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYHGIQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYHGIQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 04:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYHGIPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 04:15:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44831 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYHGIPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 04:15:38 -0400
Date: Thu, 7 Aug 2008 17:21:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, ryov@valinux.co.jp,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
Message-Id: <20080807172113.0788f800.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080807.162512.22162413.taka@valinux.co.jp>
References: <20080804.175748.189722512.ryov@valinux.co.jp>
	<20080806165421.f76edd47.kamezawa.hiroyu@jp.fujitsu.com>
	<16255819.1218030343593.kamezawa.hiroyu@jp.fujitsu.com>
	<20080807.162512.22162413.taka@valinux.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2008 16:25:12 +0900 (JST)
Hirokazu Takahashi <taka@valinux.co.jp> wrote:
> > >I've just noticed that most of overhead comes from the spin-locks
> > >when reclaiming the pages inside mem_cgroups and the spin-locks to
> > >protect the links between pages and page_cgroups.
> > Overhead between page <-> page_cgroup lock is cannot be catched by
> > lock_stat now.Do you have numbers ?
> > But ok, there are too many locks ;(
> 
> The problem is that every time the lock is held, the associated
> cache line is flushed.
I think "page" and "page_cgroup" is not so heavly shared object in fast path.
foot-print is also important here.
(anyway, I'd like to remove lock_page_cgroup() when I find a chance)

> 
> > >The latter overhead comes from the policy your team has chosen
> > >that page_cgroup structures are allocated on demand. I still feel
> > >this approach doesn't make any sense because linux kernel tries to
> > >make use of most of the pages as far as it can, so most of them
> > >have to be assigned its related page_cgroup. It would make us happy
> > >if page_cgroups are allocated at the booting time.
> > >
> > Now, multi-sizer-page-cache is discussed for a long time. If it's our
> > direction, on-demand page_cgroup make sense.
> 
> I don't think I can agree to this.
> When multi-sized-page-cache is introduced, some data structures will be
> allocated to manage multi-sized-pages. 
maybe no. it will be encoded into struct page.
> I think page_cgroups should be allocated at the same time.
> This approach will make things simple.
yes, of course.

> 
> It seems like the on-demand allocation approach leads not only
> overhead but complexity and a lot of race conditions.
> If you allocate page_cgroups when allocating page structures,
> You can get rid of most of the locks and you don't have to care about
> allocation error of page_cgroups anymore.
> 
> And it will also give us flexibility that memcg related data can be
> referred/updated inside critical sections.
> 
But it's not good for the systems with small "NORMAL" pages.
This discussion should be done again when more users of page_group appears and
it's overhead is obvious.

Thanks,
-Kame



