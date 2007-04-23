Return-Path: <linux-kernel-owner+w=401wt.eu-S1161429AbXDWL0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161429AbXDWL0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161444AbXDWL0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:26:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42488 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161429AbXDWL0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:26:02 -0400
Date: Mon, 23 Apr 2007 12:25:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, rusty@rustcorp.com.au
Subject: Re: [PATCH] kthread: Spontaneous exit support
Message-ID: <20070423112537.GA21941@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
	linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
	rusty@rustcorp.com.au
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969596686-git-send-email-ebiederm@xmission.com> <20070419162459.af7a182c.akpm@linux-foundation.org> <20070422194455.GA18561@infradead.org> <m1fy6rzsug.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fy6rzsug.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 09:12:55PM -0600, Eric W. Biederman wrote:
> 
> This patch implements the kthread helper functions kthread_start
> and kthread_end which make it simple to support a kernel thread
> that may decided to exit on it's own before we request it to.
> It is still assumed that eventually we will get around to requesting
> that the kernel thread stop.

I don't think having to parallel APIs is a good idea, people will
get utterly confused which one to use.  Better always grab a reference
in kthread_create and drop it in kthread_stop.  For normal thread
no change in behaviour and only slightly more code in the slowpath.

Of course it will need an audit for half-assed kthread conversion
first to avoid task_struct reference count leaks.

In addition to that kthrad_end implementation look wrong. When
the kthread has exited prematurely no one will call complete
on kthread_stop_info.done before it's been setup.  Interestingly
the comment there indicates someone thought about threads exiting
early, but it became defunkt during all the rewrites of the
kthread code.


> +/**
> + * kthread_start - create and wake a thread.
> + * @threadfn: the function to run until kthread_should_stop().
> + * @data: data ptr for @threadfn.
> + * @namefmt: printf-style name for the thread.
> + *
> + * Description: Convenient wrapper for kthread_create() followed by
> + * get_task_struct() and wake_up_process. kthread_start should be paired
> + * with kthread_end() so we don't leak task structs.
> + *
> + * Returns the kthread or ERR_PTR(-ENOMEM).
> + */
> +#define kthread_start(threadfn, data, namefmt, ...)			   \
> +({									   \
> +	struct task_struct *__k						   \
> +		= kthread_create(threadfn, data, namefmt, ## __VA_ARGS__); \
> +	if (!IS_ERR(__k)) {						   \
> +		get_task_struct(__k);					   \
> +		wake_up_process(__k);					   \
> +	}								   \
> +	__k;								   \
> +})
> +int kthread_end(struct task_struct *k);
>  
>  static inline int __kthread_should_stop(struct task_struct *tsk)
>  {
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 9b3c19f..d6d63c6 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -179,6 +179,24 @@ int kthread_stop(struct task_struct *tsk)
>  }
>  EXPORT_SYMBOL(kthread_stop);
>  
> +/**
> + * kthread_end - signal a kthread and wait for it to exit.
> + * @task: The kthread to end.
> + *
> + * Description: Convenient wrapper for kthread_stop() followed by
> + * put_task_struct().  Returns the kthread exit code.
> + *
> + * kthread_start()/kthread_end() can handle kthread that spontaneously exit
> + * before the kthread is requested to terminate.
> + */
> +int kthread_end(struct task_struct *task)
> +{
> +	int ret;
> +	ret = kthread_stop(task);
> +	put_task_struct(task);
> +	return ret;
> +}
> +EXPORT_SYMBOL(kthread_end);
