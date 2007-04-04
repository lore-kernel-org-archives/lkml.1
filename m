Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbXDDRLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbXDDRLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXDDRLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:11:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48246 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbXDDRLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:11:16 -0400
Date: Wed, 4 Apr 2007 10:10:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [S390] page_mkclean data corruption.
In-Reply-To: <1175704624.31111.3.camel@localhost>
Message-ID: <Pine.LNX.4.64.0704041003560.6730@woody.linux-foundation.org>
References: <1175704624.31111.3.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Apr 2007, Martin Schwidefsky wrote:
>
> the attached patch fixes a data corruption problem that has been
> introduced with the page_mkclean/clear_page_dirty_for_io change
> (the "Yes, Virginia, this is indeed insane." problem :-/)

Ok. I'm a bit worried about something like this, this late in the release 
cycle, but since I guess page_test_and_clear_dirty() is always 0 for any 
architecture but S390, I guess there are no possible downsides except for 
that architecture.

So I'll apply it, but:

> The effect of the two changes is that for every call to
> clear_page_dirty_for_io a page_test_and_clear_dirty is done. If
> the per page dirty bit is set set_page_dirty is called. Strangly
> clear_page_dirty_for_io is called for not-uptodate pages, e.g.
> over this call-chain:
> 
>  [<000000000007c0f2>] clear_page_dirty_for_io+0x12a/0x130
>  [<000000000007c494>] generic_writepages+0x258/0x3e0 
>  [<000000000007c692>] do_writepages+0x76/0x7c 
>  [<00000000000c7a26>] __writeback_single_inode+0xba/0x3e4
>  [<00000000000c831a>] sync_sb_inodes+0x23e/0x398 
>  [<00000000000c8802>] writeback_inodes+0x12e/0x140 
>  [<000000000007b9ee>] wb_kupdate+0xd2/0x178 
>  [<000000000007cca2>] pdflush+0x162/0x23c 
> 
> The bad news now is that page_test_and_clear_dirty might claim
> that a not-uptodate page is dirty since SetPageUptodate which
> resets the per page dirty bit has not yet been called. The page
> writeback that follows clobbers the data on disk.

Wouldn't it be best if S390 tried to avoid this by clearing the dirty bit 
whenever a new page is allocated? 

This is a very subtle and very surprising problem with the whole 
"page_test_and_clear_dirty()" thing - where a new page can be marked dirty 
for no obvious reason.

If S390 marked it clean at *allocation* time instead of at 
SetPageUptodate() time, that would also mean that the whole strange 
special case for S390 in SetPageUptodate() would go away.

Hmm? Or is marking things clean so expensive that you generally don't want 
to do it in the allocation path?

Anyway, I'll apply the patch, since for 2.6.21 this is clearly the 
simplest solution, but 
 (a) I think it might be ugly
and
 (b) are you sure that it doesn't introduce a new bug on S390, where some 
     page has been *removed* from the mappings, and should still trigger 
     the "page_test_and_clear_dirty()" test, but now, because it's done 
     inside the "if (page_mapped())" case, we miss it?

That said, in many ways, moving the whole "page_test_and_clear_dirty()" 
thing inside the "page_mapped()" thing does seem to make conceptual sense 
(since the only way it would become dirty in that way is if it's mapped), 
so I don't mind the patch, I just worry about (b) a bit, and if we got rid 
of the strange special code in S390 to SetPageUptodate() that would also 
be nice.

		Linus
