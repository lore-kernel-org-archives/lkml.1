Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZBCNlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZBCNlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBCNlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:41:14 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60139 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZBCNlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:41:12 -0500
Subject: Re: [BUGFIX take 2] [PATCH] write-back: fix nr_to_write counter
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: dedekind@infradead.org
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1233655712.24809.101.camel@localhost.localdomain>
References: <1233655712.24809.101.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 07:41:01 -0600
Message-Id: <1233668461.30906.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 12:08 +0200, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Date: Mon, 2 Feb 2009 18:33:49 +0200
> Subject: [PATCH] write-back: fix nr_to_write counter
> 
> Commit 05fe478dd04e02fa230c305ab9b5616669821dd3 introduced some
> @wbc->nr_to_write breakage. Here is the change from the commit:
> 
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
>                                 done = 1
>                         }

Actually quoting a patch in the description in this manner will make the
patch fail to apply (or fail to apply correctly).  If you must quote the
patch, you should probably prepend ">" or something.

> It makes the following changes:
> 1. Decrement wbc->nr_to_write instead of nr_to_write
> 2. Decrement wbc->nr_to_write _only_ if wbc->sync_mode == WB_SYNC_NONE
> 3. If synced nr_to_write pages, stop only if if wbc->sync_mode ==
> WB_SYNC_NONE, otherwise keep going.
> 
> However, according to the commit message, the intention was to
> only make change 3. Change 1 is a bug. Change 2 does not seem to be
> necessary, and it breaks UBIFS expectations, so if needed, it
> should be done separately later. And change 2 does not seem to
> be documented in the commit message.
> 
> This patch des the following:
> 1. Undo changes 1 and 2
> 2. Add a comment explaining change 3 (it very useful to have comments in
> _code_, not only in the commit).
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Acked-by: Nick Piggin <npiggin@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
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
> 
> 
-- 
David Kleikamp
IBM Linux Technology Center

