Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYACAZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYACAZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYACAZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:25:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbYACAZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:25:23 -0500
Date: Wed, 2 Jan 2008 16:23:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Lim <jlim@sgi.com>
Cc: linux-kernel@vger.kernel.org, jlan@sgi.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in
 kernel/tsacct.c
Message-Id: <20080102162338.c67769af.akpm@linux-foundation.org>
In-Reply-To: <200801022103.m02L3oL1051764@sabah.engr.sgi.com>
References: <200801022103.m02L3oL1051764@sabah.engr.sgi.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007 13:26:07 -0800 (PST) Jonathan Lim <jlim@sgi.com> wrote:

> It's possible that the values used in and returned from jiffies_to_usecs() are
> incorrect because of truncation when variables of type u64 are involved.  So a
> function specific to that type is used instead.
> 
> Diff'd against: linux/kernel/git/stable/linux-2.6.23.y.git
> 
> Signed-off-by: Jonathan Lim <jlim@sgi.com>
> 
> --- a/kernel/tsacct.c	2007-12-28 11:58:05.182065029 -0800
> +++ b/kernel/tsacct.c	2007-12-28 11:57:37.949013675 -0800
> @@ -71,6 +71,17 @@ void bacct_add_tsk(struct taskstats *sta
>  
>  #ifdef CONFIG_TASK_XACCT
>  
> +static inline u64 jiffies_to_usecs_u64(const u64 j)
> +{
> +#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
> +	return (USEC_PER_SEC / HZ) * j;
> +#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
> +	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
> +#else
> +	return (j * USEC_PER_SEC) / HZ;
> +#endif
> +}
> +
>  #define KB 1024
>  #define MB (1024*KB)
>  /*
> @@ -81,8 +92,8 @@ void xacct_add_tsk(struct taskstats *sta
>  	struct mm_struct *mm;
>  
>  	/* convert pages-jiffies to Mbyte-usec */
> -	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
> -	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
> +	stats->coremem = jiffies_to_usecs_u64(p->acct_rss_mem1) * PAGE_SIZE / MB;
> +	stats->virtmem = jiffies_to_usecs_u64(p->acct_vm_mem1) * PAGE_SIZE / MB;
>  	mm = get_task_mm(p);
>  	if (mm) {
>  		/* adjust to KB unit */

Fair enough.  But I guess that new function should be a kernel-wide thing
because surely other users will turn up.

Peter has been working on the accuracy of some of these conversion
functions and might need to know about this change?
