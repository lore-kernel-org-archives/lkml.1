Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbXEUGx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbXEUGx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXEUGxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:53:51 -0400
Received: from mx10.go2.pl ([193.17.41.74]:38932 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754357AbXEUGxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:53:50 -0400
Date: Mon, 21 May 2007 09:00:36 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070521070036.GA1695@ff.dom.local>
References: <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515220024.GA615@tv-sign.ru> <464AEA47.7030600@gmail.com> <20070516185203.GB81@tv-sign.ru> <20070518073517.GB1573@ff.dom.local> <464DAB3D.4020000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464DAB3D.4020000@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 03:33:49PM +0200, Tejun Heo wrote:
...
> I wasn't really aiming for performance optimization.  I agree that we
> have to live with barriers but it's also true that they and other
> synchronization constructs can be difficult to understand and thus to
> verify, so IMHO, when it comes to synchronization constructs, it's best
> stick to or make things look similar to more established ways, so that
> people can categorize the usage and understand it more easily.

Sorry, I'm not convinced by this...

If we want to stick to more understanable, established ways,
why don't we use a global lock (not per cpu but per work or
per workqueue) for insert_work(), which would be really the
simplest construct here. Probably because some compromise is
needed. On the other hand many locks could be replaced with
elaborate constructs with atomic operations like this. But
for some reasons this usually isn't done.

IMHO it's better to get used to barriers, because, as seen
in this thread, even after finding better solution, the
problem of execution ordering didn't disappear. Another
"strange" question is: if these barriers are so tough, why
Oleg managed to do them seemingly right from the very first
time? But even if he would do some error here, I think it
should be easier to check for this one problem only, than to
risk the "stability" of the whole algorithm by changing more.
Of course now, after the time was spent anyway, this new
"old-way" is more attractive.

> 
> Locked enter/leave model, where each cpu has its own lock and whatever
> entity enters and leaves a cpu while holding the respective per-cpu
> lock, guarantees that while holding a per-cpu lock, no one enters or
> leaves the cpu.  It's conceptually simple and basically the semantic
> that we're all trying to achieve here.

I prefer simplicity over perfomance too. But there is a
question of price... These modern things like RCU or barriers
are unavoidable, and probably we should get used to think the
ALPHA is right and 'normal' here - not x86 (by limiting
compilers and programmers with making the most of all those
new caches).

> 
> I think things can be made more similar to the locked enter/leave model
> using the extra bit by putting manipulation and testing of the bit into
> accesor functions, so readability was my primary concern not
> performance.  But, then again, we can probably make the barrier() model
> readable enough too with proper accessor functions and plenty of
> comments above them.

Yes, the good thing is Oleg can choose between two good
solutions here! (I don't envy him...)

Thanks for your response, sorry for my delay &
Best regards,
Jarek P.
