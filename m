Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYBIPxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYBIPxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYBIPxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:53:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbYBIPxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:53:32 -0500
Date: Sat, 9 Feb 2008 23:53:17 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, lguest@ozlabs.org
Subject: [PATCH] lguest: make sure cpu is initialized before accessing it
Message-ID: <20080209155317.GA12841@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If req is LHREQ_INITIALIZE, and the guest has been initialized before
(unlikely), it will attempt to access cpu->tsk even though cpu is not yet
initialized.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/lguest/lguest_user.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 85d42d3..9cbb285 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -241,15 +241,15 @@ static ssize_t write(struct file *file, const char __user *in,
 		cpu = &lg->cpus[cpu_id];
 		if (!cpu)
 			return -EINVAL;
-	}
 
-	/* Once the Guest is dead, all you can do is read() why it died. */
-	if (lg && lg->dead)
-		return -ENOENT;
+		/* Once the Guest is dead, all you can do is read() why it died. */
+		if (lg && lg->dead)
+			return -ENOENT;
 
-	/* If you're not the task which owns the Guest, you can only break */
-	if (lg && current != cpu->tsk && req != LHREQ_BREAK)
-		return -EPERM;
+		/* If you're not the task which owns the Guest, you can only break */
+		if (lg && current != cpu->tsk && req != LHREQ_BREAK)
+			return -EPERM;
+	}
 
 	switch (req) {
 	case LHREQ_INITIALIZE:

