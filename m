Return-Path: <linux-kernel-owner+w=401wt.eu-S1767766AbXDFP3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767766AbXDFP3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767767AbXDFP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:29:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44989 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767766AbXDFP3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:29:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFD] CPU hotplug and suspend
Date: Fri, 6 Apr 2007 17:32:31 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061732.32712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, we use the CPU hotplug to disable nonboot CPUs in the suspend code
paths, but with the recent change of code ordering (ie. nonboot CPUs are
disabled after freezing tasks _and_ devices) it has become quite troublesome.
The reason of this is that there are some CPU hotplug notifiers registered and
called on each run of cpu_up()/cpu_down() that assume the system to be fully
functional, which is not the case during the suspend.  Moreover, at least some
of them do things that are not really necessary for disabling or enabling the
nonboot CPUs.

For example, it doesn't seem to be necessary to stop worker threads bound to
the nonboot CPUs when they are disabled, because these CPUs most likely
reappear during the resume.  This particular problem has caused us to make all
workqueus nonfreezable, although at least some of them should be freezable, as
far as the suspend is concerned.

The advantage of using the CPU hotplug (in its current form) for suspending is
that if some CPUs don't reappear during the resume, we are safe.  Still, I
think it would be more appropriate, and simpler in the long run, to notify the
interested subsystems _only_ if one (or more) CPUs are not functional after the
resume.  In fact, with the current code ordering the subsystems don't even need
to know that we have disabled and enabled the nonboot CPUs, unless something
goes wrong.

For this reason, I'd like to change the suspend code to use a simplified CPU
management, sharing some low-level code with the current CPU hotplug, that
won't call all of the CPU hotplug notifiers at all, but will be able to call
some other special notifiers in case one (or more) of the nonboot CPUs cannot
be enabled.  Of course, that would require the subsystems to register separate
CPU notifiers for the resume, but I think they may share some code with the
current CPU hotplug notifiers.

It seems to me that we should separate the special case of suspend from the
"run-time" CPU hotplug, or things will get more and more complicated over time.
Still, that would be quite radical redesign, so I'm not sure if it's generally
acceptable.

Please advise.

Greetings,
Rafael
