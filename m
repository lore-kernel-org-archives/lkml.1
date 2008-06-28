Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYF1Mt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYF1Mt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYF1MtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:49:18 -0400
Received: from [88.205.141.71] ([88.205.141.71]:13031 "EHLO mail.ward.six"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751860AbYF1MtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:49:17 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 08:49:17 EDT
Date: Sat, 28 Jun 2008 18:41:36 +0600
From: Denis Zaitceff <zaitceff@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25.8] ipconfig.c: extend the info in /proc/net/pnp
Message-ID: <20080628184136.A5610@ward.six>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the info shown thru /proc/net/pnp, making more ipv4
autoconf results accessible to user.  The variables added are:

ic_myaddr
ic_netmask
ic_gateway
root_server_addr
root_server_path
ic_dev_name

This should make diskless clients more happy, as their startup scripts
would have more information.

Please apply the patch, would you consider it useful.


--- net/ipv4/ipconfig.c
+++ net/ipv4/ipconfig.c
@@ -183,6 +183,9 @@
 
 static struct ic_device *ic_first_dev __initdata = NULL;/* List of open device */
 static struct net_device *ic_dev __initdata = NULL;	/* Selected device */
+#ifdef CONFIG_PROC_FS
+static u8 ic_dev_name[sizeof ic_dev->name];
+#endif
 
 static int __init ic_open_devs(void)
 {
@@ -1199,6 +1202,19 @@ static int pnp_seq_show(struct seq_file 
 {
 	int i;
 
+	const struct info {
+		__be32 *value;
+		const char *name;
+	} static list[]= {
+		{&ic_servaddr,"bootserver"},
+		{&ic_myaddr,"myaddr"},
+		{&ic_netmask,"netmask"},
+		{&ic_gateway,"gateway"},
+		{&root_server_addr,"rootserver"},
+		{NULL}
+	};
+	const struct info *p= list;
+
 	if (ic_proto_used & IC_PROTO)
 		seq_printf(seq, "#PROTO: %s\n",
 			   (ic_proto_used & IC_RARP) ? "RARP"
@@ -1215,10 +1231,18 @@ static int pnp_seq_show(struct seq_file 
 				   "nameserver %u.%u.%u.%u\n",
 				   NIPQUAD(ic_nameservers[i]));
 	}
-	if (ic_servaddr != NONE)
-		seq_printf(seq,
-			   "bootserver %u.%u.%u.%u\n",
-			   NIPQUAD(ic_servaddr));
+
+	do if (*p->value != NONE)
+		seq_printf(seq, "%s %u.%u.%u.%u\n",
+			   p->name, NIPQUAD(*p->value));
+	while ((++p)->value);
+
+	if (root_server_path[0])
+		seq_printf(seq, "rootpath %s\n", root_server_path);
+
+	if (ic_dev_name[0])
+		seq_printf(seq, "device %s\n", ic_dev_name);
+
 	return 0;
 }
 
@@ -1386,6 +1410,10 @@ static int __init ip_auto_config(void)
 	ic_proto_used = ic_got_reply | (ic_proto_enabled & IC_USE_DHCP);
 #endif
 
+#ifdef CONFIG_PROC_FS
+        strcpy(ic_dev_name, ic_dev->name);
+#endif
+
 #ifndef IPCONFIG_SILENT
 	/*
 	 * Clue in the operator.
