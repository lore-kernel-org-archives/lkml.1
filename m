Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYDDQKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYDDQKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbYDDQJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:09:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16450 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbYDDQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:09:57 -0400
Date: Fri, 4 Apr 2008 09:08:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] relay: add buffer-only functionality, allowing for
 early kernel tracing
Message-Id: <20080404090801.c988f96f.randy.dunlap@oracle.com>
In-Reply-To: <20080404183303.2e239a20@linux360.ro>
References: <20080404183303.2e239a20@linux360.ro>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 18:33:03 +0300 Eduard - Gabriel Munteanu wrote:

> relay_open() can now handle NULL base_filename, to register a
> buffer-only channel. Using a new function, relay_late_setup_files(), one
> can assign files after creating the channel, thus allowing for doing
> early tracing in the kernel, before VFS is up.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  Documentation/filesystems/relay.txt |   11 ++++
>  include/linux/relay.h               |    4 ++
>  kernel/relay.c                      |  102 ++++++++++++++++++++++++++---------
>  3 files changed, 91 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/filesystems/relay.txt b/Documentation/filesystems/relay.txt
> index 094f2d2..b59c228 100644
> --- a/Documentation/filesystems/relay.txt
> +++ b/Documentation/filesystems/relay.txt
> @@ -161,6 +161,7 @@ TBD(curr. line MT:/API/)
>      relay_close(chan)
>      relay_flush(chan)
>      relay_reset(chan)
> +    relay_late_setup_files(chan, base_filename, parent)
>  
>    channel management typically called on instigation of userspace:
>  
> @@ -294,6 +295,16 @@ user-defined data with a channel, and is immediately available
>  (including in create_buf_file()) via chan->private_data or
>  buf->chan->private_data.
>  
> +Buffer-only channels
> +--------------------
> +
> +These channels have no files associated and can be created with
> +relay_open(NULL, NULL, ...). Such channels are useful in scenarios such
> +as when doing early tracing in the kernel, before the VFS is up. In these
> +cases, one may open a channel a buffer-only channel and then call
                       ~~~~~~~~~
d/a channel/

> +relay_late_setup_files() when the kernel is ready to handle files, to expose
> +the buffered data to the userspace.
> +
>  Channel 'modes'
>  ---------------
>  
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 4c035a8..4bea94a 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -378,6 +378,35 @@ void relay_reset(struct rchan *chan)
>  }
>  EXPORT_SYMBOL_GPL(relay_reset);
>  
> +static int relay_setup_buf_file(struct rchan *chan,
> +				struct rchan_buf *buf,
> +				unsigned int cpu)
> +{
> +	struct dentry *dentry;
> + 	char *tmpname;
> +
> +	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
> +	if (!tmpname)
> +		goto failed;
> +	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
> +
> +	/* Create file in fs */
> +	dentry = chan->cb->create_buf_file(tmpname, chan->parent,
> +					   S_IRUSR, buf, 
> +					   &chan->is_global);
> +	
> +	if (!dentry)
> +		goto failed;

above leaks tmpname ?

> +	buf->dentry = dentry;
> +
> +	kfree(tmpname);
> +
> +	return 0;
> +
> +failed:
> +	return 1;
> +}
> +
>  /*
>   *	relay_open_buf - create a new relay channel buffer
>   *
> @@ -386,44 +415,30 @@ EXPORT_SYMBOL_GPL(relay_reset);
>  static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
>  {
>   	struct rchan_buf *buf = NULL;
> -	struct dentry *dentry;
> - 	char *tmpname;
>  
>   	if (chan->is_global)
>  		return chan->buf[0];
>  
> -	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
> - 	if (!tmpname)
> - 		goto end;
> - 	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
> -
>  	buf = relay_create_buf(chan);
>  	if (!buf)
> - 		goto free_name;
> + 		goto end;
> +
> + 	if (chan->has_base_filename)
> +		if (relay_setup_buf_file(chan, buf, cpu)) goto free_buf;

Put 'goto free_buf;' on separate line.

>  
>   	buf->cpu = cpu;
>   	__relay_reset(buf, 1);
>  
> -	/* Create file in fs */
> - 	dentry = chan->cb->create_buf_file(tmpname, chan->parent, S_IRUSR,
> - 					   buf, &chan->is_global);
> - 	if (!dentry)
> - 		goto free_buf;
> -
> -	buf->dentry = dentry;
> -
>   	if(chan->is_global) {
>   		chan->buf[0] = buf;
>   		buf->cpu = 0;
>    	}
>  
> - 	goto free_name;
> + 	goto end;
>  
>  free_buf:
>   	relay_destroy_buf(buf);
>   	buf = NULL;
> -free_name:
> - 	kfree(tmpname);
>  end:
>  	return buf;
>  }
> @@ -576,6 +594,38 @@ free_bufs:
>  EXPORT_SYMBOL_GPL(relay_open);
>  
>  /**
> + *	relay_late_setup_files - triggers file creation
> + *	@chan: channel to operate on
> + *	@base_filename: base name of files to create
> + *	@parent: dentry of parent directory, %NULL for root directory
> + *
> + *	Returns 0 is successful, non-zero otherwise.

s/is/if/

> + *
> + *	Use to setup files for a previously buffer-only channel.
> + *	Useful to do early tracing in kernel, before VFS is up, for example.
> + */
> +int relay_late_setup_files(struct rchan *chan,
> +			   const char *base_filename,
> +			   struct dentry *parent)
> +{
> +	unsigned int i;
> +	
> +	if (!chan || !base_filename)
> +		return 1;
> +	
> +	strlcpy(chan->base_filename, base_filename, NAME_MAX);
> +	chan->has_base_filename = 1;
> +	chan->parent = parent;
> +
> +	mutex_lock(&relay_channels_mutex);
> +	for_each_present_cpu(i)
> +		relay_setup_buf_file(chan, chan->buf[i], i);
> +	mutex_unlock(&relay_channels_mutex);
> +
> +	return 0;
> +}
> +		
> +/**
>   *	relay_switch_subbuf - switch to a new sub-buffer
>   *	@buf: channel buffer
>   *	@length: size of current event

---
~Randy
