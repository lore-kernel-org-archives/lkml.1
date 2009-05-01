Return-Path: <linux-kernel-owner+w=401wt.eu-S1761893AbZEANmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761893AbZEANmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbZEANmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:42:39 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:61302 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761017AbZEANmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tO87cactzyP9kNTD2rB9ntx3XIUW+tpcjtlHVf0AUiIjArNwIq9I9vc4ofGBXYPpTi
         +XAwCIbVv5eRLbHlQjyzplMXQN3w4p5cZlN6KbVjFPUzXOyKgLjjSal/B9PE5nA8r+1E
         9wxnwBsjqR30uQH9g09nt0fzEF8gASnkhjkn4=
Date: Fri, 1 May 2009 15:42:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter atomic
Message-ID: <20090501134234.GG6011@nowhere>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501115047.GA24706@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:50:47PM +0200, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The entries counter in cpu buffer is not atomic. Although it only 
> > gets updated by a single CPU, interrupts may come in and update 
> > the counter too. This would cause missing entries to be added.
> 
> > -	unsigned long			entries;
> > +	atomic_t			entries;
> 
> Hm, that's not really good as atomics can be rather expensive and 
> this is the fastpath.
> 
> This is the upteenth time or so that the fact that we do not disable 
> irqs while generating trace entries bites us in one way or another. 
> IRQs can come in and confuse function trace output, etc. etc.
> 
> Please lets do what i suggested a long time ago: disable irqs _once_ 
> in any trace point and run atomically from that point on, and enable 
> them once, at the end.
> 
> The cost is very small and it turns into a win immediately by 
> elimination of a _single_ atomic instruction. (even on Nehalem they 
> cost 20 cycles. More on older CPUs.) We can drop the preempt-count 
> disable/enable as well and a lot of racy code as well. Please.
> 
> 	Ingo


I also suspect one other good effect on doing this.

As you know, between a lock_reserve and a discard, several interrupts
can trigger some traces. It means that if some rooms have already been
reserved, the discard will really create a discarded entry and we
can't reuse it.

For example in the case of filters with lock tracing, we rapidly run
into entries overriden, making the lock events tracing about useless
because we rapidly lose everything.

At least that's an effect I observed. I'm not sure the discard is the
real cause but it seems to make sense.

That's a pity because believe me it is very useful to hunt a softlockup.

Of course it doesn't prevent from NMI tempest, but we already have
protections for that.

Frederic.

