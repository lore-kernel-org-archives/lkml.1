Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYJHAfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYJHAfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbYJHAfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:35:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50861 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbYJHAfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:35:23 -0400
Date: Wed, 8 Oct 2008 09:34:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yinghai@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
Message-Id: <20081008093404.2ebaf72d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081007170103.3dcb6384.akpm@linux-foundation.org>
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810021705460.26309@shark.he.net>
	<20081007163331.711a938c.kamezawa.hiroyu@jp.fujitsu.com>
	<48EB8BBB.8000907@kernel.org>
	<20081008084753.f1a4fc2e.kamezawa.hiroyu@jp.fujitsu.com>
	<20081007170103.3dcb6384.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008 17:01:03 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> > Oh, yes. like this.
> > ==
> >  __con_initcall_end = .;
> >   __x86_cpu_dev_start = .;
> >   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
> >         *(.x86_cpu_dev.init)
> >   }
> >   SECURITY_INIT
> >   __x86_cpu_dev_end = .;
> > ==
> > 
> > I'll try next version when it comes.
> 
> If that fixes it then Ingo's tree will need fixing too, I suppose.
> 
Sad..

just for information. I used...

 - 3 fixes to git-x86.patch.
 - 1 fix to patches/usb-usb-remove-warn-macro-from-usbh.patch
 - 1 fix to patches/autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch 

Maybe some are fixed. Merged one is here.

==
Index: mmotm-2.6.27-rc8+/arch/x86/kernel/process_64.c
===================================================================
--- mmotm-2.6.27-rc8+.orig/arch/x86/kernel/process_64.c
+++ mmotm-2.6.27-rc8+/arch/x86/kernel/process_64.c
@@ -86,31 +86,6 @@ void exit_idle(void)
 	__exit_idle();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-DECLARE_PER_CPU(int, cpu_state);
-
-#include <asm/nmi.h>
-/* We halt the CPU with physical CPU hotplug */
-static inline void play_dead(void)
-{
-	idle_task_exit();
-	c1e_remove_cpu(raw_smp_processor_id());
-
-	mb();
-	/* Ack it */
-	__get_cpu_var(cpu_state) = CPU_DEAD;
-
-	local_irq_disable();
-	/* mask all interrupts, flush any and all caches, and halt */
-	wbinvd_halt();
-}
-#else
-static inline void play_dead(void)
-{
-	BUG();
-}
-#endif
-
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
Index: mmotm-2.6.27-rc8+/include/linux/pci_ids.h
===================================================================
--- mmotm-2.6.27-rc8+.orig/include/linux/pci_ids.h
+++ mmotm-2.6.27-rc8+/include/linux/pci_ids.h
@@ -497,6 +497,11 @@
 #define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP	0x1101
 #define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL	0x1102
 #define PCI_DEVICE_ID_AMD_K8_NB_MISC	0x1103
+#define PCI_DEVICE_ID_AMD_10H_NB_HT    0x1200
+#define PCI_DEVICE_ID_AMD_10H_NB_MAP   0x1201
+#define PCI_DEVICE_ID_AMD_10H_NB_DRAM  0x1202
+#define PCI_DEVICE_ID_AMD_10H_NB_MISC  0x1203
+#define PCI_DEVICE_ID_AMD_10H_NB_LINK  0x1204 
 #define PCI_DEVICE_ID_AMD_11H_NB_HT	0x1300
 #define PCI_DEVICE_ID_AMD_11H_NB_MAP	0x1301
 #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
Index: mmotm-2.6.27-rc8+/arch/x86/kernel/cpu/common.c
===================================================================
--- mmotm-2.6.27-rc8+.orig/arch/x86/kernel/cpu/common.c
+++ mmotm-2.6.27-rc8+/arch/x86/kernel/cpu/common.c
@@ -536,13 +536,14 @@ void __init early_cpu_init(void)
 			break;
 		cpu_devs[count] = cpudev;
 		count++;
-
+#if 0
 		for (j = 0; j < 2; j++) {
 			if (!cpudev->c_ident[j])
 				continue;
 			printk("  %s %s\n", cpudev->c_vendor,
 				cpudev->c_ident[j]);
 		}
+#endif
 	}
 
 	early_identify_cpu(&boot_cpu_data);
Index: mmotm-2.6.27-rc8+/drivers/hid/usbhid/hid-core.c
===================================================================
--- mmotm-2.6.27-rc8+.orig/drivers/hid/usbhid/hid-core.c
+++ mmotm-2.6.27-rc8+/drivers/hid/usbhid/hid-core.c
@@ -414,7 +414,7 @@ void usbhid_submit_report(struct hid_dev
 
 		if ((head = (usbhid->outhead + 1) & (HID_OUTPUT_FIFO_SIZE - 1)) == usbhid->outtail) {
 			spin_unlock_irqrestore(&usbhid->outlock, flags);
-			dev_warn(hid->dev, "output queue full\n");
+			dev_warn(&hid->dev, "output queue full\n");
 			return;
 		}
 
@@ -433,7 +433,7 @@ void usbhid_submit_report(struct hid_dev
 
 	if ((head = (usbhid->ctrlhead + 1) & (HID_CONTROL_FIFO_SIZE - 1)) == usbhid->ctrltail) {
 		spin_unlock_irqrestore(&usbhid->ctrllock, flags);
-		dev_warn(hid->dev, "control queue full\n");
+		dev_warn(&hid->dev, "control queue full\n");
 		return;
 	}
 
@@ -565,7 +565,7 @@ void usbhid_init_reports(struct hid_devi
 	}
 
 	if (err)
-		dev_warn(hid->dev, "timeout initializing reports\n");
+		dev_warn(&hid->dev, "timeout initializing reports\n");
 }
 
 /*
Index: mmotm-2.6.27-rc8+/fs/autofs4/dev-ioctl.c
===================================================================
--- mmotm-2.6.27-rc8+.orig/fs/autofs4/dev-ioctl.c
+++ mmotm-2.6.27-rc8+/fs/autofs4/dev-ioctl.c
@@ -307,7 +307,7 @@ static int autofs_dev_ioctl_open_mountpo
 			goto out;
 		}
 
-		filp = dentry_open(nd.path.dentry, nd.path.mnt, O_RDONLY, NULL);
+		filp = dentry_open(nd.path.dentry, nd.path.mnt, O_RDONLY);
 		if (IS_ERR(filp)) {
 			err = PTR_ERR(filp);
 			goto out;

