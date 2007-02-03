Return-Path: <linux-kernel-owner+w=401wt.eu-S1946407AbXBCIxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946407AbXBCIxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 03:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946408AbXBCIxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 03:53:35 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946407AbXBCIxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 03:53:34 -0500
Date: Sat, 3 Feb 2007 00:53:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
Message-Id: <20070203005316.eb0b4042.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 22:20:12 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

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

I wonder if it can be simpler.  Make two changes:

a) If the scanner encounters an mlocked page on the LRU, take it off.

b) munlock() adds all affected pages to the LRU.

And that's it.  Simpler, solves the uselessly-scan-lots-of-mlocked-pages
problem (which is the sole requirement according to your description) and
doesn't consume a page flag.  Optional (and arguable) extension: scan the
vmas during munmap, don't add page to LRU if it's still mlocked.

Why _does_ your patch add a new page flag?  That info is available via a
vma scan.

> There is still some unfinished business:
> 
> 1. We use the 21st page flag and we only have 20 on 32 bit NUMA platforms.

Ow.  How were you thinking of fixing that?

> 2. Since mlocked pages are now off the LRU page migration will no longer
>    move them.

Ow.  That could be a right pain when we get around to using migration for
memory-unplug?

