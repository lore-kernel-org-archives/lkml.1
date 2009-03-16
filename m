Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZCPIFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZCPIFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZCPIF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:05:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43981 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZCPIF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:05:26 -0400
Date: Mon, 16 Mar 2009 17:03:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "hugh@veritas.com" <hugh@veritas.com>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       David Newall <davidn@davidnewall.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: BUG?: PAGE_FLAGS_CHECK_AT_PREP seems to be cleared too early (Was
 Re: I just got got another Oops
Message-Id: <20090316170359.858e7a4e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090316115509.40ea13da.kamezawa.hiroyu@jp.fujitsu.com>
References: <200903120133.11583.gene.heskett@gmail.com>
	<49B8C98D.3020309@davidnewall.com>
	<200903121431.49437.gene.heskett@gmail.com>
	<20090316115509.40ea13da.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm sorry if I miss something..

>From this patch
==
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=79f4b7bf393e67bbffec807cc68caaefc72b82ee
==
#define PAGE_FLAGS_CHECK_AT_PREP       ((1 << NR_PAGEFLAGS) - 1)
...
@@ -468,16 +467,16 @@ static inline int free_pages_check(struct page *page)
                (page_count(page) != 0)  |
                (page->flags & PAGE_FLAGS_CHECK_AT_FREE)))
....
+       if (PageReserved(page))
+               return 1;
+       if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
+               page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+       return 0;
 }
==

PAGE_FLAGS_CHECK_AT_PREP is cleared by free_pages_check().

This means PG_head/PG_tail(PG_compound) flags are cleared here and Compound page
will never be freed in sane way.

Regards,
-Kame

