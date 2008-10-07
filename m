Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYJGPgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYJGPgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYJGPgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:36:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47907 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753035AbYJGPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:36:31 -0400
Date: Tue, 7 Oct 2008 11:36:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 2/9] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20081007114147.GB25627@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0810071122460.2591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, K.Prasad wrote:

> This patch introduces two new files named hw_breakpoint.[ch] inside x86 specific
> directories. They contain functions which help validate and serve requests for 
> using Hardware Breakpoint registers on x86 processors.

> --- /dev/null
> +++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/hw_breakpoint.c
> @@ -0,0 +1,684 @@

...
> +int pre_handler_allowed(unsigned type)
> +{
> +	if (type == HW_BREAKPOINT_EXECUTE)
> +		return 1;
> +	else
> +		return -EINVAL;
> +}

The routine's name should match the name in the header file.  "allowed" 
isn't right: You're _allowed_ to have pre_handlers -- they just won't 
get invoked.  "supported" would be better.

Also, the comment in the header file should explain the meaning of the
return value -- you should return 0 if a pre_handler is not supported, 
not -EINVAL.  Better yet, define the function (both here and in the 
header file) as returning bool rather than int.

> +
> +int post_handler_allowed(unsigned type)
> +{
> +	/* We can have a post handler for all types of breakpoints */
> +	return 1;
> +}

Same comments as above.

Also, in this initial version I would prefer to avoid the complications
of single-stepping.  It can always be added later.  So for now, the x86
implementation should not support post_handlers for execution
breakpoints.

...
> +/*
> + * Validate the arch-specific HW Breakpoint register settings
> + */
> +static int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
> +			unsigned long address, unsigned len, unsigned int type,
> +			unsigned int *align)

Why did you move this routine into the arch-specific code?

...
> +/*
> + * Handle debug exception notifications.
> + */
> +
> +static void switch_to_none_hw_breakpoint(void);
> +struct hw_breakpoint *last_hit_bp;
> +struct thread_hw_breakpoint *last_hit_thbi;

Shouldn't these variables be static?  Although if they're needed only for
single-stepping, they can be removed entirely for now...

