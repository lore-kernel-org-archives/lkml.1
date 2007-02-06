Return-Path: <linux-kernel-owner+w=401wt.eu-S1750936AbXBFLGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbXBFLGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbXBFLGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:06:04 -0500
Received: from mail.screens.ru ([213.234.233.54]:50679 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXBFLGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:06:01 -0500
Date: Tue, 6 Feb 2007 14:05:39 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: S?bastien Dugu? <sebastien.dugue@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH -mm][AIO] AIO completion signal notification fixes and cleanups
Message-ID: <20070206110539.GA129@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686> <20070201103053.64489048@frecb000686> <20070202180039.GA658@tv-sign.ru> <20070205131839.6f601c3e@frecb000686> <20070205134314.GA283@tv-sign.ru> <20070205170056.6a29b19b@frecb000686> <20070205171335.GA528@tv-sign.ru> <20070206102253.20b121ae@frecb000686>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206102253.20b121ae@frecb000686>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, S?bastien Dugu? wrote:
> 
> @@ -970,8 +969,14 @@ static long aio_setup_sigevent(struct ai
>  	rcu_read_lock();
>  	target = sigevent_find_task(&event);
>  
> -	if (unlikely(!target))
> +	if (unlikely(!target)) {
> +		/*
> +		 * Revert notify to SIGEV_NONE so that really_put_req()
> +		 * knows that no ref has been taken on a task.
> +		 */
> +		notify->notify = SIGEV_NONE;
>  		goto out_unlock;
> +	}

Very minor nit, feel free to ignore.

Isn't it better to move "notify->* = event.*;" down, when we know that
target != NULL. Imho, a bit easier to follow. This way we don't need to
reset notify->notify = SIGEV_NONE.

aio_setup_sigevent() relies on the fact that ->notify = SIGEV_NONE on
entry anyway.

Oleg.

