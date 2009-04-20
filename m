Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZDTVCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZDTVCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZDTVB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:01:58 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39898 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZDTVB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FQ26DVnhkb4VVuE/yR3hfke+fFhwuZJ830i7jhlMd5h5NYUe4X97yrFf+y95yEaj6H
         gj29TiZ9ybnHm+PliJLzEOfRMLWMYWYxSIKTq++oDLVAiUqW0vWlilgqbnYh6S0i9NSW
         CkhAIdmnNNMmugorYW4M1DzzbQTUjKlmXfdG8=
Date: Mon, 20 Apr 2009 23:01:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
Message-ID: <20090420210152.GF5974@nowhere>
References: <20090420173819.957332585@goodmis.org> <20090420175533.GA22449@elte.hu> <20090420192803.GA25629@elte.hu> <20090420194542.GB5974@nowhere> <alpine.DEB.2.00.0904201616430.10097@gandalf.stny.rr.com> <20090420203347.GD5974@nowhere> <alpine.DEB.2.00.0904201641570.10097@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904201641570.10097@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 04:44:46PM -0400, Steven Rostedt wrote:
> 
> On Mon, 20 Apr 2009, Frederic Weisbecker wrote:
> > > > 
> > > 
> > > Hmm, doesn't the trace wakeup test if the runqueue lock is locked or not?
> > > 
> > > -- Steve
> > > 
> > 
> > 
> > Hmm, yes it does but that's not the first time we meet this problem
> > (sched switch event tracing recursions by the past). So either the
> > test doesn't work well or this is about another lock that
> > wake_up_common takes...
> 
> Ug, it is the task's rq lock. Not the current rq lock. wakeup takes the 
> runqueue lock of the task. The "runqueue_is_locked" only tests the lock of 
> current CPU, which is not what we can have.


You mean the lock held on the wait_queue for wake_up_trace() ?

void __wake_up(wait_queue_head_t *q, unsigned int mode,
			int nr_exclusive, void *key)
{
	unsigned long flags;

	spin_lock_irqsave(&q->lock, flags);
	__wake_up_common(q, mode, nr_exclusive, 0, key);
	spin_unlock_irqrestore(&q->lock, flags);
}


> 
> Thus, the function tracer (gag, and probably the event tracing!) should 
> not call wakeups.


No problem for the events, I made them using the nowake commit because
of sched switch recursions :-)
That's why the nop tracer is now a "polling on traces" tracer.


> -- Steve
> 

