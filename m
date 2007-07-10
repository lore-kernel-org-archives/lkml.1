Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbXGJI7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbXGJI7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbXGJI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:57:35 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:56108 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761957AbXGJI5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:57:32 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Matt Mackall <mpm@selenic.com>, Keiichi Kii <k-keiichi@bx.jp.nec.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Date: Tue, 10 Jul 2007 14:49:46 +0530
Message-Id: <20070710091946.23907.96503.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH v2 -mm 5/9] netconsole: Introduce netconsole_target
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[5/9] netconsole: Introduce netconsole_target

Introduce a wrapper structure over netpoll to represent logging targets
configured in netconsole. This will get extended with other members in
further patches.

The original patchset did this along with (and inside the #ifdef) of
CONFIG_NETCONSOLE_DYNAMIC itself. I decided otherwise, and was able to
drastically cut down on the #ifdef-complexity of final netconsole.c.
Also, struct netconsole_target would be required for multiple targets
support also, and not just dynamic reconfigurability. Previously these
two things were coupled, but I want to de-link that (more on this later).

Note that this patch in itself looks quite redundant / stupid, but it is
purposefully made this way, so further patches are more readable.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>

---

 drivers/net/netconsole.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

---

diff -ruNp a/drivers/net/netconsole.c b/drivers/net/netconsole.c
--- a/drivers/net/netconsole.c	2007-07-10 06:42:11.000000000 +0530
+++ b/drivers/net/netconsole.c	2007-07-10 06:50:46.000000000 +0530
@@ -62,24 +62,35 @@ static int __init option_setup(char *opt
 __setup("netconsole=", option_setup);
 #endif	/* MODULE */
 
-static struct netpoll np = {
-	.name		= "netconsole",
-	.dev_name	= "eth0",
-	.local_port	= 6665,
-	.remote_port	= 6666,
-	.remote_mac	= {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
+/**
+ * struct netconsole_target - Represents a configured netconsole target.
+ * @np:		The netpoll structure for this target.
+ */
+struct netconsole_target {
+	struct netpoll		np;
+};
+
+static struct netconsole_target default_target = {
+	.np		= {
+		.name		= "netconsole",
+		.dev_name	= "eth0",
+		.local_port	= 6665,
+		.remote_port	= 6666,
+		.remote_mac	= {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
+	},
 };
 
 static void write_msg(struct console *con, const char *msg, unsigned int len)
 {
 	int frag, left;
 	unsigned long flags;
+	struct netconsole_target *nt = &default_target;
 
 	local_irq_save(flags);
 
 	for (left = len; left;) {
 		frag = min(left, MAX_PRINT_CHUNK);
-		netpoll_send_udp(&np, msg, frag);
+		netpoll_send_udp(&nt->np, msg, frag);
 		msg += frag;
 		left -= frag;
 	}
@@ -96,17 +107,18 @@ static struct console netconsole = {
 static int __init init_netconsole(void)
 {
 	int err = 0;
+	struct netconsole_target *nt = &default_target;
 
 	if (!strnlen(config, MAX_PARAM_LENGTH)) {
 		printk(KERN_INFO "netconsole: not configured, aborting\n");
 		goto out;
 	}
 
-	err = netpoll_parse_options(&np, config);
+	err = netpoll_parse_options(&nt->np, config);
 	if (err)
 		goto out;
 
-	err = netpoll_setup(&np);
+	err = netpoll_setup(&nt->np);
 	if (err)
 		goto out;
 
@@ -119,8 +131,10 @@ out:
 
 static void __exit cleanup_netconsole(void)
 {
+	struct netconsole_target *nt = &default_target;
+
 	unregister_console(&netconsole);
-	netpoll_cleanup(&np);
+	netpoll_cleanup(&nt->np);
 }
 
 module_init(init_netconsole);
