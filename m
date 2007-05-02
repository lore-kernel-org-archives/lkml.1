Return-Path: <linux-kernel-owner+w=401wt.eu-S2992735AbXEBE51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992735AbXEBE51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992738AbXEBE51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:57:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:35148 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992735AbXEBE50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PbjH8TRQ4tTHcCyS8DBM6F8bIlP/t44aKEZ11bEjeUZA9VIufmVpbtdRn3AkIJmVvJ7kOTwyQrSeawhTHABsL5fIrj1nJ7gho8IykLo78smtuzTJXFlwiHkP/y+cTk+3xl+G3xU/6FoenmDGNnv48QCVJr8192rTIAI9rVVI9sI=
Message-ID: <a36005b50705012157p15eee224o5511e60c4a956bd@mail.gmail.com>
Date: Tue, 1 May 2007 21:57:25 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Ulrich Drepper" <drepper@gmail.com>,
       "Bill Irwin" <bill.irwin@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
In-Reply-To: <20070502043100.GI26093@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070404194829.1a93d8fd.dada1@cosmosbay.com>
	 <20070409165315.4704021f.akpm@linux-foundation.org>
	 <20070410004201.GA2986@holomorphy.com>
	 <20070501172937.GQ26598@holomorphy.com>
	 <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com>
	 <20070501202456.GR26598@holomorphy.com>
	 <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com>
	 <20070501222724.GG26093@thunk.org>
	 <a36005b50705011717g28023c58m431ec28413c1b613@mail.gmail.com>
	 <20070502043100.GI26093@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Theodore Tso <tytso@mit.edu> wrote:
> The question is should we use setrlimit() to set the per-thread CPU
> limit, given that we would need some separate interface to set signal
> that should be sent.
>
> Is there any reason why we should have the interface specify whether
> the signal should be directed to a specified process or kernel
> thread-id, perhaps using si_pid field in the siginfo_t to specify
> which thread had exceeded its CPU limit.  Or would this be overkill?

The more I think about it the more complex it gets.  There is a
problem with delivering the signal to the receiving process itself: it
is out of time and cannot perform the cleanup operation anymore.  You
could grant it a grace period but how long should that be?  Some of
the cleanup handlers might take a long time.  If you don't enforce the
CPU limit then it doesn't have to be in the kernel and you might as
well use CLOCK_THREAD_CPUTIME_ID and create a timer.  This should
already work today.  If not it must be fixed.

Delivering the timeout signal to another thread isn't really possible
either since the cleanup code might access thread-local data which
wouldn't work since it's not the canceled thread's data which is
accessed.

I don't have a good answer right now whether enforced CPU limits can
be implemented at all.  But it seems for your purposes a timer with
the CPU clock might be sufficient.


> Do you think this is something that we could get standardized into an
> upcoming Posix/Posix Threads standard?

Regardless of whether a solution can be found, it's too late for the
next revision.  The deadline for new features is long gone by.
