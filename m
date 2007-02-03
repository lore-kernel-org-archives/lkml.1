Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbXBCKQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbXBCKQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbXBCKQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:16:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51942 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXBCKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:16:33 -0500
Date: Sat, 3 Feb 2007 10:16:28 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
Message-ID: <20070203101628.GB28806@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 10:20:12PM -0800, Christoph Lameter wrote:
> This is a new variation on the earlier RFC for tracking mlocked pages.
> We now mark a mlocked page with a bit in the page flags and remove
> them from the LRU. Pages get moved back when no vma that references
> the page has VM_LOCKED set anymore.
> 
> This means that vmscan no longer uselessly cycles over large amounts
> of mlocked memory should someone attempt to mlock large amounts of
> memory (may even result in a livelock on large systems).
> 
> Synchronization is build around state changes of the PageMlocked bit.
> The NR_MLOCK counter is incremented and decremented based on
> state transitions of PageMlocked. So the count is accurate.
> 
> There is still some unfinished business:
> 
> 1. We use the 21st page flag and we only have 20 on 32 bit NUMA platforms.
> 
> 2. Since mlocked pages are now off the LRU page migration will no longer
>    move them.
> 
> 3. Use NR_MLOCK to tune various VM behaviors so that the VM does not 
>    longer fall due to too many mlocked pages in certain areas.

This patch seems to not handle the cases where more than one process mlocks
a page and you really need a pincount in the page to not release it before
all processes have munlock it or died.  I did a similar patch a while
ago and tried to handle it by overloading the lru lists pointers with
a pincount, but at some point I gave up because I couldn't get that part
right.

