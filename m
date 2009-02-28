Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZB1Xll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZB1Xll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 18:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZB1Xld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 18:41:33 -0500
Received: from imta-38.everyone.net ([216.200.145.38]:57333 "EHLO
	omta0109.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751367AbZB1Xlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 18:41:32 -0500
X-Eon-Dm: dm0201
X-Eon-Sig: AQHOS7NJqcuphsvrAwIAAAAH,74d90be3e2e121cdcef17d8c9603cef8
Date: Sat, 28 Feb 2009 18:41:28 -0500
From: "Kevin O'Connor" <kevin@koconnor.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org, Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: MPTable can not be high-memory on Linux
Message-ID: <20090228234127.GA29964@morn.localdomain>
References: <499DB40C.1060205@coresystems.de> <499DCE79.8020809@coresystems.de> <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu> <49A23EE0.8000102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A23EE0.8000102@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 10:14:56PM -0800, Yinghai Lu wrote:
> please check
> 
> [PATCH] x86: check physptr with max_low_pfn on 32bit

Thanks for looking at this issue.

Unfortunately, the kernel still does not work with the applied patch.
Neither 32bit nor 64bit kernels boot.  (Note, I applied the patch to
Linus' git, and I had to replace mpf->physptr with mpf->mpf_physptr.)

The error messages from before and after patching appear to be the
same.


In order to aid in testing, I modified SeaBIOS to force the mptable
into high memory even in qemu mode.  A modified bios.bin file can be
found at:

http://linuxtogo.org/~kevin/SeaBIOS/bios.bin-high-mptable

To use it with qemu, the steps are roughly:

mkdir testbios
cp /usr/share/qemu/*.bin testbios/
cp bios.bin-high-mptable testbios/bios.bin
qemu -L testbios/ -hda mytestlinux.img -serial file:mylog


The modified bios.bin can also be built manually by running:

git clone git://linuxtogo.org/home/kevin/seabios.git
cd seabios
patch -p1 < patch-from-below
make
cp out/bios.bin ../bios.bin-high-mptable

-Kevin


diff --git a/src/config.h b/src/config.h
index 56e5302..1ecc86f 100644
--- a/src/config.h
+++ b/src/config.h
@@ -21,7 +21,7 @@
 #define CONFIG_DEBUG_LEVEL 1
 
 // Send debugging information to serial port
-#define CONFIG_DEBUG_SERIAL 0
+#define CONFIG_DEBUG_SERIAL 1
 
 // Support for int13 floppy drive access
 #define CONFIG_FLOPPY_SUPPORT 1
@@ -77,7 +77,7 @@
 // Support finding a UUID (for smbios) via "magic" outl sequence.
 #define CONFIG_UUID_BACKDOOR 1
 // Support generation of ACPI tables (for emulators)
-#define CONFIG_ACPI 1
+#define CONFIG_ACPI 0
 // Support bios callbacks specific to via vgabios.
 #define CONFIG_VGAHOOKS 0
 // Support S3 resume handler.
diff --git a/src/mptable.c b/src/mptable.c
index 9e030fe..79cc7ba 100644
--- a/src/mptable.c
+++ b/src/mptable.c
@@ -19,7 +19,7 @@ mptable_init(void)
     dprintf(3, "init MPTable\n");
 
     int smp_cpus = smp_probe();
-    if (smp_cpus <= 1)
+    if (0 && smp_cpus <= 1)
         // Building an mptable on uniprocessor machines confuses some OSes.
         return;
 
@@ -39,7 +39,9 @@ mptable_init(void)
     /* floating pointer structure */
     struct mptable_floating_s *floating = (void*)start;
     memset(floating, 0, sizeof(*floating));
-    struct mptable_config_s *config = (void*)&floating[1];
+//    struct mptable_config_s *config = (void*)&floating[1];
+    struct mptable_config_s *config = (void*)(RamSize - 64*1024);
+    add_e820((u32)config, 64*1024, E820_RESERVED);
     floating->signature = MPTABLE_SIGNATURE;
     floating->physaddr = (u32)config;
     floating->length = 1;
