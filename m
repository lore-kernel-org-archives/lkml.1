Return-Path: <linux-kernel-owner+w=401wt.eu-S1767820AbXDFQCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767820AbXDFQCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767822AbXDFQCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:02:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55333 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767820AbXDFQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:02:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFD] CPU hotplug and suspend
References: <200704061732.32712.rjw@sisk.pl>
Date: Fri, 06 Apr 2007 09:56:50 -0600
In-Reply-To: <200704061732.32712.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 6 Apr 2007 17:32:31 +0200")
Message-ID: <m1hcrt8pj1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Hi,
>
> Currently, we use the CPU hotplug to disable nonboot CPUs in the suspend code
> paths, but with the recent change of code ordering (ie. nonboot CPUs are
> disabled after freezing tasks _and_ devices) it has become quite troublesome.
> The reason of this is that there are some CPU hotplug notifiers registered and
> called on each run of cpu_up()/cpu_down() that assume the system to be fully
> functional, which is not the case during the suspend.  Moreover, at least some
> of them do things that are not really necessary for disabling or enabling the
> nonboot CPUs.
>
> For example, it doesn't seem to be necessary to stop worker threads bound to
> the nonboot CPUs when they are disabled, because these CPUs most likely
> reappear during the resume.  This particular problem has caused us to make all
> workqueus nonfreezable, although at least some of them should be freezable, as
> far as the suspend is concerned.
>
> The advantage of using the CPU hotplug (in its current form) for suspending is
> that if some CPUs don't reappear during the resume, we are safe.  Still, I
> think it would be more appropriate, and simpler in the long run, to notify the
> interested subsystems _only_ if one (or more) CPUs are not functional after the
> resume.  In fact, with the current code ordering the subsystems don't even need
> to know that we have disabled and enabled the nonboot CPUs, unless something
> goes wrong.
>
> For this reason, I'd like to change the suspend code to use a simplified CPU
> management, sharing some low-level code with the current CPU hotplug, that
> won't call all of the CPU hotplug notifiers at all, but will be able to call
> some other special notifiers in case one (or more) of the nonboot CPUs cannot
> be enabled.  Of course, that would require the subsystems to register separate
> CPU notifiers for the resume, but I think they may share some code with the
> current CPU hotplug notifiers.
>
> It seems to me that we should separate the special case of suspend from the
> "run-time" CPU hotplug, or things will get more and more complicated over time.
> Still, that would be quite radical redesign, so I'm not sure if it's generally
> acceptable.

My two cents.

cpu hotplug up/down semantics with respect to irqs do not appear to be
implementable in a race free way on x86, with the current generation
of hardware.

The suspend/resume semantics for disabling irqs seem perfect
reasonable. (We tell the drivers to shut off the irqs before we even
consider migrating or turning them off).

We already have suspend/resume callbacks for everything else, why
not some of the core subsystems.

Because of the global disable nature of suspend/resume I suspect it is
actually easier to implement a suspend/resume callback.

If we are only talking core subsystems here there is much less of
problem for duplicating functions then if this was at the driver level
because core subsystems everyone uses, so there are more eyse on the
code.

cpu hotplug is still CONFIG_EXPERIMENTAL suspend/resume is not.

Eric
