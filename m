Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXJUMnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXJUMnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbXJUMmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:42:54 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49191 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXJUMmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:42:53 -0400
Date: Sun, 21 Oct 2007 16:47:44 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Message-ID: <20071021124744.GA174@tv-sign.ru>
References: <20071016103308.GA9907@in.ibm.com> <20071016103417.GA16570@in.ibm.com> <200710171047.42693.rusty@rustcorp.com.au> <20071017053754.GB9940@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017053754.GB9940@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Gautham R Shenoy wrote:
>
> On Wed, Oct 17, 2007 at 10:47:41AM +1000, Rusty Russell wrote:
> > 
> > 	I can't see where you re-initialize the completion.  
> 
> The cpu_hotplug.readers_done is a global variable which has been
> initialized in cpu_hotplug_init. 
> 
> So I am wondering is the re-initialization required ? 

I don't understand why should we re-initialize the completion too,
but see below.

> > > +static void cpu_hotplug_begin(void)
> > > +{
> > > +	mutex_lock(&cpu_hotplug.lock);
> > > +	cpu_hotplug.active_writer = current;
> > > +	while (cpu_hotplug.refcount) {
> > > +		mutex_unlock(&cpu_hotplug.lock);
> > > +		wait_for_completion(&cpu_hotplug.readers_done);
> > > +		mutex_lock(&cpu_hotplug.lock);
> > > +	}
> > 
> > AFAICT this will busy-wait on the second CPU hotplug.

Why?

> Well when the first cpu_hotplug comes out of wait_for_completion, it
> would have decremented the ->done count, so it's as good as new 
> for the second CPU hotplug, no?

No, because we decrement the ->done count only once, but there is no
guarantee that ->done == 1 when we get CPU after wakeup. Another reader
can do lock_cpu_hotplug/unlock_cpu_hotplug in between, so we have a race.

But I disagree with "Yet once a completion is completed, it needs to be
re-initialized to be reused: it's "complete" and wait_for_completion
will return immediately thereafter".

Rusty, could you please clarify?

Side note, we don't block the new readers while cpu_hotplug_begin() waits
for the completion. I don't think this is a problem, but perhaps it makes
sense to document the possible livelock.

Oleg.

