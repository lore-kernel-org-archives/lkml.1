Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbZEHM6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbZEHM6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760334AbZEHM54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:57:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34661 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842AbZEHM5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:57:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] CRED: Guard the setprocattr security hook against ptrace
To: roland@redhat.com, jmorris@namei.org, chrisw@sous-sol.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, eparis@redhat.com,
       sds@tycho.nsa.gov, David Howells <dhowells@redhat.com>
Date: Fri, 08 May 2009 13:55:27 +0100
Message-ID: <20090508125527.8488.82217.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk>
References: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guard the setprocattr security hook against ptrace by taking the target task's
cred_guard_mutex around it.  The problem is that setprocattr() may otherwise
note the lack of a debugger, and then perform an action on that basis whilst
letting a debugger attach between the two points.  Holding cred_guard_mutex
across the test and the action prevents ptrace_attach() from doing that.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/base.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/fs/proc/base.c b/fs/proc/base.c
index fb45615..23342e1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2128,9 +2128,15 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	if (copy_from_user(page, buf, count))
 		goto out_free;
 
+	/* Guard against adverse ptrace interaction */
+	length = mutex_lock_interruptible(&task->cred_guard_mutex);
+	if (length < 0)
+		goto out_free;
+
 	length = security_setprocattr(task,
 				      (char*)file->f_path.dentry->d_name.name,
 				      (void*)page, count);
+	mutex_unlock(&task->cred_guard_mutex);
 out_free:
 	free_page((unsigned long) page);
 out:

