Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbZFXNeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbZFXNeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759484AbZFXNbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:31:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37996 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759396AbZFXNbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:31:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] add checksum selftest
Date: Wed, 24 Jun 2009 09:31:29 -0400
Message-Id: <1245850289-6673-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start a checksum internal testsuite for arch porters and people mucking
about in the checksum code -- regressions are bad.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Arnd: i've tested this on my Blackfin and it seems to work ... can you
check for any places i missed little endian swapping ?

 lib/Kconfig.debug       |    9 ++
 lib/Makefile            |    1 +
 lib/checksum-selftest.c |  292 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/checksum.c          |    2 +-
 4 files changed, 303 insertions(+), 1 deletions(-)
 create mode 100644 lib/checksum-selftest.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4c32b1a..c5cb167 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -631,6 +631,15 @@ config DEBUG_SG
 
 	  If unsure, say N.
 
+config CHECKSUM_SELFTEST
+	bool "Checksum boot-time self-tests"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here if you want the kernel to run a short self-test at boot.
+	  The self-test checks whether the networking checksum functions are
+	  operating as expected.  Useful if you are trying to implement your
+	  own optimized replacements for the generic code.
+
 config DEBUG_NOTIFIERS
 	bool "Debug notifier call chains"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index b6d1857..fde861c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_NLATTR) += nlattr.o
 obj-$(CONFIG_DMA_API_DEBUG) += dma-debug.o
 
 obj-$(CONFIG_GENERIC_CSUM) += checksum.o
+obj-$(CONFIG_CHECKSUM_SELFTEST) += checksum-selftest.o
 
 obj-$(CONFIG_GENERIC_ATOMIC64) += atomic64.o
 
diff --git a/lib/checksum-selftest.c b/lib/checksum-selftest.c
new file mode 100644
index 0000000..8cf5194
--- /dev/null
+++ b/lib/checksum-selftest.c
@@ -0,0 +1,292 @@
+/*
+ * Networking checksum self checks.
+ *
+ * Licensed under the GPL-2.
+ */
+
+/*
+ * The test vectors here are encoded in little endian format.  We do byte
+ * swapping below at runtime as needed to get the right comparison value.
+ */
+
+#define pr_fmt(fmt) "csum-selftest: " fmt
+
+#include <linux/kernel.h>
+#include <net/checksum.h>
+#include <asm/byteorder.h>
+
+
+/*
+ * The do_csum() interface is "internal" to the generic checksum code.
+ * Do not require it if the arch has not switched over.
+ */
+extern unsigned short do_csum(const unsigned char *buff, int len);
+
+struct do_csum_data {
+	unsigned short ret;
+	unsigned char *buff;
+	int len;
+};
+#define DO_CSUM_DATA(_num, _ret) \
+{ \
+	.ret = _ret, \
+	.buff = do_csum_data##_num, \
+	.len = ARRAY_SIZE(do_csum_data##_num), \
+}
+static unsigned char __initdata do_csum_data1[] = {
+	0x20,
+};
+static unsigned char __initdata do_csum_data2[] = {
+	0x0d, 0x0a,
+};
+static unsigned char __initdata do_csum_data3[] = {
+	0xff, 0xfb, 0x01,
+};
+static unsigned char __initdata do_csum_data4[] = {
+	0x63, 0x68, 0x65, 0x64,
+};
+static unsigned char __initdata do_csum_data5[] = {
+	0x67, 0x72, 0x5d, 0x0d, 0x00,
+};
+static unsigned char __initdata do_csum_data6[] = {
+	0x20, 0x20, 0x31, 0x30, 0x38, 0x20
+};
+static unsigned char __initdata do_csum_data7[] = {
+	0x20, 0x20, 0x20, 0x35, 0x37, 0x20, 0x20,
+};
+static unsigned char __initdata do_csum_data8[] = {
+	0x00, 0x00, 0x00, 0x00, 0x7f, 0x0f, 0x00, 0x02,
+};
+static unsigned char __initdata do_csum_data9[] = {
+	0x20, 0x20, 0x31, 0x31, 0x34, 0x20, 0x20, 0x20, 0x31,
+};
+static unsigned char __initdata do_csum_data10[] = {
+	0xd, 0xa, 0x72, 0x6f, 0x6f, 0x74, 0x3a, 0x2f, 0x3e, 0x20
+};
+static unsigned char __initdata do_csum_data255[] = {
+	0x20, 0x34, 0x34, 0x34, 0x20, 0x53, 0x20, 0x20, 0x20, 0x20, 0x2d,
+	0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x73, 0x68, 0x20, 0x0d, 0x0a, 0x20,
+	0x20, 0x31, 0x30, 0x35, 0x20, 0x72, 0x6f, 0x6f, 0x74, 0x20, 0x20,
+	0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x34, 0x34, 0x20, 0x53, 0x20,
+	0x20, 0x20, 0x20, 0x2f, 0x73, 0x62, 0x69, 0x6e, 0x2f, 0x69, 0x6e,
+	0x65, 0x74, 0x64, 0x20, 0x0d, 0x0a, 0x20, 0x20, 0x31, 0x30, 0x36,
+	0x20, 0x72, 0x6f, 0x6f, 0x74, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x34, 0x33, 0x36, 0x20, 0x53, 0x20, 0x20, 0x20, 0x20, 0x2f,
+	0x73, 0x62, 0x69, 0x6e, 0x2f, 0x73, 0x79, 0x73, 0x6c, 0x6f, 0x67,
+	0x64, 0x20, 0x2d, 0x6e, 0x20, 0x0d, 0x0a, 0x20, 0x20, 0x31, 0x30,
+	0x37, 0x20, 0x72, 0x6f, 0x6f, 0x74, 0x20, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x34, 0x33, 0x32, 0x20, 0x52, 0x20, 0x20, 0x20, 0x20,
+	0x2f, 0x73, 0x62, 0x69, 0x6e, 0x2f, 0x6b, 0x6c, 0x6f, 0x67, 0x64,
+	0x20, 0x2d, 0x6e, 0x20, 0x0d, 0x0a, 0x20, 0x20, 0x31, 0x30, 0x38,
+	0x20, 0x72, 0x6f, 0x6f, 0x74, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x33, 0x32, 0x20, 0x53, 0x20, 0x20, 0x20, 0x20, 0x2f,
+	0x62, 0x69, 0x6e, 0x2f, 0x77, 0x61, 0x74, 0x63, 0x68, 0x64, 0x6f,
+	0x67, 0x64, 0x20, 0x2d, 0x66, 0x20, 0x2d, 0x73, 0x20, 0x0d, 0x0a,
+	0x20, 0x20, 0x31, 0x30, 0x39, 0x20, 0x72, 0x6f, 0x6f, 0x74, 0x20,
+	0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x35, 0x36, 0x20, 0x52,
+	0x20, 0x20, 0x20, 0x20, 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x74, 0x65,
+	0x6c, 0x6e, 0x65, 0x74, 0x64, 0x20, 0x0d, 0x0a, 0x20, 0x20, 0x31,
+	0x31, 0x30, 0x20, 0x72, 0x6f, 0x6f, 0x74, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20
+};
+static struct do_csum_data __initdata do_csum_data[] = {
+	DO_CSUM_DATA(1, 0x0020),
+	DO_CSUM_DATA(2, 0x0a0d),
+	DO_CSUM_DATA(3, 0xfc00),
+	DO_CSUM_DATA(4, 0xccc8),
+	DO_CSUM_DATA(5, 0x7fc4),
+	DO_CSUM_DATA(6, 0x7089),
+	DO_CSUM_DATA(7, 0x7597),
+	DO_CSUM_DATA(8, 0x117f),
+	DO_CSUM_DATA(9, 0x91d6),
+	DO_CSUM_DATA(10, 0x3d67),
+	DO_CSUM_DATA(255, 0x4f96),
+};
+
+static int __init do_csum_selftest(void)
+{
+	int i, ret;
+	unsigned short tret, eret;
+
+	ret = 0;
+	for (i = 0; i < ARRAY_SIZE(do_csum_data); ++i) {
+		unsigned char *buff = do_csum_data[i].buff;
+		int len = do_csum_data[i].len;
+		int hret = le16_to_cpu(do_csum_data[i].ret);
+
+#ifdef CONFIG_GENERIC_CSUM
+		eret = hret;
+		tret = do_csum(buff, len);
+		if (tret != eret) {
+			pr_err("%s: (d_c) test %i: %#x != %#x: FAIL\n",
+				__func__, i, tret, eret);
+			ret = 1;
+		}
+#endif
+
+		eret = ~hret;
+		tret = ip_compute_csum(buff, len);
+		if (tret != eret) {
+			pr_err("%s: (i_c_c) test %i: %#x != %#x: FAIL\n",
+				__func__, i, tret, eret);
+			ret = 1;
+		}
+
+		if (len % 4 == 0) {
+			eret = ~hret;
+			tret = ip_fast_csum(buff, len / 4);
+			if (tret != eret) {
+				pr_err("%s: (i_f_c) test %i: %#x != %#x: FAIL\n",
+					__func__, i, tret, eret);
+				ret = 1;
+			}
+		}
+	}
+
+	return ret;
+}
+
+
+struct csum_partial_data {
+	__wsum ret;
+	const void *buff;
+	int len;
+	__wsum wsum;
+};
+#define CSUM_PARTIAL_DATA(_num, _ret, _wsum) \
+{ \
+	.ret = _ret, \
+	.buff = csum_partial_data##_num, \
+	.len = ARRAY_SIZE(csum_partial_data##_num), \
+	.wsum = _wsum, \
+}
+static unsigned char __initdata csum_partial_data1[] = {
+	0x74,
+};
+static unsigned char __initdata csum_partial_data2[] = {
+	0x0d, 0x0a,
+};
+static unsigned char __initdata csum_partial_data3[] = {
+	0xff, 0xfd, 0x01,
+};
+static unsigned char __initdata csum_partial_data5[] = {
+	0x20, 0x20, 0x31, 0x30, 0x33,
+};
+static unsigned char __initdata csum_partial_data8[] = {
+	0x8b, 0xd1, 0x89, 0x13, 0x00, 0x08, 0x69, 0x97,
+};
+static unsigned char __initdata csum_partial_data8b[] = {
+	0x3, 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+};
+static unsigned char __initdata csum_partial_data9[] = {
+	0xb6, 0xf9, 0x89, 0x13, 0x0, 0x9, 0x3e, 0x6d, 0x0,
+};
+static struct csum_partial_data __initdata csum_partial_data[] = {
+	CSUM_PARTIAL_DATA(1,  0x00000074, 0x0),
+	CSUM_PARTIAL_DATA(2,  0x00000a0d, 0x0),
+	CSUM_PARTIAL_DATA(3,  0x0000fe00, 0x0),
+	CSUM_PARTIAL_DATA(5,  0x00005084, 0x0),
+	CSUM_PARTIAL_DATA(8,  0x1101eefe, 0x11016a80),
+	CSUM_PARTIAL_DATA(8b, 0x00008781, 0x847e),
+	CSUM_PARTIAL_DATA(9,  0x1101eefe, 0x11016b80),
+};
+
+static unsigned char __initdata csum_partial_scratch[1024];
+static int __init csum_partial_selftest(void)
+{
+	int i, ret;
+	unsigned short tret, eret;
+
+	ret = 0;
+	for (i = 0; i < ARRAY_SIZE(csum_partial_data); ++i) {
+		const unsigned char *buff = csum_partial_data[i].buff;
+		int len = csum_partial_data[i].len;
+		__wsum wsum = csum_partial_data[i].wsum;
+		eret = le16_to_cpu(csum_partial_data[i].ret);
+
+		tret = csum_partial(buff, len, wsum);
+		if (tret != eret) {
+			pr_err("%s: (c_p) test %i: %#x != %#x: FAIL\n",
+				__func__, i, tret, eret);
+			ret = 1;
+		}
+
+		tret = csum_partial_copy(buff, csum_partial_scratch, len, wsum);
+		if (tret != eret) {
+			pr_err("%s: (c_p_c) test %i: %#x != %#x: FAIL\n",
+				__func__, i, tret, eret);
+			ret = 1;
+		}
+	}
+
+	return ret;
+}
+
+
+struct csum_tcpudp_nofold_data {
+	__wsum ret;
+	__be32 saddr;
+	__be32 daddr;
+	unsigned short len;
+	unsigned short proto;
+	__wsum sum;
+};
+#define C_T_N_D(_ret, _saddr, _daddr, _len, _proto, _sum) \
+{ \
+	.ret = _ret, \
+	.saddr = _saddr, \
+	.daddr = _daddr, \
+	.len = _len, \
+	.proto = _proto, \
+	.sum = _sum, \
+}
+static struct csum_tcpudp_nofold_data __initdata csum_tcpudp_nofold_data[] = {
+	C_T_N_D(0x11016a80, 0x0200a8c0, 0x0f00a8c0, 0x008, 0x11, 0x00000),
+	C_T_N_D(0x11016b80, 0x0200a8c0, 0x0f00a8c0, 0x009, 0x11, 0x00000),
+	C_T_N_D(0x1101da80, 0x0200a8c0, 0x0f00a8c0, 0x078, 0x11, 0x00000),
+	C_T_N_D(0x11050180, 0x0200a8c0, 0x0f00a8c0, 0x39f, 0x11, 0x00000),
+	C_T_N_D(0x11017d4c, 0x0f00a8c0, 0x0200a8c0, 0x020, 0x06, 0x005cc),
+	C_T_N_D(0x11027185, 0x0f00a8c0, 0x0200a8c0, 0x028, 0x06, 0x0f205),
+	C_T_N_D(0x11032bc2, 0x0f00a8c0, 0x0200a8c0, 0x035, 0x06, 0x19f42),
+	C_T_N_D(0x11019280, 0x0200a8c0, 0x0f00a8c0, 0x03b, 0x06, 0x00000),
+	C_T_N_D(0x11041290, 0x0f00a8c0, 0x0200a8c0, 0x11f, 0x06, 0x19c10),
+};
+
+static int __init csum_tcpudp_nofold_selftest(void)
+{
+	int i, ret;
+	unsigned short tret, eret;
+
+	ret = 0;
+	for (i = 0; i < ARRAY_SIZE(csum_tcpudp_nofold_data); ++i) {
+		eret = le16_to_cpu(csum_tcpudp_nofold_data[i].ret);
+		tret = csum_tcpudp_nofold(
+			csum_tcpudp_nofold_data[i].saddr,
+			csum_tcpudp_nofold_data[i].daddr,
+			csum_tcpudp_nofold_data[i].len,
+			csum_tcpudp_nofold_data[i].proto,
+			csum_tcpudp_nofold_data[i].sum);
+		if (tret != eret) {
+			pr_err("%s: test %i: %#x != %#x: FAIL\n",
+				__func__, i, tret, eret);
+			ret = 1;
+		}
+	}
+
+	return ret;
+}
+
+
+static int __init csum_selftest_init(void)
+{
+	int ret =
+		do_csum_selftest() +
+		csum_partial_selftest() +
+		csum_tcpudp_nofold_selftest();
+
+	if (!ret)
+		pr_info("all tests passed!\n");
+
+	return 0;
+}
+module_init(csum_selftest_init);
diff --git a/lib/checksum.c b/lib/checksum.c
index 45c9c93..bebfab2 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -46,7 +46,7 @@ static inline unsigned short from32to16(unsigned long x)
 	return x;
 }
 
-static unsigned int do_csum(const unsigned char *buff, int len)
+unsigned int do_csum(const unsigned char *buff, int len)
 {
 	int odd, count;
 	unsigned long result = 0;
-- 
1.6.3.3

