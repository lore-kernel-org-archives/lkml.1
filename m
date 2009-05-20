Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZETB7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZETB7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 21:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZETB7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 21:59:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47003 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbZETB7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 21:59:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class  citizen
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <20090520014445.GA7645@localhost>
References: <2f11576a0905190528n5eb29e3fme42785a76eed3551@mail.gmail.com> <20090520014445.GA7645@localhost>
Message-Id: <20090520105159.743B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 May 2009 10:59:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, May 19, 2009 at 08:28:28PM +0800, KOSAKI Motohiro wrote:
> > Hi
> > 
> > 2009/5/19 Wu Fengguang <fengguang.wu@intel.com>:
> > > On Tue, May 19, 2009 at 04:06:35PM +0800, KOSAKI Motohiro wrote:
> > >> > > > Like the console mode, the absolute nr_mapped drops considerably - to 1/13 of
> > >> > > > the original size - during the streaming IO.
> > >> > > >
> > >> > > > The delta of pgmajfault is 3 vs 107 during IO, or 236 vs 393 during the whole
> > >> > > > process.
> > >> > >
> > >> > > hmmm.
> > >> > >
> > >> > > about 100 page fault don't match Elladan's problem, I think.
> > >> > > perhaps We missed any addional reproduce condition?
> > >> >
> > >> > Elladan's case is not the point of this test.
> > >> > Elladan's IO is use-once, so probably not a caching problem at all.
> > >> >
> > >> > This test case is specifically devised to confirm whether this patch
> > >> > works as expected. Conclusion: it is.
> > >>
> > >> Dejection ;-)
> > >>
> > >> The number should address the patch is useful or not. confirming as expected
> > >> is not so great.
> > >
> > > OK, let's make the conclusion in this way:
> > >
> > > The changelog analyzed the possible beneficial situation, and this
> > > test backs that theory with real numbers, ie: it successfully stops
> > > major faults when the active file list is slowly scanned when there
> > > are partially cache hot streaming IO.
> > >
> > > Another (amazing) finding of the test is, only around 1/10 mapped pages
> > > are actively referenced in the absence of user activities.
> > >
> > > Shall we protect the remaining 9/10 inactive ones? This is a question ;-)
> > 
> > Unfortunately, I don't reproduce again.
> > I don't apply your patch yet. but mapped ratio is reduced only very little.
> 
> mapped ratio or absolute numbers? The ratio wont change much because
> nr_mapped is already small.

My box is running Fedora 10 initlevel 5 (GNOME desktop).

many GNOME component is mapped very many process (likes >50).
Thus, these page aren't dropped by typical any workload.



> > I think smem can show which library evicted.  Can you try it?
> > 
> > download:  http://www.selenic.com/smem/
> > usage:   ./smem -m -r --abbreviate
> 
> Sure, but I don't see much change in its output (see attachments).
> 
> smem-console-0 is collected after fresh boot,
> smem-console-1 is collected after the big IO.

hmmmm, your result has following characatistics.

- no graphics component
- very few mapped library
  (it is almost only zsh library)

Can you try test on X environment?



> > We can't decide 9/10 is important or not. we need know actual evicted file list.
> 
> Right. But what I measured is the activeness. Almost zero major page
> faults means the evicted 90% mapped pages are inactive during the
> long 300 seconds of IO.

Agreed.
IOW, I don't think your test environment is typical desktop...




