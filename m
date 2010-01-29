Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102Ab0A2PKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0A2PKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 10:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926Ab0A2PKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 10:10:37 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41599 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab0A2PKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 10:10:36 -0500
Date: Fri, 29 Jan 2010 10:10:24 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoskovc@redhat.com, mingo@redhat.com,
       drbd-dev@lists.linbit.com, benh@kernel.crashing.org,
       t.sailer@alumni.ethz.ch, abelay@mit.edu, gregkh@suse.de,
       spock@gentoo.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       mfasheh@suse.com, menage@google.com, shemminger@linux-foundation.org,
       takedakn@nttdata.co.jp, oleg@redhat.com
Subject: Re: [PATCH 0/2] exec: allow core_pipe recursion check to look for a
 value of 1 rather than 0 (v2)
Message-ID: <20100129151024.GA19249@hmsreliant.think-freely.org>
References: <20100121200806.GA29801@shamino.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100121200806.GA29801@shamino.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.0 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, version two of this patch.  I've cleaned up the comments, checkpatched,
rediffed to the latest -mm, etc.  More interestingly, I've taken Olegs changes
into account in this version of the patch.  By modifying Andi's work slightly,
I've introduced a new init fptr to the usermodehelper api, which lets a caller
customize the process that will be doing the helping.  In the case of the
do_coredump path its now used to create the read/write pipes.  This allows us to
remove the stdin specifics from the usermodehelper internals and factor our
call_usermodehelper_pipe entirely.  I've tested this myself using abrt on
Fedora, with good results

Summary:
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

	This patch has been tested successfully by some of the Abrt maintainers
in fedora, with good results.  Patch applies to the latest -mm tree as of this
AM.

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Neil Horman <nhorman@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: drbd-dev@lists.linbit.com
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Thomas Sailer <t.sailer@alumni.ethz.ch>
CC: Adam Belay <abelay@mit.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Michal Januszewski <spock@gentoo.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Neil Brown <neilb@suse.de>
CC: Mark Fasheh <mfasheh@suse.com>
CC: Paul Menage <menage@google.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Kentaro Takeda <takedakn@nttdata.co.jp>
CC: Oleg Nesterov <oleg@redhat.com
