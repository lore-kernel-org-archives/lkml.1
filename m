Return-Path: <linux-kernel-owner+w=401wt.eu-S1767198AbXDESil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767198AbXDESil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767200AbXDESil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:38:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767198AbXDESij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:38:39 -0400
Message-ID: <46154226.6080300@redhat.com>
Date: Thu, 05 Apr 2007 14:38:30 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <461357C4.4010403@yahoo.com.au>
In-Reply-To: <461357C4.4010403@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> Oh, also: something like this patch would help out MADV_DONTNEED, as it
> means it can run concurrently with page faults. I think the locking will
> work (but needs forward porting).

Ironically, your patch decreases throughput on my quad core
test system, with Jakub's test case.

MADV_DONTNEED, my patch, 10000 loops  (14k context switches/second)

real    0m34.890s
user    0m17.256s
sys     0m29.797s


MADV_DONTNEED, my patch & your patch, 10000 loops  (50 context 
switches/second)

real    1m8.321s
user    0m20.840s
sys     1m55.677s

I suspect it's moving the contention onto the page table lock,
in zap_pte_range().  I guess that the thread private memory
areas must be living right next to each other, in the same
page table lock regions :)

For more real world workloads, like the MySQL sysbench one,
I still suspect that your patch would improve things.

Time to move back to debugging other stuff, though.

Andrew, it would be nice if our patches could cook in -mm
for a while.  Want me to change anything before submitting?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
