Return-Path: <linux-kernel-owner+w=401wt.eu-S935044AbZLGK1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935044AbZLGK1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935004AbZLGK1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:27:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:37416 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934869AbZLGK1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:27:23 -0500
Message-ID: <4B1CD89F.9000802@kernel.org>
Date: Mon, 07 Dec 2009 19:27:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] sched: implement try_to_wake_up_local()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-8-git-send-email-tj@kernel.org>	 <1259923487.3977.1940.camel@laptop>  <4B1C75F3.9080808@kernel.org>	 <1260175804.8223.1217.camel@laptop> <1260176199.8223.1237.camel@laptop>
In-Reply-To: <1260176199.8223.1237.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/07/2009 05:56 PM, Peter Zijlstra wrote:
> OK, so you fork and wakeup a new thread when an existing one goes to
> sleep, but do you also limit the concurrency on wakeup?
>
> Otherwise we can end up with say 100 workqueue tasks running, simply
> because they all ran into a contended lock and then woke up again.

Yes, the total number of workers is limited.

> Where does that fork happen? Having to do memory allocations and all
> that while holding the rq->lock doesn't seem like a very good idea.

There always is guaranteed to be at least one idle worker and when the
last running worker goes to sleep, one idle worker is woken up which
assumes the role of manager which if necessary forks another worker,
so all that happens under rq->lock is waking up another worker.

> What happens when you run out of memory and the workqueue progress is
> needed to get free memory?

That's when the "rescuer" workers kick in.  All workqueues which might
be used during allocation paths are required to have one.  When
manager fails to fork a new worker, it summons the rescuers.  They
migrate to the distressed cpu and processes only the works from their
specific workqueues thus guaranteeing forward progress.

Thanks.

-- 
tejun
