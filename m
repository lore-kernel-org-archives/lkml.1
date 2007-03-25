Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbXCYTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbXCYTua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXCYTu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:50:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57757 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbXCYTu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:50:29 -0400
Date: Sun, 25 Mar 2007 12:50:25 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-Id: <20070325125025.b6e8f0d4.pj@sgi.com>
In-Reply-To: <20070325164746.GI11794@in.ibm.com>
References: <20070325164746.GI11794@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	task_lock(tsk);
>  	cs = tsk->cpuset;
>  	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
> +	atomic_dec(&cs->count);
> +	task_unlock(tsk);
>  
>  	if (notify_on_release(cs)) {
>  		char *pathbuf = NULL;
>  
>  		mutex_lock(&manage_mutex);
> -		if (atomic_dec_and_test(&cs->count))
> +		if (!atomic_read(&cs->count))
>  			check_for_release(cs, &pathbuf);

Is there perhaps another race here?  Could it happen that:
 1) the atomic_dec() lowers the count to say one (any value > zero)
 2) after we drop the task lock, some other task or tasks decrement
    the count to zero
 3) we catch that zero when we atomic_read the count, and issue a spurious
    check_for_release().

I'm thinking that we should use the same oldcs_tobe_released logic
here as we used in attach_task, so that we do an atomic_dec_and_test()
inside the task lock, and if that hit zero, then we know that our
pointer to this cpuset is the last remaining reference, so we can
release that pointer at our convenience, knowing no one else can
reference or mess with that cpuset any more.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
