Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXLLVSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXLLVSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbXLLVSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:18:47 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49871 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbXLLVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:18:47 -0500
Date: Wed, 12 Dec 2007 15:18:35 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, minslinux-mm@kvack.org
Cc: Andrew Morgan <morgan@kernel.org>
Subject: [RFC] [PATCH -mm] oom_kill: remove uid==0 checks
Message-ID: <20071212211835.GA24943@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a5fd2d7c75168076dc6b4b94ea8cda529fc506b1 Mon Sep 17 00:00:00 2001
From: serue@us.ibm.com <serue@us.ibm.com>
Date: Wed, 5 Dec 2007 14:07:40 -0800
Subject: [RFC] [PATCH -mm] oom_kill: remove uid==0 checks

Root processes are considered more important when out of memory
and killing proceses.  The check for CAP_SYS_ADMIN was augmented
with a check for uid==0 or euid==0.

There are several possible ways to look at this:

	1. uid comparisons are unnecessary, trust CAP_SYS_ADMIN
	   alone.  However CAP_SYS_RESOURCE is the one that really
	   means "give me extra resources" so allow for that as
	   well.
	2. Any privileged code should be protected, but uid is not
	   an indication of privilege.  So we should check whether
	   any capabilities are raised.
	3. uid==0 makes processes on the host as well as in containers
	   more important, so we should keep the existing checks.
	4. uid==0 makes processes only on the host more important,
	   even without any capabilities.  So we should be keeping
	   the (uid==0||euid==0) check but only when
	   userns==&init_user_ns.

I'm following number 1 here.

Andrew, I've cc:d you here bc in doing this patch I noticed that your
64-bit capabilities patch switched this code from an explicit check
of cap_t(p->cap_effective) to using __capable().  That means that
now being glossed over by the oom killer means PF_SUPERPRIV will
be set.  Is that intentional?

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 016127e..9fd8d5d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -128,7 +128,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime,
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (__capable(p, CAP_SYS_ADMIN) || p->uid == 0 || p->euid == 0)
+	if (__capable(p, CAP_SYS_ADMIN) || __capable(p, CAP_SYS_RESOURCE))
 		points /= 4;
 
 	/*
-- 
1.5.1

