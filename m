Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZFDUvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZFDUvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZFDUuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:50:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbZFDUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:50:54 -0400
Date: Thu, 4 Jun 2009 13:50:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: A bug in read operation for /dev/zero and a proposed fix.
Message-Id: <20090604135050.ceb6bf18.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.0906041330170.32557@bumblebee1.mtv.corp.google.com>
References: <alpine.DEB.1.00.0906041330170.32557@bumblebee1.mtv.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 13:32:55 -0700 (PDT)
Salman Qazi <sqazi@google.com> wrote:

> While running 20 parallel instances of dd as follows:
> 
> #!/bin/bash
> 
> for i in `seq 1 20`; do
>          dd if=/dev/zero of=/export/hda3/dd_$i bs=1073741824 count=1 &
> done
> wait
> 
> on a 16G machine, we noticed that rather than just killing the
> processes, the entire kernel went down.  Stracing dd reveals that it first
> does an mmap2, which makes 1GB worth of zero page mappings.  Then it 
> performs
> a read on those pages from /dev/zero, and finally it performs a write. 
> The
> machine died during the reads.  Looking at the code, it was noticed that
> /dev/zero's read operation had been changed at some point from giving
> zero page mappings to actually zeroing the page.  The zeroing of the
> pages causes physical pages to be allocated to the process.

erk, Nick broke dd(1):

  commit 557ed1fa2620dc119adb86b34c614e152a629a80
  Author: Nick Piggin <npiggin@suse.de>
  Date:   Tue Oct 16 01:24:40 2007 -0700

      remove ZERO_PAGE


This is the first report I've seen of problems arising from that
change.

>  But, when
> the process exhausts all the memory that it can, the kernel cannot kill
> it, as it is still in the kernel mode allocating more memory. 
> Consequently,
> the kernel eventually crashes.
> 
> To fix this, I propose that when a fatal signal is pending during
> /dev/zero read operation, we simply return and let the user process die.
> Here is a patch that does that.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>
> ---
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 8f05c38..2ffa36e 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -696,6 +696,11 @@ static ssize_t read_zero(struct file * file, char __user * buf,
>   			break;
>   		buf += chunk;
>   		count -= chunk;
> +		/* The exit code here doesn't actually matter, as userland
> +		 * will never see it.
> +		 */
> +		if (fatal_signal_pending(current))
> +			return -ENOMEM;
>   		cond_resched();
>   	}
>   	return written ? written : -EFAULT;

OK.  I think.

It's presumptuous to return -ENOMEM: we don't _know_ that this signal
came from the oom-killer.  It would be better to return -EINTR here.
