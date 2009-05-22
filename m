Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZEVE5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZEVE5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZEVEzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:28780 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZEVEzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M6d0RzomDvbe71cN6BDmVncq1xdH3+JpGAUe0+h2UyisIJ2OkcnBKi8qtK+C+kz5YV
         p685DNv4kUZ0INHU9yrLypLWI5ygQ/7x2fBKpdnpZLrAi+efAXDeIoN+5ZVBdAqnYRd0
         67uBq6qnHjvnAtb4FJvrhtGpocf1WBdIQyopQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 08/38] pidns 2/2: rewrite copy_pid_ns()
Date: Fri, 22 May 2009 08:55:02 +0400
Message-Id: <1242968132-1044-8-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_pid_ns() is a perfect example of a case where unwinding leads to more
code and makes it less clear. Watch the diffstat.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 kernel/pid_namespace.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 495d5de..821722a 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -116,23 +116,11 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
 
 struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
 {
-	struct pid_namespace *new_ns;
-
-	BUG_ON(!old_ns);
-	new_ns = get_pid_ns(old_ns);
 	if (!(flags & CLONE_NEWPID))
-		goto out;
-
-	new_ns = ERR_PTR(-EINVAL);
+		return get_pid_ns(old_ns);
 	if (flags & CLONE_THREAD)
-		goto out_put;
-
-	new_ns = create_pid_namespace(old_ns);
-
-out_put:
-	put_pid_ns(old_ns);
-out:
-	return new_ns;
+		return ERR_PTR(-EINVAL);
+	return create_pid_namespace(old_ns);
 }
 
 void free_pid_ns(struct kref *kref)
-- 
1.5.6.5

