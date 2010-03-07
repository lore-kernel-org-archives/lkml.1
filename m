Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab0CGJMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 04:12:33 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51901 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0CGJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 04:12:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xMCWDyM3uFkTUryjKY1sOy/z89RzFkkebwx666ySGz/6dcz0TD+h+PReOcNbt0M/At
         xSvv715pAjPDf1VwDskLEpeP8bo1LtvpPeYd8WX2+JZa9cdVuZN62o3ElGxL6dwSAJX+
         7E1KPGtf87hDLCrd/olAo2TifIlcKuh/ap6FA=
Date: Sun, 7 Mar 2010 11:12:23 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: don.mullis@gmail.com, david@fromorbit.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: modules, "modules" and CONFIG_LIST_SORT
Message-ID: <20100307091223.GA4895@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is unhealthy tendency lately which manifests itself as ifdefing
parts of core kernel code which are only used by modular code.
Example:

	commit a069c266ae5fdfbf5b4aecf2c672413aa33b2504
	lib: build list_sort() only if needed

	Build list_sort() only for configs that need it -- those that don't save
	~581 bytes (i386).

	+obj-$(CONFIG_LIST_SORT) += list_sort.o

Usually it's done to save tiny amount of code.

Unpleasant side effect of the change is that some modules stop being
true modules, i. e. admin is unable to start using them without reboot
if kernel was compiled without that tiny amount of core kernel.

Having used this feature several times, I think it'd be correct
to preserve this behaviour, at least not regress for those modules
which benefitted from it. For modules which were always "modules" (ipv6)
it's fine to continue.

Can we declare some policy about it?

And revert LIST_SORT commit if yes.

Regardless, can list_sort people fix this:

	+ make ARCH=s390 CROSS_COMPILE=s390-ibm-linux-gnu- O=../obj/s390-32-smp-n-debug-n KCONFIG_ALLCONFIG=/src/config/s390-32-smp-n-debug-n KBUILD_MODPOST_NOFINAL=1
	GEN     /src/obj/s390-32-smp-n-debug-n/Makefile
	scripts/kconfig/conf -s arch/s390/Kconfig
	Using /src/linux-1 as source for kernel
	GEN     /src/obj/s390-32-smp-n-debug-n/Makefile
	CHK     include/linux/version.h
	CHK     include/generated/utsrelease.h
	CALL    /src/linux-1/scripts/checksyscalls.sh
	CHK     include/generated/compile.h
	GZIP    kernel/config_data.gz
	IKCFG   kernel/config_data.h
	CC [M]  kernel/configs.o
	CHK     include/linux/version.h
	make[3]: `scripts/unifdef' is up to date.
	make[2]: `arch/s390/boot/image' is up to date.
	make[3]: `arch/s390/boot/compressed/vmlinux' is up to date.
	Building modules, stage 2.
	MODPOST 672 modules
	ERROR: "list_sort" [fs/xfs/xfs.ko] undefined!

commit a069c266ae5fdfbf5b4aecf2c672413aa33b2504
Author: Don Mullis <don.mullis@gmail.com>
Date:   Fri Mar 5 13:43:16 2010 -0800

    lib: build list_sort() only if needed
    
    Build list_sort() only for configs that need it -- those that don't save
    ~581 bytes (i386).
    
    Signed-off-by: Don Mullis <don.mullis@gmail.com>
    Cc: Dave Airlie <airlied@redhat.com>
    Cc: Andi Kleen <andi@firstfloor.org>
    Cc: Dave Chinner <david@fromorbit.com>
    Cc: Artem Bityutskiy <dedekind@infradead.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 305c590..3d2ab03 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -9,6 +9,7 @@ menuconfig DRM
 	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
 	select I2C
 	select I2C_ALGOBIT
+	select LIST_SORT
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
index 830e3f7..430c69f 100644
--- a/fs/ubifs/Kconfig
+++ b/fs/ubifs/Kconfig
@@ -7,6 +7,7 @@ config UBIFS_FS
 	select CRYPTO if UBIFS_FS_ZLIB
 	select CRYPTO_LZO if UBIFS_FS_LZO
 	select CRYPTO_DEFLATE if UBIFS_FS_ZLIB
+	select LIST_SORT
 	depends on MTD_UBI
 	help
 	  UBIFS is a file system for flash devices which works on top of UBI.
diff --git a/lib/Kconfig b/lib/Kconfig
index 97b136f..8034c46 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -160,6 +160,9 @@ config TEXTSEARCH_BM
 config TEXTSEARCH_FSM
 	tristate
 
+config LIST_SORT
+	boolean
+
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
diff --git a/lib/Makefile b/lib/Makefile
index 3b0b4a6..e39c361 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o list_sort.o
+	 string_helpers.o gcd.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
@@ -40,6 +40,7 @@ lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
+obj-$(CONFIG_LIST_SORT) += list_sort.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
