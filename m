Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbXLRRKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbXLRRKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbXLRRKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:10:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56584 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225AbXLRRKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:10:42 -0500
Date: Tue, 18 Dec 2007 17:10:39 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] SUNRPC: make new svc_create_kthread function
Message-ID: <20071218171039.GA5908@infradead.org>
References: <1197996159-20799-1-git-send-email-jlayton@redhat.com> <1197996159-20799-2-git-send-email-jlayton@redhat.com> <1197996159-20799-3-git-send-email-jlayton@redhat.com> <1197996159-20799-4-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197996159-20799-4-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +int
> +svc_create_kthread(svc_thread_fn func, struct svc_rqst *rqstp)
> +{
> +	struct svc_serv *serv = rqstp->rq_server;
> +	struct task_struct *task;
> +
> +	task = kthread_create((int (*)(void *)) func, rqstp, serv->sv_name);
> +	if (IS_ERR(task))
> +		return PTR_ERR(task);
> +
> +	if (serv->sv_nrpools > 1)
> +		svc_pool_map_set_cpumask(task, rqstp->rq_pool->sp_id, NULL);
> +
> +	svc_sock_update_bufs(serv);
> +	wake_up_process(task);
> +	return 0;

I don't think we'll need this helper at all.  For the normal case of
not using a pool the caller can just call svc_sock_update_bufs even
before creating the thread, and the just use kthread_run.  That'll also
get rid of all this horrible casting things around for the thread entry
point function pointer.

