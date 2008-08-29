Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYH2SGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYH2SGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 14:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbYH2SG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 14:06:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45171 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYH2SG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 14:06:27 -0400
Date: Fri, 29 Aug 2008 20:06:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Trond.Myklebust@netapp.com
Subject: [PATCH] Don't trigger softlockup detector on network fs blocked tasks
Message-ID: <20080829180623.GA22247@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't trigger softlockup detector on network fs blocked tasks

Pulling the ethernet cable on a 2.6.27-rc system with NFS mounts 
currently leads to an ongoing flood of soft lockup detector backtraces
for all tasks blocked on the NFS mounts when the hickup takes
longer than 120s.

I don't think NFS problems should be all that noisy.

Luckily there's a reasonably easy way to distingush this case.

Don't report task softlockup warnings for tasks in TASK_KILLABLE
state, which is used by the network file systems.

I believe this patch is a 2.6.27 candidate.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/kernel/softlockup.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/kernel/softlockup.c
+++ linux-2.6.27-rc4-misc/kernel/softlockup.c
@@ -180,6 +180,10 @@ static void check_hung_task(struct task_
 	if (t->flags & PF_FROZEN)
 		return;
 
+	/* Don't check for tasks waiting on network file systems like NFS */
+	if (t->state & TASK_KILLABLE)
+		return;
+
 	if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
 		t->last_switch_count = switch_count;
 		t->last_switch_timestamp = now;
