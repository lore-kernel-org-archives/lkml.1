Return-Path: <linux-kernel-owner+w=401wt.eu-S1946147AbXEBAQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946147AbXEBAQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946149AbXEBAQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:16:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946147AbXEBAQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:16:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=RC8Zddi0cOFOynNhkAQe8800fHODuICK4BPflhmaKqr1d5/WWu3JWzsKpG6siQu1P
	mZC7u8cvMzdx4CNIoED6g==
Date: Tue, 1 May 2007 17:16:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@engr.sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch] cpusets: allow empty {cpus,mems}_allowed to be set for
 unpopulated cpuset
Message-ID: <Pine.LNX.4.64.0705011714490.6376@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You currently cannot remove all cpus or mems from cpus_allowed or
mems_allowed of a cpuset.  We now allow both if there are no attached
tasks.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/cpuset.c |   38 ++++++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -822,11 +822,22 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 		return -EACCES;
 
 	trialcs = *cs;
-	retval = cpulist_parse(buf, trialcs.cpus_allowed);
-	if (retval < 0)
-		return retval;
+
+	/*
+	 * We allow a cpuset's cpus_allowed to be empty; if it has attached
+	 * tasks, we'll catch it later when we validate the change and return
+	 * -ENOSPC.
+	 */
+	if (!*buf) {
+		cpus_clear(trialcs.cpus_allowed);
+	} else {
+		retval = cpulist_parse(buf, trialcs.cpus_allowed);
+		if (retval < 0)
+			return retval;
+	}
 	cpus_and(trialcs.cpus_allowed, trialcs.cpus_allowed, cpu_online_map);
-	if (cpus_empty(trialcs.cpus_allowed))
+	/* cpus_allowed cannot be empty for a cpuset with attached tasks. */
+	if (atomic_read(&cs->count) && cpus_empty(trialcs.cpus_allowed))
 		return -ENOSPC;
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
@@ -919,16 +930,27 @@ static int update_nodemask(struct cpuset *cs, char *buf)
 		return -EACCES;
 
 	trialcs = *cs;
-	retval = nodelist_parse(buf, trialcs.mems_allowed);
-	if (retval < 0)
-		goto done;
+
+	/*
+	 * We allow a cpuset's mems_allowed to be empty; if it has attached
+	 * tasks, we'll catch it later when we validate the change and return
+	 * -ENOSPC.
+	 */
+	if (!*buf) {
+		nodes_clear(trialcs.mems_allowed);
+	} else {
+		retval = nodelist_parse(buf, trialcs.mems_allowed);
+		if (retval < 0)
+			goto done;
+	}
 	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed, node_online_map);
 	oldmem = cs->mems_allowed;
 	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
-	if (nodes_empty(trialcs.mems_allowed)) {
+	/* mems_allowed cannot be empty for a cpuset with attached tasks. */
+	if (atomic_read(&cs->count) && nodes_empty(trialcs.mems_allowed)) {
 		retval = -ENOSPC;
 		goto done;
 	}
