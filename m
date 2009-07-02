Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZGBAjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZGBAjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZGBAjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:39:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37767 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZGBAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:39:13 -0400
Date: Wed, 1 Jul 2009 17:35:20 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
Message-ID: <20090702003520.GA26247@us.ibm.com>
References: <20090701073140.GA14284@us.ibm.com> <20090701074654.A6C6321D57@magilla.sf.frob.com> <20090701082452.GA3297@redhat.com> <20090701214805.GA25734@us.ibm.com> <20090701215833.876DA404FD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701215833.876DA404FD@magilla.sf.frob.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath [roland@redhat.com] wrote:
| Yeah, that's fine.  Since Oleg's pointed out that there is indeed no way to
| avoid the leak in some global-init uses, it is fine to have a comment that
| says that global init problems are part of the reason to outlaw this usage.
| I just objected to a change that was really for container init but said it
| was only to fix something different.

Ok. How about this comment:

---

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
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/fork.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-mmotm/kernel/fork.c
===================================================================
--- linux-mmotm.orig/kernel/fork.c	2009-06-30 23:01:06.000000000 -0700
+++ linux-mmotm/kernel/fork.c	2009-07-01 17:29:09.000000000 -0700
@@ -974,6 +974,16 @@ static struct task_struct *copy_process(
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
