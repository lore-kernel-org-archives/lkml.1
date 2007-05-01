Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbXEABTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbXEABTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXEABTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:19:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbXEABS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:18:59 -0400
Date: Mon, 30 Apr 2007 18:18:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: MADV_FREE functionality
Message-Id: <20070430181839.c548c4da.akpm@linux-foundation.org>
In-Reply-To: <46368FAA.3080104@redhat.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<46368FAA.3080104@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 20:54:02 -0400 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> 
> >  lazy-freeing-of-memory-through-madv_free.patch
> >  lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
> >  restore-madv_dontneed-to-its-original-linux-behaviour.patch
> > 
> > I think the MADV_FREE changes need more work:
> > 
> > We need crystal-clear statements regarding the present functionality, the new
> > functionality and how these relate to the spec and to implmentations in other
> > OS'es.  Once we have that info we are in a position to work out whether the
> > code can be merged as-is, or if additional changes are needed.
> 
> There are two MADV variants that free pages, both do the exact
> same thing with mapped file pages, but both do something slightly
> different with anonymous pages.
> 
> MADV_DONTNEED will unmap file pages and free anonymous pages.
> When a process accesses anonymous memory at an address that
> was zapped with MADV_DONTNEED, it will return fresh zero filled
> pages.
> 
> MADV_FREE will unmap file pages.  MADV_FREE on anonymous pages
> is interpreted as a signal that the application no longer needs
> the data in the pages, and they can be thrown away if the kernel
> needs the memory for something else.  However, if the process
> accesses the memory again before the kernel needs it, the process
> will simply get the original pages back.  If the kernel needed
> the memory first, the process will get a fresh zero filled page
> like with MADV_DONTNEED.
> 
> In short:
> - both MADV_FREE and MADV_DONTNEED only unmap file pages
> - after MADV_DONTNEED the application will always get back
>    fresh zero filled anonymous pages when accessing the
>    memory
> - after MADV_FREE the application can either get back the
>    original data (without a page fault) or zero filled
>    anonymous memory
> 
> The Linux MADV_DONTNEED behavior is not POSIX compliant.
> POSIX says that with MADV_DONTNEED the application's data
> will be preserved.
> 
> Currently glibc simply ignores POSIX_MADV_DONTNEED requests
> from applications on Linux.  Changing the behaviour which
> some Linux applications may rely on might not be the best
> idea.

OK, thanks.  I stuck that in the changelog.

Michael, do you think that's enough to finalise a manpage?

> If you need any additional information, please let me know.

The patch doesn't update the various comments in madvise.c at all, which is
a surprise.  Could you please check that they are all accurate and complete?

Also, where did we end up with the Solaris compatibility?

The patch I have at present retains MADV_FREE=0x05 for sparc and sparc64
which should be good.

Did we decide that the Solaris and Linux implementations of MADV_FREE are
compatible?

What about the Solaris and Linux MADV_DONTNEED implementations?
