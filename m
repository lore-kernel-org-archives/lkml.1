Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZEHX4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZEHX4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZEHX4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:56:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47966 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZEHX4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:56:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Sat, 9 May 2009 01:55:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905090155.44635.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, David Rientjes wrote:
> On Thu, 7 May 2009, Rafael J. Wysocki wrote:
> 
> > OK, let's try with __GFP_NO_OOM_KILL first.  If there's too much disagreement,
> > I'll use the freezer-based approach instead.
> > 
> 
> Third time I'm going to suggest this, and I'd like a response on why it's 
> not possible instead of being ignored.
> 
> All of your tasks are in D state other than kthreads, right?  That means 
> they won't be in the oom killer (thus no zones are oom locked), so you can 
> easily do this
> 
> 	struct zone *z;
> 	for_each_populated_zone(z)
> 		zone_set_flag(z, ZONE_OOM_LOCKED);
> 
> and then
> 
> 	for_each_populated_zone(z)
> 		zone_clear_flag(z, ZONE_OOM_LOCKED);
> 
> The serialization is done with trylocks so this will never invoke the oom 
> killer because all zones in the allocator's zonelist will be oom locked.

Well, that might have been a good idea if it actually had worked. :-(

> Why does this not work for you?

If I set image_size to something below "hard core working set" +
totalreserve_pages, preallocate_image_memory() hangs the
box (please refer to the last patch I sent,
http://patchwork.kernel.org/patch/22423/).

However, with the freezer-based disabling of the OOM killer it doesn't hang
under the same test conditions.

The difference appears to be that using your approach makes
__alloc_pages_internal() loop forever between the !try_set_zone_oom() test and
restart:, while it should go to nopage: in that situation.

So, I think I'll stick to the Andrew's approach with using __GFP_NO_OOM_KILL.

Thanks,
Rafael
