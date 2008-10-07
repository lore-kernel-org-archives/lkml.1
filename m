Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYJGRXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYJGRXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYJGRXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:23:11 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:42923 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753390AbYJGRXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:23:09 -0400
Date: Tue, 7 Oct 2008 22:53:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 2/9] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20081007172301.GC4130@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081007114147.GB25627@in.ibm.com> <Pine.LNX.4.44L0.0810071122460.2591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0810071122460.2591-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 11:36:30AM -0400, Alan Stern wrote:
> On Tue, 7 Oct 2008, K.Prasad wrote:
> 
> > This patch introduces two new files named hw_breakpoint.[ch] inside x86 specific
> > directories. They contain functions which help validate and serve requests for 
> > using Hardware Breakpoint registers on x86 processors.
> 
> > --- /dev/null
> > +++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/hw_breakpoint.c
> > @@ -0,0 +1,684 @@
> 
> ...
> > +int pre_handler_allowed(unsigned type)
> > +{
> > +	if (type == HW_BREAKPOINT_EXECUTE)
> > +		return 1;
> > +	else
> > +		return -EINVAL;
> > +}
> 
> The routine's name should match the name in the header file.  "allowed" 
> isn't right: You're _allowed_ to have pre_handlers -- they just won't 
> get invoked.  "supported" would be better.

pre_handler_supported() definitely sounds better. I will change them.

> 
> Also, the comment in the header file should explain the meaning of the
> return value -- you should return 0 if a pre_handler is not supported, 
> not -EINVAL.  Better yet, define the function (both here and in the 
> header file) as returning bool rather than int.
>

I will change them to boolean.
 
> > +
> > +int post_handler_allowed(unsigned type)
> > +{
> > +	/* We can have a post handler for all types of breakpoints */
> > +	return 1;
> > +}
> 
> Same comments as above.
> 
> Also, in this initial version I would prefer to avoid the complications
> of single-stepping.  It can always be added later.  So for now, the x86
> implementation should not support post_handlers for execution
> breakpoints.
> 

There's been a perceivable inclination to let the user learn the
limitations/features of the underlying processor's breakpointing ability
(since the previous email mail thread on this topic) and the routines
pre_ and post_handler_allowed() are just a step towards that.

I can nullify the post_handler for x86-instruction breakpoint for now,
but it wouldn't simplify things very extensively (but for a few lines of
code in hw_breakpoint_handler() and the flag 'sstep_reason'). It also
benefits the code by bringing an understanding that there can be
multiple users of processor single-stepping (and therefore the need to
de-multiplex the exception and invoke the appropriate handler).

Left to me, I would like to retain the post_handler routine, unless you
strongly feel otherwise.

> ...
> > +/*
> > + * Validate the arch-specific HW Breakpoint register settings
> > + */
> > +static int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
> > +			unsigned long address, unsigned len, unsigned int type,
> > +			unsigned int *align)
> 
> Why did you move this routine into the arch-specific code?
> 
> ...
> > +/*
> > + * Handle debug exception notifications.
> > + */
> > +
> > +static void switch_to_none_hw_breakpoint(void);
> > +struct hw_breakpoint *last_hit_bp;
> > +struct thread_hw_breakpoint *last_hit_thbi;
> 
> Shouldn't these variables be static?  Although if they're needed only for
> single-stepping, they can be removed entirely for now...
> 
Agreed. Will make them static.

Thanks,
K.Prasad

