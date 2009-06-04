Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbZFDGZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbZFDGZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZFDGZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 02:25:25 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:34104 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZFDGZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 02:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nBBQNuAPFsZ4hvFt6jNXoFmohFqgMKmwQ5M3TlvzAY8ZcWVIoOQzVCdqr6qax/GY7y
         4qF0Zz3xB4rITov2GEFmwQKwXMKTDlP8mOJ79JwrIkqihNv/O7faJx0SBkUBQM/tDC7j
         hv21/0ubtzlZzz/drrNFmhyWkF6CQA5eJmPNg=
MIME-Version: 1.0
In-Reply-To: <20090528145021.GA5503@localhost>
References: <200905271012.668777061@firstfloor.org>
	 <20090527201239.C2C9C1D0294@basil.firstfloor.org>
	 <20090528082616.GG6920@wotan.suse.de>
	 <20090528093141.GD1065@one.firstfloor.org>
	 <20090528120854.GJ6920@wotan.suse.de>
	 <20090528134520.GH1065@one.firstfloor.org>
	 <20090528145021.GA5503@localhost>
Date: Thu, 4 Jun 2009 14:25:24 +0800
Message-ID: <ab418ea90906032325m302afbb6w6fa68f6b57f53e49@mail.gmail.com>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in 
	the VM v3
From: Nai Xia <nai.xia@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 10:50 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Thu, May 28, 2009 at 09:45:20PM +0800, Andi Kleen wrote:
>> On Thu, May 28, 2009 at 02:08:54PM +0200, Nick Piggin wrote:
>
> [snip]
>
>> >
>> > BTW. I don't know if you are checking for PG_writeback often enough?
>> > You can't remove a PG_writeback page from pagecache. The normal
>> > pattern is lock_page(page); wait_on_page_writeback(page); which I
>>
>> So pages can be in writeback without being locked? I still
>> wasn't able to find such a case (in fact unless I'm misreading
>> the code badly the writeback bit is only used by NFS and a few
>> obscure cases)
>
> Yes the writeback page is typically not locked. Only read IO requires
> to be exclusive. Read IO is in fact page *writer*, while writeback IO
> is page *reader* :-)

Sorry for maybe somewhat a little bit off topic,
I am trying to get a good understanding of PG_writeback & PG_locked ;)

So you are saying PG_writeback & PG_locked are acting like a read/write lock?
I notice wait_on_page_writeback(page) seems always called with page locked --
that is the semantics of a writer waiting to get the lock while it's
acquired by
some reader:The caller(e.g. truncate_inode_pages_range()  and
invalidate_inode_pages2_range()) are the writers waiting for
writeback readers (as you clarified ) to finish their job, right ?

So do you think the idea is sane to group the two bits together
to form a real read/write lock, which does not care about the _number_
of readers ?


>
> The writeback bit is _widely_ used.  test_set_page_writeback() is
> directly used by NFS/AFS etc. But its main user is in fact
> set_page_writeback(), which is called in 26 places.
>
>> > think would be safest
>>
>> Okay. I'll just add it after the page lock.
>>
>> > (then you never have to bother with the writeback bit again)
>>
>> Until Fengguang does something fancy with it.
>
> Yes I'm going to do it without wait_on_page_writeback().
>
> The reason truncate_inode_pages_range() has to wait on writeback page
> is to ensure data integrity. Otherwise if there comes two events:
>        truncate page A at offset X
>        populate page B at offset X
> If A and B are all writeback pages, then B can hit disk first and then
> be overwritten by A. Which corrupts the data at offset X from user's POV.
>
> But for hwpoison, there are no such worries. If A is poisoned, we do
> our best to isolate it as well as intercepting its IO. If the interception
> fails, it will trigger another machine check before hitting the disk.
>
> After all, poisoned A means the data at offset X is already corrupted.
> It doesn't matter if there comes another B page.
>
> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
