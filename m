Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbXBRQJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbXBRQJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbXBRQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:09:41 -0500
Received: from mail.screens.ru ([213.234.233.54]:33889 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbXBRQJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:09:40 -0500
Date: Sun, 18 Feb 2007 19:11:51 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070218161151.GA143@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070218113124.GA100@tv-sign.ru> <200702181314.29214.rjw@sisk.pl> <200702181609.47334.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702181609.47334.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Rafael J. Wysocki wrote:
>
> > On Sunday, 18 February 2007 12:31, Oleg Nesterov wrote:
> > > 
> > > A very vague idea: what if parent will do
> > > 
> > > 	current->flags |= PF_PLEASE_CONSIDER_ME_AS_FROZEN_BUT_SET_TIF_FREEZE
> > > 	wait_for_completion(&vfork);
> > > 	try_to_freeze();
> > > 
> > > ?
> 
> Hm, what about the following patch instead?
> 
> The problem is that if the child enters the refrigeratior, we can't freeze the
> parent, because it's uninterruptible, but the child knows the parent will be
> uninterruptible until it exits, so the child can mark the parent as frozen.
> 
> --- linux-2.6.20-mm2.orig/kernel/power/process.c	2007-02-18 15:43:30.000000000 +0100
> +++ linux-2.6.20-mm2/kernel/power/process.c	2007-02-18 16:09:53.000000000 +0100
> @@ -39,6 +39,13 @@ void refrigerator(void)
>  	/* Hmm, should we be allowed to suspend when there are realtime
>  	   processes around? */
>  	long save;
> +
> +	/* The parent is uninterruptible and will stay so until this task exits,
> +	 * so we can mark it as frozen.
> +	 */
> +	if (current->vfork_done)
> +		frozen_process(current->parent);

This is not safe. task->flags is not atomic, we can change ->flags only
if we know the task won't touch it itself (ptrace, thaw_process).
The parent could be interrupted, irq may play with current->flags (slab,
for example).

Please note that ->parent may do things like ptrace_notify() before
it actually sleeps on ->vfork_done. This means that even if we could
set PF_FROZEN in a safe manner, this doesn't look like a good idea.

> +
> +	if (current->vfork_done && frozen(current->parent))
> +		current->parent->flags &= ~PF_FROZEN;
>  }

Why? If the code above works, we shouldn't take care about frozen
->parent?

Oleg.

