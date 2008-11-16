Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYKPEvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYKPEvc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYKPEvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:51:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:60932 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYKPEvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:51:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qWbqqePioexD86A/VLZ4NfDsOf4sCLEsuklLigGGTs+5ZRNGd4mlQSptjGrU9ocoHg
         6RorE5ZCJ4uERGB3aVCOAAEmNK+CaOJXleMoiB91E+FaXBlvC//YZRC42a+UCMdiIgL+
         OIOJywxqXIuWtOFXOhK3XvfHSO6TpshaEDc1Y=
Date: Sun, 16 Nov 2008 07:54:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] net: use simple_free()
Message-ID: <20081116045457.GD24624@x200.localdomain>
References: <491FA2BC.1030600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491FA2BC.1030600@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 12:34:04PM +0800, Lai Jiangshan wrote:
> simple_free() free the memory by kfree(), or vfree() if it is vmalloc addr.
> simple_free() is simpler than current codes.

Where is corresponding alloc chunk?

> --- a/net/core/request_sock.c
> +++ b/net/core/request_sock.c
> @@ -71,22 +72,11 @@ int reqsk_queue_alloc(struct request_sock_queue *queue,
>  
>  void __reqsk_queue_destroy(struct request_sock_queue *queue)
>  {
> -	struct listen_sock *lopt;
> -	size_t lopt_size;
> -
>  	/*
>  	 * this is an error recovery path only
>  	 * no locking needed and the lopt is not NULL
>  	 */
> -
> -	lopt = queue->listen_opt;
> -	lopt_size = sizeof(struct listen_sock) +
> -		lopt->nr_table_entries * sizeof(struct request_sock *);
> -
> -	if (lopt_size > PAGE_SIZE)
> -		vfree(lopt);
> -	else
> -		kfree(lopt);
> +	simple_free(queue->listen_opt);
>  }
>  
>  static inline struct listen_sock *reqsk_queue_yank_listen_sk(
> @@ -106,8 +96,6 @@ void reqsk_queue_destroy(struct request_sock_queue *queue)
>  {
>  	/* make all the listen_opt local to us */
>  	struct listen_sock *lopt = reqsk_queue_yank_listen_sk(queue);
> -	size_t lopt_size = sizeof(struct listen_sock) +
> -		lopt->nr_table_entries * sizeof(struct request_sock *);
>  
>  	if (lopt->qlen != 0) {
>  		unsigned int i;
> @@ -124,9 +112,6 @@ void reqsk_queue_destroy(struct request_sock_queue *queue)
>  	}
>  
>  	WARN_ON(lopt->qlen != 0);
> -	if (lopt_size > PAGE_SIZE)
> -		vfree(lopt);
> -	else
> -		kfree(lopt);
> +	simple_free(lopt);
>  }
