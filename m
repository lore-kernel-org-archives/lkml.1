Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYLBWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYLBWLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYLBWLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:11:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbYLBWLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:11:21 -0500
Date: Tue, 2 Dec 2008 14:10:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@us.ibm.com>,
       Tom Zanussi <zanussi@comcast.net>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] relay: When unsigned ret cannot store a negative value
Message-Id: <20081202141042.3e0db395.akpm@linux-foundation.org>
In-Reply-To: <493161DE.6000703@gmail.com>
References: <493161DE.6000703@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 10:38:06 -0500
roel kluin <roel.kluin@gmail.com> wrote:

> When unsigned ret cannot store a negative value
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> UNTESTED! is this the way to go?
> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 32b0bef..c9d62e5 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -1220,7 +1220,8 @@ static int subbuf_splice_actor(struct file *in,
>  			       unsigned int flags,
>  			       int *nonpad_ret)
>  {
> -	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
> +	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages;
> +	ssize_t ret;
>  	struct rchan_buf *rbuf = in->private_data;
>  	unsigned int subbuf_size = rbuf->chan->subbuf_size;
>  	uint64_t pos = (uint64_t) *ppos;
> @@ -1289,7 +1290,8 @@ static int subbuf_splice_actor(struct file *in,
>  	if (!spd.nr_pages)
>  		return 0;
>  
> -	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
> +	ret = splice_to_pipe(pipe, &spd);
> +	*nonpad_ret = ret;
>  	if (ret < 0 || ret < total_len)
>  		return ret;
>  

Yeah, this code needs help.  subbuf_splice_actor() returns `int', but
carefully calculates and returns an unsigned type.

I suspect that quite a bit of code in there (including
relay_file_splice_read()) should be gone through and have its choice of
types reviewed and fixed.  Probably by converting things to ssize_t.


