Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYIWWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYIWWU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYIWWUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:20:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:43683 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYIWWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bEdipnDL5hHmJXdbi/D9P8ljmWjwh9BfOO5JUQJuKMTNmoW+9sNRGAi59y3vJrUrzD
         nr4T0awN1IFgRdTLzPCTEK+LW09XW6qiJJSKux2x/2jUfsjI1FjjPdWxGTawPrA14Iz3
         HzD5MQtUG560EOW2IeGumB/m71/wWQbbrxqLk=
Subject: [PATCH] olpc: fix endian bug in openfirmware workaround
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 15:20:09 -0700
Message-Id: <1222208409.16003.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boardrev is always treated as a u32 everywhere else, no reason to
byteswap the 0xc2 value.  The only use is to print out if it is
a prerelease board, the test being:

(olpc_platform_info.boardrev & 0xf) < 8

Which is currently always true as be32_to_cpu(0xc2) & 0xf = 0
but I doubt that was the intention here.  The consequences of the bug
are pretty minor though (incorrect boardrev displayed in dmesg when
ofw support not configured)

Also annotate the temporary used to read the boardrev in the ofw
case.

The confusion was noticed by sparse:
arch/x86/kernel/olpc.c:206:32: warning: cast to restricted __be32

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/olpc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 3e66722..7a13fac 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -190,12 +190,12 @@ EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 static void __init platform_detect(void)
 {
 	size_t propsize;
-	u32 rev;
+	__be32 rev;
 
 	if (ofw("getprop", 4, 1, NULL, "board-revision-int", &rev, 4,
 			&propsize) || propsize != 4) {
 		printk(KERN_ERR "ofw: getprop call failed!\n");
-		rev = 0;
+		rev = cpu_to_be32(0);
 	}
 	olpc_platform_info.boardrev = be32_to_cpu(rev);
 }
@@ -203,7 +203,7 @@ static void __init platform_detect(void)
 static void __init platform_detect(void)
 {
 	/* stopgap until OFW support is added to the kernel */
-	olpc_platform_info.boardrev = be32_to_cpu(0xc2);
+	olpc_platform_info.boardrev = 0xc2;
 }
 #endif
 
-- 
1.6.0.2.471.g47a76



