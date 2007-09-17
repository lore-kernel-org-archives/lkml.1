Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbXIQUQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbXIQUQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbXIQUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:16:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbXIQUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:16:17 -0400
Date: Mon, 17 Sep 2007 13:15:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Message-Id: <20070917131526.e8db80fe.akpm@linux-foundation.org>
In-Reply-To: <46EEB532.3060804@redhat.com>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>
	<1189850897.21778.301.camel@twins>
	<20070915035228.8b8a7d6d.akpm@linux-foundation.org>
	<13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk>
	<20070917163257.331c7605@twins>
	<46EEB532.3060804@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 13:11:14 -0400
Rik van Riel <riel@redhat.com> wrote:

> > I'm guessing there is no pressure at all on zone_highmem so the
> > kernel will not try to reclaim pagecache. And because the pagecache
> > pages are happily sitting there, the buggerheads are pinned and do not
> > get reclaimed.

yeah, this got pretty unavoidably broken when we killed the global LRU
in 2.5.early. It's odd that it took this long for someone to hit it.

> I've got code for this in RHEL 3, but never bothered to
> merge it upstream since I thought people with large memory
> systems would be running 64 bit kernels by now.
> 
> Obviously I was wrong.  Andrew, are you interested in a
> fix for this problem?
> 
> IIRC I simply kept a list of all buffer heads and walked
> that to reclaim pages when the number of buffer heads is
> too high (and we need memory).  This list can be maintained
> in places where we already hold the lock for the buffer head
> freelist, so there should be no additional locking overhead
> (again, IIRC).

Christoph's slab defragmentation code should permit us to fix this:
grab a page of buffer_heads off the slab lists, trylock the page,
strip the buffer_heads.  I think that would be a better approach
if we can get it going because it's more general.
