Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYKWI7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYKWI7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYKWI72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:59:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40373 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYKWI71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:59:27 -0500
Date: Sun, 23 Nov 2008 09:59:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: poll: allow f_op->poll to sleep, take #3
Message-ID: <20081123085902.GI30453@elte.hu>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> On Sun, 23 Nov 2008, Tejun Heo wrote:
> 
> > +static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
> > +{
> > +	struct poll_wqueues *pwq = wait->private;
> > +	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
> > +
> > +	set_mb(pwq->triggered, 1);
> > +
> > +	/* perform the default wake up operation */
> > +	return default_wake_function(&dummy_wait, mode, sync, key);
> > +}
> 
> Wouldn't it be nicer to un-static try_to_wake_up() (or a wrapper) 
> instead of setting up a fake wait queue just to use 
> default_wake_function(), just to wake up a task?

the already existing single-task-wakeup shortcut method made available 
by the scheduler is wake_up_process(). A number of primitives where 
waitqueue overhead is of concern already make use of it. 
(mutexes/rtmutexes and more)

if you need a different mode flag, then please extend the 
wake_up_process() family of APIs.

	Ingo
