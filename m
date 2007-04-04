Return-Path: <linux-kernel-owner+w=401wt.eu-S2993031AbXDDSl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993031AbXDDSl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993029AbXDDSlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:41:21 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:11043 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993018AbXDDSjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:39:45 -0400
X-AuditID: d80ac21c-95f9ebb000007de4-90-4613f0f1e9e9 
Date: Wed, 4 Apr 2007 19:39:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: missing madvise functionality
In-Reply-To: <20070404110406.c79b850d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704041917280.14635@blonde.wat.veritas.com>
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de>
 <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org>
 <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com>
 <20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org>
 <20070403160231.33aa862d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704040949050.17341@blonde.wat.veritas.com>
 <20070404110406.c79b850d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 18:39:11.0243 (UTC) FILETIME=[895D45B0:01C776E8]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Andrew Morton wrote:
> 
> The treatment is identical to clean swapcache pages, with the sole
> exception that they don't actually consume any swap space - hence the fake
> swapcache entry thing.

I see, sneaking through try_to_unmap's anon PageSwapCache assumptions
as simply as possible - thanks.

(Coincidentally, Andrea pointed to precisely the same issue in the
no PAGE_ZERO thread, when we were toying with writable but clean.)

> One thing which we haven't sorted out with all this stuff: once the
> application has marked an address range (and some pages) as
> whatever-were-going-call-this-feature, how does the application undo
> that change?

By re-referencing the pages.  (Hmm, so an incorrect app which accesses
"free"d areas, will undo it: well, okay, nothing terrible about that.)

> What effect will things like mremap, madvise and mlock have upon
> these pages?

mlock will undo the state in its make_pages_present: I guess that
should happen in or near follow_page's mark_page_accessed.

mremap?  Other madvises?  Nothing much at all: mremap can move
them around, and the madvises do whatever they do - I don't notice
any problem in that direction, but it'll be easier when we have an
implementation to poke at.

Hugh
