Return-Path: <linux-kernel-owner+w=401wt.eu-S1763145AbZE1Ow4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763145AbZE1Ow4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762649AbZE1Owo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:52:44 -0400
Received: from www.tglx.de ([62.245.132.106]:46964 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762626AbZE1Owo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:52:44 -0400
Date: Thu, 28 May 2009 16:52:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: annotate emit_log_char() notrace
In-Reply-To: <20090528141648.GA6018@nowhere>
Message-ID: <alpine.LFD.2.00.0905281646380.3397@localhost.localdomain>
References: <alpine.LFD.2.00.0905271657340.3397@localhost.localdomain> <20090528141648.GA6018@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Frederic Weisbecker wrote:
> On Wed, May 27, 2009 at 05:00:44PM +0200, Thomas Gleixner wrote:
> > printk calls emit_log_char() in a loop which is cluttering the trace
> > buffer. Make it notrace.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> 
> 
> Does it produce that much annoying traces?
> I mean, printk() are usually rare events.
> 
> Do you have a particular debugging workflow that makes this
> function invasive in the trace?
> 
> May be it's because you are debugging using ftrace and other
> debugging options that use a lot of printk()
> In such case, it would indeed be good to apply this patch.

I noticed when I chased a boot up problem, half of the trace was full
of

   0.540550: emit_log_char <-vprintk
   0.540550: emit_log_char <-vprintk
   ...

though there is another annoyance in the same code path:

   0.540557: vgacon_set_cursor_size <-vgacon_cursor
   0.540558: __rcu_read_lock <-__atomic_notifier_call_chain
   0.540558: __rcu_read_unlock <-__atomic_notifier_call_chain
   0.540558: __rcu_read_lock <-__atomic_notifier_call_chain
   ...

It's actually the same number of times as we have emit_log_char()
there. __atomic_notifier_call_chain() itself is marked notrace but the
rcu calls inside are not. :(

IIRC the same happens with a serial console, but that can be worse as
you busy wait during the character output.

It'd be nice if we could inherit the notrace from the caller :)

Thanks,

	tglx
