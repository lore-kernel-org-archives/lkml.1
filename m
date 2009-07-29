Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZG2WuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZG2WuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 18:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZG2WuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 18:50:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbZG2WuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 18:50:23 -0400
Date: Wed, 29 Jul 2009 15:50:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] introduce tracehook_finish_jctl() helper
Message-Id: <20090729155007.f4f5a793.akpm@linux-foundation.org>
In-Reply-To: <20090729020139.GA7381@redhat.com>
References: <20090729020139.GA7381@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 04:01:40 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> (textually depends on signals-tracehook_notify_jctl-change.patch)
> 
> Introduce the empty inline tracehook_finish_jctl() helper called by
> do_signal_stop() after wakeup.
> 
> Currently we lack the ability to report this state change.
> 
> Also fix the comment, it should be placed before schedule().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  include/linux/tracehook.h |    9 +++++++++
>  kernel/signal.c           |    2 ++
>  2 files changed, 11 insertions(+)
> 
> --- __UTRACE/include/linux/tracehook.h~2_FINISH_JCTL	2009-07-29 03:10:10.000000000 +0200
> +++ __UTRACE/include/linux/tracehook.h	2009-07-29 03:51:42.000000000 +0200
> @@ -521,6 +521,15 @@ static inline int tracehook_notify_jctl(
>  	return notify ?: (current->ptrace & PT_PTRACED) ? why : 0;
>  }
>  
> +/**
> + * tracehook_finish_jctl - report about return from job control stop
> + *
> + * This is called by do_signal_stop() after wakeup.
> + */
> +static inline void tracehook_finish_jctl(void)
> +{
> +}
> +
>  #define DEATH_REAP			-1
>  #define DEATH_DELAYED_GROUP_LEADER	-2
>  
> --- __UTRACE/kernel/signal.c~2_FINISH_JCTL	2009-07-29 03:17:49.000000000 +0200
> +++ __UTRACE/kernel/signal.c	2009-07-29 03:57:07.000000000 +0200
> @@ -1735,12 +1735,12 @@ static int do_signal_stop(int signr)
>  		read_unlock(&tasklist_lock);
>  	}
>  
> +	/* Now we don't run again until woken by SIGCONT or SIGKILL */
>  	do {
>  		schedule();
>  	} while (try_to_freeze());
> -	/*
> -	 * Now we don't run again until continued.
> -	 */
> +
> +	tracehook_finish_jctl();
>  	current->exit_code = 0;
>  

Confused.  This patch has no effect.
