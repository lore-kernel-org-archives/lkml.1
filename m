Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbXDDRf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbXDDRf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXDDRf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:35:26 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:44036 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXDDRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:35:18 -0400
Subject: Re: [S390] page_mkclean data corruption.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0704041003560.6730@woody.linux-foundation.org>
References: <1175704624.31111.3.camel@localhost>
	 <Pine.LNX.4.64.0704041003560.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Wed, 04 Apr 2007 19:35:32 +0200
Message-Id: <1175708132.31111.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 10:10 -0700, Linus Torvalds wrote:
> Ok. I'm a bit worried about something like this, this late in the release 
> cycle, but since I guess page_test_and_clear_dirty() is always 0 for any 
> architecture but S390, I guess there are no possible downsides except for 
> that architecture.

Yes, the change can only affect s390 since for all other architectures
page_test_and_clear_dirty is a nop.

> So I'll apply it, but:
> 
> > The effect of the two changes is that for every call to
> > clear_page_dirty_for_io a page_test_and_clear_dirty is done. If
> > the per page dirty bit is set set_page_dirty is called. Strangly
> > clear_page_dirty_for_io is called for not-uptodate pages, e.g.
> > over this call-chain:
> > 
> >  [<000000000007c0f2>] clear_page_dirty_for_io+0x12a/0x130
> >  [<000000000007c494>] generic_writepages+0x258/0x3e0 
> >  [<000000000007c692>] do_writepages+0x76/0x7c 
> >  [<00000000000c7a26>] __writeback_single_inode+0xba/0x3e4
> >  [<00000000000c831a>] sync_sb_inodes+0x23e/0x398 
> >  [<00000000000c8802>] writeback_inodes+0x12e/0x140 
> >  [<000000000007b9ee>] wb_kupdate+0xd2/0x178 
> >  [<000000000007cca2>] pdflush+0x162/0x23c 
> > 
> > The bad news now is that page_test_and_clear_dirty might claim
> > that a not-uptodate page is dirty since SetPageUptodate which
> > resets the per page dirty bit has not yet been called. The page
> > writeback that follows clobbers the data on disk.
> 
> Wouldn't it be best if S390 tried to avoid this by clearing the dirty bit 
> whenever a new page is allocated? 

We would love to but we cannot. The point is that I/O makes a page
dirty. We could clear the dirty bit on allocation time but the page-in
operation would make it dirty again and we'd have to make it clean AGAIN
in SetPageUptodate. The iske + sske instructions are in the range of
several 100 cycles, so they are quite expensive.

> Anyway, I'll apply the patch, since for 2.6.21 this is clearly the 
> simplest solution, but 
>  (a) I think it might be ugly
> and
>  (b) are you sure that it doesn't introduce a new bug on S390, where some 
>      page has been *removed* from the mappings, and should still trigger 
>      the "page_test_and_clear_dirty()" test, but now, because it's done 
>      inside the "if (page_mapped())" case, we miss it?

No, I'm very sure that this won't be the case. The per page dirty bit on
s390 is used as a replacement for the per pte dirty bits. We check a
single time after all the pte operations instead of doing it for every
pte. As long as there is a page_test_and_clear_dirty after the last pte
related to a page has been modified in page_mkclean or removed in
page_remove_rmap we are fine.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


