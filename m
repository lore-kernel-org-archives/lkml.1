Return-Path: <linux-kernel-owner+w=401wt.eu-S941871AbXHJVEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941871AbXHJVEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXHJVDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:03:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57449 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbXHJVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:03:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] sysctl:  Simplify the pty sysctl logic.
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC8F71.3070006@googlemail.com> <46BC944F.9020801@googlemail.com>
	<m1fy2rxpje.fsf@ebiederm.dsl.xmission.com>
	<20070810124156.2de9710e.akpm@linux-foundation.org>
	<m1ps1vw1ey.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkcjw1cc.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 10 Aug 2007 15:03:43 -0600
In-Reply-To: <m1lkcjw1cc.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 10 Aug 2007 15:01:39 -0600")
Message-ID: <m1hcn7w18w.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of having a bunch of ifdefs in sysctl.c
move all of the pty sysctl logic into drivers/char/pty.c

As well as cleaning up the logic this prevents
sysctl_check_table from complaining that the root
table has a NULL data pointer on something with
generic methods.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/char/pty.c |   24 +++++++++++++++++++++++-
 kernel/sysctl.c    |   11 -----------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index de14aea..1d68b32 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -313,7 +313,7 @@ int pty_limit = NR_UNIX98_PTY_DEFAULT;
 static int pty_limit_min = 0;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
 
-ctl_table pty_table[] = {
+static struct ctl_table pty_table[] = {
 	{
 		.ctl_name	= PTY_MAX,
 		.procname	= "max",
@@ -335,6 +335,27 @@ ctl_table pty_table[] = {
 	}
 };
 
+static struct ctl_table pty_kern_table[] = {
+	{
+		.ctl_name	= KERN_PTY,
+		.procname	= "pty",
+		.mode		= 0555,
+		.child		= pty_table,
+	},
+	{}
+};
+
+static struct ctl_table pty_root_table[] = {
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= pty_kern_table,
+	},
+	{}
+};
+
+
 static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
 			    unsigned int cmd, unsigned long arg)
 {
@@ -399,6 +420,7 @@ static void __init unix98_pty_init(void)
 		panic("Couldn't register Unix98 pts driver");
 
 	pty_table[1].data = &ptm_driver->refcount;
+	register_sysctl_table(pty_root_table);
 }
 #else
 static inline void unix98_pty_init(void) { }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 03759ab..f18e7ec 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -150,9 +150,6 @@ static struct ctl_table fs_table[];
 static struct ctl_table debug_table[];
 static struct ctl_table dev_table[];
 extern struct ctl_table random_table[];
-#ifdef CONFIG_UNIX98_PTYS
-extern struct ctl_table pty_table[];
-#endif
 #ifdef CONFIG_INOTIFY_USER
 extern struct ctl_table inotify_table[];
 #endif
@@ -519,14 +516,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0555,
 		.child		= random_table,
 	},
-#ifdef CONFIG_UNIX98_PTYS
-	{
-		.ctl_name	= KERN_PTY,
-		.procname	= "pty",
-		.mode		= 0555,
-		.child		= pty_table,
-	},
-#endif
 	{
 		.ctl_name	= KERN_OVERFLOWUID,
 		.procname	= "overflowuid",
-- 
1.5.1.1.181.g2de0

