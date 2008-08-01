Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYHAFJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYHAFJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYHAFI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:08:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40437 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbYHAFIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:08:24 -0400
Message-Id: <20080801050701.603089371@us.ibm.com>
References: <20080801050659.924495279@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 22:07:05 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 6/6] Container Freezer: Use cgroup write_string method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new cgroup write_string method rather than the raw write method
because it better matches the needs of the freezer cgroup subsystem.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
---
 kernel/cgroup_freezer.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

Index: linux-2.6.27-rc1-mm1/kernel/cgroup_freezer.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/cgroup_freezer.c
+++ linux-2.6.27-rc1-mm1/kernel/cgroup_freezer.c
@@ -29,11 +29,10 @@
 static const char *freezer_state_strs[] = {
 	"RUNNING",
 	"FREEZING",
 	"FROZEN",
 };
-#define STATE_MAX_STRLEN 8
 
 /*
  * State diagram (transition labels in parenthesis):
  *
  *  RUNNING -(FROZEN)-> FREEZING -(FROZEN)-> FROZEN
@@ -278,27 +277,17 @@ out:
 	spin_unlock_irq(&freezer->lock);
 
 	return retval;
 }
 
-static ssize_t freezer_write(struct cgroup *cgroup,
-			     struct cftype *cft,
-			     struct file *file,
-			     const char __user *userbuf,
-			     size_t nbytes, loff_t *unused_ppos)
+static int freezer_write(struct cgroup *cgroup,
+			 struct cftype *cft,
+			 const char *buffer)
 {
-	char buffer[STATE_MAX_STRLEN + 1];
-	int retval = 0;
+	int retval;
 	enum freezer_state goal_state;
 
-	if (nbytes >= PATH_MAX)
-		return -E2BIG;
-	nbytes = min(sizeof(buffer) - 1, nbytes);
-	if (copy_from_user(buffer, userbuf, nbytes))
-		return -EFAULT;
-	buffer[nbytes + 1] = 0; /* nul-terminate */
-	strstrip(buffer); /* remove any trailing whitespace */
 	if (strcmp(buffer, freezer_state_strs[STATE_RUNNING]) == 0)
 		goal_state = STATE_RUNNING;
 	else if (strcmp(buffer, freezer_state_strs[STATE_FROZEN]) == 0)
 		goal_state = STATE_FROZEN;
 	else
@@ -313,11 +302,11 @@ static ssize_t freezer_write(struct cgro
 
 static struct cftype files[] = {
 	{
 		.name = "state",
 		.read_seq_string = freezer_read,
-		.write = freezer_write,
+		.write_string = freezer_write,
 	},
 };
 
 static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
 {

-- 
