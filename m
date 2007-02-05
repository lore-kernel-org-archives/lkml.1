Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbXBERLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbXBERLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXBERLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:11:25 -0500
Received: from mail.screens.ru ([213.234.233.54]:60401 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXBERLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:11:24 -0500
Date: Mon, 5 Feb 2007 20:13:35 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: S?bastien Dugu? <sebastien.dugue@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH -mm][AIO] Fix AIO completion signal notification possible ref leak
Message-ID: <20070205171335.GA528@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686> <20070201103053.64489048@frecb000686> <20070202180039.GA658@tv-sign.ru> <20070205131839.6f601c3e@frecb000686> <20070205134314.GA283@tv-sign.ru> <20070205170056.6a29b19b@frecb000686>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205170056.6a29b19b@frecb000686>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, S?bastien Dugu? wrote:
> 
>   Make sure we only accept valid sigev_notify values in aio_setup_sigevent(),
> namely SIGEV_NONE, SIGEV_THREAD_ID or SIGEV_SIGNAL.

I think this is correct, but I have another concern (most probably I just
confused looking at non-applied patch), could you re-check?

> @@ -959,6 +959,10 @@ static long aio_setup_sigevent(struct ai
>  	if (event.sigev_notify == SIGEV_NONE)
>  		return 0;
>  
> +	if (event.sigev_notify != SIGEV_SIGNAL &&
> +	    event.sigev_notify != SIGEV_THREAD_ID)
> +		return -EINVAL;
> +
>  	notify->notify = event.sigev_notify;
>  	notify->signo = event.sigev_signo;
>  	notify->value = event.sigev_value;

Ok. But what if sigevent_find_task() fails after that? Doesn't this mean
that really_put_req() will do put_task_struct(NULL) ?

Oleg.

