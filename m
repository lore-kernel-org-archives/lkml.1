Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808Ab0BZAq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:46:29 -0500
Received: from smtp12.ono.com ([62.42.230.20]:5604 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934798Ab0BZAq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:46:26 -0500
Date: Fri, 26 Feb 2010 01:46:23 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Buggy variable-length array code...or compiler?
Message-ID: <20100226014623.11d8d79f@werewolf.home>
In-Reply-To: <1267139849.3079.68.camel@iscandar.digidescorp.com>
References: <1267139849.3079.68.camel@iscandar.digidescorp.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.19.6; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010 17:17:29 -0600, "Steven J. Magnani" <steve@digidescorp.com> wrote:

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

Can you try this in userspace ? I compiled in CentOS gcc 4.1.2 (just the
same), and the addresses are always the same:

#include <stdio.h>

int main()
{
    int c = 2;
    while (1)
    {
        int a[c];
        int b[c];
        a[0] = b[0];
        printf("%p %p\n",a,b);
    }
}

Could you post the full contents of the while loop ? Perhaps there's a
buglet in other piece of code that leaves something on the stack.
Which is the size of dma_addr_t ? Does it match the difference of 16 bytes
on each iteration ? cnt's are always 1, isn't it ?
Can you switch the size to a fixed '1' to see if this hangs again ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
