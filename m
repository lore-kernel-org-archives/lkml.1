Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbZCTQK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbZCTQK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZCTQKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:10:47 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:38697 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZCTQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:10:46 -0400
Subject: Re: [PATCH 0/2] Make the Unevictable LRU available on NOMMU
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       peterz@infradead.org, nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com
In-Reply-To: <28c262360903131727l4ef41db5xf917c7c5eb4825a8@mail.gmail.com>
References: <20090312100049.43A3.A69D9226@jp.fujitsu.com>
	 <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
	 <28c262360903131727l4ef41db5xf917c7c5eb4825a8@mail.gmail.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 20 Mar 2009 12:08:25 -0400
Message-Id: <1237565305.27431.48.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 09:27 +0900, Minchan Kim wrote:
> Hi, David.
> 
> It seems your patch is better than mine.  Thanks. :)
> But my concern is that as Peter pointed out, unevictable lru's
> solution is not fundamental one.
> 
> He want to remove ramfs page from lru list to begin with.
> I guess Andrew also thought same thing with Peter.
> 
> I think it's a fundamental solution. but it may be long term solution.
> This patch can solve NOMMU problem in current status.
> 
> Andrew, What do you think about it ?

[been meaning to respond to this...]

I just want to point out [again :)] that removing the ramfs pages from
the lru will prevent them from being migrated--e.g., for mem hot unplug,
defrag or such.  We currently have this situation with the new ram disk
driver [brd.c] which, unlike the old rd driver, doesn't place its pages
on the LRU.

Migration uses isolation of pages from lru to arbitrate between tasks
trying to migrate or reclaim the same page.  If migration doesn't find
the page on the lru, it assumes that it lost the race and skips the
page.  This is one of the reasons we chose to keep unevictable pages on
an lru-like list known to isolate_lru_page().

Something to keep in mind if/when this comes up again.  Maybe we don't
care?  Maybe ram disk/fs pages should come only from non-movable zone?
Or maybe migration can be reworked not to require the page be
"isolatable" from the lru [haven't thought about how one might do this].

Lee

