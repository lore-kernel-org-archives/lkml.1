Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYBRMA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYBRMA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757686AbYBRMAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:00:19 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41681 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbYBRMAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:00:18 -0500
Date: Mon, 18 Feb 2008 17:26:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
       vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 7/7] CGroup API: Update cpusets to use cgroup
	structured file API
Message-ID: <20080218115625.GA406@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andreas Schwab <schwab@suse.de>,
	Li Zefan <lizf@cn.fujitsu.com>,
	containers@lists.linux-foundation.org, vatsa@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
	akpm@linux-foundation.org, xemul@openvz.org
References: <20080215204418.535025000@menage.corp.google.com> <20080215204821.778088000@menage.corp.google.com> <20080216212901.70fe35ce.pj@sgi.com> <47B9560F.3030402@cn.fujitsu.com> <47B96805.7070002@linux.vnet.ibm.com> <20080218111333.GA6333@balbir.in.ibm.com> <jewsp24h3n.fsf@sykes.suse.de> <47B971C6.4080807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <47B971C6.4080807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2008-02-18 17:23:42]:

> Andreas Schwab wrote:
> > Balbir Singh <balbir@linux.vnet.ibm.com> writes:
> > 
> >> @@ -238,7 +238,7 @@ rmdir() if there are no tasks.
> >>  The type of memory accounted by the cgroup can be limited to just
> >>  mapped pages by writing "1" to memory.control_type field
> >>  
> >> -echo -n 1 > memory.control_type
> >> +echo > memory.control_type
> > 
> > Looks like you stripped too much here.
> > 
> > Andreas.
> > 
> 
Yikes,

The control type feature documentation needs to go away and Li has a patch for
it, so I'll not touch that part. Here's the updated patch. Thanks for catching
this Andreas.

The memory controller has a requirement that while writing values, we need
to use echo -n. This patch fixes the problem and makes the UI more consistent.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/controllers/memory.txt |    6 +++---
 kernel/res_counter.c                 |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-fix-crlf-echo-issue mm/memcontrol.c
diff -puN kernel/res_counter.c~memory-controller-fix-crlf-echo-issue kernel/res_counter.c
--- linux-2.6.25-rc2/kernel/res_counter.c~memory-controller-fix-crlf-echo-issue	2008-02-18 16:15:02.000000000 +0530
+++ linux-2.6.25-rc2-balbir/kernel/res_counter.c	2008-02-18 16:16:16.000000000 +0530
@@ -113,6 +113,7 @@ ssize_t res_counter_write(struct res_cou
 
 	ret = -EINVAL;
 
+	strstrip(buf);
 	if (write_strategy) {
 		if (write_strategy(buf, &tmp)) {
 			goto out_free;
diff -puN Documentation/controllers/memory.txt~memory-controller-fix-crlf-echo-issue Documentation/controllers/memory.txt
--- linux-2.6.25-rc2/Documentation/controllers/memory.txt~memory-controller-fix-crlf-echo-issue	2008-02-18 16:18:26.000000000 +0530
+++ linux-2.6.25-rc2-balbir/Documentation/controllers/memory.txt	2008-02-18 17:24:48.000000000 +0530
@@ -164,7 +164,7 @@ c. Enable CONFIG_CGROUP_MEM_CONT
 
 Since now we're in the 0 cgroup,
 We can alter the memory limit:
-# echo -n 4M > /cgroups/0/memory.limit_in_bytes
+# echo 4M > /cgroups/0/memory.limit_in_bytes
 
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes.
@@ -185,7 +185,7 @@ number of factors, such as rounding up t
 availability of memory on the system.  The user is required to re-read
 this file after a write to guarantee the value committed by the kernel.
 
-# echo -n 1 > memory.limit_in_bytes
+# echo 1 > memory.limit_in_bytes
 # cat memory.limit_in_bytes
 4096 Bytes
 
@@ -197,7 +197,7 @@ caches, RSS and Active pages/Inactive pa
 
 The memory.force_empty gives an interface to drop *all* charges by force.
 
-# echo -n 1 > memory.force_empty
+# echo 1 > memory.force_empty
 
 will drop all charges in cgroup. Currently, this is maintained for test.
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
