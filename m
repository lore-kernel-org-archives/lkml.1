Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZIIIDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZIIIDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZIIIDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:03:53 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33851 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZIIIDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:03:49 -0400
Message-ID: <4AA76162.2000309@nokia.com>
Date: Wed, 09 Sep 2009 11:03:46 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "david@fromorbit.com" <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH] mm: write_cache_pages be more sequential
References: <4AA513AA.3010206@nokia.com> <20090907141548.GA28054@wotan.suse.de> <4AA518B3.40401@nokia.com> <20090907144514.GC28054@wotan.suse.de>
In-Reply-To: <20090907144514.GC28054@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2009 08:03:21.0829 (UTC) FILETIME=[FFC66950:01CA3123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Nick Piggin wrote:
> On Mon, Sep 07, 2009 at 05:29:07PM +0300, Adrian Hunter wrote:
>> Nick Piggin wrote:
>>> On Mon, Sep 07, 2009 at 05:07:38PM +0300, Adrian Hunter wrote:
>>>> >From 6f3bb7c26936c45d810048f59c369e8d5a5623fc Mon Sep 17 00:00:00 2001
>>>> From: Adrian Hunter <adrian.hunter@nokia.com>
>>>> Date: Mon, 7 Sep 2009 10:49:11 +0300
>>>> Subject: [PATCH] mm: write_cache_pages be more sequential
>>>>
>>>> If a file is written to sequentially, then writeback
>>>> should write the pages sequentially also.  However,
>>>> that does not always happen.  For example:
>>>>
>>>> 1) user writes pages 0, 1 and 2 but 2 is incomplete
>>>> 2) write_cache_pages writes pages 0, 1 and 2 and sets
>>>> writeback_index to 3
>>>> 3) user finishes writing page 2 and writes pages 3 and 4
>>>> 4) write_cache_pages writes pages 3 and 4, and then cycles
>>>> back and writes page 2 again.
>>>>
>>>> So the pages are written out in the order 0, 1, 2, 3 ,4 ,2
>>>> instead of 0, 1, 2, 2, 3, 4.
>>> Why does page 2 get set dirty if the write was incomplete?
>> I meant that only part of the page was written. e.g.
>> write 10240 bytes, wait for writeback, then write another
>> 10240 bytes.  The pages will be written out in the order
>> 0, 1, 2, 3, 4, 2
> 
> OK...
> 
> 
>>>> This situation was noticed on UBIFS because it writes
>>>> directly from writepage.  Hence if there is an unexpected
>>>> power-loss, a file will end up with a hole even though
>>>> the file was written sequentially by the user.
>>>>
>>>> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
>>>> ---
>>>> mm/page-writeback.c |    2 ++
>>>> 1 files changed, 2 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>>>> index 81627eb..7410b7a 100644
>>>> --- a/mm/page-writeback.c
>>>> +++ b/mm/page-writeback.c
>>>> @@ -960,6 +960,8 @@ int write_cache_pages(struct address_space *mapping,
>>>> 	pagevec_init(&pvec, 0);
>>>> 	if (wbc->range_cyclic) {
>>>> 		writeback_index = mapping->writeback_index; /* prev offset */
>>>> +		if (writeback_index)
>>>> +			writeback_index -= 1;
>>>> 		index = writeback_index;
>>>> 		if (index == 0)
>>>> 			cycled = 1;
>>> Doesn't this just break range_cyclic? range_cyclic is supposed to
>>> work across calls to write_cache_pages, and it's there I guess so
>>> background writeout will be able to eventually get around to writing
>>> all pages relatively fairly in the presence of redirtying operations.
>> I do not immediately see how it breaks range_cyclic.  Can you give an
>> example?
> 
> Oh, I must be dyslexic, I read it as writeback_index = -1; :P
> But I think it can still cause some subtle problems with error
> cases.
> 
> I guess you could just make the done_index assignment more logical
> and make it page->index. Then add a comment when assigning to
> writeback_index that you want to start up again at the previously
> written page to help this case.

That means changing slightly the meaning of writeback_index which will
mean more analysis to avoid unexpected side-effects.

Speaking of unexpected side-effects, I glanced at ext4_da_writepages()
which contains the line:

		wbc->nr_to_write -= mpd.pages_written;

which should probably be:

		if (mpd.pages_written >= wbc->nr_to_write)
			wbc->nr_to_write = 0;
		else
			wbc->nr_to_write -= mpd.pages_written;

now that write_cache_pages() can write more than wbc->nr_to_write
pages.  What do you think?

> Also, check to ensure the error cases are going to still work correctly.
> Eg. you might want to increment done_index in the case of error.

Sure.

> I guess it is a reasonable workaround for the problem. It is a bit
> unsatisfying to special case on a page basis like this, but anyway
> I don't think there should be a realistic downside in practice.

