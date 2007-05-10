Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbXEJRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbXEJRzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbXEJRzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:55:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53196 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756222AbXEJRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:55:43 -0400
Date: Thu, 10 May 2007 10:55:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: linux-kernel@vger.kernel.org
Subject: VM statistics: Make timer deferrable
Message-ID: <Pine.LNX.4.64.0705101055060.9982@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

VM statistics updates do not matter if the kernel is in idle powersaving mode.
So allow the timer to be deferred.

It would be better though if we could switch the timer between deferrable
and nondeferrable based on differentials present. The timer would
start out nondeferrable and if we find that there were no updates in
the last statistics interval then we would switch the timer to deferrable.
If the timer later finds again that there are differentials then go to
nondeferrable again.

And yet another way would be to run the timer shortly before going to idle?

The solution here means that the VM counters may be slightly off during idle
since differentials may be still pending while the timer is deferred.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: slub/mm/vmstat.c
===================================================================
--- slub.orig/mm/vmstat.c	2007-05-10 10:09:19.000000000 -0700
+++ slub/mm/vmstat.c	2007-05-10 10:10:14.000000000 -0700
@@ -698,7 +698,7 @@ static void __devinit start_cpu_timer(in
 {
 	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
 
-	INIT_DELAYED_WORK(vmstat_work, vmstat_update);
+	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);
 	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
 }
 
