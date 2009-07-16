Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZGPK4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZGPK4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZGPKyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:54:43 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58110 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbZGPKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:39 -0400
Message-Id: <20090716104817.589309391@samba.org>
References: <20090716104247.536695580@samba.org>
User-Agent: quilt/0.46-1
Date: Thu, 16 Jul 2009 20:42:50 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/5] perf_counter: Log vfork as a fork event
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we don't output vfork events. Even though we should always see an
exec after a vfork, we may get perfcounter samples between the vfork and exec.
These samples can lead to some confusion when parsing perfcounter data.

To keep things consistent we should always log a fork event. It will result
in a little more log data, but is less confusing to trace parsing tools.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

It took me a while to realise this wasn't a bug in some trace parsing
code I wrote, or an issue with samples being dropped :)

Index: linux.trees.git/kernel/fork.c
===================================================================
--- linux.trees.git.orig/kernel/fork.c	2009-07-15 10:00:30.000000000 +1000
+++ linux.trees.git/kernel/fork.c	2009-07-15 10:01:28.000000000 +1000
@@ -1407,14 +1407,11 @@
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
-		} else if (!(clone_flags & CLONE_VM)) {
-			/*
-			 * vfork will do an exec which will call
-			 * set_task_comm()
-			 */
-			perf_counter_fork(p);
 		}
 
+		if (!(clone_flags & CLONE_THREAD))
+			perf_counter_fork(p);
+
 		audit_finish_fork(p);
 		tracehook_report_clone(regs, clone_flags, nr, p);
 

-- 

