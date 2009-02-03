Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZBCJp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZBCJp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZBCJpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:45:47 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:21820 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752885AbZBCJpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:45:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=plBD4BcQF+kEQL+whlsUm+WPVRpHvprZwdvy/gePPU08HXeKY/1LJkwETSvh2+B5kU7PXixp8GhYVnBDx84+V4UBHmGdc/Jf2K3bUNlKGTjRTRqio4mglSQzQGmPk52DYNKcTY3pXkGW2H/HqWRHmtJXDVL3/rXMJkIu1ba9/Qc=  ;
X-YMail-OSG: MTTKcpIVM1lmHiqyr29aAl4iuujIYRx.vx7MRbp4YvCpNp5JeMJ7C97LRyhs.1F8xixC7.xZJxsEJ_hf4tmC0g2d8mNYjCo5rDSE58tyat5mSchPpUIeWGMSPmnIuNC89cA5YPPnRRaCt2Z0vjlAugcjtnLnXzUv4DYxiA0WKtz9xFZnbYO29NZhiU1tNkbcZqOqF0l4e5unQOshdZl0tXSqMiw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: dedekind@infradead.org
Subject: Re: [BUGFIX re-send] [PATCH] write-back: fix nr_to_write counter
Date: Tue, 3 Feb 2009 20:45:15 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>, npiggin@suse.de,
       LKML <linux-kernel@vger.kernel.org>
References: <1233650542.24809.54.camel@localhost.localdomain> <200902032013.57438.nickpiggin@yahoo.com.au> <1233653569.24809.69.camel@localhost.localdomain>
In-Reply-To: <1233653569.24809.69.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032045.16829.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 20:32:49 Artem Bityutskiy wrote:
> On Tue, 2009-02-03 at 20:13 +1100, Nick Piggin wrote:
> > On Tuesday 03 February 2009 19:42:22 Artem Bityutskiy wrote:
> > > Hi,
> > >
> > > commit 05fe478dd04e02fa230c305ab9b5616669821dd3
> > > Author: Nick Piggin <npiggin@suse.de>
> > > Date:   Tue Jan 6 14:39:08 2009 -0800
> > >
> > >     mm: write_cache_pages integrity fix
> > >
> > > broke wbc->nr_to_write handling. Here is the fix.
> > >
> > > I'm not 100% sure I got things right, because I am far not expert in
> > > the area. Please, review it. The patch fixes my UBIFS issues, which are
> > > caused by the fact that wbc->nr_to_write is not updated.
> > > ======================================================================
> > >
> > > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > > Date: Mon, 2 Feb 2009 18:33:49 +0200
> > > Subject: [PATCH] write-back: fix nr_to_write counter
> > >
> > > Commit 05fe478dd04e02fa230c305ab9b5616669821dd3 broke
> > > @wbc->nr_to_write. 'write_cache_pages()' changes it in the loop, but
> > > restores the original value from @nr_to_write at the end, because of
> > > this code:
> > >
> > >        if (!wbc->no_nrwrite_index_update) {
> > >                 if (wbc->range_cyclic || (range_whole && nr_to_write >
> > > 0)) mapping->writeback_index = done_index; wbc->nr_to_write =
> > > nr_to_write;
> > >         }
> >
> > The commit you quote only moves nr_to_write to not take effect for
> > WB_SYNC_ALL (ie. data integrity) writeout. And makes no other change
> > to write_cache_pages.
>
> Nick, I'm sorry if my e-mail looked like I'm blame you, I referred the
> commit because git-bisect pointed to it and I though it for me :-)
>
> And I apologize if I write stupid things.

No, you are probably right to blame me ;) but I just am not quite sure
if I read your description correctly.


> Here is the commit 05fe478dd04e02fa230c305ab9b5616669821dd3:
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index f9d8818..9c5e623 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -210,7 +210,7 @@ int __filemap_fdatawrite_range(struct address_space
> *mapping, loff_t start, int ret;
>         struct writeback_control wbc = {
>                 .sync_mode = sync_mode,
> -               .nr_to_write = mapping->nrpages * 2,
> +               .nr_to_write = LONG_MAX,
>                 .range_start = start,
>                 .range_end = end,
>         };
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 2e847cd..5edca67 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -963,8 +963,10 @@ retry:
>                                 }
>                         }
>
> -                       if (--nr_to_write <= 0)
> -                               done = 1;
> +                       if (wbc->sync_mode == WB_SYNC_NONE) {
> +                               if (--wbc->nr_to_write <= 0)
> +                                       done = 1;
> +                       }
>                         if (wbc->nonblocking && bdi_write_congested(bdi)) {
>                                 wbc->encountered_congestion = 1;
>                                 done = 1;
>
> It makes the following changes:
> 1. Decrement wbc->nr_to_write instead of nr_to_write

Ah, ok drat yes I missed this. Indeed this is a stupid bug :(


> 2. Decrement wbc->nr_to_write _only_ if wbc->sync_mode == WB_SYNC_NONE
> 3. If synced nr_to_write pages, stop only if if wbc->sync_mode ==
> WB_SYNC_NONE, otherwise keep going.
>
> The commit message talks only about item 3, at leaset as I understand
> it. I do not quote the commit message because it is large. Thus, I
> thought changes 1 and 2 were not intentional.

2 was more or less intentional but I glossed over ubifs. At any rate
I'm happy if you restore the old behaviour.


> In my patch I try to
> 1. Undo changes 1 and 2
> 2. Add a comment explaining change 3 (it very useful to have comments in
> _code_, not only in the commit)
>
> > I thought your problem might have been that you were calling this
> > with WB_SYNC_ALL and expecting it to heed nr_to_write, however...
>
> Err, my problem is that wbc->nr_to_write is not updated.
>
> > > Also, I think wbc->nr_to_write should be changed in all cases, not only
> > > when wbc->sync_mode == WB_SYNC_NONE.
> >
> > ... you mention this here like it is an *additional* issue on top
> > of your problem. So I fail to see how my commit could have caused
> > this problem?
>
> This is the change number 2 in your commit.

OK, it just wasn't clear to me from the changelog (I missed noticing bug #1).


> > > Well, in case of @wbc->no_nrwrite_index_update != 0, we do change
> > > wbc->nr_to_write, while we should not. This patch fixes this behavior.
> >
> > And I don't know what you mean by this because the patch doesn't
> > fix any problem there AFAIKS.
>
> This is about change number 1. In the "for" loop you change
> wbc->nr_to_write, instead of nr_to_write. But before the function
> returns, it writes nr_to_write back to wbc->nr_to_write, so the
> result is that the caller sees wbc->nr_to_write unchanged.
>
> > Anyway, I did probably not pay enough attention to ubifs when making
> > this change, and if it wants wbc->nr_to_write updated even for data
> > integrity syncs, I don't see the harm in that. So I don't have any
> > objection to your patch. Thanks.
>
> It is just how things were _before_ your patch.
>
> > Can you cc stable@kernel.org when a final version gets merged upstream
> > please?
>
> Sure, I just want to get blessing of one of MM/FS gurus. E.g. you
> Acked-by would be enough.

Yes please put an Acked-by: Nick Piggin <npiggin@suse.de> on there.
But I found your comments in this mail to be easier to understand.
Perhaps incorporate them into the changelog?

