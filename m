Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZBJSP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZBJSP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZBJSPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:15:18 -0500
Received: from smtp-out.google.com ([216.239.45.13]:37890 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZBJSPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:15:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=ItFbpalvCWJMYRh3vJAEUUEm4Mxtq+uyR9yPibisSLfD63UIwYSmNzh25qXZrkD5D
	zPliGvqfnbCph64qk66qw==
Date: Tue, 10 Feb 2009 10:15:04 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: Re: [PATCH] softlockup: ensure the task has been switched out once
Message-ID: <20090210181504.GI7332@google.com>
References: <4991a557.1ade660a.582e.7835@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4991a557.1ade660a.582e.7835@mx.google.com>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker (fweisbec@gmail.com) wrote:
> When we check if a task has been switched out since the last scan, we might
> have a race condition on the following scenario:
> 
> _ the task is freshly created and scheduled
> _ it puts its state to TASK_UNINTERRUPTIBLE and is not yet switched out
> _ check_hung_task() scans this task and will report a false positive because
>   t->nvcsw + t->nivcsw == t->last_switch_count == 0
> 
> Add a check for such cases.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/hung_task.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index 0c924de..022a492 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -72,7 +72,13 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
>  {
>  	unsigned long switch_count = t->nvcsw + t->nivcsw;
>  
> -	if (t->flags & PF_FROZEN)
> +	/*
> +	 * Ensure the task is not frozen.
> +	 * Also, when a freshly created task is scheduled once, changes
> +	 * its state to TASK_UNINTERRUPTIBLE without having ever been
> +	 * switched out once, it musn't be checked.
> +	 */
> +	if (unlikely(t->flags & PF_FROZEN || !switch_count))
>  		return;
>  
>  	if (switch_count != t->last_switch_count) {
> -- 
> 1.6.1
> 
> 


Looks good to me. Thanks for fixing this!

Acked-by: Mandeep Singh Baines <msb@google.com>
