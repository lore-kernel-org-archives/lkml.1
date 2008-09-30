Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYI3Af0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYI3Af0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYI3AfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:35:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43283 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYI3AfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:35:14 -0400
Date: Tue, 30 Sep 2008 09:40:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: gerald.schaefer@de.ibm.com
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: setup_per_zone_pages_min(): zone->lock vs. zone->lru_lock
Message-Id: <20080930094017.5ed2938a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1222723206.6791.2.camel@ubuntu>
References: <1222708257.4723.23.camel@localhost.localdomain>
	<20080929173607.GC14905@brain>
	<1222723206.6791.2.camel@ubuntu>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 23:20:05 +0200
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> On Mon, 2008-09-29 at 18:36 +0100, Andy Whitcroft wrote:
> > The allocator protects it freelists using zone->lock (as we can see in
> > rmqueue_bulk), so anything which manipulates those should also be using
> > that lock.  move_freepages() is scanning the cmap and picking up free
> > pages directly off the free lists, it is expecting those lists to be
> > stable; it would appear to need zone->lock.  It does look like
> > setup_per_zone_pages_min() is holding the wrong thing at first look.
> 
> I just noticed that the spin_lock in that function is much older than the
> call to setup_zone_migrate_reserve(), which then calls move_freepages().
> So it seems that the zone->lru_lock there does (did?) have another purpose,
> maybe protecting zone->present_pages/pages_min/etc.
> 
Maybe.

> Looks like the need for a zone->lock (if any) was added later, but I'm not
> sure if makes sense to take both locks together, or if the lru_lock is still
> needed at all.
>
At first look, replacing zone->lru_lock with zone->lock is enough...
This function is an only one function which use zone->lru_lock in page_alloc.c
And zone_watermark_ok() which access zone->pages_min/low/high is not under any
locks. So, taking zone->lru_lock here doesn't seem to be necessary...


Thanks,
-Kame

