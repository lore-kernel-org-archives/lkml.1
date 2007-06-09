Return-Path: <linux-kernel-owner+w=401wt.eu-S1032458AbXFIBf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032458AbXFIBf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 21:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032788AbXFIBex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 21:34:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39035 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1032782AbXFIBew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 21:34:52 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Paul Menage <menage@google.com>, Kirill Korotaev <dev@openvz.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Paul Jackson <pj@sgi.com>,
       Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Jun 2007 18:34:50 -0700
Message-Id: <20070609013450.17278.29072.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20070609013437.17278.52649.sendpatchset@jackhammer.engr.sgi.com>
References: <20070609013437.17278.52649.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 3/3] cpuset: zero malloc - fix for new containers
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Third of three -- This applies after the container patches,
fixing a problem that earlier patches also fixed in the older
cpuset code.

The container code to present a list of tasks using a container
to user space could write to an array that it had kmalloc'd,
after a kmalloc request of zero size.

The problem was that the code didn't check for writes past the
allocated end of the array until -after- the first write.

This is a race condition that is likely rare -- it would only show
up if a container went from being empty to having a task in it,
during the brief time between the allocation and the first write.

Prior to roughly 2.6.22 kernels, this was also a benign problem,
because a zero kmalloc returned a few usable bytes anyway,
and no harm was done with the bogus write.

With the 2.6.22 kernel changes to make issue a warning if
code tries to write to the location returned from a zero size
allocation, this problem is no longer benign.  This container code
would occassionally trigger that warning.

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

Andrew - this is the third of three similar patches.  This one
redoes the fix for the container code.

Please apply somewhere after:
  containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch

 kernel/container.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.22-rc4-mm2.orig/kernel/container.c	2007-06-08 15:36:14.997835546 -0700
+++ 2.6.22-rc4-mm2/kernel/container.c	2007-06-08 15:37:09.606655972 -0700
@@ -1451,9 +1451,9 @@ static int pid_array_load(pid_t *pidarra
 	struct task_struct *tsk;
 	container_iter_start(cont, &it);
 	while ((tsk = container_iter_next(cont, &it))) {
-		pidarray[n++] = pid_nr(task_pid(tsk));
 		if (unlikely(n == npids))
 			break;
+		pidarray[n++] = pid_nr(task_pid(tsk));
 	}
 	container_iter_end(cont, &it);
 	return n;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
