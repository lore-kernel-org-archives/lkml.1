Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYKQQWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYKQQWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYKQQWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:22:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbYKQQWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:22:34 -0500
Date: Mon, 17 Nov 2008 08:22:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
In-Reply-To: <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0811170802010.3468@nehalem.linux-foundation.org>
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081115210039.537f59f5.akpm@linux-foundation.org> <alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org> <49208E9A.5080801@redhat.com> <20081116204720.1b8cbe18.akpm@linux-foundation.org>
 <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com> <2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com> <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, KAMEZAWA Hiroyuki wrote:
> 
> How about resetting zone->recent_scanned/rotated to be some value calculated from
> INACTIVE_ANON/INACTIVE_FILE at some time (when the system is enough idle) ?

.. or how about just considering the act of adding a new page to the LRU 
to be a "scan" event? IOW, "scanning" is not necessarily just an act of 
the VM looking for pages to free, but would be a more general "activity" 
meter.

IOW, when we calculate the percentages of anon-vs-file in get_scan_ratio() 
we take into account how much anon-page activity vs how much file cache 
activity there has been.

So if we've seen a lot of filesystem activity ("streaming"), we would tend 
to prefer to scan the page cache. If we've seen a lot of anon page 
mapping, we'd tend to prefer to scan the anon side.

That would seem to be the right kind of thing to do: if we literally have 
a load that only does streaming and pages never get moved to the active 
LRU, it should basically keep the page cache close to constant size - 
which is just another way of saying that we should only be scanning page 
cache pages.

Hmm? 

			Linus
