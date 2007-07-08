Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbXGHHTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbXGHHTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 03:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXGHHTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 03:19:46 -0400
Received: from ozlabs.org ([203.10.76.45]:35614 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbXGHHTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 03:19:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18064.36870.150985.222090@cargo.ozlabs.ibm.com>
Date: Sun, 8 Jul 2007 17:19:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <Pine.LNX.4.44L0.0707061111050.3737-100000@iolanthe.rowland.org>
References: <1183676393.3388.89.camel@localhost.localdomain>
	<Pine.LNX.4.44L0.0707061111050.3737-100000@iolanthe.rowland.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern writes:

> In answer to both questions: We need the freezer in order to implement 
> hibernate.  Even if we take your advice and stop using the freezer 
> during suspend, these issues would still remain and would need to be 
> solved.

Stepping back for a minute, let's think about what the freezer is
trying to achieve.  I think that currently there are three basic
design goals:

A. Ensure that device drivers don't get I/O requests after being
   suspended.

B. Ensure that driver suspend routines don't end up blocking forever
   on mutexes or semaphores held by frozen tasks.

C. Provide a way to get an atomic snapshot of memory for hibernation.

Now, it's easy enough to freeze all processes (or all except one), if
you don't have goal B.  Just offline non-boot cpus and disable
interrupts, or use stop_machine().  But goal B implies that you can't
necessarily just stop all tasks wherever they are.  In fact it means
there are points where it is safe to stop a given task, and there may
be points where it isn't safe to stop it - and there is no practical
way to determine those points reliably.[1]

That implies to me that we can have a freezer as long as we do nothing
that can sleep, while tasks are frozen.  In other words, I think the
freezer is a viable option for hibernation as long as we restrict
driver hibernate routines to doing only things which don't sleep.  I
_think_ that should be doable since hibernate routines only need to
wait for outstanding DMAs to complete, as I understand it, which can
be done by polling.

Paul.

[1] For a start, there's no way to determine which mutexes a task
holds.  Even if there were, we would then also have to know which
mutexes it is going to try to acquire before it releases the one we
want, which is pretty much unknowable.

One can say "we'll only freeze kernel tasks that ask to be frozen" but
then one has no way to guarantee A, and we still don't reliably
guarantee B if we have user-level filesystems or device drivers.
