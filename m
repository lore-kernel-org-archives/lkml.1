Return-Path: <linux-kernel-owner+w=401wt.eu-S1161384AbXDKW62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161384AbXDKW62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161369AbXDKW56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:57:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161363AbXDKW5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:57:51 -0400
Message-ID: <461D67A9.5020509@redhat.com>
Date: Wed, 11 Apr 2007 18:56:41 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com>
In-Reply-To: <461D6413.6050605@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Rik van Riel a écrit :
>> Make it possible for applications to have the kernel free memory
>> lazily.  This reduces a repeated free/malloc cycle from freeing
>> pages and allocating them, to just marking them freeable.  If the
>> application wants to reuse them before the kernel needs the memory,
>> not even a page fault will happen.

> I dont understand this last sentence. If not even a page fault happens, 
> how the kernel knows that the page was eventually reused by the 
> application, and should not be freed in case of memory pressure ?

Before maybe freeing the page, the kernel checks the referenced
and dirty bits of the page table entries mapping that page.

> ptr = mmap(some space);
> madvise(ptr, length, MADV_FREE);
> /* kernel may free the pages */

All this call does is:
- clear the accessed and dirty bits
- move the page to the far end of the inactive list,
   where it will be the first to be reclaimed

> sleep(10);
> 
> /* what the application must do know before reusing space ? */
> memset(ptr, data, 10000);
> /* kernel should not free ptr[0..10000] now */

Two things can happen here.

If this program used the pages before the kernel needed
them, the program will be reusing its old pages.

If the kernel got there first, you will get page faults
and the kernel will fill in the memory with new pages.

Both of these alternatives are transparent to userspace.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
