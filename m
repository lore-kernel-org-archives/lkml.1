Return-Path: <linux-kernel-owner+w=401wt.eu-S1767271AbXDETvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767271AbXDETvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767276AbXDETvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:51:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50873 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767271AbXDETvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:51:22 -0400
Date: Thu, 5 Apr 2007 14:51:18 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: init's children list is long and slows reaping children.
Message-ID: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We have been testing a new larger configuration and we are seeing a very
large scan time of init's tsk->children list.  In the cases we are seeing,
there are numerous kernel processes created for each cpu (ie: events/0
... events/<big number>, xfslogd/0 ... xfslogd/<big number>).  These are
all on the list ahead of the processes we are currently trying to reap.

wait_task_zombie() is taking many seconds to get through the list.
For the case of a modprobe, stop_machine creates one thread per cpu
(remember big number). All are parented to init and their exit will
cause wait_task_zombie to scan multiple times most of the way through
this very long list looking for threads which need to be reaped.  As
a reference point, when we tried to mount the xfs root filesystem,
we ran out of pid space and had to recompile a kernel with a larger
default max pids.

For testing, Jack Steiner create the following patch.  All it does
is moves tasks which are transitioning to the zombie state from where
they are in the children list to the head of the list.  In this way,
they will be the first found and reaping does speed up.  We will still
do a full scan of the list once the rearranged tasks are all removed.
This does not seem to be a significant problem.

This does, however, modify the order of reaping of children.  Is there a
guarantee of the order for reaping children which needs to be preserved
or can this simple patch be used to speed up the reaping?  If this
simple patch is not acceptable, are there any preferred methods for
linking together the tasks that have been zombied so they can be reaped
more quickly?  Maybe add a zombie list_head to the task_struct and chain
them together in the children list order?

In comparison, without this patch, following modprobe on that particular
machine init is still reaping zombied tasks more than 30 seconds
following command completion.  With this patch, all the zombied tasks
are removed within the first couple seconds.

Any suggestions would be greatly appreciated.

Thanks,
Robin Holt

Patch against 2.6.16 SLES 10 kernel.

Index: linux-2.6.16/kernel/exit.c
===================================================================
--- linux-2.6.16.orig/kernel/exit.c	2007-03-28 21:56:20.601860403 -0500
+++ linux-2.6.16/kernel/exit.c	2007-03-28 22:01:12.233942431 -0500
@@ -710,6 +710,13 @@ static void exit_notify(struct task_stru
 	write_lock_irq(&tasklist_lock);
 
 	/*
+	 * Relink to head of parent's child list. This makes it easier to find.
+	 * On large systems, init has way too many children that never terminate.
+	 */
+	list_del_init(&tsk->sibling);
+	list_add(&tsk->sibling, &tsk->parent->children);
+
+	/*
 	 * This does two things:
 	 *
   	 * A.  Make init inherit all the child processes
