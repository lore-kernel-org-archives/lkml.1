Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYKZEex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYKZEex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYKZEen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:34:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:52113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYKZEem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:34:42 -0500
Message-ID: <492CD1AB.3000802@kernel.org>
Date: Wed, 26 Nov 2008 13:33:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Davide Libenzi <davidel@xmailserver.org>,
       Brad Boyer <flar@allandria.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + poll-allow-f_op-poll-to-sleep-take-4.patch added to -mm tree
References: <20081125173032.GA21539@redhat.com>
In-Reply-To: <20081125173032.GA21539@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Nov 2008 04:33:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Oleg Nesterov wrote:
> So, why do we need this mb() in pollwake() ?
> 
> try_to_wake_up() has a full barrier semantics, note the wmb() before
> task_rq_lock(). Since spin_lock() itself is STORE, the setting of
> pwq->triggered can't be further re-ordered with the reading of p->state.
> 
> Or any other reason ?

try_to_wake_up() is a full barrier.  Is it something guaranteed and
intentional or is it just something which just happened to be so?
Also, as the function is doing some dirty hackery to get to
try_to_wake_up(), I just wanted to make it clear.  I suppose it's time
to add more comments there then.

>> +	/* clear triggered for the next iteration */
>> +	pwq->triggered = 0;
> 
> And don't we (in theory) actually need the mb() here instead?
> 
> Let's suppose do_poll() starts the next iteration, so we are doing
> 
> 	pwq->triggered = 0;
> 
> 	->poll(file)
> 		if (!check_file(file))
> 			return 0;
> 
> 		return POLLXXX;
> 
> We don't have any barriers in between (unless fget_light bumps
> ->f_count), so this can be reordered as
> 
> 	->poll(file)
> 		if (!check_file(file))
> 			return 0;
> 
> 		pwq->triggered = 0;
> 
> And, if pollwake() happens in between we can miss the event, no?

Hmmmm... yes, from the second run, ->poll doesn't grab the waitqueue
lock, so it doesn't necessary have the required barriers.
Heh... set_mb() should be here not in pollwake().  Thanks for spotting
it.

-- 
tejun
