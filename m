Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZKTQlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZKTQlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbZKTQlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:41:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbZKTQlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:41:01 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 09/15] frv: remove "struct file *" argument from sysctl ->proc_handler
Date: Fri, 20 Nov 2009 17:40:39 +0100
Message-Id: <1258735245-25826-10-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that Alexey Dobriyan missed this usage of the file argument when
removing it from ->proc_handler in commit 8d65af789f3e2cf4cfbdbf71a0f7a61ebcd41d38.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/frv/kernel/sysctl.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/frv/kernel/sysctl.c b/arch/frv/kernel/sysctl.c
index 3e9d7e0..bd6cc5c 100644
--- a/arch/frv/kernel/sysctl.c
+++ b/arch/frv/kernel/sysctl.c
@@ -47,8 +47,9 @@ static void frv_change_dcache_mode(unsigned long newmode)
 /*
  * handle requests to dynamically switch the write caching mode delivered by /proc
  */
-static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
-				 void __user *buffer, size_t *lenp, loff_t *ppos)
+static int procctl_frv_cachemode(ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos)
 {
 	unsigned long hsr0;
 	char buff[8];
@@ -85,7 +86,7 @@ static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
 	}
 
 	/* read the state */
-	if (filp->f_pos > 0) {
+	if (*ppos > 0) {
 		*lenp = 0;
 		return 0;
 	}
@@ -111,7 +112,7 @@ static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
 		return -EFAULT;
 
 	*lenp = len;
-	filp->f_pos = len;
+	*ppos = len;
 	return 0;
 
 } /* end procctl_frv_cachemode() */
@@ -121,8 +122,9 @@ static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
  * permit the mm_struct the nominated process is using have its MMU context ID pinned
  */
 #ifdef CONFIG_MMU
-static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
+static int procctl_frv_pin_cxnr(ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
 {
 	pid_t pid;
 	char buff[16], *p;
@@ -151,7 +153,7 @@ static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
 	}
 
 	/* read the currently pinned CXN */
-	if (filp->f_pos > 0) {
+	if (*ppos > 0) {
 		*lenp = 0;
 		return 0;
 	}
@@ -164,7 +166,7 @@ static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
 		return -EFAULT;
 
 	*lenp = len;
-	filp->f_pos = len;
+	*ppos = len;
 	return 0;
 
 } /* end procctl_frv_pin_cxnr() */
-- 
1.6.4.2

