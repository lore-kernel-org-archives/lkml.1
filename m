Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZK3TNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZK3TNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZK3TNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:13:18 -0500
Received: from smtp-out.google.com ([216.239.33.17]:54381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZK3TNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:13:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=LYjDzfIkkZTwZOhmfgSTHjYGpcyZ3K3V0DMnhBUlLNp2J5sUWmQMY/wSTsw0xvBwX
	o48t/mURsD2hY591o5liA==
Date: Mon, 30 Nov 2009 11:13:07 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: PATCH: softlockup: Fix hung_task_check_count sysctl
Message-ID: <20091130191307.GM11670@google.com>
References: <20091127022820.GU32182@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127022820.GU32182@kryten>
X-Operating-System: Linux/2.6.24-gg804003-generic (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To disable hung_task at runtime:

# echo 0 > /proc/sys/kernel/hung_task_check_count

33 /*
34  * Zero means infinite timeout - no checking done:
35  */
36 unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;

For hung_task_check_count, 0 means there is no maximum so all tasks
are checked.

Anton Blanchard (anton@samba.org) wrote:
> 
> I'm seeing spikes of up to 0.5ms in khungtaskd on a large machine. To reduce
> this source of jitter I tried setting hung_task_check_count to 0:
> 

Hmm, maybe khungtaskd should be run using SCHED_IDLE.

> # echo 0 > /proc/sys/kernel/hung_task_check_count
> 
> which didn't have the intended response. Change to a post increment of
> max_count, so a value of 0 means check 0 tasks.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: linux.trees.git/kernel/hung_task.c
> ===================================================================
> --- linux.trees.git.orig/kernel/hung_task.c	2009-11-27 13:11:46.000000000 +1100
> +++ linux.trees.git/kernel/hung_task.c	2009-11-27 13:11:57.000000000 +1100
> @@ -144,7 +144,7 @@ static void check_hung_uninterruptible_t
>  
>  	rcu_read_lock();
>  	do_each_thread(g, t) {
> -		if (!--max_count)
> +		if (!max_count--)
>  			goto unlock;
>  		if (!--batch_count) {
>  			batch_count = HUNG_TASK_BATCHING;
