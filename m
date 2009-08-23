Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbZHWS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbZHWS3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933377AbZHWS3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 14:29:47 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49989 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329AbZHWS3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 14:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xeH21jinFyB3qE4w7I4fTSfmBEkXjjlE659EEBjOktkMwYF/JcAgugye9LX9EYjPoq
         RSv0DtZYKRMOrDtEngC0p0mMSZ6JALTawq8ZPkytusKSR+0ujc/suk86o2Df1GnwYpRO
         ScRYpb8VHAPOY0Si0a/wy8IfkOHjf0TV14mFs=
Message-ID: <4A918A99.4080909@gmail.com>
Date: Sun, 23 Aug 2009 20:29:45 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH resend] net: use printk_once
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: net: use printk_once

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index da0f64f..39c895b 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1792,12 +1792,8 @@ static int ax25_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 
 		/* old structure? */
 		if (cmd == SIOCAX25GETINFOOLD) {
-			static int warned = 0;
-			if (!warned) {
-				printk(KERN_INFO "%s uses old SIOCAX25GETINFO\n",
+			printk_once(KERN_INFO "%s uses old SIOCAX25GETINFO\n",
 					current->comm);
-				warned=1;
-			}
 
 			if (copy_to_user(argp, &ax25_info, sizeof(struct ax25_info_struct_deprecated))) {
 				res = -EFAULT;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 71489f6..ecd2dfb 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -302,14 +302,12 @@ static struct net_device *dev_to_net_device(struct device *dev)
 
 static int dsa_probe(struct platform_device *pdev)
 {
-	static int dsa_version_printed;
 	struct dsa_platform_data *pd = pdev->dev.platform_data;
 	struct net_device *dev;
 	struct dsa_switch_tree *dst;
 	int i;
 
-	if (!dsa_version_printed++)
-		printk(KERN_NOTICE "Distributed Switch Architecture "
+	printk_once(KERN_NOTICE "Distributed Switch Architecture "
 			"driver version %s\n", dsa_driver_version);
 
 	if (pd == NULL || pd->netdev == NULL)
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 2979f14..f919925 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -470,10 +470,8 @@ static int raw_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		if (msg->msg_namelen < sizeof(*usin))
 			goto out;
 		if (usin->sin_family != AF_INET) {
-			static int complained;
-			if (!complained++)
-				printk(KERN_INFO "%s forgot to set AF_INET in "
-						 "raw sendmsg. Fix it!\n",
+			printk_once(KERN_INFO "%s forgot to set AF_INET in "
+						"raw sendmsg. Fix it!\n",
 						 current->comm);
 			err = -EAFNOSUPPORT;
 			if (usin->sin_family)
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index eb0ceb8..d60d317 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -456,13 +456,9 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 #ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
 static int recent_old_seq_open(struct inode *inode, struct file *filp)
 {
-	static bool warned_of_old;
-
-	if (unlikely(!warned_of_old)) {
-		printk(KERN_INFO KBUILD_MODNAME ": Use of /proc/net/ipt_recent"
-		       " is deprecated; use /proc/net/xt_recent.\n");
-		warned_of_old = true;
-	}
+	printk_once(KERN_INFO KBUILD_MODNAME ": "
+		"Use of /proc/net/ipt_recent is deprecated; "
+		"use /proc/net/xt_recent.\n");
 	return recent_seq_open(inode, filp);
 }
 
diff --git a/net/socket.c b/net/socket.c
index 791d71a..1d07f69 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1161,12 +1161,8 @@ static int __sock_create(struct net *net, int family, int type, int protocol,
 	   deadlock in module load.
 	 */
 	if (family == PF_INET && type == SOCK_PACKET) {
-		static int warned;
-		if (!warned) {
-			warned = 1;
-			printk(KERN_INFO "%s uses obsolete (PF_INET,SOCK_PACKET)\n",
-			       current->comm);
-		}
+		printk_once(KERN_INFO "%s uses obsolete (PF_INET,SOCK_PACKET)\n",
+			    current->comm);
 		family = PF_PACKET;
 	}
 

