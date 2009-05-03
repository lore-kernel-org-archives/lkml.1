Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZECX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZECX0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZECX0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:26:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:29006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZECX0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DheG5M3+k3OPzrZdZRcmJdvJGfK44/WRgGZ7O6uFk1VD2YyTtKCETyvjuPIakMcEyr
         kJY3tdJSpk96R3PXrQb9gkWmMsK1uvHi5e/wyrPhNacxML9hIOBjtWaCIwPcl82NSZ/L
         /XlthQPgMFC7j7tKEFGo46ycTzyjl3HBGc0gU=
Date: Mon, 4 May 2009 03:27:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       xemul@parallels.com
Subject: [PATCH 2/2] pidns 2/2: rewrite copy_pid_ns()
Message-ID: <20090503232721.GE16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
