Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbXE3SGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbXE3SGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbXE3SFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:05:54 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005AbXE3SFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:05:53 -0400
Date: Wed, 30 May 2007 11:05:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix leakage of -ERESTARTSYS to userland
Message-Id: <20070530110513.b2ae50ad.akpm@linux-foundation.org>
In-Reply-To: <20070529184435.GA174@tv-sign.ru>
References: <20070529184435.GA174@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 22:44:35 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Spotted by Satoru Takeuchi.
> 
> kill_pgrp(task_pgrp(current)) sends the signal to the current's thread group,
> but can choose any sub-thread as a target for signal_wake_up(). This means
> that job_control() and tty_check_change() may return -ERESTARTSYS without
> signal_pending().
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- t/drivers/char/n_tty.c~	2007-04-05 12:18:26.000000000 +0400
> +++ t/drivers/char/n_tty.c	2007-05-28 10:57:58.000000000 +0400
> @@ -1191,6 +1191,7 @@ static int job_control(struct tty_struct
>  			    is_current_pgrp_orphaned())
>  				return -EIO;
>  			kill_pgrp(task_pgrp(current), SIGTTIN, 1);
> +			set_thread_flag(TIF_SIGPENDING);
>  			return -ERESTARTSYS;
>  		}
>  	}
> --- t/drivers/char/tty_io.c~	2007-04-05 12:18:26.000000000 +0400
> +++ t/drivers/char/tty_io.c	2007-05-29 22:15:52.000000000 +0400
> @@ -1121,7 +1121,8 @@ int tty_check_change(struct tty_struct *
>  		return 0;
>  	if (is_current_pgrp_orphaned())
>  		return -EIO;
> -	(void) kill_pgrp(task_pgrp(current), SIGTTOU, 1);
> +	kill_pgrp(task_pgrp(current), SIGTTOU, 1);
> +	set_thread_flag(TIF_SIGPENDING);
>  	return -ERESTARTSYS;
>  }
>  

Are there other callers of kill_pgrp() which have the same problem?

Perhaps we should have a kill_pgrp_self() which takes care of doing
this, rather than open-coding it.  Something with a comment which
explains what's going on ;)
