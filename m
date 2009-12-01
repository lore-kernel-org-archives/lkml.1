Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZLAAmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZLAAmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZLAAme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:42:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46192 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZLAAmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:42:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Dec 2009 09:39:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-Id: <20091201093945.8c24687f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091130120705.GD30235@random.random>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
	<Pine.LNX.4.64.0911241640590.25288@sister.anvils>
	<20091130094616.8f3d94a7.kamezawa.hiroyu@jp.fujitsu.com>
	<20091130120705.GD30235@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 13:07:05 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Mon, Nov 30, 2009 at 09:46:16AM +0900, KAMEZAWA Hiroyuki wrote:
> > Hmm. I'm not sure how many pages are shared in a system but
> > can't we add some threshold for avoidng too much scan against shared pages ?
> > (in vmscan.c)
> > like..
> >       
> >        if (page_mapcount(page) > (XXXX >> scan_priority))
> > 		return 1;
> > 
> > I saw terrible slow downs in shmem-swap-out in old RHELs (at user support).
> > (Added kosaki to CC.)
> 
> If those ptes are all old there's no reason to keep those pages in ram
> more... I don't like those magic number levels. If you saw slowdowns
> it'd be interesting to get more information on those workloads. I
> never seen swap out workloads in real life that are not 99% I/O
> dominated, there's nothing that loads the cpu anything close to 100%,
> so nothing that a magic check like above could affect. 

I saw an user incident that all 64cpus hangs on shmem's spinlock and get
great slow down, cluster fail over. 
As workaround, we recommend them to use hugepage. It's not scanned.

Hmm. Can KSM coalesce 10000+ of pages to a page ? In such case, lru
need to scan 10000+ ptes with 10000+ anon_vma->lock and 10000+ pte locks
for reclaiming a page.


> Besides tmpfs
> unmap methods are different from ksm and anon pages unmap methods, and
> certain locks are coarser if there's userland taking i_mmap_lock for
> I/O during paging.
> 
maybe. 

Hmm, Larry Woodman reports another? issue.
http://marc.info/?l=linux-mm&m=125961823921743&w=2

Maybe some modification to lru scanning is necessary independent from ksm.
I think.

Thanks,
-Kame

