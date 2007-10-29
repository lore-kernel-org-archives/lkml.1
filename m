Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbXJ2Uqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbXJ2Uqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXJ2Uqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:46:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:22042 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXJ2Uqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=t8wkq76ZXtOws9hjQUPBqqWlr+7Df+gNnZus/EKXKCKksvo57vDXz/u+kxTOq/lAjvzfPgaYDLWoYgcY+g8cGusR3Ozke88RD5mPhR4NjgCoeWG3DNhowMDeYeQEeAg2qJWY/r1dyXgJfwuDBWzkmotXPj+dlmKdHORDkPemXMU=
Date: Mon, 29 Oct 2007 23:46:38 +0300
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: linux/interrupt.h doesn't need sched.h
Message-ID: <20071029204638.GC1822@martell.zuzino.mipt.ru>
References: <20071029134539.GB7810@ghostprotocols.net> <20071029181210.GA1822@martell.zuzino.mipt.ru> <20071029190845.GC7810@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029190845.GC7810@ghostprotocols.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 05:08:46PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Oct 29, 2007 at 09:12:10PM +0300, Alexey Dobriyan escreveu:
> > On Mon, Oct 29, 2007 at 11:45:39AM -0200, Arnaldo Carvalho de Melo wrote:
> > > --- a/include/linux/interrupt.h
> > > +++ b/include/linux/interrupt.h
> > > @@ -9,7 +9,6 @@
> > >  #include <linux/cpumask.h>
> > >  #include <linux/irqreturn.h>
> > >  #include <linux/hardirq.h>
> > > -#include <linux/sched.h>
> > >  #include <linux/irqflags.h>
> > >  #include <asm/atomic.h>
> > >  #include <asm/ptrace.h>
> > 
> > ACK the part that nothing needs sched.h, but it shouldn't change anything,
> > because of interrupt.h => hardirq.h => smp_lock.h => sched.h dependency.
> 
> Yeah, but one thing at a time, now its one link in the maze, before it
> was two :-)
>  
> > [puts patch on cross-compile farm anyway]
> > [starts finding scalpels]

Argh!

interrupt.h contains sti().
sti() on m68k wants hardirq_count().
hardirq_count() wants preempt_count();
preempt_count() wants current_thread_info()
current_thread_info() on m68k wants task_thread_info()
task_thread_info() on m68k is

	(&(tsk)->thread.info)

We're screwed, because adding sched.h to asm-m68k/thread_info.h leads to
even more horrible things.

Comments? Well, apart from "our header dependencies suck" and "let's add
CONFIG_M^*K to interrupt.h".
