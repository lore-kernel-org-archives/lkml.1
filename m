Return-Path: <linux-kernel-owner+w=401wt.eu-S935167AbXJOSvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167AbXJOSvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935104AbXJOSs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:48:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934895AbXJOSsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:48:25 -0400
Date: Mon, 15 Oct 2007 11:47:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, mingo@elte.hu
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20071015114738.6b5a25c7.akpm@linux-foundation.org>
In-Reply-To: <20071015104647.14e60bc5@laptopd505.fenrus.org>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 10:46:47 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> 
> Subject: Give kjournald a IOPRIO_CLASS_RT io priority
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> With latencytop, I noticed that the (in memory) atime updates during a
> kernel build had latencies of 600 msec or longer; this is obviously not so
> nice behavior. Other EXT3 journal related operations had similar or even
> longer latencies.
> 
> Digging into this a bit more, it appears to be an interaction between EXT3
> and CFQ in that CFQ tries to be fair to everyone, including kjournald.
> However, in reality, kjournald is "special" in that it does a lot of journal
> work and effectively this leads to a twisted kind of "mass priority
> inversion" type of behavior.
> 
> The good news is that CFQ already has the infrastructure to make certain
> processes special... JBD just wasn't using that quite yet.
> 
> The patch below makes kjournald of the IOPRIO_CLASS_RT priority to break
> this priority inversion behavior. With this patch, the latencies for atime
> updates (and similar operation) go down by a factor of 3x to 4x !
> 

Seems a pretty fundamental change which could do with some careful
benchmarking, methinks.

See, your patch amounts to "do more seeks to improve one test case". 
Surely other testcases will worsen.  What are they?

> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> 
> diff -purN linux-2.6.23-rc9.org/fs/jbd/journal.c linux-2.6.23-rc9.lt/fs/jbd/journal.c
> --- linux-2.6.23-rc9.org/fs/jbd/journal.c	2007-10-02 05:24:52.000000000 +0200
> +++ linux-2.6.23-rc9.lt/fs/jbd/journal.c	2007-10-14 00:06:55.000000000 +0200
> @@ -35,6 +35,7 @@
>  #include <linux/kthread.h>
>  #include <linux/poison.h>
>  #include <linux/proc_fs.h>
> +#include <linux/ioprio.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
> @@ -131,6 +132,8 @@ static int kjournald(void *arg)
>  	printk(KERN_INFO "kjournald starting.  Commit interval %ld seconds\n",
>  			journal->j_commit_interval / HZ);
>  
> +	current->ioprio =  (IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT) | 4;
> +

Might be worth a code comment?
