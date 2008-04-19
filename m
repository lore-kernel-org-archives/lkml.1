Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYDSRhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYDSRhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 13:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYDSRgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 13:36:48 -0400
Received: from mail.queued.net ([207.210.101.209]:2756 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbYDSRgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 13:36:48 -0400
Date: Sat, 19 Apr 2008 13:39:15 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, jordan.crouse@amd.com,
       Mitch Bradley <wmb@firmworks.com>
Subject: [PATCH 2/2] OLPC: drop pre-OpenFirmware workarounds
Message-ID: <20080419133915.07bc0f69@ephemeral>
In-Reply-To: <20080419092544.378664a8@ephemeral>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Prior to including OFW kernel support, we had to work around the lack of
OFW.  Once OFW support is added, we can switch to using it.  This cleans
up some pre-OFW model detection and OFW signature detection.

Note: this should be a bit nicer to non-OLPC hardware.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/kernel/olpc.c |   43 +++++++++++++++++++++++++++++--------------
 1 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 11670be..3a05683 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -190,11 +190,11 @@ EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 static void __init platform_detect(void)
 {
 	size_t propsize;
-	u32 rev;
+	uint32_t rev;
 
 	if (ofw("getprop", 4, 1, NULL, "board-revision-int", &rev, 4,
 			&propsize) || propsize != 4) {
-		printk(KERN_ERR "ofw: getprop call failed!\n");
+		printk(KERN_ERR "olpc:  ofw getprop call failed!\n");
 		rev = 0;
 	}
 	olpc_platform_info.boardrev = be32_to_cpu(rev);
@@ -207,26 +207,43 @@ static void __init platform_detect(void)
 }
 #endif
 
-static int __init olpc_init(void)
+static int __init ofw_detect(void)
 {
-	unsigned char *romsig;
+	size_t propsize;
+	char romsig[20];
+	ofw_phandle phandle;
 
-	spin_lock_init(&ec_lock);
+	/* Fetch /openprom/model */
+	if (ofw("finddevice", 1, 1, "/openprom", &phandle) || phandle == ~0)
+		return -ENODEV;
 
-	romsig = ioremap(0xffffffc0, 16);
-	if (!romsig)
-		return 0;
+	if (ofw("getprop", 4, 1, phandle, "model", &romsig, sizeof(romsig),
+			&propsize) || propsize < 7)
+		return -ENODEV;
 
+	/* String should look something like "CL1   Q2D08  Q2D" */
 	if (strncmp(romsig, "CL1   Q", 7))
-		goto unmap;
+		return -ENODEV;
 	if (strncmp(romsig+6, romsig+13, 3)) {
-		printk(KERN_INFO "OLPC BIOS signature looks invalid.  "
+		printk(KERN_INFO "olpc:  BIOS signature looks invalid.  "
 				"Assuming not OLPC\n");
-		goto unmap;
+		return -ENODEV;
 	}
 
-	printk(KERN_INFO "OLPC board with OpenFirmware %.16s\n", romsig);
+	/* Looks like we have OLPC's OFW */
 	olpc_platform_info.flags |= OLPC_F_PRESENT;
+	printk(KERN_INFO "olpc:  board with OpenFirmware %.16s\n", romsig);
+
+	return 0;
+}
+
+static int __init olpc_init(void)
+{
+	spin_lock_init(&ec_lock);
+
+	/* ensure OFW is available */
+	if (ofw_detect())
+		return 0;
 
 	/* get the platform revision */
 	platform_detect();
@@ -248,8 +265,6 @@ static int __init olpc_init(void)
 			olpc_platform_info.boardrev >> 4,
 			olpc_platform_info.ecver);
 
-unmap:
-	iounmap(romsig);
 	return 0;
 }
 
-- 
1.5.4.4



-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
