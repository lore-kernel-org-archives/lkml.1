Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbXGSU6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbXGSU6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbXGSU57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:57:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43884 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbXGSU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:57:58 -0400
Date: Thu, 19 Jul 2007 15:57:57 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] user namespace: fix copy_user_ns return value
Message-ID: <20070719205757.GA15099@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As found by sukadev@us.ibm.com, current -git, when compiled with
CONFIG_USER_NS=n, can be crashed by doing

#include <sched.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
	unshare(CLONE_NEWNS);
	setuid(1000);
}

as root.

The dummy version of copy_user_ns was returning NULL instead of
a valid namespace.  The following patch fixes the problem.
Please apply.

thanks,
-serge

>From 32f86740d27ef77160e438cd7dc4fcd5df159dd0 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Tue, 17 Jul 2007 15:28:17 -0400
Subject: [PATCH] user namespace: fix copy_user_ns return value

When a CONFIG_USER_NS=n and a user tries to unshare some
namespace other than the user namespace, the dummy
copy_user_ns returns NULL rather than the old_ns.  This
value then gets assigned to task->nsproxy->user_ns, so
that a subsequent setuid, which uses task->nsproxy->user_ns,
causes a NULL pointer deref.

Fix this by returning old_ns.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/user_namespace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index bb32057..1101b0c 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -49,7 +49,7 @@ static inline struct user_namespace *copy_user_ns(int flags,
 	if (flags & CLONE_NEWUSER)
 		return ERR_PTR(-EINVAL);
 
-	return NULL;
+	return old_ns;
 }
 
 static inline void put_user_ns(struct user_namespace *ns)
-- 
1.5.1.1.GIT

