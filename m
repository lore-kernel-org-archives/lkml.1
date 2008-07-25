Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYGYGil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYGYGil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 02:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYGYGid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 02:38:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57933
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751624AbYGYGic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 02:38:32 -0400
Date: Thu, 24 Jul 2008 23:38:31 -0700 (PDT)
Message-Id: <20080724.233831.193691312.davem@davemloft.net>
To: bzolnier@gmail.com
CC: harvey.harrison@gmail.com, linux-ide@kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: recent IDE regression
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After today's IDE merge my sparc64 workstation stopped booting.

It's due to this change:

commit 7fa897b91a3ea0f16c2873b869d7a0eef05acff4
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Thu Jul 24 22:53:34 2008 +0200

    ide: trivial sparse annotations
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Heh, "trivial", indeed.

Specifically, this part of the change:

diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 07da5fb..8aae917 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -510,10 +510,8 @@ void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
 
 	if (byteswap) {
 		/* convert from big-endian to host byte order */
-		for (p = end ; p != s;) {
-			unsigned short *pp = (unsigned short *) (p -= 2);
-			*pp = ntohs(*pp);
-		}
+		for (p = end ; p != s;)
+			be16_to_cpus((u16 *)(p -= 2));
 	}
 	/* strip leading blanks */
 	while (s != end && *s == ' ')

On big-endian, be16_to_cpus() (via __be16_to_cpus()) is:

	do { } while (0)

which therefore does not evaluate the argument, and thus this loop
will make no forward progress.

Probably the fix is in be16_to_cpus(), making it do something like
"(void) (x);" in the do/while body.

Something like this:

endian: Always evaluate arguments.

Changeset 7fa897b91a3ea0f16c2873b869d7a0eef05acff4
("ide: trivial sparse annotations") created an IDE bootup
regression on big-endian systems.  In drivers/ide/ide-iops.c,
function ide_fixstring() we now have the loop:

		for (p = end ; p != s;)
			be16_to_cpus((u16 *)(p -= 2));

which will never terminate on big-endian because in such
a configuration be16_to_cpus() evaluates to "do { } while (0)"

Therefore, always evaluate the arguments to nop endian transformation
operations.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
index 961ed4b..44f95b9 100644
--- a/include/linux/byteorder/big_endian.h
+++ b/include/linux/byteorder/big_endian.h
@@ -94,12 +94,12 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
 #define __le32_to_cpus(x) __swab32s((x))
 #define __cpu_to_le16s(x) __swab16s((x))
 #define __le16_to_cpus(x) __swab16s((x))
-#define __cpu_to_be64s(x) do {} while (0)
-#define __be64_to_cpus(x) do {} while (0)
-#define __cpu_to_be32s(x) do {} while (0)
-#define __be32_to_cpus(x) do {} while (0)
-#define __cpu_to_be16s(x) do {} while (0)
-#define __be16_to_cpus(x) do {} while (0)
+#define __cpu_to_be64s(x) do { (void)(x); } while (0)
+#define __be64_to_cpus(x) do { (void)(x); } while (0)
+#define __cpu_to_be32s(x) do { (void)(x); } while (0)
+#define __be32_to_cpus(x) do { (void)(x); } while (0)
+#define __cpu_to_be16s(x) do { (void)(x); } while (0)
+#define __be16_to_cpus(x) do { (void)(x); } while (0)
 
 #ifdef __KERNEL__
 #include <linux/byteorder/generic.h>
diff --git a/include/linux/byteorder/little_endian.h b/include/linux/byteorder/little_endian.h
index 05dc7c3..4cc170a 100644
--- a/include/linux/byteorder/little_endian.h
+++ b/include/linux/byteorder/little_endian.h
@@ -88,12 +88,12 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
 {
 	return __swab16p((__u16 *)p);
 }
-#define __cpu_to_le64s(x) do {} while (0)
-#define __le64_to_cpus(x) do {} while (0)
-#define __cpu_to_le32s(x) do {} while (0)
-#define __le32_to_cpus(x) do {} while (0)
-#define __cpu_to_le16s(x) do {} while (0)
-#define __le16_to_cpus(x) do {} while (0)
+#define __cpu_to_le64s(x) do { (void)(x); } while (0)
+#define __le64_to_cpus(x) do { (void)(x); } while (0)
+#define __cpu_to_le32s(x) do { (void)(x); } while (0)
+#define __le32_to_cpus(x) do { (void)(x); } while (0)
+#define __cpu_to_le16s(x) do { (void)(x); } while (0)
+#define __le16_to_cpus(x) do { (void)(x); } while (0)
 #define __cpu_to_be64s(x) __swab64s((x))
 #define __be64_to_cpus(x) __swab64s((x))
 #define __cpu_to_be32s(x) __swab32s((x))
