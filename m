Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYEWNoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYEWNoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYEWNoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:18 -0400
Received: from gw.goop.org ([64.81.55.164]:53223 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbYEWNoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:16 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 12] xen: add save/restore/migrate for Xen domains
Message-Id: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:07 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series adds save/restore/migrate for Xen domains.  This is almost
entirely contained within the Xen-specific code.

The only exception is the WARN_ON I remove in hres_timers_resume,
which is spurious in the case of a Xen suspend/resume, since we don't
offline all the CPUs.

This also adds another user of the freezer, since it turns out to
solve a somewhat tricky problem.  The problem is that Xen pagetables
are expressed in terms of machine frame numbers - ie, the page numbers
of the underlying host machine.  When the domain is saved, all the
mfns everywhere are canonicalized into guest-relative pfns in the save
image.  The tricky part is that when preemption is enabled, it's
possible the suspend will preempt a pagetable manipulation, which will
leave a machine frame number sitting in a register or on the stack
which will not be canonicalized.

The freezer solves this because it makes sure that every thread is
quiesced at a well known point, which is not during a pagetable
update.  So by freezing everything and then stopping all the
processors in stop_machine, we can make sure the system is in a
saveable state.

The freezer is only required when preemption is enabled, since
stop_machine will quiesce all processors (and therefore threads) at
suitable points anyway.

     J

