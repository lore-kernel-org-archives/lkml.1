Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbXGECXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbXGECXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 22:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXGECXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 22:23:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55810 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbXGECXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 22:23:34 -0400
Subject: Re: [PATCH] dio: remove bogus refcounting BUG_ON
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070703222855.GA6293@mami.zabbo.net>
References: <46832499.40807@us.ibm.com>
	 <5A6608DF-EDC3-43C1-BFB7-58ACBF94DBCB@oracle.com>
	 <46859DE2.9040604@us.ibm.com>  <20070703222855.GA6293@mami.zabbo.net>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 19:25:10 -0700
Message-Id: <1183602311.29435.1.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 15:28 -0700, Zach Brown wrote:
> Linus, Andrew, please apply the bug fix patch at the end of this reply
> for .22.
> 
> > >>One of our perf. team ran into this while doing some runs.
> > >>I didn't see anything obvious - it looks like we converted
> > >>async IO to synchronous one. I didn't spend much time digging
> > >>around.
> 
> OK, I think this BUG_ON() is just broken.  I wasn't able to find any
> obvious bugs from reading the code which would cause the BUG_ON() to
> fire.  If it's reproducible I'd love to hear what the recipe is.
> 
> I did notice that this BUG_ON() is evaluating dio after having dropped
> it's ref :/.  So it's not completely absurd to fear that it's a race
> with the dio's memory being reused, but that'd be a pretty tight race.
> 
> Let's remove this stupid BUG_ON and see if that test box still has
> trouble.  It might just hit the valid BUG_ON a few lines down, but this
> unsafe BUG_ON needs to go.

I went through the code multiple times, I can't find how we can trigger
the BUG_ON(). But unfortunately, our perf. team is able reproduce the
problem. Debug indicated that, the ret2 == 1 :(

Not sure how that can happen. Ideas ?

Thanks,
Badari

> 
> -------
> 
> dio: remove bogus refcounting BUG_ON
> 
> Badari Pulavarty reported a case of this BUG_ON is triggering during
> testing.  It's completely bogus and should be removed.
> 
> It's trying to notice if we left references to the dio hanging around in
> the sync case.  They should have been dropped as IO completed while this
> path was in dio_await_completion().  This condition will also be
> checked, via some twisty logic, by the BUG_ON(ret != -EIOCBQUEUED) a few
> lines lower.  So to start this BUG_ON() is redundant.
> 
> More fatally, it's dereferencing dio-> after having dropped its
> reference.  It's only safe to dereference the dio after releasing the
> lock if the final reference was just dropped.  Another CPU might free
> the dio in bio completion and reuse the memory after this path drops the
> dio lock but before the BUG_ON() is evaluated.
> 
> This patch passed aio+dio regression unit tests and aio-stress on ext3.
> 
> Signed-off-by: Zach Brown <zach.brown@oracle.com>
> Cc: Badari Pulavarty <pbadari@us.ibm.com>
> 
> diff -r 509ce354ae1b fs/direct-io.c
> --- a/fs/direct-io.c	Sun Jul 01 22:00:49 2007 +0000
> +++ b/fs/direct-io.c	Tue Jul 03 14:56:41 2007 -0700
> @@ -1106,7 +1106,7 @@ direct_io_worker(int rw, struct kiocb *i
>  	spin_lock_irqsave(&dio->bio_lock, flags);
>  	ret2 = --dio->refcount;
>  	spin_unlock_irqrestore(&dio->bio_lock, flags);
> -	BUG_ON(!dio->is_async && ret2 != 0);
> +
>  	if (ret2 == 0) {
>  		ret = dio_complete(dio, offset, ret);
>  		kfree(dio);

