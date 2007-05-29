Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbXE2Q7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbXE2Q7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXE2Q7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:59:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbXE2Q7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:59:22 -0400
Message-ID: <465C5BE0.4090903@redhat.com>
Date: Tue, 29 May 2007 12:59:12 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au>
In-Reply-To: <463B108C.10602@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Rik van Riel wrote:
>> With lazy freeing of anonymous pages through MADV_FREE, performance of
>> the MySQL sysbench workload more than doubles on my quad-core system.
> 
> OK, I've run some tests on a 16 core Opteron system, both sysbench with
> MySQL 5.33 (set up as described in the freebsd vs linux page), and with
> ebizzy.
> 
> What I found is that, on this system, MADV_FREE performance improvement
> was in the noise when you look at it on top of the MADV_DONTNEED glibc
> and down_read(mmap_sem) patch in sysbench.

It turns out that setting the pte accessed bit in hardware
can apparently take a few thousand CPU cycles - 3000 cycles
is the number I've heard for one CPU family.

This is a similar number of cycles as is needed to zero out
a page.  Giving a cache hot page to userspace could cancel
out the rest of the cost of the page fault handling.

Lets stick with the simpler MADV_DONTNEED code for now and
save the page flag for something else...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
