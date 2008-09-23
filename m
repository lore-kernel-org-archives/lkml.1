Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYIWU1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYIWU1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYIWU12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:27:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbYIWU11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:27:27 -0400
Date: Tue, 23 Sep 2008 13:20:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tom Zanussi <zanussi@comcast.net>
Cc: a.p.zijlstra@chello.nl, prasad@linux.vnet.ibm.com, mbligh@google.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, compudj@krystal.dyndns.org, rostedt@goodmis.org,
       od@novell.com, fche@redhat.com, hch@lst.de, dwilder@us.ibm.com
Subject: Re: [PATCH 3/3] relay - add channel flags
Message-Id: <20080923132053.eb2cf871.akpm@linux-foundation.org>
In-Reply-To: <1222147676.6875.138.camel@charm-linux>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	<1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	<20080922140740.GB5279@in.ibm.com>
	<1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	<1222147676.6875.138.camel@charm-linux>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 00:27:56 -0500
Tom Zanussi <zanussi@comcast.net> wrote:

> Add channel flags to relay, remove global callback param.
>     
> relay should probably have had a flags param from the beginning; it
> wasn't originally added because it wasn't originally needed - it
> probably would have helped avoid some of the callback contortions
> that were added due to a lack of flags.  This adds them and does a
> small amount of low-hanging cleanup, and is also in preparation for
> some new flags in future patches.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index eb9651c..150c5f7 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -356,8 +356,7 @@ static int blk_remove_buf_file_callback(struct dentry *dentry)
>  static struct dentry *blk_create_buf_file_callback(const char *filename,
>  						   struct dentry *parent,
>  						   int mode,
> -						   struct rchan_buf *buf,
> -						   int *is_global)
> +						   struct rchan_buf *buf)
>  {
>  	return debugfs_create_file(filename, mode, parent, buf,
>  					&relay_file_operations);
> @@ -424,7 +423,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>  		goto err;
>  
>  	bt->rchan = relay_open("trace", dir, buts->buf_size,
> -				buts->buf_nr, &blk_relay_callbacks, bt);
> +			       buts->buf_nr, &blk_relay_callbacks, bt, 0UL);
>  	if (!bt->rchan)
>  		goto err;
>  
> diff --git a/include/linux/relay.h b/include/linux/relay.h
> index 52e4d61..18fd269 100644
> --- a/include/linux/relay.h
> +++ b/include/linux/relay.h
> @@ -25,7 +25,13 @@
>  /*
>   * Tracks changes to rchan/rchan_buf structs
>   */
> -#define RELAYFS_CHANNEL_VERSION		7
> +#define RELAYFS_CHANNEL_VERSION		8

What is the significance of this change?  Does it affect the
kernel<->userspace interface?  Is it back-compatible with existing
userspace?


> +/*
> + * relay channel flags
> + */
> +#define RCHAN_MODE_OVERWRITE		0x00000001	/* 'flight' mode */
> +#define RCHAN_GLOBAL_BUFFER		0x00000002	/* not using per-cpu */
>  
>
> ...
>
> @@ -480,7 +478,7 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
>   	buf->cpu = cpu;
>   	__relay_reset(buf, 1);
>  
> - 	if(chan->is_global) {
> +	if(chan->flags & RCHAN_GLOBAL_BUFFER) {
	
Please use checkpatch.  It's a little thing, but it's so easy to fix..

>   		chan->buf[0] = buf;
>   		buf->cpu = 0;
>    	}
>
> ...
