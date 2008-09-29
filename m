Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYI2VUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYI2VUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYI2VUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:20:23 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:33101 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYI2VUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:20:22 -0400
Subject: Re: setup_per_zone_pages_min(): zone->lock vs. zone->lru_lock
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080929173607.GC14905@brain>
References: <1222708257.4723.23.camel@localhost.localdomain>
	 <20080929173607.GC14905@brain>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 23:20:05 +0200
Message-Id: <1222723206.6791.2.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-29 at 18:36 +0100, Andy Whitcroft wrote:
> The allocator protects it freelists using zone->lock (as we can see in
> rmqueue_bulk), so anything which manipulates those should also be using
> that lock.  move_freepages() is scanning the cmap and picking up free
> pages directly off the free lists, it is expecting those lists to be
> stable; it would appear to need zone->lock.  It does look like
> setup_per_zone_pages_min() is holding the wrong thing at first look.

I just noticed that the spin_lock in that function is much older than the
call to setup_zone_migrate_reserve(), which then calls move_freepages().
So it seems that the zone->lru_lock there does (did?) have another purpose,
maybe protecting zone->present_pages/pages_min/etc.

Looks like the need for a zone->lock (if any) was added later, but I'm not
sure if makes sense to take both locks together, or if the lru_lock is still
needed at all.

Thanks,
Gerald


