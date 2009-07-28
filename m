Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZG1QgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZG1QgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZG1QgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:36:01 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43038 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbZG1Qf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:35:58 -0400
Date: Tue, 28 Jul 2009 09:38:35 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, roland@redhat.com,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Disable CLONE_PARENT for init
Message-ID: <20090728163835.GA16040@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Disable CLONE_PARENT for init.

When global or container-init processes use CLONE_PARENT, they create a
multi-rooted process tree. Besides siblings of global init remain as
zombies on exit since they are not reaped by their parent (swapper). So
prevent global and container-inits from creating siblings.

Changelog[v3]:
	- [Roland, Oleg] Simplify comment describing the change
Changelog[v2]:
	- Simplify patch description based on comments from Eric Biederman
	  and Oleg Nesterov.
	- [Oleg Nesterov] Use SIGNAL_UNKILLABLE instead of is_global_init()

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Roland McGrath <roland@redhat.com>
---
 kernel/fork.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-mmotm/kernel/fork.c
===================================================================
--- linux-mmotm.orig/kernel/fork.c	2009-07-16 10:03:01.000000000 -0700
+++ linux-mmotm/kernel/fork.c	2009-07-16 11:36:28.000000000 -0700
@@ -992,6 +992,16 @@
 	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Siblings of global init remain as zombies on exit since they are
+	 * not reaped by their parent (swapper). To solve this and to avoid
+	 * multi-rooted process trees, prevent global and container-inits
+	 * from creating siblings.
+	 */
+	if ((clone_flags & CLONE_PARENT) &&
+				current->signal->flags & SIGNAL_UNKILLABLE)
+		return ERR_PTR(-EINVAL);
+
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;
