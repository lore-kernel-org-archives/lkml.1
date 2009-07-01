Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZGAVwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZGAVwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZGAVwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:52:01 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57143 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZGAVwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:52:00 -0400
Date: Wed, 1 Jul 2009 14:48:05 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
Message-ID: <20090701214805.GA25734@us.ibm.com>
References: <20090701073140.GA14284@us.ibm.com> <20090701074654.A6C6321D57@magilla.sf.frob.com> <20090701082452.GA3297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701082452.GA3297@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| This won't fix the problem. The child won't autoreap itself if ->exit_signal
| != SIGCHLD.
| 
| > If you want to make this change because of container-init issues, I think
| > you should just say so independent of this global-init case.
| 
| Yes, agreed, the comment looks confusing.
| 
| Oleg

Here is an updated patch with comments fixed.

Roland pls ack again if this is better.

---

Disable CLONE_PARENT for init.

When global or container-init processes use CLONE_PARENT, they create a
multi-rooted process tree. Besides if the siblings of init exit, the
SIGCHLD is not sent to init process resulting in the zombies sticking
around indefinitely.

Changelog[v3]:
	- [Roland, Oleg] Simplify comment describing the change
Changelog[v2]:
	- Simplify patch description based on comments from Eric Biederman
	  and Oleg Nesterov.
	- [Oleg Nesterov] Use SIGNAL_UNKILLABLE instead of is_global_init()

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 kernel/fork.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-mmotm/kernel/fork.c
===================================================================
--- linux-mmotm.orig/kernel/fork.c	2009-06-30 23:01:06.000000000 -0700
+++ linux-mmotm/kernel/fork.c	2009-07-01 14:43:10.000000000 -0700
@@ -974,6 +974,14 @@ static struct task_struct *copy_process(
 	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * To avoid multi-rooted process-trees prevent global and container
+	 * inits from creating siblings.
+	 */
+	if ((clone_flags & CLONE_PARENT) &&
+				current->signal->flags & SIGNAL_UNKILLABLE)
+		return ERR_PTR(-EINVAL);
+
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;
