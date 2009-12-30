Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZL3M3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZL3M3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZL3M3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:29:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbZL3M3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:29:32 -0500
Subject: Re: [PATCH 1/1] perf_event: add check for group_list if the parent
 isn't counted
From: Peter Zijlstra <peterz@infradead.org>
To: Liming Wang <liming.wang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1262172487-13694-1-git-send-email-liming.wang@windriver.com>
References: <1262172487-13694-1-git-send-email-liming.wang@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 13:28:45 +0100
Message-ID: <1262176125.7135.207.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 19:28 +0800, Liming Wang wrote:
> If the parent has no entry in group_list, child_ctx will not be
> allocated, which will lead dereference of a NULL child_ctx.

That changelog sucks.

Best I can make of it is that there is a race where the parent gets his
context instantiated and we manage to get the mutex before the other
thread manages to add the first event.

Then we observe parent_event_ctx but have an empty list.

Is that it?

In that case, would it not be better to change the if (inherited_all)
condition to if (inherited_all && child_ctx) ?

> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> ---
>  kernel/perf_event.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 5b987b4..3664c4b 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -5126,6 +5126,8 @@ int perf_event_init_task(struct task_struct *child)
>  	 */
>  	mutex_lock(&parent_ctx->mutex);
>  
> +	if (list_empty(&parent_ctx->group_list))
> +		goto exit;
>  	/*
>  	 * We dont have to disable NMIs - we are only looking at
>  	 * the list, not manipulating it:


