Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZBCJOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZBCJOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZBCJO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:14:26 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:21145 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750977AbZBCJOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:14:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=t/IU9xrWyCOLVSVK8BWWmLWEGJYIINR+Uz4PCJFvOcyWcnOSEenzpT0EsFPFCzTXYuQvQOsAUXOXTwxRuesvxG28kZcK10ywNNTuygbJKPjr7+rlrC/jjVA0jFPWbHy2pSh/picAJ8xXFzenM9m9kiqLOU+QPNQNQsoZ4wbt6B0=  ;
X-YMail-OSG: 2ZbRzHYVM1lF.l9tG28S33HpUS.ecgJyHcg0sh5_4jDBtjSfd9tS67tBvR4wy1e6AmUwgOiU_hGx8GsugcgozNn3GtzkhyhLlzi87_ELgrD5SDxdtHLCtpyBN0SaJ6VSQnEOYZO9mP7s9X.jcMpwfornc8wlCm46dVW1KPOjBvOfF8qzfqr0_ssQPBbjoFzaZAwrdpWknzZCU8VuFtrHdOfIw4I-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: dedekind@infradead.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUGFIX re-send] [PATCH] write-back: fix nr_to_write counter
Date: Tue, 3 Feb 2009 20:13:56 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "linux-fsdevel" <linux-fsdevel@vger.kernel.org>, npiggin@suse.de,
       LKML <linux-kernel@vger.kernel.org>
References: <1233650542.24809.54.camel@localhost.localdomain>
In-Reply-To: <1233650542.24809.54.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032013.57438.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 19:42:22 Artem Bityutskiy wrote:
> Hi,
>
> commit 05fe478dd04e02fa230c305ab9b5616669821dd3
> Author: Nick Piggin <npiggin@suse.de>
> Date:   Tue Jan 6 14:39:08 2009 -0800
>
>     mm: write_cache_pages integrity fix
>
> broke wbc->nr_to_write handling. Here is the fix.
>
> I'm not 100% sure I got things right, because I am far not expert in the
> area. Please, review it. The patch fixes my UBIFS issues, which are
> caused by the fact that wbc->nr_to_write is not updated.
> ======================================================================
>
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Date: Mon, 2 Feb 2009 18:33:49 +0200
> Subject: [PATCH] write-back: fix nr_to_write counter
>
> Commit 05fe478dd04e02fa230c305ab9b5616669821dd3 broke @wbc->nr_to_write.
> 'write_cache_pages()' changes it in the loop, but restores the original
> value from @nr_to_write at the end, because of this code:
>
>        if (!wbc->no_nrwrite_index_update) {
>                 if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
>                         mapping->writeback_index = done_index;
>                 wbc->nr_to_write = nr_to_write;
>         }

The commit you quote only moves nr_to_write to not take effect for
WB_SYNC_ALL (ie. data integrity) writeout. And makes no other change
to write_cache_pages.

I thought your problem might have been that you were calling this
with WB_SYNC_ALL and expecting it to heed nr_to_write, however...

> Also, I think wbc->nr_to_write should be changed in all cases, not only
> when wbc->sync_mode == WB_SYNC_NONE.

... you mention this here like it is an *additional* issue on top
of your problem. So I fail to see how my commit could have caused
this problem?


> Well, in case of @wbc->no_nrwrite_index_update != 0, we do change
> wbc->nr_to_write, while we should not. This patch fixes this behavior.

And I don't know what you mean by this because the patch doesn't
fix any problem there AFAIKS.

Anyway, I did probably not pay enough attention to ubifs when making
this change, and if it wants wbc->nr_to_write updated even for data
integrity syncs, I don't see the harm in that. So I don't have any
objection to your patch. Thanks.

Can you cc stable@kernel.org when a final version gets merged upstream
please?

>
> Also, I add a comment explaining why we do not stop writing back.
>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---
>  mm/page-writeback.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index b493db7..13a2b8e 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1051,13 +1051,22 @@ continue_unlock:
>  				}
>   			}
>
> -			if (wbc->sync_mode == WB_SYNC_NONE) {
> -				wbc->nr_to_write--;
> -				if (wbc->nr_to_write <= 0) {
> -					done = 1;
> -					break;
> -				}
> +			if (nr_to_write > 0)
> +				nr_to_write--;
> +			else if (wbc->sync_mode == WB_SYNC_NONE) {
> +				/*
> +				 * We stop writing back only if we are not
> +				 * doing integrity sync. In case of integrity
> +				 * sync we have to keep going because someone
> +				 * may be concurrently dirtying pages, and we
> +				 * might have synced a lot of newly appeared
> +				 * dirty pages, bud have not synced all of the
> +				 * old dirty pages.
> +				 */
> +				done = 1;
> +				break;
>  			}
> +
>  			if (wbc->nonblocking && bdi_write_congested(bdi)) {
>  				wbc->encountered_congestion = 1;
>  				done = 1;
> --
> 1.6.0.6


