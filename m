Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZBDR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZBDR4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZBDR4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:56:07 -0500
Received: from 64-76-18-116.static.impsat.net.ar ([64.76.18.116]:54066 "EHLO
	mother.lugmen.org.ar" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZBDR4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:56:06 -0500
X-Greylist: delayed 1498 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 12:56:05 EST
Message-ID: <4989D0D4.80300@lugmen.org.ar>
Date: Wed, 04 Feb 2009 15:31:00 -0200
From: Federico Cuello <fedux@lugmen.org.ar>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sync-Regression in 2.6.28.2?
References: <20090127093533.GB7037@charite.de> <200902031209.12615.nickpiggin@yahoo.com.au> <4988A034.20406@lugmen.org.ar> <200902041717.27320.nickpiggin@yahoo.com.au>
In-Reply-To: <200902041717.27320.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> [...]
> Thanks, could you reply-to-all when replying to retain ccs please?
>
> Common theme is ext4, which uses no_nrwrite_index_update, and I introduced
> a bug in there which could possibly cause ext4 to go into a loop...
>
> Would it be possible if you can test the following patch?
>   

I'll test it as soon as I get home.

Meanwhile, I think the new patch may be slightly wrong. If I understand
correctly PageWriteback(page) is called before nr_to_write is tested for
being > 0 and then decremented if true, but "done" is  not set to 1
until the next iteration. So another call to PageWriteback(page) while
take place and then "done" will be set to true (if wbc->sync_mode ==
WB_SYNC_NONE).

If nr_to_write == 1 at the beginning of the loop then two pages will be
written.

I think the test condition should something like:

if (--nr_to_write <= 0 && wbc->sync_mode == WB_SYNC_NONE) {
    done = 1;
    break;
}

.
.

> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Acked-by: Nick Piggin <npiggin@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  mm/page-writeback.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index b493db7..dc32dae 100644
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
> +				 * dirty pages, but have not synced all of the
> +				 * old dirty pages.
> +				 */
> +				done = 1;
> +				break;
>  			}
> +
>  			if (wbc->nonblocking && bdi_write_congested(bdi)) {
>  				wbc->encountered_congestion = 1;
>  				done = 1;
>   

