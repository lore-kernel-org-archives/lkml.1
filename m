Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZFDVBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZFDVBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZFDVBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:01:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbZFDVB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:01:29 -0400
Date: Thu, 4 Jun 2009 14:01:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: A bug in read operation for /dev/zero and a proposed fix.
In-Reply-To: <20090604135050.ceb6bf18.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0906041355560.4880@localhost.localdomain>
References: <alpine.DEB.1.00.0906041330170.32557@bumblebee1.mtv.corp.google.com> <20090604135050.ceb6bf18.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Andrew Morton wrote:
> > 
> > To fix this, I propose that when a fatal signal is pending during
> > /dev/zero read operation, we simply return and let the user process die.
> > Here is a patch that does that.
> > 
> > Signed-off-by: Salman Qazi <sqazi@google.com>
> > ---
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 8f05c38..2ffa36e 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -696,6 +696,11 @@ static ssize_t read_zero(struct file * file, char __user * buf,
> >   			break;
> >   		buf += chunk;
> >   		count -= chunk;
> > +		/* The exit code here doesn't actually matter, as userland
> > +		 * will never see it.
> > +		 */
> > +		if (fatal_signal_pending(current))
> > +			return -ENOMEM;
> >   		cond_resched();
> >   	}
> >   	return written ? written : -EFAULT;
> 
> OK.  I think.
> 
> It's presumptuous to return -ENOMEM: we don't _know_ that this signal
> came from the oom-killer.  It would be better to return -EINTR here.

I don't think the error matters in this case, since we literally only care 
about fatal signals, but I agree that EINTR is probably better.

That said, it would be even better to basically act as if it was a signal, 
and do something like

	return written ? written : -EINTR;

because that might allow us to simply make it _totally_ interruptible some 
day. There is nothing that says that /dev/zero shouldn't act like an 
interruptible file descriptor (like a pipe), and just return a partial 
read.

If we want to do this for 2.6.30, though, I very much agree with the 
notion of limiting it to just fatal signals, though.

			Linus
