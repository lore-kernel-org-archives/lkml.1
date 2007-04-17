Return-Path: <linux-kernel-owner+w=401wt.eu-S1031120AbXDQSrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031120AbXDQSrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031064AbXDQSrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:47:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031132AbXDQSrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:47:06 -0400
Message-ID: <462515CC.1080107@redhat.com>
Date: Tue, 17 Apr 2007 14:45:32 -0400
From: Larry Woodman <lwoodman@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4.2) Gecko/20040301
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysctl_panic_on_oom broken
Content-Type: multipart/mixed;
 boundary="------------020906020100070305020709"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020906020100070305020709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

out_of_memory() does not panic when sysctl_panic_on_oom is set
if constrained_alloc() does not return CONSTRAINT_NONE.  Instead,
out_of_memory() kills the current process whenever constrained_alloc()
returns either CONSTRAINT_MEMORY_POLICY or CONSTRAINT_CPUSET.
This patch fixes this problem:

Signed-off-by: Larry Woodman <lwoodman@redhat.com>




--------------020906020100070305020709
Content-Type: text/plain;
 name="panic_on_oom.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="panic_on_oom.patch"

--- linux-2.6.18.noarch/mm/oom_kill.c.orig
+++ linux-2.6.18.noarch/mm/oom_kill.c
@@ -431,6 +437,9 @@ void out_of_memory(struct zonelist *zone
 	cpuset_lock();
 	read_lock(&tasklist_lock);
 
+	/* check if we are going to panic before enything else... */
+	if (sysctl_panic_on_oom)
+		panic("out of memory. panic_on_oom is selected\n");
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
@@ -447,8 +456,6 @@ void out_of_memory(struct zonelist *zone
 		break;
 
 	case CONSTRAINT_NONE:
-		if (sysctl_panic_on_oom)
-			panic("out of memory. panic_on_oom is selected\n");
 retry:
 		/*
 		 * Rambo mode: Shoot down a process and hope it solves whatever

--------------020906020100070305020709--

