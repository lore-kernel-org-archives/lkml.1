Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZA0StT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZA0StT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZA0StH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:49:07 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43451 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZA0StG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:49:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:in-reply-to:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=ayV9xVrUXPDOyOLMYdwZzvTRLAAbVd1wT/O2huvepPqirm9Mu9gSK0L8wVih0Sw4i
	DoK1IA9MvjcAfgvVXSbMA==
Date: Tue, 27 Jan 2009 10:48:51 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] softlockup: remove hung_task_check_count
Message-ID: <20090127184851.GD22298@google.com>
References: <1232991701.4863.222.camel@laptop> <20090127003055.GA21269@google.com> <20090127132626.GH23121@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090127132626.GH23121@elte.hu>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.28.16.75
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mandeep Singh Baines <msb@google.com> wrote:
> 
> > The design was proposed by Frédéric Weisbecker. Peter Zijlstra suggested 
> > the use of RCU.
> 
> ok, this looks _much_ cleaner.
> 
> One question:
> 
> > -	read_lock(&tasklist_lock);
> > +	rcu_read_lock();
> >  	do_each_thread(g, t) {
> > -		if (!--max_count)
> > +		if (need_resched())
> >  			goto unlock;
> 
> Isnt it dangerous to skip a check just because we got marked for 
> reschedule? Since it runs so rarely it could by accident be preempted and 
> we'd not get any checking done for a long time.
> 

Yeah, the checking could be deferred indefinitely. So you could have a system
where tasks are hung but it takes a really long time to detect this and
finally panic the system. Not so good for high-availability.

What if a check_count sysctl was added? But instead of being a max_check_count,
it would be a min_check_count. This would guarantee that a minimum amount of
checking is done.

Alternatively, the code for trying to continue the iteration after a
reschedule could be re-inserted. That code is a little tricky and
potentially fragile since continuation of a tasklist iteration is not
really supported by the sched.h APIs. But it is does have the nice properties
of getting through the entire list almost all the time and still playing nice
with the scheduler.

Regards,
Mandeep
