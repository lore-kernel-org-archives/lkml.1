Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494Ab0AZNcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0AZNcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972Ab0AZNcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:32:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:12936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab0AZNcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:32:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,346,1262592000"; 
   d="scan'208";a="590490617"
Date: Tue, 26 Jan 2010 21:32:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Frost <frost@cs.ucla.edu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve Dickson <steved@redhat.com>, David Howells <dhowells@redhat.com>,
       Xu Chenfeng <xcf@ustc.edu.cn>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Steve VanDeBogart <vandebo-lkml@nerdbox.net>
Subject: Re: [PATCH] mm/readahead.c: update the LRU positions of in-core
	pages, too
Message-ID: <20100126133217.GB25407@localhost>
References: <20100120215536.GN27212@frostnet.net> <20100121054734.GC24236@localhost> <20100123040348.GC30844@frostnet.net> <20100123102222.GA6943@localhost> <20100125094228.f7ca1430.kamezawa.hiroyu@jp.fujitsu.com> <20100125024544.GA16462@localhost> <20100125223635.GC2822@frostnet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20100125223635.GC2822@frostnet.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 03:36:35PM -0700, Chris Frost wrote:
> I changed Wu's patch to add a PageLRU() guard that I believe is required
> and optimized zone lock acquisition to only unlock and lock at zone changes.
> This optimization seems to provide a 10-20% system time improvement for
> some of my GIMP benchmarks and no improvement for other benchmarks.

> +			del_page_from_lru_list(zone, page, lru);
> +			add_page_to_lru_list(zone, page, lru);
> +		}
> +		put_page(page);

Hmm. put_page() inside lru_lock can deadlock. So you need to further
optimize the code to do pagevec_lookup() and pagevec_release() plus
cond_resched().

Thanks,
Fengguang
