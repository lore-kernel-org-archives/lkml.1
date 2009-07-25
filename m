Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZGYChb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZGYChb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 22:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZGYCha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 22:37:30 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:48498 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZGYCh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 22:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bJh2C+wXKvV9m91cGrAMxn8yOZkdK8aIaYVisbTMIL1pZvtPufMvqwetaYtMHuxm6H
         K+44fS0LQ4hEM2ogOaCf05dDM5J5SNRGfJlkAngbypToePEUTcSS/Q8MEJkW2fU5Mo/2
         XNbEJp/zgsJBFvTj9vxcFubud57F9L8QBecN0=
Date: Sat, 25 Jul 2009 04:37:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/5] hw-breakpoints: Make kernel breakpoints API
	truly generic
Message-ID: <20090725023723.GB5100@nowhere>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-2-git-send-email-fweisbec@gmail.com> <20090720172748.GA27660@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720172748.GA27660@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 01:27:48PM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> [...]
> > diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> > index c1f64e6..015fec6 100644
> > --- a/kernel/hw_breakpoint.c
> > +++ b/kernel/hw_breakpoint.c
> > @@ -297,15 +297,21 @@ EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);
> >  /**
> >   * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
> >   * @bp: the breakpoint structure to register
> > - *
> > - * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
> > + * @addr: the address where we want to set the breakpoint
> > + * @len: length of the value in memory to break in
> > + * @type: the type of the breakpoint (read/write/execute)
> >   * @bp->triggered must be set properly before invocation
> 
> Hi Frederic,
> 
> I think one of the great addition in this patchset is to allow using
> breakpoints from arch-agnostic code.
> 
> It becomes important to document the error values which can be returned
> by register_kernel_hw_breakpoint, so this will serve as guidelines for
> architecture-specific arch_fill_hw_breakpoint() implementation. This
> will become increasingly important, as this abstraction layer will
> basically be responsible for either:
> 
> - Finding the best support the architecture can provide for a given hw
>   breakpoint.


Indeed, and that's the biggest problem it has to face because supported
hardware breakpoint features are very differents from one architecture
to another.


> - Failing with an explicit error value telling the in-kernel user why it
>   failed (e.g. if it must use a fallback, or return the error to the
>   user).


Yeah, nice point, I'll send another iteration which better documents the error
return values, at least once I get a mostly agreed core implementation :-)


> Maybe we should think of a more flexible breakpoint type mapping too,
> e.g.:
> 
>  monitor _strictly_ execute operation on address 0x...
>    -> would fail if the architecture does not support execution access
>       monitoring
>  monitor (at least) execute operations on address 0x...
>    -> would be allowed to use a more general monitor (e.g. RWX) if the
>       architecture does not support "execute only" monitor.
> 
> (same for read and write)
> 
> Mathieu


Well, I'm not sure the problem mostly resides in the hardware implementation
of strict exec breakpoint types. But I guess your point is not limiting to
that. Yeah for example, x86 doesn't support read-only breakpoints.
But I guess that can be simulated using software artifacts, for example using
READ-WRITE breakpoints + the x86 decoder API, recently submitted by Masami,
to find the nature of the current instruction.

Anyway, your point is indeed important: return common error values for unsupported
breakpoint operations.

Thanks.

> 
> >   *
> >   */
> > -int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > +int register_kernel_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
> > +				  int len, enum breakpoint_type type)
> >  {
> >  	int rc;
> >  
> > +	rc = arch_fill_hw_breakpoint(bp, addr, len, type);
> > +	if (rc)
> > +		return rc;
> > +
> >  	rc = arch_validate_hwbkpt_settings(bp, NULL);
> >  	if (rc)
> >  		return rc;
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

