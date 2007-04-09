Return-Path: <linux-kernel-owner+w=401wt.eu-S965985AbXDIP4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965985AbXDIP4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966014AbXDIP4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:56:14 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:37817 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965985AbXDIP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:56:13 -0400
Subject: Re: [PATCH 0/8] RSS controller based on process containers (v2)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@google.com>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <461A3010.90403@sw.ru>
References: <461A3010.90403@sw.ru>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 17:54:50 +0200
Message-Id: <1176134091.22676.96.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


*ugh* /me no like.

The basic premises seems to be that we can track page owners perfectly
(although this patch set does not yet do so), through get/release
operations (on _mapcount).

This is simply not true for unmapped pagecache pages. Those receive no
'release' event; (the usage by find_get_page() could be seen as 'get').

Also, you don't seem to balance the active/inactive scanning on a per
container basis. This skews the per container working set logic.

Lastly, you don't call the slab shrinker for container reclaim; which
would leave slab reclaim only for those few non process specific
allocations, which would greatly skew the pagecache/slab balance.



Let us call 

struct reclaim_struct {
	struct list_head active_list;
	struct list_head inactive_list;
	unsigned long nr_active;
	unsigned long nr_inactive;
}

Lets recognise three distinct page categories:
 - anonymous memory,
 - mapped pagecache, and
 - unmapped pagecache.


We then keep anonymous pages on a per container reclaim_struct, these
pages are fully accounted to each container.

We keep mapped pagecache pages on per inode reclaim_structs, these files
could be shared between containers and we could either just account all
pages belonging to each file proportional to the number of containers
involved, or do a more precise accounting.

We keep unmapped pagecache pages on a global reclaim_struct, these pages
can, in general, not be pinned to a specific container; all we can do is
keep a floating proportion relative to container 'get' events
(find_get_page() and perhaps add_to_page_cache()).

Reclaim will then have to fairly reclaim pages from all of these lists.
If we schedule such that it appears that these lists are parallel
instead of serial - that is a each tail is really a tail, not the head
of another list - the current reclaim semantics are preserved.

The slab shrinker should be called proportional to the containers size
relative to the machine.

Global reclaim will have to call each container reclaim in proportional
fashion.

The biggest problem with this approach is that there is no per zone
reclaim left, which is relied upon by the allocator to provide free
pages in a given physical address range. However there has been talk to
create a proper range allocator independent of zones.

Just my 0.02 euro..

Peter


