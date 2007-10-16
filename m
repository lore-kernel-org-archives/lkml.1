Return-Path: <linux-kernel-owner+w=401wt.eu-S1765349AbXJPJf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765349AbXJPJf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbXJPJft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:35:49 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48013 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbXJPJfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:35:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] rd: Preserve the dirty bit in init_page_buffers()
References: <200710151028.34407.borntraeger@de.ibm.com>
	<m18x64knqx.fsf@ebiederm.dsl.xmission.com>
	<m14pgsknmd.fsf_-_@ebiederm.dsl.xmission.com>
	<200710161812.01970.nickpiggin@yahoo.com.au>
Date: Tue, 16 Oct 2007 03:35:08 -0600
In-Reply-To: <200710161812.01970.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Tue, 16 Oct 2007 18:12:01 +1000")
Message-ID: <m1przfh06r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Tuesday 16 October 2007 08:40, Eric W. Biederman wrote:
>> The problem:  When we are trying to free buffers try_to_free_buffers()
>> will look at ramdisk pages with clean buffer heads and remove the
>> dirty bit from the page.  Resulting in ramdisk pages with data that get
>> removed from the page cache.  Ouch!
>>
>> Buffer heads appear on ramdisk pages when a filesystem calls
>> __getblk() which through a series of function calls eventually calls
>> init_page_buffers().
>>
>> So to fix the mismatch between buffer head and page state this patch
>> modifies init_page_buffers() to transfer the dirty bit from the page to
>> the buffer heads like we currently do for the uptodate bit.
>>
>> This patch is safe as only __getblk calls init_page_buffers, and
>> there are only two implementations of block devices cached in the
>> page cache.  The generic implementation in block_dev.c and the
>> implementation in rd.c.
>>
>> The generic implementation of block devices always does everything
>> in terms of buffer heads so it always has buffer heads allocated
>> before a page is marked dirty so this change does not affect it.
>
> This is probably a good idea. Was this causing the reiserfs problems?
> If so, I think we should be concentrating on what the real problem
> is with reiserfs... (or at least why this so obviously correct
> looking patch is wrong).

I think it was my cleanup patch that was sitting on top of this,
That caused the problems.

Eric
