Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbYE2GPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbYE2GPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYE2GOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:14:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYE2GOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:14:53 -0400
Date: Wed, 28 May 2008 23:13:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block: make blktrace use per-cpu buffers for message notes
Message-Id: <20080528231351.a35001bc.akpm@linux-foundation.org>
In-Reply-To: <200805281559.m4SFx7b9022392@hera.kernel.org>
References: <200805281559.m4SFx7b9022392@hera.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 15:59:07 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=64565911cdb57c2f512a9715b985b5617402cc67
> Commit:     64565911cdb57c2f512a9715b985b5617402cc67
> Parent:     4722dc52a891ab6cb2d637ddb87233e0ce277827
> Author:     Jens Axboe <jens.axboe@oracle.com>
> AuthorDate: Wed May 28 14:45:33 2008 +0200
> Committer:  Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Wed May 28 14:49:27 2008 +0200

please try to avoid merging unreviewed changes.

>     block: make blktrace use per-cpu buffers for message notes
>     
>     Currently it uses a single static char array, but that risks
>     being corrupted when multiple users issue message notes at the
>     same time. Make the buffers dynamically allocated when the trace
>     is setup and make them per-cpu instead.
>     
>     The default max message size of 1k is also very large, the
>     interface is mainly for small text notes. So shrink it to 128 bytes.
>     
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/blktrace.c             |   15 ++++++++++++---
>  include/linux/blktrace_api.h |    3 ++-
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index 20e11f3..7ae87cc 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -79,13 +79,16 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
>  {
>  	int n;
>  	va_list args;
> -	static char bt_msg_buf[BLK_TN_MAX_MSG];
> +	char *buf;
>  
> +	preempt_disable();
> +	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());

get_cpu()/put_cpu() is the standard way of doing this.

> @@ -172,7 +173,7 @@ extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
>  		if (unlikely(bt))					\
>  			__trace_note_message(bt, fmt, ##__VA_ARGS__);	\
>  	} while (0)
> -#define BLK_TN_MAX_MSG		1024
> +#define BLK_TN_MAX_MSG		128

It seems a bit strange to do this right when we've taken this _off_ the
stack.  But I suppose nothing will break.


I cannot work out why 9d5f09a424a67ddb959829894efb4c71cbf6d600 ("Added
in MESSAGE notes for blktraces") was -rc material.

