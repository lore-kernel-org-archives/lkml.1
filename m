Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZBCJdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZBCJdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZBCJdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:33:24 -0500
Received: from smtp.nokia.com ([192.100.105.134]:20120 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZBCJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:33:23 -0500
Subject: Re: [BUGFIX re-send] [PATCH] write-back: fix nr_to_write counter
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, npiggin@suse.de,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200902032013.57438.nickpiggin@yahoo.com.au>
References: <1233650542.24809.54.camel@localhost.localdomain>
	 <200902032013.57438.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Feb 2009 11:32:49 +0200
Message-Id: <1233653569.24809.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Feb 2009 09:32:44.0102 (UTC) FILETIME=[5DE2D660:01C985E2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 20:13 +1100, Nick Piggin wrote:
> On Tuesday 03 February 2009 19:42:22 Artem Bityutskiy wrote:
> > Hi,
> >
> > commit 05fe478dd04e02fa230c305ab9b5616669821dd3
> > Author: Nick Piggin <npiggin@suse.de>
> > Date:   Tue Jan 6 14:39:08 2009 -0800
> >
> >     mm: write_cache_pages integrity fix
> >
> > broke wbc->nr_to_write handling. Here is the fix.
> >
> > I'm not 100% sure I got things right, because I am far not expert in the
> > area. Please, review it. The patch fixes my UBIFS issues, which are
> > caused by the fact that wbc->nr_to_write is not updated.
> > ======================================================================
> >
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > Date: Mon, 2 Feb 2009 18:33:49 +0200
> > Subject: [PATCH] write-back: fix nr_to_write counter
> >
> > Commit 05fe478dd04e02fa230c305ab9b5616669821dd3 broke @wbc->nr_to_write.
> > 'write_cache_pages()' changes it in the loop, but restores the original
> > value from @nr_to_write at the end, because of this code:
> >
> >        if (!wbc->no_nrwrite_index_update) {
> >                 if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
> >                         mapping->writeback_index = done_index;
> >                 wbc->nr_to_write = nr_to_write;
> >         }
> 
> The commit you quote only moves nr_to_write to not take effect for
> WB_SYNC_ALL (ie. data integrity) writeout. And makes no other change
> to write_cache_pages.

Nick, I'm sorry if my e-mail looked like I'm blame you, I referred the
commit because git-bisect pointed to it and I though it for me :-)

And I apologize if I write stupid things.

Here is the commit 05fe478dd04e02fa230c305ab9b5616669821dd3:

diff --git a/mm/filemap.c b/mm/filemap.c
index f9d8818..9c5e623 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -210,7 +210,7 @@ int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
        int ret;
        struct writeback_control wbc = {
                .sync_mode = sync_mode,
-               .nr_to_write = mapping->nrpages * 2,
+               .nr_to_write = LONG_MAX,
                .range_start = start,
                .range_end = end,
        };
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2e847cd..5edca67 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -963,8 +963,10 @@ retry:
                                }
                        }

-                       if (--nr_to_write <= 0)
-                               done = 1;
+                       if (wbc->sync_mode == WB_SYNC_NONE) {
+                               if (--wbc->nr_to_write <= 0)
+                                       done = 1;
+                       }
                        if (wbc->nonblocking && bdi_write_congested(bdi)) {
                                wbc->encountered_congestion = 1;
                                done = 1;

It makes the following changes:
1. Decrement wbc->nr_to_write instead of nr_to_write
2. Decrement wbc->nr_to_write _only_ if wbc->sync_mode == WB_SYNC_NONE
3. If synced nr_to_write pages, stop only if if wbc->sync_mode ==
WB_SYNC_NONE, otherwise keep going.

The commit message talks only about item 3, at leaset as I understand
it. I do not quote the commit message because it is large. Thus, I
thought changes 1 and 2 were not intentional.

In my patch I try to
1. Undo changes 1 and 2
2. Add a comment explaining change 3 (it very useful to have comments in
_code_, not only in the commit)

> I thought your problem might have been that you were calling this
> with WB_SYNC_ALL and expecting it to heed nr_to_write, however...

Err, my problem is that wbc->nr_to_write is not updated.

> > Also, I think wbc->nr_to_write should be changed in all cases, not only
> > when wbc->sync_mode == WB_SYNC_NONE.
> 
> ... you mention this here like it is an *additional* issue on top
> of your problem. So I fail to see how my commit could have caused
> this problem?

This is the change number 2 in your commit.

> > Well, in case of @wbc->no_nrwrite_index_update != 0, we do change
> > wbc->nr_to_write, while we should not. This patch fixes this behavior.
> 
> And I don't know what you mean by this because the patch doesn't
> fix any problem there AFAIKS.

This is about change number 1. In the "for" loop you change
wbc->nr_to_write, instead of nr_to_write. But before the function
returns, it writes nr_to_write back to wbc->nr_to_write, so the
result is that the caller sees wbc->nr_to_write unchanged.

> Anyway, I did probably not pay enough attention to ubifs when making
> this change, and if it wants wbc->nr_to_write updated even for data
> integrity syncs, I don't see the harm in that. So I don't have any
> objection to your patch. Thanks.

It is just how things were _before_ your patch.

> Can you cc stable@kernel.org when a final version gets merged upstream
> please?

Sure, I just want to get blessing of one of MM/FS gurus. E.g. you
Acked-by would be enough.

Thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

