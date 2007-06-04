Return-Path: <linux-kernel-owner+w=401wt.eu-S1762504AbXFDWev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762504AbXFDWev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760347AbXFDWeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:34:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:33855 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761985AbXFDWeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:34:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="253155521"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm patch] the ASYNC_* options shouldn't be user visible
Date: Mon, 4 Jun 2007 15:34:03 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201F037B2@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070604192000.GZ5500@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm patch] the ASYNC_* options shouldn't be user visible
Thread-Index: Acem3Vj08avhLg+DSw6hDM81k3+LJAAEHfEA
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>, <neilb@suse.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Jun 2007 22:34:04.0723 (UTC) FILETIME=[74EE6830:01C7A6F8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Adrian Bunk [mailto:bunk@stusta.de]
> > One caveat with this... md.o needs xor.o to be initialized first.
> > Moving xor.o under lib/ means this assumption is broken since the
> > top-level Makefile puts 'libs' after 'drivers'.
> >...
> 
> What about using a different initcall level?
> 
> Depending on the link order is not such a good idea.
> 

Ok I have added the following to the md-accel-linus git series.  Note
the patch is outlook damaged.

---
xor: make 'xor_blocks' a library routine for use with async_tx

From: Dan Williams <dan.j.williams@intel.com>

* move drivers/md/xor.c => crypto/xor.c
* rename xor_block => xor_blocks, suggested by Adrian Bunk
* ensure that xor.o initializes before md.o in the built-in case

Cc: NeilBrown <neilb@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/Kconfig               |    6 ++++++
 crypto/Makefile              |    6 ++++++
 {drivers/md => crypto}/xor.c |   17 +++++++++--------
 drivers/md/Kconfig           |    1 +
 drivers/md/Makefile          |    4 ++--
 drivers/md/md.c              |    2 +-
 drivers/md/raid5.c           |   10 +++++-----
 include/linux/raid/xor.h     |    2 +-
 8 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4ca0ab3..a12a926 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -9,6 +9,12 @@ config CRYPTO
 	help
 	  This option provides the core Cryptographic API.
 
+#
+# Generic algorithms support
+#
+config XOR_BLOCKS
+	tristate
+
 if CRYPTO
 
 config CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index cce46a1..68e934b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -50,3 +50,9 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
+
+#
+# generic algorithms and the async_tx api
+#
+obj-$(CONFIG_XOR_BLOCKS) += xor.o
+
diff --git a/drivers/md/xor.c b/crypto/xor.c
similarity index 87%
rename from drivers/md/xor.c
rename to crypto/xor.c
index 324897c..0bc3c2c 100644
--- a/drivers/md/xor.c
+++ b/crypto/xor.c
@@ -26,7 +26,7 @@
 static struct xor_block_template *active_template;
 
 void
-xor_block(unsigned int count, unsigned int bytes, void **ptr)
+xor_blocks(unsigned int count, unsigned int bytes, void **ptr)
 {
 	unsigned long *p0, *p1, *p2, *p3, *p4;
 
@@ -96,14 +96,14 @@ do_xor_speed(struct xor_block_template *tmpl, void
*b1, void *b2)
 }
 
 static int
-calibrate_xor_block(void)
+calibrate_xor_blocks(void)
 {
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
 	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
 	if (! b1) {
-		printk("raid5: Yikes!  No memory available.\n");
+		printk("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
@@ -122,11 +122,11 @@ calibrate_xor_block(void)
 #define xor_speed(templ)	do_xor_speed((templ), b1, b2)
 
 	if (fastest) {
-		printk(KERN_INFO "raid5: automatically using best
checksumming function: %s\n",
+		printk(KERN_INFO "xor: automatically using best
checksumming function: %s\n",
 			fastest->name);
 		xor_speed(fastest);
 	} else {
-		printk(KERN_INFO "raid5: measuring checksumming
speed\n");
+		printk(KERN_INFO "xor: measuring checksumming speed\n");
 		XOR_TRY_TEMPLATES;
 		fastest = template_list;
 		for (f = fastest; f; f = f->next)
@@ -134,7 +134,7 @@ calibrate_xor_block(void)
 				fastest = f;
 	}
 
-	printk("raid5: using function: %s (%d.%03d MB/sec)\n",
+	printk("xor: using function: %s (%d.%03d MB/sec)\n",
 	       fastest->name, fastest->speed / 1000, fastest->speed %
1000);
 
 #undef xor_speed
@@ -147,8 +147,9 @@ calibrate_xor_block(void)
 
 static __exit void xor_exit(void) { }
 
-EXPORT_SYMBOL(xor_block);
+EXPORT_SYMBOL(xor_blocks);
 MODULE_LICENSE("GPL");
 
-module_init(calibrate_xor_block);
+/* when built-in xor.o must initialize before drivers/md/md.o */
+core_initcall(calibrate_xor_blocks);
 module_exit(xor_exit);
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 7df934d..24d93d0 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -109,6 +109,7 @@ config MD_RAID10
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
+	select XOR_BLOCKS
 	---help---
 	  A RAID-5 set of N drives with a capacity of C MB per drive
provides
 	  the capacity of C * (N - 1) MB, and protects against a failure
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 3875408..71eb45f 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -17,7 +17,7 @@ raid456-objs	:= raid5.o raid6algos.o raid6recov.o
raid6tables.o \
 hostprogs-y	:= mktables
 
 # Note: link order is important.  All raid personalities
-# and xor.o must come before md.o, as they each initialise 
+# and must come before md.o, as they each initialise 
 # themselves, and md.o may use the personalities when it 
 # auto-initialised.
 
@@ -25,7 +25,7 @@ obj-$(CONFIG_MD_LINEAR)		+= linear.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
-obj-$(CONFIG_MD_RAID456)	+= raid456.o xor.o
+obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c54f3c..33beaa7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5814,7 +5814,7 @@ static __exit void md_exit(void)
 	}
 }
 
-module_init(md_init)
+subsys_initcall(md_init);
 module_exit(md_exit)
 
 static int get_ro(char *buffer, struct kernel_param *kp)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 061375e..5adbe0b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -918,7 +918,7 @@ static void copy_data(int frombio, struct bio *bio,
 
 #define check_xor() 	do {
\
 			   if (count == MAX_XOR_BLOCKS) {
\
-				xor_block(count, STRIPE_SIZE, ptr);
\
+				xor_blocks(count, STRIPE_SIZE, ptr);
\
 				count = 1;
\
 			   }
\
 			} while(0)
@@ -949,7 +949,7 @@ static void compute_block(struct stripe_head *sh,
int dd_idx)
 		check_xor();
 	}
 	if (count != 1)
-		xor_block(count, STRIPE_SIZE, ptr);
+		xor_blocks(count, STRIPE_SIZE, ptr);
 	set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 }
 
@@ -1004,7 +1004,7 @@ static void compute_parity5(struct stripe_head
*sh, int method)
 		break;
 	}
 	if (count>1) {
-		xor_block(count, STRIPE_SIZE, ptr);
+		xor_blocks(count, STRIPE_SIZE, ptr);
 		count = 1;
 	}
 	
@@ -1038,7 +1038,7 @@ static void compute_parity5(struct stripe_head
*sh, int method)
 			}
 	}
 	if (count != 1)
-		xor_block(count, STRIPE_SIZE, ptr);
+		xor_blocks(count, STRIPE_SIZE, ptr);
 	
 	if (method != CHECK_PARITY) {
 		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
@@ -1160,7 +1160,7 @@ static void compute_block_1(struct stripe_head
*sh, int dd_idx, int nozero)
 			check_xor();
 		}
 		if (count != 1)
-			xor_block(count, STRIPE_SIZE, ptr);
+			xor_blocks(count, STRIPE_SIZE, ptr);
 		if (!nozero) set_bit(R5_UPTODATE,
&sh->dev[dd_idx].flags);
 		else clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 	}
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index f0d67cb..7d6c20b 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -5,7 +5,7 @@
 
 #define MAX_XOR_BLOCKS 5
 
-extern void xor_block(unsigned int count, unsigned int bytes, void
**ptr);
+extern void xor_blocks(unsigned int count, unsigned int bytes, void
**ptr);
 
 struct xor_block_template {
         struct xor_block_template *next;
