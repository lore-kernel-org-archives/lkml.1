Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbZG1TE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbZG1TE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZG1TE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:04:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60926 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbZG1TEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:04:25 -0400
Date: Tue, 28 Jul 2009 12:06:54 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, oleg@redhat.com, roland@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Deny CLONE_PARENT|CLONE_NEWPID combination
Message-ID: <20090728190654.GA5806@us.ibm.com>
References: <20090728164406.GA17275@us.ibm.com> <20090728180553.GB6427@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728180553.GB6427@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn [serue@us.ibm.com] wrote:
| Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
| > 
| > Deny CLONE_PARENT|CLONE_NEWPID combination.
| > 
| > CLONE_PARENT was used to implement an older threading model.  For consistency
| > with the CLONE_THREAD check in copy_pid_ns(), disable CLONE_PARENT and
| > CLONE_SIGHAND with CLONE_NEWPID, at least until the required semantics of
| > the pid namespaces are clear.
| > 
| > Changelog[v3]:
| > 	Remove CLONE_SIGHAND and for now only fail CLONE_NEWPID|CLONE_PARENT.
| 
| (FWIW your patch description does not reflect this...)

You are right. Here is the patch with updated description.
---

Deny CLONE_PARENT|CLONE_NEWPID|CLONE_SIGHAND combination.

CLONE_PARENT was used to implement an older threading model.  For consistency
with the CLONE_THREAD check in copy_pid_ns(), disable CLONE_PARENT with
CLONE_NEWPID, at least until the required semantics of pid namespaces are
clear.

Changelog[v3]:
	Remove CLONE_SIGHAND and for now only fail CLONE_NEWPID|CLONE_PARENT.
Changelog[v2]:
	[Eric Biederman] Disable CLONE_SIGHAND also ?

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 kernel/pid_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-mmotm/kernel/pid_namespace.c
===================================================================
--- linux-mmotm.orig/kernel/pid_namespace.c	2009-07-16 10:03:01.000000000 -0700
+++ linux-mmotm/kernel/pid_namespace.c	2009-07-16 11:37:24.000000000 -0700
@@ -118,7 +118,7 @@
 {
 	if (!(flags & CLONE_NEWPID))
 		return get_pid_ns(old_ns);
-	if (flags & CLONE_THREAD)
+	if (flags & (CLONE_THREAD|CLONE_PARENT))
 		return ERR_PTR(-EINVAL);
 	return create_pid_namespace(old_ns);
 }
