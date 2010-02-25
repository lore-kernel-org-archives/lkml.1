Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934568Ab0BYXq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:46:58 -0500
Received: from smtp-out.google.com ([216.239.33.17]:29221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553Ab0BYXq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:46:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=F1qiVwxkmA/wSfOLste/CQsYCfc0cSt2LqPf7VU3xnlUGh9NxB0f6aYexEKlm2o5A
	kDtY7r5Gj8BDIzQ1xvOhQ==
Date: Thu, 25 Feb 2010 15:46:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Steven J. Magnani" <steve@digidescorp.com>
cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       dan.j.williams@intel.com, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Buggy variable-length array code...or compiler?
In-Reply-To: <1267139849.3079.68.camel@iscandar.digidescorp.com>
Message-ID: <alpine.DEB.2.00.1002251544120.25189@chino.kir.corp.google.com>
References: <1267139849.3079.68.camel@iscandar.digidescorp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Steven J. Magnani wrote:

> When I run a memcpy dmatest with a Microblaze 2.6.33 noMMU kernel, the
> system crashes after about 400 iterations. After much head scratching, I
> believe I've narrowed the problem to this fragment of code in
> drivers/dma/dmatest.c:
> 
> static int dmatest_func(void *data)
> {
> 	struct dmatest_thread	*thread = data;
> ...
> 	unsigned int		total_tests = 0;
> 	int			src_cnt;
> 	int			dst_cnt;
> 
> ...
> 	if (thread->type == DMA_MEMCPY)
> 		src_cnt = dst_cnt = 1;
> ...
> 
> 	while (!kthread_should_stop()
> 	       && !(iterations && total_tests >= iterations)) {
> 		struct dma_device *dev = chan->device;
> 		struct dma_async_tx_descriptor *tx = NULL;
> 		dma_addr_t dma_srcs[src_cnt];
> 		dma_addr_t dma_dsts[dst_cnt];
> 
> 		...
> 		total_tests++;
> 
> 		/* CODE ADDED BY ME FOR DEBUG */
> 		printk("dmatest: Iteration %d, dma_srcs = %p\n",
> 		       total_tests, dma_srcs);
> 
> 		...
> 	}
> 
> With this code I get output like this:
> 
> dmatest: Iteration 1, dma_srcs = 2c963ee8
> dmatest: Iteration 2, dma_srcs = 2c963ed8
> dmatest: Iteration 3, dma_srcs = 2c963ec8
> dmatest: Iteration 4, dma_srcs = 2c963eb8
> ...
> dmatest: Iteration 420, dma_srcs = 2c9624b8
> 
> ...and then the stack detonates and the kernel crashes with some strange
> error or other.
> 

This could probably become the first kernel user of the flexible array 
library (see Documentation/flexible-arrays.txt).  Dan?
