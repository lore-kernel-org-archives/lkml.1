Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbYFNJOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbYFNJOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbYFNJOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:14:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:65069 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYFNJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eWgGFrALvzoqJhngrc71OUkfgNk1vUZI1qAxG8iRA3kbZGvADJhq4JqrRXytDSSDDe
         veN3K7Zk4QiWsWIhlbt278zaXOq4Y7Hg90Q2UW78Mhi/s3jJR+pMnNlU6x+ePna0HTZ8
         L64b4EiM1adUtLxy12s7/sp+zxpj8zsMW3Ya4=
Date: Sat, 14 Jun 2008 11:13:40 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: implement flush_work()
Message-ID: <20080614091339.GA2466@ami.dom.local>
References: <20080613142801.GA9165@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613142801.GA9165@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 06:28:01PM +0400, Oleg Nesterov wrote:
> (on top of [PATCH] workqueues: insert_work: use "list_head *" instead of "int tail"
>  http://marc.info/?l=linux-kernel&m=121328944230175)
> 
> Most of users of flush_workqueue() can be changed to use cancel_work_sync(),
> but sometimes we really need to wait for the completion and cancelling is not
> an option. schedule_on_each_cpu() is good example.
> 
> Add the new helper, flush_work(work), which waits for the completion of the
> specific work_struct.

This all looks right and better than current flush_, but... the main
problem is that probably in 90% cases cancel_ + self-running a work
function (if cancelled) should be both more efficient and safer wrt
locking (what you convince me to, BTW). But, since there is no visible
macro/wrapper for this, people will probably mostly choose what they
can see in workqueue.h, so not necessarily the best thing.

Another question is if schedule_on_each_cpu() is really such a good
example here: it seems these "xxx && yyy" examples could be faster,
but I've lost track of this earlier thread.

BTW, flush_work() probably needs a lockdep annotation similar to
flush_workqueue().

Otherwise this all looks OK to me.

Thanks,
Jarek P.
