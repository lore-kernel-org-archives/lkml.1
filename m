Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYKCLQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYKCLQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbYKCLQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:16:43 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52797 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbYKCLQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:16:42 -0500
Date: Mon, 3 Nov 2008 16:46:02 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric_Weisbecker_=3Cfweisbec=40gmail=2Ecom=3E?=@thinktux.in.ibm.com,
       linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Message-ID: <20081103111602.GA7515@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <490A08E3.2040201@gmail.com> <20081030182056.GA14102@elte.hu> <c62985530810301130q41cc5c0ete2d7610d2172775@mail.gmail.com> <20081030183714.GA17822@elte.hu> <alpine.DEB.1.10.0810301447490.15853@gandalf.stny.rr.com> <20081030192621.GF27407@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030192621.GF27407@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 08:26:21PM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > gcc -c -finstrument-functions traceme.c
> 
> > This is not 5 extra bytes but 27 extra bytes for a total of 32 bytes 
> > at every function. Also note that this also adds these calls to 
> > inline functions as well. We could easly stop that by adding 
> > "notrace" to the inline define (which I've done).
> > 
> > But this would make the patching a bit more difficult (not 
> > impossible). But it will bloat the image quite a bit.
> 
> yeah, i too knew it was expensive, but didnt realize it's this bloaty. 
> It's a non-starter really.
> 
> How reliable can we make Frederic's trampoline approach? Especially 
> with the opt-in function filters of dyn-ftrace, there's real value in 
> the trampoline approach IMO (we could display real function cost, 
> etc.), and the runtime cost should be OK as long we dont probe a ton 
> of functions all the time. (and it's optional anyway)

Something similar to Frederic's trampoline approach is what we use for
kretprobes. Recently, it's also acquired the capability to run handlers
at function entry. See samples/kprobes/kretprobe_example.c -- it
currently can print the time spent in any user-specified kernel routine.

Of course, this approach is not cheap... since it's kprobe based, we
have two exceptions -- but it is reliable. You are limited by the number
of slots available to record return addresses for each invocation,
especially if functions are reentrant, in the hotpath and can sleep.

There were other issues encountered during its implementation (some
of them 'cos we hash instances on the task) were with routines that are
entered/exited in different task contexts, noret type functions, etc.

Ananth
