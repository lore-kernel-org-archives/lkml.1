Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbXGJJA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbXGJJA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbXGJI5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:57:44 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:56127 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762436AbXGJI5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:57:41 -0400
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
Date: Tue, 10 Jul 2007 14:49:56 +0530
Message-Id: <20070710091956.23907.61655.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH v2 -mm 7/9] netconsole: Use netif_running() in write_msg()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[7/9] netconsole: Use netif_running() in write_msg()

Avoid unnecessarily disabling interrupts and calling netpoll_send_udp()
if the corresponding local interface is not up.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>

---

 drivers/net/netconsole.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

---

diff -ruNp a/drivers/net/netconsole.c b/drivers/net/netconsole.c
--- a/drivers/net/netconsole.c	2007-07-10 07:26:47.000000000 +0530
+++ b/drivers/net/netconsole.c	2007-07-10 07:45:51.000000000 +0530
@@ -113,16 +113,16 @@ static void write_msg(struct console *co
 	unsigned long flags;
 	struct netconsole_target *nt = &default_target;
 
-	local_irq_save(flags);
-
-	for (left = len; left;) {
-		frag = min(left, MAX_PRINT_CHUNK);
-		netpoll_send_udp(&nt->np, msg, frag);
-		msg += frag;
-		left -= frag;
+	if (netif_running(nt->np.dev)) {
+		local_irq_save(flags);
+		for (left = len; left;) {
+			frag = min(left, MAX_PRINT_CHUNK);
+			netpoll_send_udp(&nt->np, msg, frag);
+			msg += frag;
+			left -= frag;
+		}
+		local_irq_restore(flags);
 	}
-
-	local_irq_restore(flags);
 }
 
 static struct console netconsole = {
