Return-Path: <linux-kernel-owner+w=401wt.eu-S1032761AbXFIBes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032761AbXFIBes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 21:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968436AbXFIBel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 21:34:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39013 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968428AbXFIBek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 21:34:40 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       Paul Jackson <pj@sgi.com>, Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Jun 2007 18:34:37 -0700
Message-Id: <20070609013437.17278.52649.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 1/3] cpuset: zero malloc - fix for old cpusets
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

First of three -- this one goes before the container patches,
and should be sent to Linus for 2.6.22.

The cpuset code to present a list of tasks using a cpuset to
user space could write to an array that it had kmalloc'd,
after a kmalloc request of zero size.

The problem was that the code didn't check for writes past
the allocated end of the array until -after- the first write.

This is a race condition that is likely rare -- it would only
show up if a cpuset went from being empty to having a task
in it, during the brief time between the allocation and the
first write.

Prior to roughly 2.6.22 kernels, this was also a benign
problem, because a zero kmalloc returned a few usable bytes
anyway, and no harm was done with the bogus write.

With the 2.6.22 kernel changes to make issue a warning if
code tries to write to the location returned from a zero
size allocation, this problem is no longer benign.  This
cpuset code would occassionally trigger that warning.

The fix is trivial -- check before storing into the array,
not after, whether the array is big enough to hold the store.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Paul Jackson <pj@sgi.com>

---

Andrew - this fix collides with the container changes, and now
that you have sent Christoph's patch to Linus to warn on writes
to zero-sized allocations, this fix should go to Linus too.

So it comes in three parts: fix the old, undo that, fix the new.

This patch should be applied first, before the container patches,
and sent to Linus for 2.6.22.

 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.22-rc4-mm2.orig/kernel/cpuset.c	2007-06-08 14:44:58.899036450 -0700
+++ 2.6.22-rc4-mm2/kernel/cpuset.c	2007-06-08 14:47:00.996907442 -0700
@@ -1620,9 +1620,9 @@ static int pid_array_load(pid_t *pidarra
 
 	do_each_thread(g, p) {
 		if (p->cpuset == cs) {
-			pidarray[n++] = p->pid;
 			if (unlikely(n == npids))
 				goto array_full;
+			pidarray[n++] = p->pid;
 		}
 	} while_each_thread(g, p);
 

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
