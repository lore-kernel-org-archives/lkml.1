Return-Path: <linux-kernel-owner+w=401wt.eu-S933324AbYDPQok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbYDPQok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765006AbYDPQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:44:18 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38590 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163AbYDPQoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:44:18 -0400
Date: Wed, 16 Apr 2008 11:44:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 3/3] ipc: sysvsem: refuse clone(CLONE_SYSVSEM|CLONE_NEWIPC)
Message-ID: <20080416164410.GB24563@sergelap.austin.ibm.com>
References: <20080416164232.GB22748@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416164232.GB22748@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLONE_NEWIPC|CLONE_SYSVSEM interaction isn't handled properly.  This can
cause a kernel memory corruption. CLONE_NEWIPC must detach from the existing
undo lists.
Fix, part 3: refuse clone(CLONE_SYSVSEM|CLONE_NEWIPC).

With unshare, specifying CLONE_SYSVSEM means unshare the sysvsem.  So
it seems reasonable that CLONE_NEWIPC without CLONE_SYSVSEM would just
imply CLONE_SYSVSEM.

However with clone, specifying CLONE_SYSVSEM means *share* the sysvsem.
So calling clone(CLONE_SYSVSEM|CLONE_NEWIPC) is explicitly asking for
something we can't allow.  So return -EINVAL in that case.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/nsproxy.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f5d332c..468ade3 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -139,6 +139,18 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 		goto out;
 	}
 
+	/*
+	 * CLONE_NEWIPC must detach from the undolist: after switching
+	 * to a new ipc namespace, the semaphore arrays from the old
+	 * namespace are unreachable.  In clone parlance, CLONE_SYSVSEM
+	 * means share undolist with parent, so we must forbid using
+	 * it along with CLONE_NEWIPC.
+	 */
+	if ((flags&CLONE_NEWIPC) && (flags&CLONE_SYSVSEM)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	new_ns = create_new_namespaces(flags, tsk, tsk->fs);
 	if (IS_ERR(new_ns)) {
 		err = PTR_ERR(new_ns);
-- 
1.5.1.1.GIT

