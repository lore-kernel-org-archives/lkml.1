Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264Ab0AUKxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0AUKxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253Ab0AUKxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:53:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:11954 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab0AUKxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:53:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IlKEW1sJm+iwvMbV9npnb3uHtR1kx8TA4cmQVoZvI5PGVCBY17vYyO9GDNgk79q20N
         dYSHtdDr9Y4PV0OvNOOKimuKzOg37UIiXzDAG696KuZwAvBOcsK3DuL2l96+VvRd4yOL
         apY58knOC6xTfYFEzSFH2QWWaRxa9tJ3MXJuA=
Date: Thu, 21 Jan 2010 11:53:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
Message-ID: <20100121105311.GB5017@nowhere>
References: <1263932978.31321.53.camel@gandalf.stny.rr.com> <Pine.LNX.4.64.1001192155490.28583@ask.diku.dk> <1263935333.4561.26.camel@frodo> <Pine.LNX.4.64.1001211145480.13529@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001211145480.13529@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:47:41AM +0100, Julia Lawall wrote:
> What about something like the following (drivers/macintosh/adb.c):
> 
>         add_wait_queue(&state->wait_queue, &wait);
>         current->state = TASK_INTERRUPTIBLE;
> 
> 	for (;;) {
> 	        req = state->completed;
>                 if (req != NULL)
>                         state->completed = req->next;
>                 else if (atomic_read(&state->n_pending) == 0)
>                         ret = -EIO;
> 		if (req != NULL || ret != 0)
> 			break;
> 
>                 if (file->f_flags & O_NONBLOCK) {
>                         ret = -EAGAIN;
>                         break;
> 		}
>                 if (signal_pending(current)) {
>                         ret = -ERESTARTSYS;
>                         break;
>                 }
>                 spin_unlock_irqrestore(&state->lock, flags);
>                 schedule();
>         	spin_lock_irqsave(&state->lock, flags);
>         }
> 
>         current->state = TASK_RUNNING;
>         remove_wait_queue(&state->wait_queue, &wait);
> 
> There is a call to schedule eventually after the first current->state 
> assignment, but it is not right after.



Looks fine as spin_unlock includes a memory barrier, IIRC.

