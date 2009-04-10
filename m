Return-Path: <linux-kernel-owner+w=401wt.eu-S938175AbZDJNfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938175AbZDJNfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764361AbZDJNfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:35:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:36354 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762743AbZDJNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SYV4MLW4sj0o+Q/bElftw9RdLpShGy9jXk6+U6UElHAj/9lm8JXiUT6rGMmIHFMNkL
         T6c8TvGY1/6PTa+87YPvAb9uyP5gwgEQLSLHJuCRktuT+N0yXMU4TthstQneIPCB9QlZ
         S3gseyjY0MRjxsAH6sSfV2V0MWQSbfDaS+eUc=
Date: Fri, 10 Apr 2009 15:34:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] lockdep: warn about lockdep disabling after kernel
	taint
Message-ID: <20090410133443.GC5988@nowhere>
References: <1239312460-13396-1-git-send-email-fweisbec@gmail.com> <20090410121243.GO21506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410121243.GO21506@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 02:12:43PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: provide useful missing info for developers
> > 
> > Kernel taint can occur in several situations such as warnings,
> > load of prorietary or staging modules, bad page, etc...
> > 
> > But when such taint happens, a developer might still be working on
> > the kernel, expecting that lockdep is still enabled. But a taint
> > disables lockdep without ever warning about it.
> > Such a kernel behaviour doesn't really help for kernel development.
> > 
> > This patch adds this missing warning.
> > 
> > Since the taint is done most of the time after the main message that
> > explain the real source issue, it seems safe to warn about it inside
> > add_taint() so that it appears at last, without hurting the main
> > information.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > diff --git a/kernel/panic.c b/kernel/panic.c
> > index 3fd8c5b..9e7420a 100644
> > --- a/kernel/panic.c
> > +++ b/kernel/panic.c
> > @@ -213,8 +213,14 @@ unsigned long get_taint(void)
> >  
> >  void add_taint(unsigned flag)
> >  {
> > -	/* can't trust the integrity of the kernel anymore: */
> > -	debug_locks = 0;
> > +	/*
> > +	 * Can't trust the integrity of the kernel anymore.
> > +	 * We don't call directly debug_locks_off() because the issue
> > +	 * is not necessarily serious enough to set oops_in_progress to 1
> > +	 */
> > +	if (xchg(&debug_locks, 0))
> > +		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
> > +
> 
> nice idea - but please use the proper debug_locks_off() construct 
> instead of an open-coded xchg(). Something like:
> 
> 	if (debug_locks_off())
> 		printk(...);
> 
> should do the trick.
> 
> 	Ingo


Yeah, I first wanted to do so but was shy about the oops_in_progress = 1
inside debug_locks_off(). Isn't it a problem?

Thanks,
Frederic.

