Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZESG4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZESG4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZESG42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:56:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45501 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZESG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:56:27 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class  citizen
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <84144f020905182339o5fb1e78eved95c4c20fd9ffa7@mail.gmail.com>
References: <20090516090448.410032840@intel.com> <84144f020905182339o5fb1e78eved95c4c20fd9ffa7@mail.gmail.com>
Message-Id: <20090519155528.4EE1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 May 2009 15:56:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi!
> 
> On Sat, May 16, 2009 at 12:00 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > @@ -1272,28 +1273,40 @@ static void shrink_active_list(unsigned
> >
> >        /* page_referenced clears PageReferenced */
> >        if (page_mapping_inuse(page) &&
> > -          page_referenced(page, 0, sc->mem_cgroup, &vm_flags))
> > +          page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
> >            pgmoved++;
> > +            /*
> > +            * Identify referenced, file-backed active pages and
> > +            * give them one more trip around the active list. So
> > +            * that executable code get better chances to stay in
> > +            * memory under moderate memory pressure. Anon pages
> > +            * are ignored, since JVM can create lots of anon
> > +            * VM_EXEC pages.
> > +            */
> > +            if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
> > +                list_add(&page->lru, &l_active);
> > +                continue;
> > +            }
> 
> Why do we need to skip JIT'd code? There are plenty of desktop
> applications that use Mono, for example, and it would be nice if we
> gave them the same treatment as native applications. Likewise, I am
> sure all browsers that use JIT for JavaScript need to be considered.

anon pages are already protected from streaming-io by get_scan_ratio().




