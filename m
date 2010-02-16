Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab0BPWDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:03:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20437 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429Ab0BPWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:03:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xQIvv3g6H8isuuOC9yhO7/uFknHHVjQltbIT4wUK4GK9ZqNYA1DpZ15VoRtA041H4
	xV32CCF5Rcj/gjTQtrHdQ==
Date: Tue, 16 Feb 2010 14:03:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm] Kill existing current task quickly
In-Reply-To: <1266335957.1709.67.camel@barrios-desktop>
Message-ID: <alpine.DEB.2.00.1002161357170.23037@chino.kir.corp.google.com>
References: <1266335957.1709.67.camel@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, Minchan Kim wrote:

> If we found current task is existing but didn't set TIF_MEMDIE
> during OOM victim selection, let's stop unnecessary looping for
> getting high badness score task and go ahead for killing current.
> 
> This patch would make side effect skip OOM_DISABLE test.
> But It's okay since the task is existing and oom_kill_process
> doesn't show any killing message since __oom_kill_task will
> interrupt it in oom_kill_process.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: Nick Piggin <npiggin@suse.de>
> ---
>  mm/oom_kill.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 3618be3..5c21398 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -295,6 +295,7 @@ static struct task_struct
> *select_bad_process(unsigned long *ppoints,
>  
>  			chosen = p;
>  			*ppoints = ULONG_MAX;
> +			break;
>  		}
>  
>  		if (p->signal->oom_adj == OOM_DISABLE)

No, we don't want to break because there may be other candidate tasks that 
have TIF_MEMDIE set that will be detected if we keep scanning.  Returning 
ERR_PTR(-1UL) from select_bad_process() has a special meaning: it means we 
return to the page allocator without doing anything.  We don't want more 
than one candidate task to ever have TIF_MEMDIE at a time, otherwise they 
can deplete all memory reserves and not make any forward progress.  So we 
always have to iterate the entire tasklist unless we find an already oom 
killed task with access to memory reserves (to prevent needlessly killing 
additional tasks before the first had a chance to exit and free its 
memory) or a different candidate task is exiting so we'll be freeing 
memory shortly (or it will be invoking the oom killer itself as current 
and then get chosen as the victim).
