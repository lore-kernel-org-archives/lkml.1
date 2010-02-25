Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498Ab0BYXRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:17:35 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:42617 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934472Ab0BYXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:17:34 -0500
X-Spam-Processed: digidescorp.com, Thu, 25 Feb 2010 17:17:32 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1672ac1db0=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Buggy variable-length array code...or compiler?
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, dan.j.williams@intel.com
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Thu, 25 Feb 2010 17:17:29 -0600
Message-Id: <1267139849.3079.68.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I run a memcpy dmatest with a Microblaze 2.6.33 noMMU kernel, the
system crashes after about 400 iterations. After much head scratching, I
believe I've narrowed the problem to this fragment of code in
drivers/dma/dmatest.c:

static int dmatest_func(void *data)
{
	struct dmatest_thread	*thread = data;
...
	unsigned int		total_tests = 0;
	int			src_cnt;
	int			dst_cnt;

...
	if (thread->type == DMA_MEMCPY)
		src_cnt = dst_cnt = 1;
...

	while (!kthread_should_stop()
	       && !(iterations && total_tests >= iterations)) {
		struct dma_device *dev = chan->device;
		struct dma_async_tx_descriptor *tx = NULL;
		dma_addr_t dma_srcs[src_cnt];
		dma_addr_t dma_dsts[dst_cnt];

		...
		total_tests++;

		/* CODE ADDED BY ME FOR DEBUG */
		printk("dmatest: Iteration %d, dma_srcs = %p\n",
		       total_tests, dma_srcs);

		...
	}

With this code I get output like this:

dmatest: Iteration 1, dma_srcs = 2c963ee8
dmatest: Iteration 2, dma_srcs = 2c963ed8
dmatest: Iteration 3, dma_srcs = 2c963ec8
dmatest: Iteration 4, dma_srcs = 2c963eb8
...
dmatest: Iteration 420, dma_srcs = 2c9624b8

...and then the stack detonates and the kernel crashes with some strange
error or other.

Are there any language lawyers in the house who'd care to weigh in on
which of these possibilities is the right one?

1. There is a coding error in dmatest
2. There is a bug specific to Microblaze gcc compiler(s) [mine is 4.1.2]
3. There is a bug generic to specific versions of gcc compilers
4. There is a bug generic to all gcc compilers

Obviously, the options get more disturbing the higher you go. I don't
know if VLAs are used elsewhere in the kernel; a 'smatch' search might
be helpful.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



