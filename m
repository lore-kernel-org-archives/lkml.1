Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZJVMGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZJVMGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZJVMGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:06:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:58561 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbZJVMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mvbmBaAW0yhasbiIaeLmQdYsljbvNmp2SBt4xztUf5OVof/HRpf4L+tQVOVtSYPQOo
         lr2bU8vDrsWzega4MWKOjTMx22ngJyMIepMl03wHmZ6l2iebPdivmfyTeSrXNmsQffrA
         VFa5+t+PqrueRfuu1CPyyd0xlxkyIh2Y2n+j0=
Date: Thu, 22 Oct 2009 14:06:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Can current macro be accessed from interrupt context?
Message-ID: <20091022120613.GB4928@nowhere>
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com> <20091022112746.GA4928@nowhere> <f22d86810910220443u49cdfabg83ef836406cfb36d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22d86810910220443u49cdfabg83ef836406cfb36d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 04:43:38AM -0700, Leonidas . wrote:
> > Yep.
> > For example we do that in the function graph tracer. Because we store return
> > addresses of functions in the "current" task structure. Even if the task
> > is interrupted, it still makes sense to use current because we want
> > to know the flow of execution as a linear thing per cpu, the interrupt
> > is part of that flow
> >
> > I hope that helps.
> >
> 
> Can you give pointers to the source code of this project?


Yep, it's in kernel/trace/trace_functions_graph.c (with a little
part in arch/*/kernel/ftrace.c and arch/*/kernel/entry*.S)
and also parts in kernel/trace/ftrace.c

We do that from the former file in ftrace_push_return_trace()
and ftrace_pop_return_trace()

We deref current from whatever context, this part of the code doesn't care
about interrupt or process context, and this code can be called from
every contexts, since it is tracing 99% of the kernel function calls.

We do care about the context in which the trace has been taken while displaying
these traces to the user, later, just to inform the user, but this is already 
post-processing at this stage, even though it's done from the kernel.


Anyway, the point is that it's safe to deref current from an irq handler.

But whether it makes sense to do that. It depends on what you want to do.

