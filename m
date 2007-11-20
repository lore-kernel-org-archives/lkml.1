Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbXKTMu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbXKTMu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbXKTMuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:50:51 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:52580 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756847AbXKTMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:50:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAD9nQkdMROHU/2dsb2JhbACBWw
Date: Tue, 20 Nov 2007 07:50:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: clameter@sgi.com
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 23/45] cpu alloc: dmaengine conversion
Message-ID: <20071120125047.GC10127@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011337.156646718@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071120011337.156646718@sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:49:24 up 16 days, 17:54,  2 users,  load average: 3.90, 3.78,
	2.84
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* clameter@sgi.com (clameter@sgi.com) wrote:
> Convert DMA engine to use CPU_xx operations. This also removes the use of local_t
> from the dmaengine.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
>  drivers/dma/dmaengine.c   |   38 ++++++++++++++------------------------
>  include/linux/dmaengine.h |   16 ++++++----------
>  2 files changed, 20 insertions(+), 34 deletions(-)
> 
> Index: linux-2.6/drivers/dma/dmaengine.c
> ===================================================================
> --- linux-2.6.orig/drivers/dma/dmaengine.c	2007-11-19 15:45:06.009390961 -0800
> +++ linux-2.6/drivers/dma/dmaengine.c	2007-11-19 15:59:59.894744662 -0800
> @@ -84,7 +84,7 @@ static ssize_t show_memcpy_count(struct 
>  	int i;
>  
>  	for_each_possible_cpu(i)
> -		count += per_cpu_ptr(chan->local, i)->memcpy_count;
> +		count += CPU_PTR(chan->local, i)->memcpy_count;
>  
>  	return sprintf(buf, "%lu\n", count);
>  }
> @@ -96,7 +96,7 @@ static ssize_t show_bytes_transferred(st
>  	int i;
>  
>  	for_each_possible_cpu(i)
> -		count += per_cpu_ptr(chan->local, i)->bytes_transferred;
> +		count += CPU_PTR(chan->local, i)->bytes_transferred;
>  
>  	return sprintf(buf, "%lu\n", count);
>  }
> @@ -110,10 +110,8 @@ static ssize_t show_in_use(struct class_
>  		atomic_read(&chan->refcount.refcount) > 1)
>  		in_use = 1;
>  	else {
> -		if (local_read(&(per_cpu_ptr(chan->local,
> -			get_cpu())->refcount)) > 0)
> +		if (_CPU_READ(chan->local->refcount) > 0)
>  			in_use = 1;
> -		put_cpu();
>  	}
>  
>  	return sprintf(buf, "%d\n", in_use);
> @@ -226,7 +224,7 @@ static void dma_chan_free_rcu(struct rcu
>  	int bias = 0x7FFFFFFF;
>  	int i;
>  	for_each_possible_cpu(i)
> -		bias -= local_read(&per_cpu_ptr(chan->local, i)->refcount);
> +		bias -= _CPU_READ(chan->local->refcount);
>  	atomic_sub(bias, &chan->refcount.refcount);
>  	kref_put(&chan->refcount, dma_chan_cleanup);
>  }
> @@ -372,7 +370,8 @@ int dma_async_device_register(struct dma
>  
>  	/* represent channels in sysfs. Probably want devs too */
>  	list_for_each_entry(chan, &device->channels, device_node) {
> -		chan->local = alloc_percpu(typeof(*chan->local));
> +		chan->local = CPU_ALLOC(typeof(*chan->local),
> +					GFP_KERNEL | __GFP_ZERO);
>  		if (chan->local == NULL)
>  			continue;
>  
> @@ -385,7 +384,7 @@ int dma_async_device_register(struct dma
>  		rc = class_device_register(&chan->class_dev);
>  		if (rc) {
>  			chancnt--;
> -			free_percpu(chan->local);
> +			CPU_FREE(chan->local);
>  			chan->local = NULL;
>  			goto err_out;
>  		}
> @@ -413,7 +412,7 @@ err_out:
>  		kref_put(&device->refcount, dma_async_device_cleanup);
>  		class_device_unregister(&chan->class_dev);
>  		chancnt--;
> -		free_percpu(chan->local);
> +		CPU_FREE(chan->local);
>  	}
>  	return rc;
>  }
> @@ -488,11 +487,8 @@ dma_async_memcpy_buf_to_buf(struct dma_c
>  	tx->tx_set_dest(addr, tx, 0);
>  	cookie = tx->tx_submit(tx);
>  
> -	cpu = get_cpu();
> -	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
> -	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
> -	put_cpu();
> -
> +	__CPU_ADD(chan->local->bytes_transferred, len);
> +	__CPU_INC(chan->local->memcpy_count);

I am wondering about the impact of the preempt disable removal here. It
means that there is a statistically low probability that we will be
moved to a different CPU between the bytes_transferred and the
memcpy_count increments. I hope nobody relies on the fact that the
per-cpu counts should match perfectly...


>  	return cookie;
>  }
>  EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
> @@ -532,11 +528,8 @@ dma_async_memcpy_buf_to_pg(struct dma_ch
>  	tx->tx_set_dest(addr, tx, 0);
>  	cookie = tx->tx_submit(tx);
>  
> -	cpu = get_cpu();
> -	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
> -	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
> -	put_cpu();
> -
> +	_CPU_ADD(chan->local->bytes_transferred, len);
> +	_CPU_INC(chan->local->memcpy_count);
>  	return cookie;
>  }
>  EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
> @@ -578,11 +571,8 @@ dma_async_memcpy_pg_to_pg(struct dma_cha
>  	tx->tx_set_dest(addr, tx, 0);
>  	cookie = tx->tx_submit(tx);
>  
> -	cpu = get_cpu();
> -	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
> -	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
> -	put_cpu();
> -
> +	_CPU_ADD(chan->local->bytes_transferred, len);
> +	_CPU_INC(chan->local->memcpy_count);
>  	return cookie;
>  }
>  EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
> Index: linux-2.6/include/linux/dmaengine.h
> ===================================================================
> --- linux-2.6.orig/include/linux/dmaengine.h	2007-11-19 15:45:06.017390185 -0800
> +++ linux-2.6/include/linux/dmaengine.h	2007-11-19 15:56:26.814390333 -0800
> @@ -102,13 +102,13 @@ typedef struct { DECLARE_BITMAP(bits, DM
>  
>  /**
>   * struct dma_chan_percpu - the per-CPU part of struct dma_chan
> - * @refcount: local_t used for open-coded "bigref" counting
> + * @refcount: int used for open-coded "bigref" counting
>   * @memcpy_count: transaction counter
>   * @bytes_transferred: byte counter
>   */
>  
>  struct dma_chan_percpu {
> -	local_t refcount;
> +	int refcount;
>  	/* stats */
>  	unsigned long memcpy_count;
>  	unsigned long bytes_transferred;
> @@ -149,20 +149,16 @@ static inline void dma_chan_get(struct d
>  {
>  	if (unlikely(chan->slow_ref))
>  		kref_get(&chan->refcount);
> -	else {
> -		local_inc(&(per_cpu_ptr(chan->local, get_cpu())->refcount));
> -		put_cpu();
> -	}
> +	else
> +		_CPU_INC(chan->local->refcount);
>  }
>  
>  static inline void dma_chan_put(struct dma_chan *chan)
>  {
>  	if (unlikely(chan->slow_ref))
>  		kref_put(&chan->refcount, dma_chan_cleanup);
> -	else {
> -		local_dec(&(per_cpu_ptr(chan->local, get_cpu())->refcount));
> -		put_cpu();
> -	}
> +	else
> +		_CPU_DEC(chan->local->refcount);
>  }
>  
>  /*
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
