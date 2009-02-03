Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZBCJZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZBCJZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZBCJYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:24:46 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:38427 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750881AbZBCJYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:24:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=S9nRn0h9nYfQUFgh+IS3CkQ0rJaaAs16OIhBfqYAMcYe10mmIZ4enCyQSQY8qk62nCPvNYbmavXUpDaFj9AwMR3bYW9UUMQeqHUX/vscAx9z6aJk+hkGeu19cHbXEEwfLzSd0xJ9mgZOcNSMRPxHt4uBXjyGcyxJBw3BHuRh/fI=  ;
X-YMail-OSG: kSexjnwVM1kW9pVIRFcLAWoFo5cOmReJxFf7PhqjnI2TXoWO2gIqSBNYY5jh_khavhQCUv.Ikof7Gi682y1ftL5k3eud0uU99cBYhM9Pob.Zuii3FllEWsEFFYIhBj4O8tYBZ3DRokg6Qeu7UPrEHlI.6Uf1jf4iVd5dlHZSsS9dl7BfTejt3mqRvqT9SEphjTSjnfLiDsSlKgeWSfVoq_W22uw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: dedekind@infradead.org
Subject: Re: [BUGFIX re-send] [PATCH] write-back: fix nr_to_write counter
Date: Tue, 3 Feb 2009 20:24:17 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>, npiggin@suse.de,
       LKML <linux-kernel@vger.kernel.org>
References: <1233650542.24809.54.camel@localhost.localdomain> <200902032013.57438.nickpiggin@yahoo.com.au>
In-Reply-To: <200902032013.57438.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032024.19074.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 20:13:56 Nick Piggin wrote:
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
> >                 if (wbc->range_cyclic || (range_whole && nr_to_write >
> > 0)) mapping->writeback_index = done_index;
> >                 wbc->nr_to_write = nr_to_write;
> >         }
>
> The commit you quote only moves nr_to_write to not take effect for
> WB_SYNC_ALL (ie. data integrity) writeout. And makes no other change
> to write_cache_pages.
>
> I thought your problem might have been that you were calling this
> with WB_SYNC_ALL and expecting it to heed nr_to_write, however...
>
> > Also, I think wbc->nr_to_write should be changed in all cases, not only
> > when wbc->sync_mode == WB_SYNC_NONE.
>
> ... you mention this here like it is an *additional* issue on top
> of your problem. So I fail to see how my commit could have caused
> this problem?
>
> > Well, in case of @wbc->no_nrwrite_index_update != 0, we do change
> > wbc->nr_to_write, while we should not. This patch fixes this behavior.
>
> And I don't know what you mean by this because the patch doesn't
> fix any problem there AFAIKS.
>
> Anyway, I did probably not pay enough attention to ubifs when making
> this change, and if it wants wbc->nr_to_write updated even for data
> integrity syncs, I don't see the harm in that. So I don't have any
> objection to your patch. Thanks.
>
> Can you cc stable@kernel.org when a final version gets merged upstream
> please?

What I mean to say is that while I think the patch is not a problem,
and actually should be merged if it is required for ubifs, I would
like to just see the changelog clarified...

Also if you add a nice comment there, maybe mention that nr_to_write
must reflect the number of pages written even for the WB_SYNC_ALL case
(arguably the data integrity issue which you comment on is more
obvious in comparison to the nr_to_write requirement of callers).

