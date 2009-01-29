Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZA2BnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZA2BnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZA2BnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:43:01 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1955 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZA2BnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:43:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:in-reply-to:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=ExdaASpNX1TUJWV0kp4ac1eJbcP2REgTI/GxDK9rDrZI0Vx9bTluETfBUz/C2zfsP
	wm68WQnYf4/fabMmhyb0A==
Date: Wed, 28 Jan 2009 17:42:45 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] softlockup: remove hung_task_check_count
Message-ID: <20090129014245.GM22298@google.com>
References: <1232991701.4863.222.camel@laptop> <20090127003055.GA21269@google.com> <20090127132626.GH23121@elte.hu> <20090127184851.GD22298@google.com> <1233131100.10992.43.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1233131100.10992.43.camel@laptop>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.24.198.101
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2009-01-27 at 10:48 -0800, Mandeep Singh Baines wrote:
> > Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Mandeep Singh Baines <msb@google.com> wrote:
> > > 
> > > > The design was proposed by Frédéric Weisbecker. Peter Zijlstra suggested 
> > > > the use of RCU.
> > > 
> > > ok, this looks _much_ cleaner.
> > > 
> > > One question:
> > > 
> > > > -	read_lock(&tasklist_lock);
> > > > +	rcu_read_lock();
> > > >  	do_each_thread(g, t) {
> > > > -		if (!--max_count)
> > > > +		if (need_resched())
> > > >  			goto unlock;
> > > 
> > > Isnt it dangerous to skip a check just because we got marked for 
> > > reschedule? Since it runs so rarely it could by accident be preempted and 
> > > we'd not get any checking done for a long time.
> > > 
> > 
> > Yeah, the checking could be deferred indefinitely. So you could have a system
> > where tasks are hung but it takes a really long time to detect this and
> > finally panic the system. Not so good for high-availability.
> 
> Why break out at all? Are you that worried about khungtaskd introducing
> latencies?

Yes, I was worried about disabling preemption for an unbounded amount of
time.

> Is using preemptible RCU an option for you?
> 

I had not even considered that. To be honest, I had not even heard of it
till now. So I spent another morning at LWN grokking preemptible RCU;)

I think it can work. I'm a little worried about the OOM risk. It could take
a really long time to iterate over the task list. A lot of pending kfree()s
could build up in that time.

I'm still unclear as to whether khungtaskd would get priority boosted
or not. Are only tasks that explicitly block (by sleeping on a lock)
boostable or would a task which got pre-empted inside the critical section
also be boostable? My worry here is khungtaskd would run at high priority for
an indefinite amount of time making it more overhead. Is there an OOMing-soon
booster?

But I think this can all be mitigated by adding back the max_count sysctl.
But preemptible RCU would allow increasing the default to a much higher
value or we may even be able to make the default "check all tasks".

Running out of time today but I'll send out a patch tomorrow.

Thanks Peter!

Regards,
Mandeep
