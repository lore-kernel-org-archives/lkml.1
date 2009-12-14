Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbZLOAA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbZLOAA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758830AbZLOAA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:00:28 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:33989 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828AbZLOAA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:00:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=nDeOkNBclhH7b2w5NPndI15B69g6BFSM7KjlsiexLi3ii0NUDI4hRfN+h2DyuWbzEP
         DEh3frM/6AhxtLDzeiMnfO3/DOOiUnq/eOY/JISGoS/AgNiCMNNJBzCNr9ackhZpATEf
         m1LuG8s6wGvcA5EXlR3aLOUSQ3+r2H86aAaSo=
Date: Tue, 15 Dec 2009 08:54:55 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 8/8] mm: Give up allocation if the task have fatal
 signal
Message-Id: <20091215085455.13eb65cc.minchan.kim@barrios-desktop>
In-Reply-To: <20091214213224.BBC6.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	<20091214210823.BBAE.A69D9226@jp.fujitsu.com>
	<20091214213224.BBC6.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 21:32:58 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> In OOM case, almost processes may be in vmscan. There isn't any reason
> the killed process continue allocation. process exiting free lots pages
> rather than greedy vmscan.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/page_alloc.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ca9cae1..8a9cbaa 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1878,6 +1878,14 @@ rebalance:
>  		goto got_pg;
>  
>  	/*
> +	 * If the allocation is for userland page and we have fatal signal,
> +	 * there isn't any reason to continue allocation. instead, the task
> +	 * should exit soon.
> +	 */
> +	if (fatal_signal_pending(current) && (gfp_mask & __GFP_HIGHMEM))
> +		goto nopage;

If we jump nopage, we meets dump_stack and show_mem. 
Even, we can meet OOM which might kill innocent process.

> +
> +	/*
>  	 * If we failed to make any progress reclaiming, then we are
>  	 * running out of options and have to consider going OOM
>  	 */
> -- 
> 1.6.5.2
> 
> 
> 


-- 
Kind regards,
Minchan Kim
