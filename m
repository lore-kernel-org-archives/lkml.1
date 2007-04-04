Return-Path: <linux-kernel-owner+w=401wt.eu-S2992734AbXDDIU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992734AbXDDIU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992738AbXDDIU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:20:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992735AbXDDIU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:20:26 -0400
Date: Wed, 4 Apr 2007 04:20:15 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ulrich Drepper <drepper@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: missing madvise functionality
Message-ID: <20070404082015.GG355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <46128051.9000609@redhat.com> <461357C4.4010403@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461357C4.4010403@yahoo.com.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 05:46:12PM +1000, Nick Piggin wrote:
> Does mmap(PROT_NONE) actually free the memory?

Yes.
        /* Clear old maps */
        error = -ENOMEM;
munmap_back:
        vma = find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
        if (vma && vma->vm_start < addr + len) {
                if (do_munmap(mm, addr, len))
                        return -ENOMEM;
                goto munmap_back;
        }

> In the case of pages being unused then almost immediately reused, why is
> it a bad solution to avoid freeing? Is it that you want to avoid
> heuristics because in some cases they could fail and end up using memory?

free(3) doesn't know if the memory will be reused soon, late or never.
So avoiding trimming could substantially increase memory consumption with
certain malloc/free patterns, especially in threaded programs that use
multiple arenas.  Implementing some sort of deferred memory trimming
in malloc is "solving" the problem in a wrong place, each app really has no
idea (and should not have) what the current system memory pressure is.

> Secondly, why is MADV_DONTNEED bad? How much more expensive is a pagefault
> than a syscall? (including the cost of the TLB fill for the memory access
> after the syscall, of course).

That's page fault per page rather than a syscall for the whole chunk,
furthermore zeroing is expensive.

We really want something like FreeBSD MADV_FREE in Linux, see e.g.
http://mail.nl.linux.org/linux-mm/2000-03/msg00059.html
for some details.  Apparently FreeBSD malloc is using MADV_FREE for years
(according to their CVS for 10 years already).

	Jakub
