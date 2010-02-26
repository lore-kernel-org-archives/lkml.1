Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab0BZKMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:12:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52897 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161Ab0BZKMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:12:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=BvjQI959CF4eFbcfua9fI4+Zu7fmYKfYyitz1kaWMBxI3HodJ5pzg1t3jtOE+1qlD2
         lMblPWyyYqwoq4RexV1wtLF86QXNBI0ngWpn/kAWzm5HsQJ4BUATUvl7Qa6tLVHZTq8V
         AtDogbGevlPIqwWbEyv780HMj0JQkMYGus1DE=
Date: Fri, 26 Feb 2010 13:11:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       dan.j.williams@intel.com
Subject: Re: Buggy variable-length array code...or compiler?
Message-ID: <20100226101153.GB8417@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Steven J. Magnani" <steve@digidescorp.com>,
	linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
	dan.j.williams@intel.com
References: <1267139849.3079.68.camel@iscandar.digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267139849.3079.68.camel@iscandar.digidescorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 05:17:29PM -0600, Steven J. Magnani wrote:
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
> Are there any language lawyers in the house who'd care to weigh in on
> which of these possibilities is the right one?
> 
> 1. There is a coding error in dmatest
> 2. There is a bug specific to Microblaze gcc compiler(s) [mine is 4.1.2]
> 3. There is a bug generic to specific versions of gcc compilers
> 4. There is a bug generic to all gcc compilers
> 
> Obviously, the options get more disturbing the higher you go. I don't
> know if VLAs are used elsewhere in the kernel; a 'smatch' search might
> be helpful.
> 

Sparse complains about variable length arrays.

drivers/dma/dmatest.c:293:37: error: bad constant expression

In my allmodconfig with staging:
~/progs/kernel/devel$ grep "bad constant expression" warns.txt  | sort -u | wc -l
133

regards,
dan carpenter


> Regards,
> ------------------------------------------------------------------------
>  Steven J. Magnani               "I claim this network for MARS!
>  www.digidescorp.com              Earthling, return my space modulator!"
> 
>  #include <standard.disclaimer>
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
