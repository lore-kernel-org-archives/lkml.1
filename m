Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab0BZK2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:28:03 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61682 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab0BZK17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:27:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=N1wDrNWjMNVlJlj59mlv1U2V3gzCi/MNRciN5vX54KEXaVGlK5awXQ04DSJcsOcu6A
         U/ixUcTf6BSrqWQ8tQiU+DSoo3uJDPmPiCR8JgrO5uyDznJjo0mbtWea2vavDuaJmGI/
         Cq/DyyUwvFRqLglCEjRApD1oY8P7VU4TWtaOo=
Date: Fri, 26 Feb 2010 13:27:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: "Steven J. Magnani" <steve@digidescorp.com>, linux-kernel@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, dan.j.williams@intel.com,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Buggy variable-length array code...or compiler?
Message-ID: <20100226102745.GC8417@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Rientjes <rientjes@google.com>,
	"Steven J. Magnani" <steve@digidescorp.com>,
	linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
	dan.j.williams@intel.com, Dave Hansen <dave@linux.vnet.ibm.com>
References: <1267139849.3079.68.camel@iscandar.digidescorp.com> <alpine.DEB.2.00.1002251544120.25189@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002251544120.25189@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 03:46:48PM -0800, David Rientjes wrote:
> On Thu, 25 Feb 2010, Steven J. Magnani wrote:
> 
> > When I run a memcpy dmatest with a Microblaze 2.6.33 noMMU kernel, the
> > system crashes after about 400 iterations. After much head scratching, I
> > believe I've narrowed the problem to this fragment of code in
> > drivers/dma/dmatest.c:
> > 
> > static int dmatest_func(void *data)
> > {
> > 	struct dmatest_thread	*thread = data;
> > ...
> > 	unsigned int		total_tests = 0;
> > 	int			src_cnt;
> > 	int			dst_cnt;
> > 
> > ...
> > 	if (thread->type == DMA_MEMCPY)
> > 		src_cnt = dst_cnt = 1;
> > ...
> > 
> > 	while (!kthread_should_stop()
> > 	       && !(iterations && total_tests >= iterations)) {
> > 		struct dma_device *dev = chan->device;
> > 		struct dma_async_tx_descriptor *tx = NULL;
> > 		dma_addr_t dma_srcs[src_cnt];
> > 		dma_addr_t dma_dsts[dst_cnt];
> > 
> > 		...
> > 		total_tests++;
> > 
> > 		/* CODE ADDED BY ME FOR DEBUG */
> > 		printk("dmatest: Iteration %d, dma_srcs = %p\n",
> > 		       total_tests, dma_srcs);
> > 
> > 		...
> > 	}
> > 
> > With this code I get output like this:
> > 
> > dmatest: Iteration 1, dma_srcs = 2c963ee8
> > dmatest: Iteration 2, dma_srcs = 2c963ed8
> > dmatest: Iteration 3, dma_srcs = 2c963ec8
> > dmatest: Iteration 4, dma_srcs = 2c963eb8
> > ...
> > dmatest: Iteration 420, dma_srcs = 2c9624b8
> > 
> > ...and then the stack detonates and the kernel crashes with some strange
> > error or other.
> > 
> 
> This could probably become the first kernel user of the flexible array 
> library (see Documentation/flexible-arrays.txt).  Dan?
> --

I think the max that src_cnt can be is 3 and the most dst_cnt can be is 2.  
We could just put that there.

regards,
dan carpenter

