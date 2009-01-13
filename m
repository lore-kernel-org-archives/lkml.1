Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbZANI7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbZANI7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761255AbZANI7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:59:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:42167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761259AbZANI7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:59:08 -0500
Date: Tue, 13 Jan 2009 20:34:34 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] async: Handle kthread_run() return codes.
Message-ID: <20090113203434.7094dd60@infradead.org>
In-Reply-To: <20090113174304.2186532c@gondolin>
References: <20090113174304.2186532c@gondolin>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  		ec = atomic_read(&entry_count);
>  
>  		while (tc < ec && tc < MAX_THREADS) {
> -			kthread_run(async_thread, NULL, "async/%i",
> tc);
> +			if (IS_ERR(kthread_run(async_thread, NULL,
> "async/%i",
> +					       tc)))
> +				/* Try again later. */
> +				goto schedule;

I do not like this recovery to be honest. an msleep() followed by a
"continue" is probably much better.


> @@ -330,7 +333,9 @@ static int async_manager_thread(void *un
>  static int __init async_init(void)
>  {
>  	if (async_enabled)
> -		kthread_run(async_manager_thread, NULL, "async/mgr");
> +		if (IS_ERR(kthread_run(async_manager_thread, NULL,
> +				       "async/mgr")))
> +			async_enabled = 0;

hmm maybe; it might make more sense to set it to 0 here, and have the
thread itself set the variable to 1..... that way we KNOW the thread is
running for sure..

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
