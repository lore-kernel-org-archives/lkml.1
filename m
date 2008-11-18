Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYKRWoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYKRWoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYKRWo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:44:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbYKRWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:44:27 -0500
Date: Tue, 18 Nov 2008 14:42:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Julia Lawall <julia@diku.dk>
Cc: srostedt@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/3] kernel/trace/trace.c: introduce missing kfree
Message-Id: <20081118144217.34ffa4e1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811141904580.10023@pc-004.diku.dk>
References: <Pine.LNX.4.64.0811141904580.10023@pc-004.diku.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 19:05:31 +0100 (CET)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kzalloc should free the allocated data.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
> 
> (
> if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
> |
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> )
> <... when != x
>      when != if (...) { <+...x...+> }
> x->f = E
> ...>
> (
>  return \(0\|<+...x...+>\|ptr\);
> |
>  return@p2 ...;
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  kernel/trace/trace.c          |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 697eda3..d86e325 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1936,6 +1936,7 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
>  			ring_buffer_read_finish(iter->buffer_iter[cpu]);
>  	}
>  	mutex_unlock(&trace_types_lock);
> +	kfree(iter);
>  
>  	return ERR_PTR(-ENOMEM);
>  }

Nobody seems to have applied this to anything yet?

That function really needs help.  Sometimes it will return NULL and
will set *ret.  Other times it will return ERR_PTR(-ENOMEM) and will
fail to write anything to *ret.  One caller (tracing_open) ignores the
return value.  Another caller (tracing_lt_open) tests the
possibly-uninitialised `ret' and then blindly dereferences the
possibly-IS_ERR return value.

Or something like that.  I looked at it long enough to convince myself
that it needs fixing ;)


