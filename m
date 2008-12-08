Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYLHCrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYLHCrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 21:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYLHCrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 21:47:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:63013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYLHCrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 21:47:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=Bn33Z40vB9IYEYMCVJziqpJ8PCP/6/Xw6vMO4R6ci4Hfa+EPtMi/SNkgsiRzjtjGG
	Q2yMXeYVXt53i6va/iGdg==
MIME-Version: 1.0
Date: Sun, 7 Dec 2008 18:47:37 -0800
Message-ID: <b040c32a0812071847x351c0315pb2cdb59150a59e79@mail.gmail.com>
Subject: [patch] sched: fix sd_parent_degenerate on non-numa smp machine
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addition of SD_SERIALIZE flag added to SD_NODE_INIT prevented top level
dummy numa sched_domain to be properly degenerated on non-numa smp machine.
The reason is that in sd_parent_degenerate(), it found that the child and
parent does not have comon sched_domain flags due to SD_SERIALIZE.  However,
for non-numa smp box, the top level is a dummy with a single sched_group.

Filter out SD_SERIALIZE if it is on non-numa machine to properly degenerate
top level node sched_domain.  this will cut back some of the sd domain walk
in the load balancer code.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index b7480fb..6beae36 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6814,6 +6814,8 @@ sd_parent_degenerate
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
 				SD_SHARE_PKG_RESOURCES);
+		if (nr_node_ids == 1)
+			pflags &= ~SD_SERIALIZE;
 	}
 	if (~cflags & pflags)
 		return 0;
