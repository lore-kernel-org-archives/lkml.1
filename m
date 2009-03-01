Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZCAUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZCAUAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 15:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZCAUAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 15:00:21 -0500
Received: from ns2.suse.de ([195.135.220.15]:50676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492AbZCAUAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 15:00:21 -0500
Message-ID: <49AAE94E.8080308@suse.de>
Date: Sun, 01 Mar 2009 21:00:14 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, Ankita Garg <ankita@in.ibm.com>,
       Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Seidel <fseidel@suse.de>, Frank Seidel <frank@f-seidel.de>,
       kernalert.de@gmail.com
Subject: [PATCH] lkdtm: reduce stack size
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Reduce stack memory footprint of lkdtm
(recursive_loop). From 1024 bytes on i386 down
to <10.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/misc/lkdtm.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -225,14 +225,24 @@ static int lkdtm_parse_commandline(void)
 
 static int recursive_loop(int a)
 {
-	char buf[1024];
+	char *buf;
+	int ret;
+
+	buf = kmalloc(1024, GFP_KERNEL);
+	if (!buf) {
+		printk(KERN_ERR "lkdtm : couldn't allocate buffer\n");
+		return -ENOMEM;
+	}
 
 	memset(buf,0xFF,1024);
 	recur_count--;
 	if (!recur_count)
-		return 0;
+		ret = 0;
 	else
-        	return recursive_loop(a);
+		ret = recursive_loop(a);
+
+	kfree(buf);
+	return ret;
 }
 
 void lkdtm_handler(void)
