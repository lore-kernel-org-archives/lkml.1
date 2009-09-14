Return-Path: <linux-kernel-owner+w=401wt.eu-S933722AbZINULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbZINULd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933598AbZINUJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54172 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933556AbZINUJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:03 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 61/72] Blackfin: add some isram-driver self tests
Date: Mon, 14 Sep 2009 16:08:05 -0400
Message-Id: <1252958896-25150-62-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easy to figure out if code changes here are correct.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig.debug     |    6 +
 arch/blackfin/mm/isram-driver.c |  212 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 216 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/Kconfig.debug b/arch/blackfin/Kconfig.debug
index 1fc4981..87f195e 100644
--- a/arch/blackfin/Kconfig.debug
+++ b/arch/blackfin/Kconfig.debug
@@ -252,4 +252,10 @@ config ACCESS_CHECK
 
 	  Say N here to disable that check to improve the performance.
 
+config BFIN_ISRAM_SELF_TEST
+	bool "isram boot self tests"
+	default n
+	help
+	  Run some self tests of the isram driver code at boot.
+
 endmenu
diff --git a/arch/blackfin/mm/isram-driver.c b/arch/blackfin/mm/isram-driver.c
index c080e70..02eaaa6 100644
--- a/arch/blackfin/mm/isram-driver.c
+++ b/arch/blackfin/mm/isram-driver.c
@@ -16,6 +16,8 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#define pr_fmt(fmt) "isram: " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -23,6 +25,7 @@
 #include <linux/sched.h>
 
 #include <asm/blackfin.h>
+#include <asm/dma.h>
 
 /*
  * IMPORTANT WARNING ABOUT THESE FUNCTIONS
@@ -127,8 +130,7 @@ static bool isram_check_addr(const void *addr, size_t n)
 	    (addr < (void *)(L1_CODE_START + L1_CODE_LENGTH))) {
 		if ((addr + n) > (void *)(L1_CODE_START + L1_CODE_LENGTH)) {
 			show_stack(NULL, NULL);
-			printk(KERN_ERR "isram_memcpy: copy involving %p length "
-					"(%zu) too long\n", addr, n);
+			pr_err("copy involving %p length (%zu) too long\n", addr, n);
 		}
 		return true;
 	}
@@ -199,3 +201,209 @@ void *isram_memcpy(void *dest, const void *src, size_t n)
 }
 EXPORT_SYMBOL(isram_memcpy);
 
+#ifdef CONFIG_BFIN_ISRAM_SELF_TEST
+
+#define TEST_LEN 0x100
+
+static __init void hex_dump(unsigned char *buf, int len)
+{
+	while (len--)
+		pr_cont("%02x", *buf++);
+}
+
+static __init int isram_read_test(char *sdram, void *l1inst)
+{
+	int i, ret = 0;
+	uint64_t data1, data2;
+
+	pr_info("INFO: running isram_read tests\n");
+
+	/* setup some different data to play with */
+	for (i = 0; i < TEST_LEN; ++i)
+		sdram[i] = i;
+	dma_memcpy(l1inst, sdram, TEST_LEN);
+
+	/* make sure we can read the L1 inst */
+	for (i = 0; i < TEST_LEN; i += sizeof(uint64_t)) {
+		data1 = isram_read(l1inst + i);
+		memcpy(&data2, sdram + i, sizeof(data2));
+		if (memcmp(&data1, &data2, sizeof(uint64_t))) {
+			pr_err("FAIL: isram_read(%p) returned %#llx but wanted %#llx\n",
+				l1inst + i, data1, data2);
+			++ret;
+		}
+	}
+
+	return ret;
+}
+
+static __init int isram_write_test(char *sdram, void *l1inst)
+{
+	int i, ret = 0;
+	uint64_t data1, data2;
+
+	pr_info("INFO: running isram_write tests\n");
+
+	/* setup some different data to play with */
+	memset(sdram, 0, TEST_LEN * 2);
+	dma_memcpy(l1inst, sdram, TEST_LEN);
+	for (i = 0; i < TEST_LEN; ++i)
+		sdram[i] = i;
+
+	/* make sure we can write the L1 inst */
+	for (i = 0; i < TEST_LEN; i += sizeof(uint64_t)) {
+		memcpy(&data1, sdram + i, sizeof(data1));
+		isram_write(l1inst + i, data1);
+		data2 = isram_read(l1inst + i);
+		if (memcmp(&data1, &data2, sizeof(uint64_t))) {
+			pr_err("FAIL: isram_write(%p, %#llx) != %#llx\n",
+				l1inst + i, data1, data2);
+			++ret;
+		}
+	}
+
+	dma_memcpy(sdram + TEST_LEN, l1inst, TEST_LEN);
+	if (memcmp(sdram, sdram + TEST_LEN, TEST_LEN)) {
+		pr_err("FAIL: isram_write() did not work properly\n");
+		++ret;
+	}
+
+	return ret;
+}
+
+static __init int
+_isram_memcpy_test(char pattern, void *sdram, void *l1inst, const char *smemcpy,
+                   void *(*fmemcpy)(void *, const void *, size_t))
+{
+	memset(sdram, pattern, TEST_LEN);
+	fmemcpy(l1inst, sdram, TEST_LEN);
+	fmemcpy(sdram + TEST_LEN, l1inst, TEST_LEN);
+	if (memcmp(sdram, sdram + TEST_LEN, TEST_LEN)) {
+		pr_err("FAIL: %s(%p <=> %p, %#x) failed (data is %#x)\n",
+			smemcpy, l1inst, sdram, TEST_LEN, pattern);
+		return 1;
+	}
+	return 0;
+}
+#define _isram_memcpy_test(a, b, c, d) _isram_memcpy_test(a, b, c, #d, d)
+
+static __init int isram_memcpy_test(char *sdram, void *l1inst)
+{
+	int i, j, thisret, ret = 0;
+
+	/* check broad isram_memcpy() */
+	pr_info("INFO: running broad isram_memcpy tests\n");
+	for (i = 0xf; i >= 0; --i)
+		ret += _isram_memcpy_test(i, sdram, l1inst, isram_memcpy);
+
+	/* check read of small, unaligned, and hardware 64bit limits */
+	pr_info("INFO: running isram_memcpy (read) tests\n");
+
+	for (i = 0; i < TEST_LEN; ++i)
+		sdram[i] = i;
+	dma_memcpy(l1inst, sdram, TEST_LEN);
+
+	thisret = 0;
+	for (i = 0; i < TEST_LEN - 32; ++i) {
+		unsigned char cmp[32];
+		for (j = 1; j <= 32; ++j) {
+			memset(cmp, 0, sizeof(cmp));
+			isram_memcpy(cmp, l1inst + i, j);
+			if (memcmp(cmp, sdram + i, j)) {
+				pr_err("FAIL: %p:", l1inst + 1);
+				hex_dump(cmp, j);
+				pr_cont(" SDRAM:");
+				hex_dump(sdram + i, j);
+				pr_cont("\n");
+				if (++thisret > 20) {
+					pr_err("FAIL: skipping remaining series\n");
+					i = TEST_LEN;
+					break;
+				}
+			}
+		}
+	}
+	ret += thisret;
+
+	/* check write of small, unaligned, and hardware 64bit limits */
+	pr_info("INFO: running isram_memcpy (write) tests\n");
+
+	memset(sdram + TEST_LEN, 0, TEST_LEN);
+	dma_memcpy(l1inst, sdram + TEST_LEN, TEST_LEN);
+
+	thisret = 0;
+	for (i = 0; i < TEST_LEN - 32; ++i) {
+		unsigned char cmp[32];
+		for (j = 1; j <= 32; ++j) {
+			isram_memcpy(l1inst + i, sdram + i, j);
+			dma_memcpy(cmp, l1inst + i, j);
+			if (memcmp(cmp, sdram + i, j)) {
+				pr_err("FAIL: %p:", l1inst + i);
+				hex_dump(cmp, j);
+				pr_cont(" SDRAM:");
+				hex_dump(sdram + i, j);
+				pr_cont("\n");
+				if (++thisret > 20) {
+					pr_err("FAIL: skipping remaining series\n");
+					i = TEST_LEN;
+					break;
+				}
+			}
+		}
+	}
+	ret += thisret;
+
+	return ret;
+}
+
+static __init int isram_test_init(void)
+{
+	int ret;
+	char *sdram;
+	void *l1inst;
+
+	sdram = kmalloc(TEST_LEN * 2, GFP_KERNEL);
+	if (!sdram) {
+		pr_warning("SKIP: could not allocate sdram\n");
+		return 0;
+	}
+
+	l1inst = l1_inst_sram_alloc(TEST_LEN);
+	if (!l1inst) {
+		kfree(sdram);
+		pr_warning("SKIP: could not allocate L1 inst\n");
+		return 0;
+	}
+
+	/* sanity check initial L1 inst state */
+	ret = 1;
+	pr_info("INFO: running initial dma_memcpy checks\n");
+	if (_isram_memcpy_test(0xa, sdram, l1inst, dma_memcpy))
+		goto abort;
+	if (_isram_memcpy_test(0x5, sdram, l1inst, dma_memcpy))
+		goto abort;
+
+	ret = 0;
+	ret += isram_read_test(sdram, l1inst);
+	ret += isram_write_test(sdram, l1inst);
+	ret += isram_memcpy_test(sdram, l1inst);
+
+ abort:
+	sram_free(l1inst);
+	kfree(sdram);
+
+	if (ret)
+		return -EIO;
+
+	pr_info("PASS: all tests worked !\n");
+	return 0;
+}
+late_initcall(isram_test_init);
+
+static __exit void isram_test_exit(void)
+{
+	/* stub to allow unloading */
+}
+module_exit(isram_test_exit);
+
+#endif
-- 
1.6.4.2

