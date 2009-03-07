Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZCGVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZCGVxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZCGVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 16:53:12 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:63054 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZCGVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 16:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xi4yPoyZBHx4G0NGbu7/sRLCi1q7+WVm2/g+IR2TcHPubL654D01f9sqvr+rTBJsQd
         y3MgY8Mnw2g3xIog9DcZWQBgG/BAx/9epDCamDbdSW96UXN8NB2jzuPd40ehPsvSZAHe
         FDUN0Q32oBxbflCMBuMtXq1Qr46CcRlrQ7pC0=
Date: Sat, 7 Mar 2009 22:53:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 0/2] Syscalls tracing
Message-ID: <20090307215303.GB5869@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <y0mbpsdqdti.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mbpsdqdti.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 03:26:49PM -0500, Frank Ch. Eigler wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > Here is a first attempt, quick one-shot, to provide a syscall tracing
> > infrastructure on ftrace.
> 
> Please see also the utrace-based thread syscall/signal/lifecycle.
> tracer I posted a few times, and is just about to be reposted as a
> part of the larger utrace submission.


Yes I've looked at it and as I will explain below, I don't have
any bad feelings against utrace.

 
> System call metadata (name, argument count, and getting fancier from
> there) would be nice to have for other clients too, such as the audit
> subsystem.
> 
> The main drawback of this general approach however is the notion that
> ftrace is the solitary user of system call tracing, thus dedicating
> that new task flag to this purpose.  Therefore, your code has nothing
> like reference counting or sharing; nothing yet to avoid overhead on
> threads that need no tracing, nor to allow more than one tracing
> widget to consume events.  These are the sorts of services that utrace
> provides.
> 
> - FChE


Yes. But it was a first attempt scribbled in one day. I already knew
that a fair amount of bits coming along these patches started on the wrong
way. But that doesn't matter, I just wanted to test the feelings of anyone
interested about the main axis inside:

- having a O(1) access table which stores the number of parameters for each
  syscalls, so that the traced path can be very fast and efficient:
  we know what to save quickly and we only save the relevant bits from
  the path, that said, 1 syscall number (which behaves here as a unique
  identifier key) and its parameters values.

- provide a good way to extract the results. It needs a better and larger work
  on the syscalls metadata. Ie: the string mask is a bit ridiculous, as well as
  the individual callback to display a syscall (because it implies too much work
  and code that can be a lot factorized) but I expect that a discussion about a
  good to produce efficient metadata could born after it.

For example we could have an array of char where the types are encoding using
an enum which describes the types of the parameters.
Depending of these parameters, we can have one callback for each type to display
them. We can also export these metadatas to userspace so that the users are able
to only extract the binary traces and format and give some sense by formatting it
later using the metadas.


Anyway, since this is a first scribbling, there is neither reference count nor
per task tracing granularity :-)

But, that's said, I already expressed my feelings about utrace by the past.
It's a good library, seems easy to use and powerful and I would like to see
it merged.

I don't know what other people think about it. But IMHO, I think it would be good
if you could, for now, make an attempt to sort the only relevant bits to provide
syscalls tracing and submit it.

It would exclude a large part that concerns the signals/fork/exec tracing
which will probably be needed later.

