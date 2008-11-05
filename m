Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYKEQsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYKEQsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYKEQry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:47:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50801 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYKEQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:47:54 -0500
Date: Wed, 5 Nov 2008 11:47:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: bug: ftrace & lockdep badness
In-Reply-To: <20081105163052.GA28884@elte.hu>
Message-ID: <alpine.DEB.1.10.0811051143420.11900@gandalf.stny.rr.com>
References: <20081105123714.GA23504@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811051054430.11900@gandalf.stny.rr.com> <20081105163052.GA28884@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 5 Nov 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This is the type of problems we deal with when we have the tracer 
> > tracing lockdep code at the same time the lockdep code is checking 
> > the tracer.
> 
> ok ... you are right, i guess we need to go back to raw locks after 
> all?

I do like the fact that lockdep checks it too. But there's times that we 
can not do that.

Perhaps we can do something in between.

Make a rb_spin_lock macro inside ring_buffer.c that can be either a 
spin_lock or a raw_spin_lock.  There are some tracers that must have this 
as a raw (function trace, irqsoff and preemptoff), but the rest should be 
fine. We can make it where the rb_spin_lock is a raw lock when any of 
those three tracers are configured, and make it into a normal lock when 
they are not.

This way we can still test the integrity of the ring_buffer for other 
tracers. We just need to be careful when we are using function tracing or 
irqs/preempt off tracing. But we need to be careful with those anyway.

-- Steve

