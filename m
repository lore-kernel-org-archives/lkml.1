Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935633Ab0COM3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:29:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57259 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab0COM3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:29:15 -0400
Date: Mon, 15 Mar 2010 08:29:08 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, andi@firstfloor.org,
       nhorman@tuxdriver.com
Subject: [PATCH 0/2] exec: refactor how call_usermodehelper works, and update
 the sense of the core_pipe recursion check (v4 rediff)
Message-ID: <20100315122908.GB16175@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, so I've rediffed and tested the user mode helper bits from my previous
patch set that got wrecked when the rcustring bits got pulled.  I've got he
origional summary below, and the patches follwoing.  Note, their just my
changes, rediffed to work without Andis patch set.  The other umh call sites can
still use plain old call_usermodehelper as they did previously.  I'll submit
patches as needed for other callers to make use of the init/cleanup functions as
I have the time/ability to test those changes properly.  The changes below I've
been able to test and verify myself.

Hey all-
        So, about 6 months ago, I made a set of changes to how the
core-dump-to-a-pipe feature in the kernel works.  We had reports of several
races, including some reports of apps bypassing our recursion check so that a
process that was forked as part of a core_pattern setup could infinitely crash
and refork until the system crashed.

        We fixes those by improving our recursion checks.  The new check
basically refuses to fork a process if its core limit is zero, which works well.

        Unfortunately, I've been getting grief from maintainer of user space
programs that are inserted as the forked process of core_pattern.  They contend
that in order for their programs (such as abrt and apport) to work, all the
running processes in a system must have their core limits set to a non-zero
value, to which I say 'yes'.  I did this by design, and think thats the right
way to do things.

        But I've been asked to ease this burden on user space enough times that
I thought I would take a look at it.  The first suggestion was to make the
recursion check fail on a non-zero 'special' number, like one.  That way the
core collector process could set its core size ulimit to 1, and enable the
kernel's recursion detection.  This isn't a bad idea on the surface, but I don't
like it since its opt-in, in that if a program like abrt or apport has a bug and
fails to set such a core limit, we're left with a recursively crashing system
again.

        So I've come up with this.  What I've done is modify the
call_usermodehelper api such that an extra parameter is added, a function
pointer which will be called by the user helper task, after it forks, but before
it exec's the required process.  This will give the caller the opportunity to
get a call back in the processes context, allowing it to do whatever it needs to
to the process in the kernel prior to exec-ing the user space code.  In the case
of do_coredump, this callback is ues to set the core ulimit of the helper
process to 1.  This elimnates the opt-in problem that I had above, as it allows
the ulimit for core sizes to be set to the value of 1, which is what the
recursion check looks for in do_coredump.

        This patch has been tested successfully by me.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
