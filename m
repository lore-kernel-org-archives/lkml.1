Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZG1XxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZG1XxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbZG1XxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:53:13 -0400
Received: from kroah.org ([198.145.64.141]:35948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbZG1Xu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:00 2009
Message-Id: <20090728234200.738235776@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 60/71] netfilter: nf_log: fix direct userspace memory access in proc handler
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-nf_log-fix-direct-userspace-memory-access-in-proc-handler.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 249556192859490b6280552d4b877064f9f5ee48 upstream.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_log.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -47,7 +47,6 @@ int nf_log_register(u_int8_t pf, struct 
 	mutex_lock(&nf_log_mutex);
 
 	if (pf == NFPROTO_UNSPEC) {
-		int i;
 		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
 			list_add_tail(&(logger->list[i]), &(nf_loggers_l[i]));
 	} else {
@@ -216,7 +215,7 @@ static const struct file_operations nflo
 #endif /* PROC_FS */
 
 #ifdef CONFIG_SYSCTL
-struct ctl_path nf_log_sysctl_path[] = {
+static struct ctl_path nf_log_sysctl_path[] = {
 	{ .procname = "net", .ctl_name = CTL_NET, },
 	{ .procname = "netfilter", .ctl_name = NET_NETFILTER, },
 	{ .procname = "nf_log", .ctl_name = CTL_UNNUMBERED, },
@@ -228,19 +227,26 @@ static struct ctl_table nf_log_sysctl_ta
 static struct ctl_table_header *nf_log_dir_header;
 
 static int nf_log_proc_dostring(ctl_table *table, int write, struct file *filp,
-			 void *buffer, size_t *lenp, loff_t *ppos)
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	const struct nf_logger *logger;
+	char buf[NFLOGGER_NAME_LEN];
+	size_t size = *lenp;
 	int r = 0;
 	int tindex = (unsigned long)table->extra1;
 
 	if (write) {
-		if (!strcmp(buffer, "NONE")) {
+		if (size > sizeof(buf))
+			size = sizeof(buf);
+		if (copy_from_user(buf, buffer, size))
+			return -EFAULT;
+
+		if (!strcmp(buf, "NONE")) {
 			nf_log_unbind_pf(tindex);
 			return 0;
 		}
 		mutex_lock(&nf_log_mutex);
-		logger = __find_logger(tindex, buffer);
+		logger = __find_logger(tindex, buf);
 		if (logger == NULL) {
 			mutex_unlock(&nf_log_mutex);
 			return -ENOENT;


