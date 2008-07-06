Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYGFRu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYGFRu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbYGFRgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:12326 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbYGFRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aoQ9ypYBjJQf/3BGkn4/7Kwgvrda9MhCquuyhiol7fOt4kLKBT8hPoiF5e7iQBfomr
         fW5YFjRzDi27cKT84Ypz0RmCDxwvXU2RGwTch9YmbSv1Bbx8Ef2Rm4UIg91g9t6Cwsjv
         hzXBym+/QYiNgPAYUdVGKmhXBy5ruzIslj0FM=
Date: Sun, 6 Jul 2008 19:35:38 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueues: lockdep annotations for flush_work()
Message-ID: <20080706173538.GA2500@ami.dom.local>
References: <20080706162800.GA6443@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706162800.GA6443@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 08:28:00PM +0400, Oleg Nesterov wrote:
> Add lockdep annotations to flush_work() and update the comment.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Looks OK to me. (But probably the comment on "true" would be easier
(more precise).)

Regards,
Jarek P.

> 
> --- 26-rc2/kernel/workqueue.c~FW_LOCKDEP	2008-06-29 19:36:27.000000000 +0400
> +++ 26-rc2/kernel/workqueue.c	2008-07-06 20:15:16.000000000 +0400
> @@ -403,6 +403,8 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
>   * flush_work - block until a work_struct's callback has terminated
>   * @work: the work which is to be flushed
>   *
> + * Returns false if @work has already terminated.
> + *
>   * It is expected that, prior to calling flush_work(), the caller has
>   * arranged for the work to not be requeued, otherwise it doesn't make
>   * sense to use this function.
> @@ -418,6 +420,9 @@ int flush_work(struct work_struct *work)
>  	if (!cwq)
>  		return 0;
>  
> +	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> +	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
> +
>  	prev = NULL;
>  	spin_lock_irq(&cwq->lock);
>  	if (!list_empty(&work->entry)) {
> 
