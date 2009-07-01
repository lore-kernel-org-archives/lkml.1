Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZGAHfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZGAHfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZGAHfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:35:32 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57775 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZGAHfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:35:31 -0400
Date: Wed, 1 Jul 2009 00:31:41 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>, roland@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Cc: serue@us.ibm.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Disable CLONE_PARENT for init
Message-ID: <20090701073140.GA14284@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Disable CLONE_PARENT for init

When global or container-init processes use CLONE_PARENT, they create a
multi-rooted process tree. Besides, if the siblings of init exit, the
SIGCHLD is not sent to init process resulting in the zombies sticking
around indefinitely. So disable CLONE_PARENT for init.

Lightly tested, RFC patch :-)

Changelog[v2]:
	- Simplify patch description based on comments from Eric Biederman
	  and Oleg Nesterov.
	- [Oleg Nesterov] Use SIGNAL_UNKILLABLE instead of is_global_init()

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Roland McGrath <roland@redhat.com>
---
 kernel/fork.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-mmotm/kernel/fork.c
===================================================================
--- linux-mmotm.orig/kernel/fork.c	2009-06-30 23:01:06.000000000 -0700
+++ linux-mmotm/kernel/fork.c	2009-06-30 23:13:53.000000000 -0700
@@ -974,6 +974,17 @@ static struct task_struct *copy_process(
 	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Swapper process sets the handler for SIGCHLD to SIG_DFL. If init
+	 * creates a sibling and the sibling exits, the SIGCHLD is sent to
+	 * the swapper (since the swapper's handler for SIGCHLD is SIG_DFL).
+	 * But since the swapper does not reap its children, the zombie will
+	 * remain forever. So prevent init from using CLONE_PARENT.
+	 */
+	if ((clone_flags & CLONE_PARENT) &&
+				current->signal->flags & SIGNAL_UNKILLABLE)
+		return ERR_PTR(-EINVAL);
+
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;
