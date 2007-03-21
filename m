Return-Path: <linux-kernel-owner+w=401wt.eu-S965030AbXCUVub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030AbXCUVub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965055AbXCUVub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:50:31 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55043 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030AbXCUVua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:50:30 -0400
Date: Wed, 21 Mar 2007 14:50:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reject taskset for kernel threads
Message-Id: <20070321145027.c76121dc.akpm@linux-foundation.org>
In-Reply-To: <20070321205353.GA32529@aepfle.de>
References: <20070321205353.GA32529@aepfle.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 21:53:53 +0100
Olaf Hering <olaf@aepfle.de> wrote:

> 
> Do not allow taskset for kernel threads.
> These commands will cause oopses due to stack corruption:
> 
> ls /proc/*/task | grep -v ^/ | xargs echo | xargs -n1 taskset -pc 2-9
> taskset -pc 1 $$
> taskset -pc 0 $((pidof john))

Why does the kernel oops?

> Possible fix in userland:
> 
> for i in ` ls /proc/*/task | grep -v ^/ `
> do
> 	e=/proc/*/task/$i/exe
> 	if test -e $e
> 	then
> 		taskset -pc 2-9	$i
> 	fi
> done
> 
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> ---
>  kernel/sched.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.20/kernel/sched.c
> ===================================================================
> --- linux-2.6.20.orig/kernel/sched.c
> +++ linux-2.6.20/kernel/sched.c
> @@ -4310,6 +4310,8 @@ long sched_setaffinity(pid_t pid, cpumas
>  	read_unlock(&tasklist_lock);
>  
>  	retval = -EPERM;
> +	if (!p->mm)
> +		goto out_unlock;
>  	if ((current->euid != p->euid) && (current->euid != p->uid) &&
>  			!capable(CAP_SYS_NICE))
>  		goto out_unlock;


Maybe.  There are some kernel threads for which we definitely don't want
the affinity altered (ksoftirqd, probably keventd..).  But otoh there might
be legitimate reasons to alter, say, pdflush's or kjournald's affinity, and
that should be a safe thing to do.

Perhaps a suitable compromise would be to disallow affinity-setting on
non-singlethreaded kernel threads.  But of course, we don't want that to
oops.

