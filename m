Return-Path: <linux-kernel-owner+w=401wt.eu-S1946152AbXEBARc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946152AbXEBARc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946159AbXEBARc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:17:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:9332 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946152AbXEBARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i6t1wWBx7JS/fPuPXkv2tA0RjTVWhb9F0Hi1STjXqHAOzpuAKCz2WrLcDePhV4XmNgH0UmSuWp+NuMaCXBd/41PvRkP75cEUkA9RRvWWDfJtczOo9HLUpjk8HSjOCubFS5jGGkS+4Fq3Ce5LV+tufhddh6WX03IZmaXP0zZqgfM=
Message-ID: <a36005b50705011717g28023c58m431ec28413c1b613@mail.gmail.com>
Date: Tue, 1 May 2007 17:17:28 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Ulrich Drepper" <drepper@gmail.com>,
       "Bill Irwin" <bill.irwin@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
In-Reply-To: <20070501222724.GG26093@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070404172931.GM2986@holomorphy.com>
	 <20070404194829.1a93d8fd.dada1@cosmosbay.com>
	 <20070404181050.GN2986@holomorphy.com>
	 <20070409165315.4704021f.akpm@linux-foundation.org>
	 <20070410004201.GA2986@holomorphy.com>
	 <20070501172937.GQ26598@holomorphy.com>
	 <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com>
	 <20070501202456.GR26598@holomorphy.com>
	 <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com>
	 <20070501222724.GG26093@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Theodore Tso <tytso@mit.edu> wrote:
>         There are two ways of implementing this.  One is to have the
> JVM periodically poll using a pthread_getrusage() interface.

Not a good idea.

>  A better
> choice might be some kind of per-thread CPU limit, that would result
> in a thread-specific SIGXCPU signal.  But there are no interfaces
> today that do anything like this.

We have, in principal: setrlimit.  We jump through hoops in the moment
to make RLIMIT_CPU a per-process facility.  This is all nice.  All you
need to do is to add resources RLIMIT_*_THREAD (e.g.,
RLIMIT_CPU_THREAD) and additionally do accounting in a per-thread
basis.

The only issue which has to be decided is what is the action when the
limit is exceeded.  An unanswered signal kills the process, not just
the thread.  And you cannot just terminate a thread in the kernel
since there might be userlevel cleanup to do.  The thread library can
also not simply hijack the SIGXCPU signal, the application want to use
it.  The thread cancellation must appear like any other cancellation,
perhaps with a special status value (PTHREAD_CANCELED_XCPU instead of
PTHREAD_CANCEL).  But that's a userlevel detail.

So what would be additionally needed is a method to specify what
signal to sent.  The default might just as well be SIGXCPU but this
must be changable.
