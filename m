Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbXJQUI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbXJQUI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbXJQUIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:08:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:36643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054AbXJQUIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:08:42 -0400
Date: Wed, 17 Oct 2007 20:08:27 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.20.21
Message-ID: <20071017200827.GA7096@hera.kernel.org>
References: <20071017200725.GA1681@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017200725.GA1681@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 15b82c6..41e3b28 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .20
+EXTRAVERSION = .21
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/arch/i386/kernel/sysenter.c b/arch/i386/kernel/sysenter.c
index 666f70d..0577312 100644
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -183,7 +183,9 @@ struct vm_area_struct *get_gate_vma(struct task_struct *tsk)
 
 int in_gate_area(struct task_struct *task, unsigned long addr)
 {
-	return 0;
+	const struct vm_area_struct *vma = get_gate_vma(task);
+
+	return vma && addr >= vma->vm_start && addr < vma->vm_end;
 }
 
 int in_gate_area_no_task(unsigned long addr)
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index f3d4dd5..21d4caf 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -84,7 +84,7 @@ void flush_fp_to_thread(struct task_struct *tsk)
 			 */
 			BUG_ON(tsk != current);
 #endif
-			giveup_fpu(current);
+			giveup_fpu(tsk);
 		}
 		preempt_enable();
 	}
@@ -144,7 +144,7 @@ void flush_altivec_to_thread(struct task_struct *tsk)
 #ifdef CONFIG_SMP
 			BUG_ON(tsk != current);
 #endif
-			giveup_altivec(current);
+			giveup_altivec(tsk);
 		}
 		preempt_enable();
 	}
@@ -183,7 +183,7 @@ void flush_spe_to_thread(struct task_struct *tsk)
 #ifdef CONFIG_SMP
 			BUG_ON(tsk != current);
 #endif
-			giveup_spe(current);
+			giveup_spe(tsk);
 		}
 		preempt_enable();
 	}
diff --git a/arch/sparc64/kernel/traps.c b/arch/sparc64/kernel/traps.c
index ad67784..ab72e91 100644
--- a/arch/sparc64/kernel/traps.c
+++ b/arch/sparc64/kernel/traps.c
@@ -2146,12 +2146,20 @@ static void user_instruction_dump (unsigned int __user *pc)
 void show_stack(struct task_struct *tsk, unsigned long *_ksp)
 {
 	unsigned long pc, fp, thread_base, ksp;
-	void *tp = task_stack_page(tsk);
+	struct thread_info *tp;
 	struct reg_window *rw;
 	int count = 0;
 
 	ksp = (unsigned long) _ksp;
-
+	if (!tsk)
+		tsk = current;
+	tp = task_thread_info(tsk);
+	if (ksp == 0UL) {
+		if (tsk == current)
+			asm("mov %%fp, %0" : "=r" (ksp));
+		else
+			ksp = tp->ksp;
+	}
 	if (tp == current_thread_info())
 		flushw_all();
 
@@ -2180,11 +2188,7 @@ void show_stack(struct task_struct *tsk, unsigned long *_ksp)
 
 void dump_stack(void)
 {
-	unsigned long *ksp;
-
-	__asm__ __volatile__("mov	%%fp, %0"
-			     : "=r" (ksp));
-	show_stack(current, ksp);
+	show_stack(current, NULL);
 }
 
 EXPORT_SYMBOL(dump_stack);
diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
index 55ae802..f6377b4 100644
--- a/arch/sparc64/mm/fault.c
+++ b/arch/sparc64/mm/fault.c
@@ -129,15 +129,12 @@ static void __kprobes unhandled_fault(unsigned long address,
 
 static void bad_kernel_pc(struct pt_regs *regs, unsigned long vaddr)
 {
-	unsigned long *ksp;
-
 	printk(KERN_CRIT "OOPS: Bogus kernel PC [%016lx] in fault handler\n",
 	       regs->tpc);
 	printk(KERN_CRIT "OOPS: RPC [%016lx]\n", regs->u_regs[15]);
 	print_symbol("RPC: <%s>\n", regs->u_regs[15]);
 	printk(KERN_CRIT "OOPS: Fault was to vaddr[%lx]\n", vaddr);
-	__asm__("mov %%sp, %0" : "=r" (ksp));
-	show_stack(current, ksp);
+	dump_stack();
 	unhandled_fault(regs->tpc, current, regs);
 }
 
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 38c293b..dbb0192 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1072,12 +1072,6 @@ void blk_queue_end_tag(request_queue_t *q, struct request *rq)
 		 */
 		return;
 
-	if (unlikely(!__test_and_clear_bit(tag, bqt->tag_map))) {
-		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
-		       __FUNCTION__, tag);
-		return;
-	}
-
 	list_del_init(&rq->queuelist);
 	rq->cmd_flags &= ~REQ_QUEUED;
 	rq->tag = -1;
@@ -1087,6 +1081,13 @@ void blk_queue_end_tag(request_queue_t *q, struct request *rq)
 		       __FUNCTION__, tag);
 
 	bqt->tag_index[tag] = NULL;
+
+	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {
+		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
+		       __FUNCTION__, tag);
+		return;
+	}
+
 	bqt->busy--;
 }
 
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 6e93004..cb95fa8 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -58,11 +58,13 @@ static inline void blkcipher_unmap_dst(struct blkcipher_walk *walk)
 	scatterwalk_unmap(walk->dst.virt.addr, 1);
 }
 
+/* Get a spot of the specified length that does not straddle a page.
+ * The caller needs to ensure that there is enough space for this operation.
+ */
 static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
 {
-	if (offset_in_page(start + len) < len)
-		return (u8 *)((unsigned long)(start + len) & PAGE_MASK);
-	return start;
+	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
+	return start > end_page ? start : end_page;
 }
 
 static inline unsigned int blkcipher_done_slow(struct crypto_blkcipher *tfm,
@@ -154,7 +156,8 @@ static inline int blkcipher_next_slow(struct blkcipher_desc *desc,
 	if (walk->buffer)
 		goto ok;
 
-	n = bsize * 2 + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
+	n = bsize * 3 - (alignmask + 1) +
+	    (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 	walk->buffer = kmalloc(n, GFP_ATOMIC);
 	if (!walk->buffer)
 		return blkcipher_walk_done(desc, walk, -ENOMEM);
diff --git a/drivers/acpi/events/evgpeblk.c b/drivers/acpi/events/evgpeblk.c
index 95ddeb4..2ae48c2 100644
--- a/drivers/acpi/events/evgpeblk.c
+++ b/drivers/acpi/events/evgpeblk.c
@@ -586,6 +586,10 @@ acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xrupt_info *gpe_xrupt)
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (gpe_xrupt->previous) {
 		gpe_xrupt->previous->next = gpe_xrupt->next;
+	} else {
+		/* No previous, update list head */
+
+		acpi_gbl_gpe_xrupt_list_head = gpe_xrupt->next;
 	}
 
 	if (gpe_xrupt->next) {
diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
index 9a48ca2..3fc3895 100644
--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -1170,7 +1170,7 @@ static void __exit ieee1394_cleanup(void)
 	unregister_chrdev_region(IEEE1394_CORE_DEV, 256);
 }
 
-fs_initcall(ieee1394_init); /* same as ohci1394 */
+module_init(ieee1394_init);
 module_exit(ieee1394_cleanup);
 
 /* Exported symbols */
diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
index 628130a..ec301a8 100644
--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -3785,7 +3785,5 @@ static int __init ohci1394_init(void)
 	return pci_register_driver(&ohci1394_pci_driver);
 }
 
-/* Register before most other device drivers.
- * Useful for remote debugging via physical DMA, e.g. using firescope. */
-fs_initcall(ohci1394_init);
+module_init(ohci1394_init);
 module_exit(ohci1394_cleanup);
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 1fe1a83..1093ff4 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -556,7 +556,7 @@ struct cx8802_dev * cx8802_get_device(struct inode *inode)
 
 	list_for_each(list,&cx8802_devlist) {
 		h = list_entry(list, struct cx8802_dev, devlist);
-		if (h->mpeg_dev->minor == minor)
+		if (h->mpeg_dev && h->mpeg_dev->minor == minor)
 			return h;
 	}
 
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index a996aad..957694a 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1196,12 +1196,19 @@ static int pwc_video_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+
+static void pwc_cleanup(struct pwc_device *pdev)
+{
+	pwc_remove_sysfs_files(pdev->vdev);
+	video_unregister_device(pdev->vdev);
+}
+
 /* Note that all cleanup is done in the reverse order as in _open */
 static int pwc_video_close(struct inode *inode, struct file *file)
 {
 	struct video_device *vdev = file->private_data;
 	struct pwc_device *pdev;
-	int i;
+	int i, hint;
 
 	PWC_DEBUG_OPEN(">> video_close called(vdev = 0x%p).\n", vdev);
 
@@ -1224,8 +1231,9 @@ static int pwc_video_close(struct inode *inode, struct file *file)
 	pwc_isoc_cleanup(pdev);
 	pwc_free_buffers(pdev);
 
+	lock_kernel();
 	/* Turn off LEDS and power down camera, but only when not unplugged */
-	if (pdev->error_status != EPIPE) {
+	if (!pdev->unplugged) {
 		/* Turn LEDs off */
 		if (pwc_set_leds(pdev, 0, 0) < 0)
 			PWC_DEBUG_MODULE("Failed to set LED on/off time.\n");
@@ -1234,9 +1242,19 @@ static int pwc_video_close(struct inode *inode, struct file *file)
 			if (i < 0)
 				PWC_ERROR("Failed to power down camera (%d)\n", i);
 		}
+		pdev->vopen--;
+		PWC_DEBUG_OPEN("<< video_close() vopen=%d\n", i);
+	} else {
+		pwc_cleanup(pdev);
+		/* Free memory (don't set pdev to 0 just yet) */
+		kfree(pdev);
+		/* search device_hint[] table if we occupy a slot, by any chance */
+		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
+			if (device_hint[hint].pdev == pdev)
+				device_hint[hint].pdev = NULL;
 	}
-	pdev->vopen--;
-	PWC_DEBUG_OPEN("<< video_close() vopen=%d\n", pdev->vopen);
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -1783,21 +1801,21 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
 	/* Alert waiting processes */
 	wake_up_interruptible(&pdev->frameq);
 	/* Wait until device is closed */
-	while (pdev->vopen)
-		schedule();
-	/* Device is now closed, so we can safely unregister it */
-	PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
-	pwc_remove_sysfs_files(pdev->vdev);
-	video_unregister_device(pdev->vdev);
-
-	/* Free memory (don't set pdev to 0 just yet) */
-	kfree(pdev);
+	if(pdev->vopen) {
+		pdev->unplugged = 1;
+	} else {
+		/* Device is closed, so we can safely unregister it */
+		PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
+		pwc_cleanup(pdev);
+		/* Free memory (don't set pdev to 0 just yet) */
+		kfree(pdev);
 
 disconnect_out:
-	/* search device_hint[] table if we occupy a slot, by any chance */
-	for (hint = 0; hint < MAX_DEV_HINTS; hint++)
-		if (device_hint[hint].pdev == pdev)
-			device_hint[hint].pdev = NULL;
+		/* search device_hint[] table if we occupy a slot, by any chance */
+		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
+			if (device_hint[hint].pdev == pdev)
+				device_hint[hint].pdev = NULL;
+	}
 
 	unlock_kernel();
 }
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index 7e9c423..7dae6c4 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -198,6 +198,7 @@ struct pwc_device
    char vsnapshot;		/* snapshot mode */
    char vsync;			/* used by isoc handler */
    char vmirror;		/* for ToUCaM series */
+	char unplugged;
 
    int cmd_len;
    unsigned char cmd_buf[13];
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index c383dc3..f18edd8 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -554,6 +554,7 @@ union ring_type {
 #define PHY_OUI_MARVELL	0x5043
 #define PHY_OUI_CICADA	0x03f1
 #define PHY_OUI_VITESSE	0x01c1
+#define PHY_OUI_REALTEK	0x0732
 #define PHYID1_OUI_MASK	0x03ff
 #define PHYID1_OUI_SHFT	6
 #define PHYID2_OUI_MASK	0xfc00
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 1aafa71..2847a0c 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2646,14 +2646,16 @@ rtl8169_interrupt(int irq, void *dev_instance)
 			rtl8169_check_link_status(dev, tp, ioaddr);
 
 #ifdef CONFIG_R8169_NAPI
-		RTL_W16(IntrMask, rtl8169_intr_mask & ~rtl8169_napi_event);
-		tp->intr_mask = ~rtl8169_napi_event;
-
-		if (likely(netif_rx_schedule_prep(dev)))
-			__netif_rx_schedule(dev);
-		else if (netif_msg_intr(tp)) {
-			printk(KERN_INFO "%s: interrupt %04x taken in poll\n",
-			       dev->name, status);
+		if (status & rtl8169_napi_event) {
+			RTL_W16(IntrMask, rtl8169_intr_mask & ~rtl8169_napi_event);
+			tp->intr_mask = ~rtl8169_napi_event;
+
+			if (likely(netif_rx_schedule_prep(dev)))
+				__netif_rx_schedule(dev);
+			else if (netif_msg_intr(tp)) {
+				printk(KERN_INFO "%s: interrupt %04x in poll\n",
+				       dev->name, status);
+			}
 		}
 		break;
 #else
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index b091a0f..9040564 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -4,7 +4,7 @@
    Written By: Adam Radford <linuxraid@amcc.com>
    Modifications By: Tom Couch <linuxraid@amcc.com>
 
-   Copyright (C) 2004-2006 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2007 Applied Micro Circuits Corporation.
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -69,6 +69,7 @@
    2.26.02.008 - Free irq handler in __twa_shutdown().
                  Serialize reset code.
                  Add support for 9650SE controllers.
+   2.26.02.009 - Fix dma mask setting to fallback to 32-bit if 64-bit fails.
 */
 
 #include <linux/module.h>
@@ -92,7 +93,7 @@
 #include "3w-9xxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.008"
+#define TW_DRIVER_VERSION "2.26.02.009"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -2063,11 +2064,14 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	pci_set_master(pdev);
 
-	retval = pci_set_dma_mask(pdev, sizeof(dma_addr_t) > 4 ? DMA_64BIT_MASK : DMA_32BIT_MASK);
-	if (retval) {
-		TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
-		goto out_disable_device;
-	}
+	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
+	    || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)
+		    || pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+			TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
+			retval = -ENODEV;
+			goto out_disable_device;
+		}
 
 	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
 	if (!host) {
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index d6eb5ce..c5dc61a 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -66,7 +66,7 @@ static ssize_t store_new_id(struct device_driver *driver,
 	dynid->id.match_flags = USB_DEVICE_ID_MATCH_DEVICE;
 
 	spin_lock(&usb_drv->dynids.lock);
-	list_add_tail(&usb_drv->dynids.list, &dynid->node);
+	list_add_tail(&dynid->node, &usb_drv->dynids.list);
 	spin_unlock(&usb_drv->dynids.lock);
 
 	if (get_driver(driver)) {
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 149aa8b..dec1337 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -608,12 +608,12 @@ int usb_get_descriptor(struct usb_device *dev, unsigned char type, unsigned char
 	memset(buf,0,size);	// Make sure we parse really received data
 
 	for (i = 0; i < 3; ++i) {
-		/* retry on length 0 or stall; some devices are flakey */
+		/* retry on length 0 or error; some devices are flakey */
 		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 				USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
 				(type << 8) + index, 0, buf, size,
 				USB_CTRL_GET_TIMEOUT);
-		if (result == 0 || result == -EPIPE)
+		if (result <= 0 && result != -ETIMEDOUT)
 			continue;
 		if (result > 1 && ((u8 *)buf)[1] != type) {
 			result = -EPROTO;
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4df39c4..99f0f72 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -380,13 +380,28 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "dx entry: limit != root limit");
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{
 		count = dx_get_count(entries);
-		assert (count && count <= dx_get_limit(entries));
+		if (!count || count > dx_get_limit(entries)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: no count or count > limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -424,8 +439,15 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: limit != node limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
@@ -433,6 +455,10 @@ fail2:
 		frame--;
 	}
 fail:
+	if (*err == ERR_BAD_DX_DIR)
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt dir inode %ld, running e2fsck is "
+			     "recommended.", dir->i_ino);
 	return NULL;
 }
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e5a74a5..5edc327 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -380,13 +380,28 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "dx entry: limit != root limit");
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{
 		count = dx_get_count(entries);
-		assert (count && count <= dx_get_limit(entries));
+		if (!count || count > dx_get_limit(entries)) {
+			ext4_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: no count or count > limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -424,8 +439,15 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext4_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: limit != node limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
@@ -433,6 +455,10 @@ fail2:
 		frame--;
 	}
 fail:
+	if (*err == ERR_BAD_DX_DIR)
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt dir inode %ld, running e2fsck is "
+			     "recommended.", dir->i_ino);
 	return NULL;
 }
 
diff --git a/fs/locks.c b/fs/locks.c
index 52a8100..bcdfebc 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -790,7 +790,7 @@ find_conflict:
 	if (request->fl_flags & FL_ACCESS)
 		goto out;
 	locks_copy_lock(new_fl, request);
-	locks_insert_lock(&inode->i_flock, new_fl);
+	locks_insert_lock(before, new_fl);
 	new_fl = NULL;
 	error = 0;
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 28108c8..c81fcd8 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -180,8 +180,8 @@ void __exit unregister_nfs_fs(void)
 		remove_shrinker(acl_shrinker);
 #ifdef CONFIG_NFS_V4
 	unregister_filesystem(&nfs4_fs_type);
-	nfs_unregister_sysctl();
 #endif
+	nfs_unregister_sysctl();
 	unregister_filesystem(&nfs_fs_type);
 }
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 511edef..3743086 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -29,6 +29,14 @@ static struct dentry_operations sysfs_dentry_ops = {
 	.d_iput		= sysfs_d_iput,
 };
 
+static unsigned int sysfs_inode_counter;
+ino_t sysfs_get_inum(void)
+{
+	if (unlikely(sysfs_inode_counter < 3))
+		sysfs_inode_counter = 3;
+	return sysfs_inode_counter++;
+}
+
 /*
  * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
  */
@@ -42,6 +50,7 @@ static struct sysfs_dirent * sysfs_new_dirent(struct sysfs_dirent * parent_sd,
 		return NULL;
 
 	memset(sd, 0, sizeof(*sd));
+	sd->s_ino = sysfs_get_inum();
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
@@ -461,7 +470,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			ino = parent_sd->s_ino;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -490,10 +499,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = next->s_ino;
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e79e38d..bb2da9d 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -129,6 +129,7 @@ struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent * sd)
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = sd->s_ino;
 		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 		if (sd->s_iattr) {
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index e503f85..4305e46 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -29,6 +29,7 @@ static struct sysfs_dirent sysfs_root = {
 	.s_element	= NULL,
 	.s_type		= SYSFS_ROOT,
 	.s_iattr	= NULL,
+	.s_ino		= 1,
 };
 
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
diff --git a/include/asm-avr32/atomic.h b/include/asm-avr32/atomic.h
index c40b603..7df7b75 100644
--- a/include/asm-avr32/atomic.h
+++ b/include/asm-avr32/atomic.h
@@ -101,7 +101,7 @@ static inline int atomic_sub_unless(atomic_t *v, int a, int u)
 		"	mov	%1, 1\n"
 		"1:"
 		: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
+		: "m"(v->counter), "rKs21"(a), "rKs21"(u), "1"(result)
 		: "cc", "memory");
 
 	return result;
@@ -137,7 +137,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 			"	mov	%1, 1\n"
 			"1:"
 			: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-			: "m"(v->counter), "r"(a), "ir"(u)
+			: "m"(v->counter), "r"(a), "ir"(u), "1"(result)
 			: "cc", "memory");
 	}
 
diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 6328175..ab399fc 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -28,6 +28,7 @@ header-y += xt_policy.h
 header-y += xt_realm.h
 header-y += xt_sctp.h
 header-y += xt_state.h
+header-y += xt_statistic.h
 header-y += xt_string.h
 header-y += xt_tcpmss.h
 header-y += xt_tcpudp.h
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2129d1b..8799dc3 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -73,6 +73,7 @@ struct sysfs_dirent {
 	void 			* s_element;
 	int			s_type;
 	umode_t			s_mode;
+	ino_t			s_ino;
 	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
 	atomic_t		s_event;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index cd8fa0c..da5bac3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -273,7 +273,7 @@ extern int			tcp_v4_remember_stamp(struct sock *sk);
 
 extern int		    	tcp_v4_tw_remember_stamp(struct inet_timewait_sock *tw);
 
-extern int			tcp_sendmsg(struct kiocb *iocb, struct sock *sk,
+extern int			tcp_sendmsg(struct kiocb *iocb, struct socket *sock,
 					    struct msghdr *msg, size_t size);
 extern ssize_t			tcp_sendpage(struct socket *sock, struct page *page, int offset, size_t size, int flags);
 
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 50f24ee..5f0115f 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -61,10 +61,10 @@ void compat_exit_robust_list(struct task_struct *curr)
 	if (fetch_robust_entry(&upending, &pending,
 			       &head->list_op_pending, &pip))
 		return;
-	if (upending)
+	if (pending)
 		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
-	while (compat_ptr(uentry) != &head->list) {
+	while (entry != (struct robust_list __user *) &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
diff --git a/kernel/signal.c b/kernel/signal.c
index 5630255..4975f4c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1345,20 +1345,19 @@ struct sigqueue *sigqueue_alloc(void)
 void sigqueue_free(struct sigqueue *q)
 {
 	unsigned long flags;
+	spinlock_t *lock = &current->sighand->siglock;
+
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	/*
 	 * If the signal is still pending remove it from the
-	 * pending queue.
+	 * pending queue. We must hold ->siglock while testing
+	 * q->list to serialize with collect_signal().
 	 */
-	if (unlikely(!list_empty(&q->list))) {
-		spinlock_t *lock = &current->sighand->siglock;
-		read_lock(&tasklist_lock);
-		spin_lock_irqsave(lock, flags);
-		if (!list_empty(&q->list))
-			list_del_init(&q->list);
-		spin_unlock_irqrestore(lock, flags);
-		read_unlock(&tasklist_lock);
-	}
+	spin_lock_irqsave(lock, flags);
+	if (!list_empty(&q->list))
+		list_del_init(&q->list);
+	spin_unlock_irqrestore(lock, flags);
+
 	q->flags &= ~SIGQUEUE_PREALLOC;
 	__sigqueue_free(q);
 }
diff --git a/kernel/sys.c b/kernel/sys.c
index 475ddbb..17f8447 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1358,7 +1358,6 @@ asmlinkage long sys_times(struct tms __user * tbuf)
  * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
  * LBT 04.03.94
  */
-
 asmlinkage long sys_setpgid(pid_t pid, pid_t pgid)
 {
 	struct task_struct *p;
@@ -1386,7 +1385,7 @@ asmlinkage long sys_setpgid(pid_t pid, pid_t pgid)
 	if (!thread_group_leader(p))
 		goto out;
 
-	if (p->real_parent == group_leader) {
+	if (p->real_parent->tgid == group_leader->tgid) {
 		err = -EPERM;
 		if (process_session(p) != process_session(group_leader))
 			goto out;
diff --git a/net/802/psnap.c b/net/802/psnap.c
index 270b9d2..44dc3f9 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -55,6 +55,9 @@ static int snap_rcv(struct sk_buff *skb, struct net_device *dev,
 		.type = __constant_htons(ETH_P_SNAP),
 	};
 
+	if (unlikely(!pskb_may_pull(skb, 5)))
+		goto drop;
+
 	rcu_read_lock();
 	proto = find_snap_client(skb->h.raw);
 	if (proto) {
@@ -62,14 +65,18 @@ static int snap_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb->h.raw  += 5;
 		skb_pull_rcsum(skb, 5);
 		rc = proto->rcvfunc(skb, dev, &snap_packet_type, orig_dev);
-	} else {
-		skb->sk = NULL;
-		kfree_skb(skb);
-		rc = 1;
 	}
-
 	rcu_read_unlock();
+
+	if (unlikely(!proto))
+		goto drop;
+
+out:
 	return rc;
+
+drop:
+	kfree_skb(skb);
+	goto out;
 }
 
 /*
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 797fdd4..5d55a2e 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -444,6 +444,9 @@ int skb_copy_and_csum_datagram_iovec(struct sk_buff *skb,
 	__wsum csum;
 	int chunk = skb->len - hlen;
 
+	if (!chunk)
+		return 0;
+
 	/* Skip filled elements.
 	 * Pretty silly, look at memcpy_toiovec, though 8)
 	 */
diff --git a/net/dccp/ccids/ccid2.c b/net/dccp/ccids/ccid2.c
index fd38b05..05324db 100644
--- a/net/dccp/ccids/ccid2.c
+++ b/net/dccp/ccids/ccid2.c
@@ -298,7 +298,7 @@ static void ccid2_hc_tx_packet_sent(struct sock *sk, int more, unsigned int len)
 		int rc;
 
 		ccid2_pr_debug("allocating more space in history\n");
-		rc = ccid2_hc_tx_alloc_seq(hctx, CCID2_SEQBUF_LEN, GFP_KERNEL);
+		rc = ccid2_hc_tx_alloc_seq(hctx, CCID2_SEQBUF_LEN, gfp_any());
 		BUG_ON(rc); /* XXX what do we do? */
 
 		next = hctx->ccid2hctx_seqh->ccid2s_next;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8640096..d8e6f77 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -803,7 +803,7 @@ const struct proto_ops inet_stream_ops = {
 	.shutdown	   = inet_shutdown,
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
-	.sendmsg	   = inet_sendmsg,
+	.sendmsg	   = tcp_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = tcp_sendpage,
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 67a5509..41ad421 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -46,7 +46,7 @@ static int ip_clear_mutable_options(struct iphdr *iph, __be32 *daddr)
 			memcpy(daddr, optptr+optlen-4, 4);
 			/* Fall through */
 		default:
-			memset(optptr+2, 0, optlen-2);
+			memset(optptr, 0, optlen);
 		}
 		l -= optlen;
 		optptr += optlen;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6842474..a3818f2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -658,9 +658,10 @@ static inline int select_size(struct sock *sk, struct tcp_sock *tp)
 	return tmp;
 }
 
-int tcp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
+int tcp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 		size_t size)
 {
+	struct sock *sk = sock->sk;
 	struct iovec *iov;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 12de90a..9c4862f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2427,7 +2427,6 @@ struct proto tcp_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
-	.sendmsg		= tcp_sendmsg,
 	.recvmsg		= tcp_recvmsg,
 	.backlog_rcv		= tcp_v4_do_rcv,
 	.hash			= tcp_v4_hash,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 0e0e426..30c8299 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -473,7 +473,7 @@ const struct proto_ops inet6_stream_ops = {
 	.shutdown	   = inet_shutdown,		/* ok		*/
 	.setsockopt	   = sock_common_setsockopt,	/* ok		*/
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
-	.sendmsg	   = inet_sendmsg,		/* ok		*/
+	.sendmsg	   = tcp_sendmsg,		/* ok		*/
 	.recvmsg	   = sock_common_recvmsg,	/* ok		*/
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = tcp_sendpage,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 7b7bd44..2c613fa 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1357,8 +1357,9 @@ void ip6_flush_pending_frames(struct sock *sk)
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue_tail(&sk->sk_write_queue)) != NULL) {
-		IP6_INC_STATS(ip6_dst_idev(skb->dst),
-			      IPSTATS_MIB_OUTDISCARDS);
+		if (skb->dst)
+			IP6_INC_STATS(ip6_dst_idev(skb->dst),
+				      IPSTATS_MIB_OUTDISCARDS);
 		kfree_skb(skb);
 	}
 
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 9479fbd..ddbe790 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -851,11 +851,10 @@ back_from_confirm:
 			ip6_flush_pending_frames(sk);
 		else if (!(msg->msg_flags & MSG_MORE))
 			err = rawv6_push_pending_frames(sk, &fl, rp);
+		release_sock(sk);
 	}
 done:
 	dst_release(dst);
-	if (!inet->hdrincl)
-		release_sock(sk);
 out:	
 	fl6_sock_release(flowlabel);
 	return err<0?err:len;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 03f53f5..f6214b7 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2127,7 +2127,6 @@ struct proto tcpv6_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
-	.sendmsg		= tcp_sendmsg,
 	.recvmsg		= tcp_recvmsg,
 	.backlog_rcv		= tcp_v6_do_rcv,
 	.hash			= tcp_v6_hash,
diff --git a/net/socket.c b/net/socket.c
index afb6085..d9bae01 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1147,7 +1147,7 @@ static int __sock_create(int family, int type, int protocol,
 	module_put(pf->owner);
 	err = security_socket_post_create(sock, family, type, protocol, kern);
 	if (err)
-		goto out_release;
+		goto out_sock_release;
 	*res = sock;
 
 	return 0;
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index bc0bd09..02c2ce6 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <asm/uaccess.h>
 #include <linux/dma-mapping.h>
 #include <linux/moduleparam.h>
@@ -483,10 +484,8 @@ static void free_all_reserved_pages(void)
 #define SND_MEM_PROC_FILE	"driver/snd-page-alloc"
 static struct proc_dir_entry *snd_mem_proc;
 
-static int snd_mem_proc_read(char *page, char **start, off_t off,
-			     int count, int *eof, void *data)
+static int snd_mem_proc_read(struct seq_file *seq, void *offset)
 {
-	int len = 0;
 	long pages = snd_allocated_pages >> (PAGE_SHIFT-12);
 	struct list_head *p;
 	struct snd_mem_list *mem;
@@ -494,44 +493,47 @@ static int snd_mem_proc_read(char *page, char **start, off_t off,
 	static char *types[] = { "UNKNOWN", "CONT", "DEV", "DEV-SG", "SBUS" };
 
 	mutex_lock(&list_mutex);
-	len += snprintf(page + len, count - len,
-			"pages  : %li bytes (%li pages per %likB)\n",
-			pages * PAGE_SIZE, pages, PAGE_SIZE / 1024);
+	seq_printf(seq, "pages  : %li bytes (%li pages per %likB)\n",
+		   pages * PAGE_SIZE, pages, PAGE_SIZE / 1024);
 	devno = 0;
 	list_for_each(p, &mem_list_head) {
 		mem = list_entry(p, struct snd_mem_list, list);
 		devno++;
-		len += snprintf(page + len, count - len,
-				"buffer %d : ID %08x : type %s\n",
-				devno, mem->id, types[mem->buffer.dev.type]);
-		len += snprintf(page + len, count - len,
-				"  addr = 0x%lx, size = %d bytes\n",
-				(unsigned long)mem->buffer.addr, (int)mem->buffer.bytes);
+		seq_printf(seq, "buffer %d : ID %08x : type %s\n",
+			   devno, mem->id, types[mem->buffer.dev.type]);
+		seq_printf(seq, "  addr = 0x%lx, size = %d bytes\n",
+			   (unsigned long)mem->buffer.addr,
+			   (int)mem->buffer.bytes);
 	}
 	mutex_unlock(&list_mutex);
-	return len;
+	return 0;
+}
+
+static int snd_mem_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, snd_mem_proc_read, NULL);
 }
 
 /* FIXME: for pci only - other bus? */
 #ifdef CONFIG_PCI
 #define gettoken(bufp) strsep(bufp, " \t\n")
 
-static int snd_mem_proc_write(struct file *file, const char __user *buffer,
-			      unsigned long count, void *data)
+static ssize_t snd_mem_proc_write(struct file *file, const char __user * buffer,
+				  size_t count, loff_t * ppos)
 {
 	char buf[128];
 	char *token, *p;
 
-	if (count > ARRAY_SIZE(buf) - 1)
-		count = ARRAY_SIZE(buf) - 1;
+	if (count > sizeof(buf) - 1)
+		return -EINVAL;
 	if (copy_from_user(buf, buffer, count))
 		return -EFAULT;
-	buf[ARRAY_SIZE(buf) - 1] = '\0';
+	buf[count] = '\0';
 
 	p = buf;
 	token = gettoken(&p);
 	if (! token || *token == '#')
-		return (int)count;
+		return count;
 	if (strcmp(token, "add") == 0) {
 		char *endp;
 		int vendor, device, size, buffers;
@@ -552,7 +554,7 @@ static int snd_mem_proc_write(struct file *file, const char __user *buffer,
 		    (buffers = simple_strtol(token, NULL, 0)) <= 0 ||
 		    buffers > 4) {
 			printk(KERN_ERR "snd-page-alloc: invalid proc write format\n");
-			return (int)count;
+			return count;
 		}
 		vendor &= 0xffff;
 		device &= 0xffff;
@@ -564,7 +566,7 @@ static int snd_mem_proc_write(struct file *file, const char __user *buffer,
 				if (pci_set_dma_mask(pci, mask) < 0 ||
 				    pci_set_consistent_dma_mask(pci, mask) < 0) {
 					printk(KERN_ERR "snd-page-alloc: cannot set DMA mask %lx for pci %04x:%04x\n", mask, vendor, device);
-					return (int)count;
+					return count;
 				}
 			}
 			for (i = 0; i < buffers; i++) {
@@ -574,7 +576,7 @@ static int snd_mem_proc_write(struct file *file, const char __user *buffer,
 							size, &dmab) < 0) {
 					printk(KERN_ERR "snd-page-alloc: cannot allocate buffer pages (size = %d)\n", size);
 					pci_dev_put(pci);
-					return (int)count;
+					return count;
 				}
 				snd_dma_reserve_buf(&dmab, snd_dma_pci_buf_id(pci));
 			}
@@ -600,9 +602,21 @@ static int snd_mem_proc_write(struct file *file, const char __user *buffer,
 		free_all_reserved_pages();
 	else
 		printk(KERN_ERR "snd-page-alloc: invalid proc cmd\n");
-	return (int)count;
+	return count;
 }
 #endif /* CONFIG_PCI */
+
+static const struct file_operations snd_mem_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= snd_mem_proc_open,
+	.read		= seq_read,
+#ifdef CONFIG_PCI
+	.write		= snd_mem_proc_write,
+#endif
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 #endif /* CONFIG_PROC_FS */
 
 /*
@@ -613,12 +627,8 @@ static int __init snd_mem_init(void)
 {
 #ifdef CONFIG_PROC_FS
 	snd_mem_proc = create_proc_entry(SND_MEM_PROC_FILE, 0644, NULL);
-	if (snd_mem_proc) {
-		snd_mem_proc->read_proc = snd_mem_proc_read;
-#ifdef CONFIG_PCI
-		snd_mem_proc->write_proc = snd_mem_proc_write;
-#endif
-	}
+	if (snd_mem_proc)
+		snd_mem_proc->proc_fops = &snd_mem_proc_fops;
 #endif
 	return 0;
 }
