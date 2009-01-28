Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZA1RB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZA1RB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZA1RBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:01:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZA1RBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:01:18 -0500
Subject: Re: Buggy IPI and MTRR code on low memory
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, jens.axboe@oracle.com
In-Reply-To: <alpine.DEB.1.10.0901281153080.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	 <1233161182.10992.52.camel@laptop>
	 <alpine.DEB.1.10.0901281153080.25359@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 18:00:49 +0100
Message-Id: <1233162049.10992.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 11:56 -0500, Steven Rostedt wrote:
> On Wed, 28 Jan 2009, Peter Zijlstra wrote:
> 
> > On Wed, 2009-01-28 at 11:38 -0500, Steven Rostedt wrote:
> > 
> > > The problem is that if we use the stack, then we must wait for the 
> > > function to finish. But in the mtrr code, the called functions are waiting 
> > > for the caller to do something after the smp_call_function. Thus we 
> > > deadlock!
> > 
> > You'd have to 'fix' the regular fallback paths to use your scheme as
> > well.
> 
> Not sure what you mean by that. I booted just fine with the patch, and 
> forcing data to NULL. Although, I'm not saying that these should not be 
> fixed.

Yeah, I was being confused by:

> @@ -230,6 +242,20 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>                         data = kmalloc(sizeof(*data), GFP_ATOMIC);
>                         if (data)
>                                 data->flags = CSD_FLAG_ALLOC;
> +                       else {
> +                               /*
> +                                * There exist callers that call
> +                                * functions that will wait on the caller
> +                                * to do something after calling this.
> +                                * This means we can not wait for the callee
> +                                * function to finish.
> +                                * Use the stack data but have the callee
> +                                * copy it and tell us we can continue
> +                                * before they call the function.
> +                                */
> +                               data = &d;
> +                               data->flags = CSD_FLAG_RELEASE;
> +                       }
>                 }
>                 if (!data) {
>                         data = &d;

that second !data test in there, thinking there was a fallback path
still relying on CSD_FLAG_WAIT.

It appears all is well indeed.

