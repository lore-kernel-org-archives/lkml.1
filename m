Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZHGU6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZHGU6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZHGU6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:58:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbZHGU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:58:31 -0400
Date: Fri, 7 Aug 2009 13:58:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Message-Id: <20090807135806.ffd068e9.akpm@linux-foundation.org>
In-Reply-To: <1249676830.27640.16.camel@wall-e>
References: <1249676830.27640.16.camel@wall-e>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Aug 2009 22:27:10 +0200
Stefani Seibold <stefani@seibold.net> wrote:

> The following fix a long standing issue in the proc_file_write function,
> which doesn't update the ppos file position pointer.
> 
> This prevent the usage of multiple sequently writes on an opened proc
> file, because it is impossible to distinguish these due the offset is
> always 0.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> 
>  generic.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.31-rc4.orig/fs/proc/generic.c	2009-08-07 22:05:57.000000000 +0200
> +++ linux-2.6.30-rc4/fs/proc/generic.c	2009-08-07 22:06:22.000000000 +0200
> @@ -219,9 +219,10 @@
>  		pde->pde_users++;
>  		spin_unlock(&pde->pde_unload_lock);
>  
> -		/* FIXME: does this routine need ppos?  probably... */
>  		rv = pde->write_proc(file, buffer, count, pde->data);
>  		pde_users_dec(pde);
> +		if (rv > 0)
> +			*ppos += rv;
>  	}
>  	return rv;
>  }

Yes, that's odd.

I worry that there might be procfs write handlers which are looking at
*ppos and whose behaviour might be altered by this patch.

<searches a bit>

Look at arch/s390/appldata/appldata_base.c:appldata_timer_handler().

static int
appldata_timer_handler(ctl_table *ctl, int write, struct file *filp,
			   void __user *buffer, size_t *lenp, loff_t *ppos)
{
	int len;
	char buf[2];

	if (!*lenp || *ppos) {
		*lenp = 0;
		return 0;
	}


Prior to your change, an application which opened that proc file and
repeatedly wrote to the fd would repeatedly start and stop the timer.

After your change, the second and successive writes would have no
effect unless the application was changed to lseek back to the start of
the "file".

And that was just the second file I looked at via

	$EDITOR $(grep -l '[*]ppos' $(grep -rl _proc_ .))
