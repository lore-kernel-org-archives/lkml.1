Return-Path: <linux-kernel-owner+w=401wt.eu-S1945976AbXEAWKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945976AbXEAWKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945986AbXEAWKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:10:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:58543 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945976AbXEAWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oBZ7Us6faAuJ1BcFphjAOpz66hYVmfU5mwNpeeIrp51kpQY3wRIBp1ERAqC9gEOFpJ6Z6/xcnGgXod0alHpjFSXWjEVm2/I4x4joCt6f7cTmW80WXoi5jGRUMd5HemzuBQC1niWcK3snKvVzenXDqpDgW4KB+Iod/coAVuopBaE=
Message-ID: <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com>
Date: Tue, 1 May 2007 15:10:40 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Bill Irwin" <bill.irwin@oracle.com>, "Ulrich Drepper" <drepper@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Cc: wli@holomorphy.com
In-Reply-To: <20070501202456.GR26598@holomorphy.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Bill Irwin <bill.irwin@oracle.com> wrote:
> The basic
> idea is to try to do it similarly to how everyone else does so userspace
> (I suppose this would include glibc) don't have to bend over backward to
> accommodate it. Or basically to do what everyone expects.

I think beside RUSAGE_THREAD you'll find no precedence.  It's all new,
you have to tread the path.  The RUSAGE_THREAD interface is not
sufficient, actually.  First, if a thread terminates we don't have to
keep it stick around until a wait call can be issued.  We terminate
threads right away and the synchronization with waiters is done
independently.  Seond, the thread ID (aka kernel process ID) is not
exported nor should it.  This is easy to solve, though: introduce a
pthread_getrusage interface.

To solve the first problem the terminating thread should write out the
data before it is gone.  Automatically.  After registration.  So, you
could have a syscall to register a structure in the user address space
which is filled with the data.  If the data structure is the same as
rusage you're done.  If you use a different data structure yo need to
introduce a getrusage-equivalent syscall.

With this infrastructure in place we could have

  int pthread_getrusage(pthread_t, struct ruage *);

and

  int pthread_join4(pthread_t, void ** valueptr, struct rusage *);

pthread_join4 is a joke, we need a better name, but you get the drift.
