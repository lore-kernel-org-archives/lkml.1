Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZEGQAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZEGQAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZEGQAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:00:08 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:47682 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZEGQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:00:06 -0400
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class citizen
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0905071016410.24528@qirst.com>
References: <20090430072057.GA4663@eskimo.com>
	 <20090430174536.d0f438dd.akpm@linux-foundation.org>
	 <20090430205936.0f8b29fc@riellaptop.surriel.com>
	 <20090430181340.6f07421d.akpm@linux-foundation.org>
	 <20090430215034.4748e615@riellaptop.surriel.com>
	 <20090430195439.e02edc26.akpm@linux-foundation.org>
	 <49FB01C1.6050204@redhat.com>
	 <20090501123541.7983a8ae.akpm@linux-foundation.org>
	 <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>
	 <20090507121101.GB20934@localhost>
	 <alpine.DEB.1.10.0905070935530.24528@qirst.com>
	 <1241705702.11251.156.camel@twins>
	 <alpine.DEB.1.10.0905071016410.24528@qirst.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Thu, 07 May 2009 12:00:00 -0400
Message-Id: <1241712000.18617.7.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 10:18 -0400, Christoph Lameter wrote:
> On Thu, 7 May 2009, Peter Zijlstra wrote:
> 
> > It re-instates the young bit for PROT_EXEC pages, so that they will only
> > be paged when they are really cold, or there is severe pressure.
> 
> But they are rescanned until then. Really cold means what exactly? I do a
> back up of a few hundred gigabytes and do not use firefox while the backup
> is ongoing. Will the firefox pages still be in memory or not?
> 
> > This simply gives them an edge over regular data. I don't think the
> > extra scanning is a problem, since you rarely have huge amounts of
> > executable pages around.
> >
> > mlock()'ing all code just doesn't sound like a good alternative.
> 
> Another possibility may be to put the exec pages on the mlock list
> and scan the list if under extreme duress?

Actually, you don't need to go thru the overhead of mucking with the
PG_mlocked flag which incurs the rmap walk on unlock, etc.  If one sets
the the AS_UNEVICTABLE flag, the pages will be shuffled off the the
unevictable LRU iff we ever try to reclaim them.  And, we do have the
function to scan the unevictable lru to "rescue" pages in a given
mapping should we want to bring them back under extreme load.  We'd need
to remove the AS_UNEVICTABLE flag, first.  This is how
SHM_LOCK/SHM_UNLOCK works.

Lee



