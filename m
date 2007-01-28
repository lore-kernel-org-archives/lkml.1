Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXA1Ui7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXA1Ui7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 15:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820AbXA1Ui7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 15:38:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47169 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbXA1Ui6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 15:38:58 -0500
Date: Sun, 28 Jan 2007 20:38:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
Message-ID: <20070128203841.GA27397@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128184116.GA12150@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128184116.GA12150@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 07:41:16PM +0100, Ingo Molnar wrote:
> starts one process per CPU and open()s/close()s a file all over again, 
> simulating an open/close-intense workload. This pattern is quite typical 
> of several key Linux applications.
> 
> Using Peter's s_files patchset the following scalability improvement can 
> be measured (lower numbers are better):
> 
>  ----------------------------------------------------------------------
>                   v2.6.20-rc6     |   v2.6.20-rc6+Peter's s_files queue
>  ----------------------------------------------------------------------
>  dual-core:       2.11 usecs/op   |   1.51 usecs/op     (  +39.7% win )
>  8-socket:        6.30 usecs/op   |   2.70 usecs/op     ( +233.3% win )

Thanks for having some numbers to start with.

> Now could you please tell me why i had to waste 3.5 hours on measuring 
> and profiling this /again/, while a tiny little bit of goodwill from 
> your side could have avoided this? I told you that we lock-profiled this 
> under -rt, and that it's an accurate measurement of such things - as the 
> numbers above prove it too. Would it have been so hard to say something 
> like: "Cool Peter! That lock had been in our way of good open()/close() 
> scalability for such a long time and it's an obviously good idea to 
> eliminate it. Now here's a couple of suggestions of how to do it even 
> simpler: [...]." Why did you have to in essence piss on his patchset? 
> Any rational explanation?

Can we please stop this stupid pissing contest.  I'm totally fine to admit
yours is bigger than mine in public, so let's get back to the facts.


The patchkit we're discussing here introduces a lot of complexity:

 - a new type of implicitly locked linked lists
 - a new synchronization primitive
 - a new locking scheme that utilizes the previous two items, aswell
   as rcu.

I think we definitly we want some numbers (which you finally provided)
to justify this.

Then going on to the implementation I don't like trying to "fix" a problem
with this big hammer approach.  I've outlined some alternate ways that
actually simplify both the underlying data structures and locking that
should help towards this problem instead of making the code more complex
and really hard to understand.
