Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbXGDUbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbXGDUbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 16:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXGDUbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 16:31:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:36695 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbXGDUbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 16:31:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=ta5eWNJvVBFmD/AFYyk8S4eERJHczkmTmQ9ucSy0iGB32RrbyDOpc6CEeC7WVOL6rzomhZXD1vtSj30voeDVBTWkCZ4jhIeszZGOZQNgZYh0AeliWtjtQSdIGurejUhzCzpwZnoLTEy/Jq47cXYlGAZXy+jWcuSwE0CBQmb1jXg=
Date: Thu, 5 Jul 2007 00:31:19 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070704203119.GB5812@martell.zuzino.mipt.ru>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070703185748.GA4047@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 02:57:48PM -0400, Mathieu Desnoyers wrote:
> * Alexey Dobriyan (adobriyan@gmail.com) wrote:
> > On Tue, Jul 03, 2007 at 12:40:56PM -0400, Mathieu Desnoyers wrote:
> > > Use immediate values with lower d-cache hit in optimized version as a
> > > condition for scheduler profiling call.
> >
> > How much difference in performance do you see?
> >
>
> Hi Alexey,
>
> Please have a look at Documentation/immediate.txt for that information.
> Also note that the main advantage of the load immediate is to free a
> cache line. Therefore, I guess the best way to quantify the improvement
> it brings at one single site is not in terms of cycles, but in terms of
> number of cache lines used by the scheduler code. Since memory bandwidth
> seems to be an increasing bottleneck (CPU frequency increases faster
> than the available memory bandwidth), it makes sense to free as much
> cache lines as we can.
>
> Measuring the overall impact on the system of this single modification
> results in the difference brought by one site within the standard
> deviation of the normal samples. It will become significant when the
> number of immediate values used instead of global variables at hot
> kernel paths (need to ponder with the frequency at which the data is
> accessed) will start to be significant compared to the L1 data cache
> size.

L1 cache is 8K here. Just how many such variables should exist?
On hot paths!

> We could characterize this in memory to L1 cache transfers per
> seconds.
>
> On 3GHz P4:
>
> memory read: ~48 cycles
>
> So we can definitely say that 48*HZ (approximation of the frequency at
> which the scheduler is called) won't make much difference, but as it
> grows, it will.
>
> On a 1000HZ system, it results in:
>
> 48000 cycles/second, or 16µs/second, or 0.000016% speedup.
>
> However, if we place this in code called much more often, such as
> do_page_fault, we get, with an hypotetical scenario of approximation
> of 100000 page faults per second:
>
> 4800000 cycles/s, 1.6ms/second or 0.0016% speedup.
>
> So as the number of immediate values used increase, the overall memory
> bandwidth required by the kernel will go down.

Adding so many infrastructure for something that you can't even measure
is totally unjustified.

There are already too many places where unlikely() and __read_mostly are
used just because they can be used, so adding yet another such very
specific, let's call it annotation, seems wrong to me.

