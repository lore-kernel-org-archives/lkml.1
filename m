Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0CJUSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:18:47 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33982 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0CJUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:18:46 -0500
Date: Wed, 10 Mar 2010 15:18:37 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] call_usermodehelper: call info->init() after
 set_user_nice()
Message-ID: <20100310201837.GB3770@hmsreliant.think-freely.org>
References: <20100310184439.GA3386@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310184439.GA3386@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 07:44:39PM +0100, Oleg Nesterov wrote:
> Mostly cosmetic, but imho it makes sense to call sub_info->init() right
> before kernel_execve(). This looks more natural and allows ->init() hook
> to change the priority if needed.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  kernel/kmod.c |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> --- mm/kernel/kmod.c~5_MOVE_INIT_DOWN	2010-03-10 17:36:37.000000000 +0100
> +++ mm/kernel/kmod.c	2010-03-10 19:40:24.000000000 +0100
> @@ -159,6 +159,11 @@ static int ____call_usermodehelper(void 
>  
>  	/* We can run anywhere, unlike our parent keventd(). */
>  	set_cpus_allowed_ptr(current, cpu_all_mask);
> +	/*
> +	 * Our parent is keventd, which runs with elevated scheduling priority.
> +	 * Avoid propagating that into the userspace child.
> +	 */
> +	set_user_nice(current, 0);
>  
>  	if (sub_info->init) {
>  		retval = sub_info->init(sub_info);
> @@ -166,14 +171,7 @@ static int ____call_usermodehelper(void 
>  			goto fail;
>  	}
>  
> -	/*
> -	 * Our parent is keventd, which runs with elevated scheduling priority.
> -	 * Avoid propagating that into the userspace child.
> -	 */
> -	set_user_nice(current, 0);
> -
>  	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
> -
>  	/* Exec failed? */
>  fail:
>  	sub_info->retval = retval;
> 
> 
> 

Sure, why not. :)

Acked-by: Neil Horman <nhorman@tuxdriver.com>

