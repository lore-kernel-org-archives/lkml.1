Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZINJOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZINJOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZINJOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:14:31 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:44372 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZINJOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:14:30 -0400
X-Greylist: delayed 2837 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2009 05:14:30 EDT
From: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH] Make safe some helpers building on container_of
To: linux-kernel@vger.kernel.org
Cc: wferi@niif.hu
Date: Mon, 14 Sep 2009 10:27:00 +0200
Message-ID: <20090914082700.8550.94087.stgit@szonett.ki.iif.hu>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example, drivers/base/core.c contains

#define to_root_device(dev) container_of(dev, struct root_device, dev)

which works fine as long as the 'to_root_device' macro is always
applied to a variable called 'dev', as it is the case in the current
kernel sources.  However, it breaks as soon as it gets applied to a
variable of any other name, as the name of the variable is also
substituted into the third argument of the 'container_of' macro, which
really should stay 'dev' in the above case.

This patch renames the real macro arguments in all 5 such constructs
found by git-grep -E '#define.*container_of *\( *([^ ,]+) *,.*, *\1 *\)',
which may have missed some similar dangerous constructs, of course.
So these changes probably cross all possible boundaries of responsibility,
and I do not know how to best handle it, suggestions welcome.

Btw. this dangerous idom is also popularised by the excellent Linux Device
Drivers book (3rd edition, chapter 14, bottom of page 383).

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---

 arch/x86/kernel/hpet.c       |    2 +-
 drivers/base/core.c          |    2 +-
 drivers/mtd/nand/fsl_upm.c   |    2 +-
 include/linux/i2o.h          |    2 +-
 include/linux/mtd/sh_flctl.h |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index dedc2bd..48f70ad 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -27,7 +27,7 @@
 #define HPET_DEV_FSB_CAP		0x1000
 #define HPET_DEV_PERI_CAP		0x2000
 
-#define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
+#define EVT_TO_HPET_DEV(evtdev) container_of(evtdev, struct hpet_dev, evt)
 
 /*
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7ecb193..68374f3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1285,7 +1285,7 @@ struct root_device
 	struct module *owner;
 };
 
-#define to_root_device(dev) container_of(dev, struct root_device, dev)
+#define to_root_device(d) container_of(d, struct root_device, dev)
 
 static void root_device_release(struct device *dev)
 {
diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index d120cd8..623d0b4 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -48,7 +48,7 @@ struct fsl_upm_nand {
 	uint32_t wait_flags;
 };
 
-#define to_fsl_upm_nand(mtd) container_of(mtd, struct fsl_upm_nand, mtd)
+#define to_fsl_upm_nand(mtdinfo) container_of(mtdinfo, struct fsl_upm_nand, mtd)
 
 static int fun_chip_ready(struct mtd_info *mtd)
 {
diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 4c4e57d..b588b8f 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -782,7 +782,7 @@ extern int i2o_exec_lct_get(struct i2o_controller *);
 #define to_i2o_driver(drv) container_of(drv,struct i2o_driver, driver)
 #define to_i2o_device(dev) container_of(dev, struct i2o_device, device)
 #define to_i2o_controller(dev) container_of(dev, struct i2o_controller, device)
-#define kobj_to_i2o_device(kobj) to_i2o_device(container_of(kobj, struct device, kobj))
+#define kobj_to_i2o_device(kobject) to_i2o_device(container_of(kobject, struct device, kobj))
 
 /**
  *	i2o_out_to_virt - Turn an I2O message to a virtual address
diff --git a/include/linux/mtd/sh_flctl.h b/include/linux/mtd/sh_flctl.h
index e77c1ce..254f5c3 100644
--- a/include/linux/mtd/sh_flctl.h
+++ b/include/linux/mtd/sh_flctl.h
@@ -91,7 +91,7 @@
 #define INIT_FL4ECCRESULT_VAL	0x03FF03FF
 #define LOOP_TIMEOUT_MAX	0x00010000
 
-#define mtd_to_flctl(mtd)	container_of(mtd, struct sh_flctl, mtd)
+#define mtd_to_flctl(mtdinfo)	container_of(mtdinfo, struct sh_flctl, mtd)
 
 struct sh_flctl {
 	struct mtd_info		mtd;

