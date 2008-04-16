Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbYDPQn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbYDPQn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759692AbYDPQno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:43:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38205 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbYDPQnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:43:43 -0400
Date: Wed, 16 Apr 2008 11:43:38 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 2/3] ipc: sysvsem: force unshare(CLONE_SYSVSEM) when
	CLONE_NEWIPC
Message-ID: <20080416164338.GA24563@sergelap.austin.ibm.com>
References: <20080416164232.GB22748@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416164232.GB22748@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
cause a kernel memory corruption. CLONE_NEWIPC must detach from the existing
undo lists.
Fix, part 2: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC.
CLONE_NEWIPC creates a new IPC namespace, the task cannot access the
existing semaphore arrays after the unshare syscall. Thus the task
can/must detach from the existing undo list entries, too.

This fixes the kernel corruption, because it makes it impossible that
undo records from two different namespaces are in sysvsem.undo_list.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/fork.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 56fa5ae..4c28232 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1705,7 +1705,12 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
 				CLONE_NEWNET))
 		goto bad_unshare_out;
 
-	if (unshare_flags & CLONE_SYSVSEM)
+	/*
+	 * CLONE_NEWIPC must also detach from the undolist: after switching
+	 * to a new ipc namespace, the semaphore arrays from the old
+	 * namespace are unreachable.
+	 */
+	if (unshare_flags & (CLONE_NEWIPC|CLONE_SYSVSEM))
 		do_sysvsem = 1;
 	if ((err = unshare_thread(unshare_flags)))
 		goto bad_unshare_out;
-- 
1.5.1.1.GIT

