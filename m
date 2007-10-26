Return-Path: <linux-kernel-owner+w=401wt.eu-S1765589AbXJZRH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765589AbXJZRH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXJZRHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:07:52 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43438 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXJZRHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:07:51 -0400
Date: Fri, 26 Oct 2007 13:07:50 -0400
To: "George G. Davis" <gdavis@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix hang in posix_locks_deadlock()
Message-ID: <20071026170750.GC13033@fieldses.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018185759.GU3785@mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 02:57:59PM -0400, George G. Davis wrote:
> On Wed, Oct 17, 2007 at 02:51:57PM -0400, George G. Davis wrote:
> > ---
> > Not sure if this is the correct fix but it does resolve the hangs we're
> > observing in posix_locks_deadlock().
> 
> Please disregard the previous patch, it's not quite right - causes occasional
> segfaults and clearly did not retain the posix_same_owner() checks implemented
> in the original code.  Here's a new version which I believe retains the
> intent of the original code:
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 7f9a3ea..e012b27 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -702,14 +702,12 @@ static int posix_locks_deadlock(struct file_lock *caller_fl,
>  {
>  	struct file_lock *fl;
>  
> -next_task:
>  	if (posix_same_owner(caller_fl, block_fl))
>  		return 1;
>  	list_for_each_entry(fl, &blocked_list, fl_link) {
>  		if (posix_same_owner(fl, block_fl)) {
> -			fl = fl->fl_next;
> -			block_fl = fl;
> -			goto next_task;
> +			if (posix_same_owner(caller_fl, fl))
> +				return 1;
>  		}
>  	}
>  	return 0;

It may take multiple steps to identify a deadlock.  With the above
you'll miss deadlocks like

	process 1 is requesting a lock held by process 2
	process 2 is blocking on a lock held by process 3
	process 3 is blocking on a lock held by process 1.

Could you give more details about how you're causing
posix_locks_deadlock to hang?  Is there a simple test-case you can post?

--b.

> 
> 
> I'm not sure about those "fl = fl->fl_next; block_fl = fl;" statements,
> first, the order of those statements seems reversed to me.  Otherwise,
> I think the intent was to advance the "fl" for loop variable to the next
> entry in the list but it doesn't work out that way at all - the for
> loop restarts from the beginning - this is where we get into an
> infinite loop condition.  Whether the test case I posted before is
> valid or not, I reckon it shouldn't be possible for non-root Joe user
> to contrive a test case which can hang the system as we're observing
> with that test case.  The above patch fixes the hang.
> 
> Comments greatly appreciated...
> 
> -- 
> Regards,
> George
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
