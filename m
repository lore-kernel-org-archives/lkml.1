Return-Path: <linux-kernel-owner+w=401wt.eu-S1030915AbXAZQzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030915AbXAZQzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030909AbXAZQzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:55:13 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25705 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030910AbXAZQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:55:07 -0500
Date: Fri, 26 Jan 2007 17:55:00 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: jan.glauber@de.ibm.com
Subject: [S390] Support for s390 Pseudo Random Number Generator
Message-ID: <20070126165500.GX11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jan.glauber@de.ibm.com>

[S390] Support for s390 Pseudo Random Number Generator

Starting with the z9 the CPU Cryptographic Assist Facility comes with
an integrated Pseudo Random Number Generator. The generator creates
random numbers by an algorithm similar to the ANSI X9.17 standard.
The pseudo-random numbers can be accessed via a character device driver
node called /dev/prandom. Similar to /dev/urandom any amount of bytes
can be read from the device without blocking.

Signed-off-by: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/crypto/Makefile           |    1 
 arch/s390/crypto/crypt_s390.h       |    1 
 arch/s390/crypto/crypt_s390_query.c |    2 
 arch/s390/crypto/prng.c             |  213 ++++++++++++++++++++++++++++++++++++
 arch/s390/defconfig                 |    1 
 drivers/crypto/Kconfig              |    2 
 include/asm-s390/timex.h            |   12 ++
 7 files changed, 232 insertions(+)

diff -urpN linux-2.6/arch/s390/crypto/crypt_s390.h linux-2.6-patched/arch/s390/crypto/crypt_s390.h
--- linux-2.6/arch/s390/crypto/crypt_s390.h	2007-01-26 17:29:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/crypt_s390.h	2007-01-26 17:29:32.000000000 +0100
@@ -71,6 +71,7 @@ enum crypt_s390_kmc_func {
 	KMC_AES_192_DECRYPT  = CRYPT_S390_KMC | 0x13 | 0x80,
 	KMC_AES_256_ENCRYPT  = CRYPT_S390_KMC | 0x14,
 	KMC_AES_256_DECRYPT  = CRYPT_S390_KMC | 0x14 | 0x80,
+	KMC_PRNG	     = CRYPT_S390_KMC | 0x43,
 };
 
 /*
diff -urpN linux-2.6/arch/s390/crypto/crypt_s390_query.c linux-2.6-patched/arch/s390/crypto/crypt_s390_query.c
--- linux-2.6/arch/s390/crypto/crypt_s390_query.c	2007-01-26 17:29:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/crypt_s390_query.c	2007-01-26 17:29:32.000000000 +0100
@@ -55,6 +55,8 @@ static void query_available_functions(vo
 		crypt_s390_func_available(KMC_AES_192_ENCRYPT));
 	printk(KERN_INFO "KMC_AES_256: %d\n",
 		crypt_s390_func_available(KMC_AES_256_ENCRYPT));
+	printk(KERN_INFO "KMC_PRNG: %d\n",
+		crypt_s390_func_available(KMC_PRNG));
 
 	/* query available KIMD functions */
 	printk(KERN_INFO "KIMD_QUERY: %d\n",
diff -urpN linux-2.6/arch/s390/crypto/Makefile linux-2.6-patched/arch/s390/crypto/Makefile
--- linux-2.6/arch/s390/crypto/Makefile	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/Makefile	2007-01-26 17:29:32.000000000 +0100
@@ -6,5 +6,6 @@ obj-$(CONFIG_CRYPTO_SHA1_S390) += sha1_s
 obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256_s390.o
 obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o des_check_key.o
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
+obj-$(CONFIG_S390_PRNG) += prng.o
 
 obj-$(CONFIG_CRYPTO_TEST) += crypt_s390_query.o
diff -urpN linux-2.6/arch/s390/crypto/prng.c linux-2.6-patched/arch/s390/crypto/prng.c
--- linux-2.6/arch/s390/crypto/prng.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/prng.c	2007-01-26 17:29:32.000000000 +0100
@@ -0,0 +1,213 @@
+/*
+ * Copyright 2006,2007 IBM Corporation
+ * Author(s): Jan Glauber <jan.glauber@de.ibm.com>
+ * Driver for the s390 pseudo random number generator
+ */
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/random.h>
+#include <asm/debug.h>
+#include <asm/uaccess.h>
+
+#include "crypt_s390.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jan Glauber <jan.glauber@de.ibm.com>");
+MODULE_DESCRIPTION("s390 PRNG interface");
+
+static int prng_chunk_size = 256;
+module_param(prng_chunk_size, int, S_IRUSR | S_IRGRP | S_IROTH);
+MODULE_PARM_DESC(prng_chunk_size, "PRNG read chunk size in bytes");
+
+static int prng_entropy_limit = 4096;
+module_param(prng_entropy_limit, int, S_IRUSR | S_IRGRP | S_IROTH | S_IWUSR);
+MODULE_PARM_DESC(prng_entropy_limit,
+	"PRNG add entropy after that much bytes were produced");
+
+/*
+ * Any one who considers arithmetical methods of producing random digits is,
+ * of course, in a state of sin. -- John von Neumann
+ */
+
+struct s390_prng_data {
+	unsigned long count; /* how many bytes were produced */
+	char *buf;
+};
+
+static struct s390_prng_data *p;
+
+/* copied from libica, use a non-zero initial parameter block */
+static unsigned char parm_block[32] = {
+0x0F,0x2B,0x8E,0x63,0x8C,0x8E,0xD2,0x52,0x64,0xB7,0xA0,0x7B,0x75,0x28,0xB8,0xF4,
+0x75,0x5F,0xD2,0xA6,0x8D,0x97,0x11,0xFF,0x49,0xD8,0x23,0xF3,0x7E,0x21,0xEC,0xA0,
+};
+
+static int prng_open(struct inode *inode, struct file *file)
+{
+	return nonseekable_open(inode, file);
+}
+
+static void prng_add_entropy(void)
+{
+	__u64 entropy[4];
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < 16; i++) {
+		ret = crypt_s390_kmc(KMC_PRNG, parm_block, (char *)entropy,
+				     (char *)entropy, sizeof(entropy));
+		BUG_ON(ret < 0 || ret != sizeof(entropy));
+		memcpy(parm_block, entropy, sizeof(entropy));
+	}
+}
+
+static void prng_seed(int nbytes)
+{
+	char buf[16];
+	int i = 0;
+
+	BUG_ON(nbytes > 16);
+	get_random_bytes(buf, nbytes);
+
+	/* Add the entropy */
+	while (nbytes >= 8) {
+		*((__u64 *)parm_block) ^= *((__u64 *)buf+i*8);
+		prng_add_entropy();
+		i += 8;
+		nbytes -= 8;
+	}
+	prng_add_entropy();
+}
+
+static ssize_t prng_read(struct file *file, char __user *ubuf, size_t nbytes,
+			 loff_t *ppos)
+{
+	int chunk, n;
+	int ret = 0;
+	int tmp;
+
+	/* nbytes can be arbitrary long, we spilt it into chunks */
+	while (nbytes) {
+		/* same as in extract_entropy_user in random.c */
+		if (need_resched()) {
+			if (signal_pending(current)) {
+				if (ret == 0)
+					ret = -ERESTARTSYS;
+				break;
+			}
+			schedule();
+		}
+
+		/*
+		 * we lose some random bytes if an attacker issues
+		 * reads < 8 bytes, but we don't care
+		 */
+		chunk = min_t(int, nbytes, prng_chunk_size);
+
+		/* PRNG only likes multiples of 8 bytes */
+		n = (chunk + 7) & -8;
+
+		if (p->count > prng_entropy_limit)
+			prng_seed(8);
+
+		/* if the CPU supports PRNG stckf is present too */
+		asm volatile(".insn     s,0xb27c0000,%0"
+			     : "=m" (*((unsigned long long *)p->buf)) : : "cc");
+
+		/*
+		 * Beside the STCKF the input for the TDES-EDE is the output
+		 * of the last operation. We differ here from X9.17 since we
+		 * only store one timestamp into the buffer. Padding the whole
+		 * buffer with timestamps does not improve security, since
+		 * successive stckf have nearly constant offsets.
+		 * If an attacker knows the first timestamp it would be
+		 * trivial to guess the additional values. One timestamp
+		 * is therefore enough and still guarantees unique input values.
+		 *
+		 * Note: you can still get strict X9.17 conformity by setting
+		 * prng_chunk_size to 8 bytes.
+		*/
+		tmp = crypt_s390_kmc(KMC_PRNG, parm_block, p->buf, p->buf, n);
+		BUG_ON((tmp < 0) || (tmp != n));
+
+		p->count += n;
+
+		if (copy_to_user(ubuf, p->buf, chunk))
+			return -EFAULT;
+
+		nbytes -= chunk;
+		ret += chunk;
+		ubuf += chunk;
+	}
+	return ret;
+}
+
+static struct file_operations prng_fops = {
+	.owner		= THIS_MODULE,
+	.open		= &prng_open,
+	.release	= NULL,
+	.read		= &prng_read,
+};
+
+static struct miscdevice prng_dev = {
+	.name	= "prandom",
+	.minor	= MISC_DYNAMIC_MINOR,
+	.fops	= &prng_fops,
+};
+
+static int __init prng_init(void)
+{
+	int ret;
+
+	/* check if the CPU has a PRNG */
+	if (!crypt_s390_func_available(KMC_PRNG))
+		return -ENOTSUPP;
+
+	if (prng_chunk_size < 8)
+		return -EINVAL;
+
+	p = kmalloc(sizeof(struct s390_prng_data), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+	p->count = 0;
+
+	p->buf = kmalloc(prng_chunk_size, GFP_KERNEL);
+	if (!p->buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	/* initialize the PRNG, add 128 bits of entropy */
+	prng_seed(16);
+
+	ret = misc_register(&prng_dev);
+	if (ret) {
+		printk(KERN_WARNING
+		       "Could not register misc device for PRNG.\n");
+		goto out_buf;
+	}
+	return 0;
+
+out_buf:
+	kfree(p->buf);
+out_free:
+	kfree(p);
+	return ret;
+}
+
+static void __exit prng_exit(void)
+{
+	/* wipe me */
+	memset(p->buf, 0, prng_chunk_size);
+	kfree(p->buf);
+	kfree(p);
+
+	misc_deregister(&prng_dev);
+}
+
+module_init(prng_init);
+module_exit(prng_exit);
diff -urpN linux-2.6/arch/s390/defconfig linux-2.6-patched/arch/s390/defconfig
--- linux-2.6/arch/s390/defconfig	2007-01-26 17:29:31.000000000 +0100
+++ linux-2.6-patched/arch/s390/defconfig	2007-01-26 17:29:32.000000000 +0100
@@ -756,6 +756,7 @@ CONFIG_CRYPTO_CBC=y
 # CONFIG_CRYPTO_SHA256_S390 is not set
 # CONFIG_CRYPTO_DES_S390 is not set
 # CONFIG_CRYPTO_AES_S390 is not set
+CONFIG_S390_PRNG=m
 
 #
 # Library routines
diff -urpN linux-2.6/drivers/crypto/Kconfig linux-2.6-patched/drivers/crypto/Kconfig
--- linux-2.6/drivers/crypto/Kconfig	2007-01-26 17:27:28.000000000 +0100
+++ linux-2.6-patched/drivers/crypto/Kconfig	2007-01-26 17:29:32.000000000 +0100
@@ -51,6 +51,8 @@ config CRYPTO_DEV_PADLOCK_SHA
 	  If unsure say M. The compiled module will be
 	  called padlock-sha.ko
 
+source "arch/s390/crypto/Kconfig"
+
 config CRYPTO_DEV_GEODE
 	tristate "Support for the Geode LX AES engine"
 	depends on CRYPTO && X86_32 && PCI
diff -urpN linux-2.6/include/asm-s390/timex.h linux-2.6-patched/include/asm-s390/timex.h
--- linux-2.6/include/asm-s390/timex.h	2007-01-26 17:29:32.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/timex.h	2007-01-26 17:29:32.000000000 +0100
@@ -62,6 +62,18 @@ static inline unsigned long long get_clo
 	return clk;
 }
 
+static inline void get_clock_extended(void *dest)
+{
+	typedef struct { unsigned long long clk[2]; } __clock_t;
+
+#if __GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ > 2)
+	asm volatile("stcke %0" : "=Q" (*((__clock_t *)dest)) : : "cc");
+#else /* __GNUC__ */
+	asm volatile("stcke 0(%1)" : "=m" (*((__clock_t *)dest))
+				   : "a" ((__clock_t *)dest) : "cc");
+#endif /* __GNUC__ */
+}
+
 static inline cycles_t get_cycles(void)
 {
 	return (cycles_t) get_clock() >> 2;
