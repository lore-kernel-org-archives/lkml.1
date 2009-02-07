Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZBGPkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZBGPkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 10:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZBGPj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 10:39:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZBGPjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 10:39:55 -0500
Date: Sat, 7 Feb 2009 16:33:20 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: Greg KH <greg@kroah.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090207153320.GA13276@random.random>
References: <20090128213322.GA15789@kroah.com> <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com> <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090130061714.GC31209@kroah.com> <20090202220856.GY20323@random.random> <20090204234153.GA32244@kroah.com> <20090206175414.GQ14011@random.random> <498D8D53.6030007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498D8D53.6030007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 03:32:03PM +0200, Izik Eidus wrote:
> we are opening here a tiny race:
>
> cpu#1 do get_user_pages_fast and fetch the pte (it think the pte is 
> writeable)
> cpu#2 do ptep_set_wrprotect()
> cpu#2 check the mapcount against pagecount (it think that everything is 
> fine and continue)
> cpu#1 only now do get_page()
>
> Anyway this is minor issue that can be probably solved by just:
> rechecking if the pte isnt read_only in gup_fast after we do the get_page()

Not needed, if I check page_count vs mapcount after marking the pte
readonly and after sending smp-tlb-flush there is no race.

> Anyway sound like a great idea to fix this issue!

The only problem I'm thinking now is the IPI flood that would be
generated if I send IPIs for every pte wrprotected in fork, that
sounds overkill. So to use the IPI fix I could have gup-fast take the
slow path first time around if PG_gup isn't set, and then only second
time take the lockless fast path when PG_gup is already set (PG_gup
gets set by follow_page under PT lock/mmap_sem read mode at
least). And fork/ksm would only send IPIs for PG_gup pages. However
that would make gup-fast slow the first time it runs on an
anonymous/hugetlb page with pte marked writeable and I'm unsure if
that's ok.

Otherwise we've to return to the plan of the slightly more complicated
fix.
