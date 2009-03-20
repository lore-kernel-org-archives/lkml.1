Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbZCTFVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbZCTFVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 01:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZCTFVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 01:21:43 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:23822 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbZCTFVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 01:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=s63FaJOgy6oDJQikre1Xm6p4XUvhQNYF9mtljaC2pY7DmvRY2XCFroj4FiAlPj2hkL
         kyDXBm2RNoNw4c8CH3KOXuXqiUiLyD2A2bCK8UoglBTkTE3Mkj+Z/ojzxMlwX4iMl42w
         FGif7H0YG04yMSfLkoC1sBZ+D2kVECzQBtlJI=
Subject: Re: PROBLEM: relay - stale data copied to user space
From: Tom Zanussi <tzanussi@gmail.com>
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <1237485040.4752.16.camel@kitka.ibm.com>
References: <1237388848.4084.64.camel@kitka.ibm.com>
	 <1237436347.7834.13.camel@charm-linux>
	 <1237485040.4752.16.camel@kitka.ibm.com>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 00:21:28 -0500
Message-Id: <1237526488.7764.58.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-03-19 at 18:50 +0100, Martin Peschke wrote:
> On Wed, 2009-03-18 at 23:19 -0500, Tom Zanussi wrote:
> > On Wed, 2009-03-18 at 16:07 +0100, Martin Peschke wrote
> > > This is my theory:
> > > Timing matters. It's a race caused by improper protection of critical
> > > sections in a producer-consumer scenario. A bug in the bookkeeping
> > > allows a reader to read at a position that is just being written to.
> > > 
> > 
> > It does look consistent with a reader reading an event that's been
> > reserved but not yet written, or partially written e.g. if an event
> > being written on one cpu was read by another before the first one
> > finished.
> 
> So this is part of relay's design, and it's up to user space to make
> sure that reader and writer are on the same CPU?
> 

No, that wasn't originally part of relay's design, but for all practical
purposes that's what you need to do if you're using the read()
interface.

The original design was meant to be used with mmap() and poll() on
complete sub-buffers i.e. you grab complete sub-buffers from the mmaped
buffer only when poll() says they're ready.  If used this way, it
doesn't matter which cpu is doing the reading or writing.  relay still
works this way if you use mmap() as in e.g. the klog example.

The read() was added later, on top of something that wasn't designed
with it in mind, the main difference being that a read() can be done at
any time and it expects whatever's available to be returned, regardless
of whether it's reading from a complete sub-buffer or not (if you could
only read from complete sub-buffers, you might as well use the mmap()
method).

So if a reader can read from a sub-buffer at any time, and there can
simultaneously be a writer in that sub-buffer, if they're on different
cpus, you can get what you were seeing.  One way to prevent that is to
keep the reader on the same cpu, and disable preemption for the writer,
so when the reader on that cpu finally reads, it can be sure there are
no in-progress events up to the endpoint of what it's reading.

Hope that helps,

Tom

> > Can you see if the below patch to blktrace userspace helps?
> 
> It appears to fix it. I will give it more testing in a larger
> environment.
> 
> > Or failing that, explicitly using gettid() in place of getpid() in
> > sched_setaffinity().  Or, failing that, you had mentioned previously
> > that you would try to reproduce the problem on your laptop - were you
> > able to do that?  If so, it would help in debugging it further...
> 
> This didn't work out. But then, it's a single-CPU machine.
> 
> Thanks,
> Martin
> 
> 

