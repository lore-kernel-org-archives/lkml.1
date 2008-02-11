Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYBKBSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYBKBSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 20:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYBKBSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 20:18:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40497 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYBKBSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 20:18:01 -0500
Date: Mon, 11 Feb 2008 02:53:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: kgdb in git-x86#mm review
Message-ID: <20080211015321.GA27376@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I sent Jan & Jason earlier a quick review of the kgdb code currently in git-x86#mm.

The kgdb code in git-x86#mm is right now is totally broken of course because the CFI
annotations in assembler code are gone now, but they are needed for gdb use. 
And the bogus fault handling code is still in there, but Jason apprently fixed that one.

Here are the other commments I wrote just in case someone is interested.
Overall I would say there is quite a lot of stuff to clean up still.

<snip>

ok, doing a review on the code in git-x86#mm. I have not read
everything in detail, just a quick skip over.

My personal test for clean kernel debugger integration is if the
debugger could be made a loadable (but not unloadable) module with
minor/no effort. How far away is your code from that?

The 32bit in_exception_stack code looks weird. Are you sure you cannot
just use the pt_regs passed to the die notifier?

It might be safer to explicitely disable interrupts early in the notifier.

You should probably use simple_strtoul() instead of inventing an
own hex parser in kgdb.c. And sprintf instead of an own hex writer.
In general more use sprintf would probably shorten a lot of the parser
code.

The num_online_cpu()s check in getthread() looks weird. What is that
supposed to do?

kgdb_softlock_notify: I think the right way to handle this is just
calling touch_softlockup_watchdog() (or perhaps better touch_nmi_watchdog)
Actually it should be only needed once when you exit the debugger
for soft lockup, but regularly for nmi watchdog.

On x86 it is ok, but on other architectures i'm suspect the SMP
synchronization with atomics might benefit from more memory barriers.

gdb_cmd_reboot: always calling emergency_sync looks dangerous.
In fact i suspect if you hold the other CPUs the changes are good
it will lock up. You should at least offer a option to not call that
(or better don't do it by default). Even machine_start is likely
lock up actually if the other CPUs are truly halted (as they should
be) because it will try to halt them. So if anything I suspect you
need to exit the debugger first before executing this.

The logic to halt all the other CPUs in kgdb_handle_exception et.al.
looks a little fragile. It would be probably best to use the same
as kcrash uses factored out into a common function.
One obvious problem is that it is racy against cpu hotplug, but there
are likely others too. With a better implementation you likely
wouldn't need the mdelay(2) hack further down.

You should use raw spinlocks everywhere in the debugger -- i don't
think you want lockdep etc. anywhere.

The unregister hook stuff looks racy against NMIs etc.

-Andi



