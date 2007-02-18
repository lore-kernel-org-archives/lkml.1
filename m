Return-Path: <linux-kernel-owner+w=401wt.eu-S1750698AbXBRLcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750698AbXBRLcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 06:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750695AbXBRLcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 06:32:09 -0500
Received: from mail.screens.ru ([213.234.233.54]:49825 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbXBRLcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 06:32:08 -0500
Date: Sun, 18 Feb 2007 14:31:24 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070218113124.GA100@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070217234201.GA591@tv-sign.ru> <20070217234728.GA679@tv-sign.ru> <200702181143.32538.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702181143.32538.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Rafael J. Wysocki wrote:
>
> On Sunday, 18 February 2007 00:47, Oleg Nesterov wrote:
> > 
> > However, this means that sys_vfork() makes impossible to freeze processes
> > until child exits/execs. Not good.
> 
> Yes, but this also is the current behavior.

Yes, yes, I see.

I forgot to say that we have another problem: coredumping.

A thread which does do_coredump() send SIGKILL to ->mm users, and sleeps
on ->mm->core_startup_done. Now it can't be frozen if sub-thread goes to
refrigerator. I think this could be solved easily if we add a check to
refrigerator() as you suggested for ->vfork_donw.

> I think the real solution would be to use an interruptible completion in the
> vfork code.  It was discussed some time ago and, IIRC, Ingo had an experimental
> patch that implemented it.  Still, for the suspend this really is not an issue
> in practice, so it wasn't merged.

It is not (afaics) so trivial to do rightly, and with this change the parent
will be seen as TASK_INTERRUPTIBLE even without freezer in progress.

A very vague idea: what if parent will do

	current->flags |= PF_PLEASE_CONSIDER_ME_AS_FROZEN_BUT_SET_TIF_FREEZE
	wait_for_completion(&vfork);
	try_to_freeze();

?

> It may be a good time to solve this problem now. :-)

Yes, I think so :)

Oleg.

