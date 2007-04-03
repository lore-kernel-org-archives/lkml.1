Return-Path: <linux-kernel-owner+w=401wt.eu-S965451AbXDCQzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451AbXDCQzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXDCQzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:55:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965451AbXDCQzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:55:41 -0400
Message-ID: <46128708.9030900@redhat.com>
Date: Tue, 03 Apr 2007 12:55:36 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>
In-Reply-To: <46128051.9000609@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:

> That's it.  The current MADV_DONTNEED doesn't cut it because it zaps the
> pages, causing *all* future reuses to create page faults.  This is what
> I guess happens in the mysql test case where the pages where unused and
> freed but then almost immediately reused.  The page faults erased all
> the benefits of using one mprotect() call vs a pair of mmap()/mprotect()
> calls.

I already started looking into implementing this.

Basically:

1) on MADV_DONTNEED, mark pages clean, not accessed and move them
    to some "dontneed" LRU list.

2) when the VM needs pages, the pages are first removed from that
    list, before the VM goes elsewhere - or maybe we'll want to
    balance this list with reclaim from the inactive list at some
    point based on size, reuse rate, etc...?

3) if an application reuses a DONTNEED page before the VM reclaims
    it, the accessed and dirty bits will get set by hardware

4) in the reclaiming of the DONTNEED pages we simply move accessed
    pages back to the active list, instead of reclaiming them

5) if the system hsa lots of free memory, pages can go through
    multiple free/malloc cycles while sitting on the "dontneed"
    list, very lazily with no lock contention :)

What do you think?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
