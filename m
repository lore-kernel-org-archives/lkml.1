Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZFWWQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZFWWQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbZFWWQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:16:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58276 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329AbZFWWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:16:01 -0400
Date: Wed, 24 Jun 2009 00:15:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: swetland@google.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: HTC Dream video cleanups
Message-ID: <20090623221552.GA16775@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This removes debug & commented out code from msm-video. Debugging
infrastructure should normally use dprintk(), not custom, per file
infrastructure.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index f3a3ac0..adc559e 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -1,5 +1,4 @@
-/* drivers/video/msm_fb/mddi
- *
+/*
  * MSM MDDI Transport
  *
  * Copyright (C) 2007 Google Incorporated
@@ -43,8 +42,6 @@
 #define CMD_GET_CLIENT_CAP     0x0601
 #define CMD_GET_CLIENT_STATUS  0x0602
 
-static uint32_t mddi_debug_flags;
-
 union mddi_rev {
 	unsigned char raw[MDDI_REV_BUFFER_SIZE];
 	struct mddi_rev_packet hdr;
@@ -135,8 +132,6 @@ static void mddi_handle_rev_data(struct mddi_info *mddi, union mddi_rev *rev)
 
 	if ((rev->hdr.length <= MDDI_REV_BUFFER_SIZE - 2) &&
 	   (rev->hdr.length >= sizeof(struct mddi_rev_packet) - 2)) {
-		/* printk(KERN_INFO "rev: len=%04x type=%04x\n",
-		 * rev->hdr.length, rev->hdr.type); */
 
 		switch (rev->hdr.type) {
 		case TYPE_CLIENT_CAPS:
@@ -152,9 +147,6 @@ static void mddi_handle_rev_data(struct mddi_info *mddi, union mddi_rev *rev)
 			wake_up(&mddi->int_wait);
 			break;
 		case TYPE_REGISTER_ACCESS:
-			/* printk(KERN_INFO "rev: reg %x = %x\n",
-			 * rev->reg.register_address,
-			 * rev->reg.register_data_list); */
 			ri = mddi->reg_read;
 			if (ri == 0) {
 				printk(KERN_INFO "rev: got reg %x = %x without "
@@ -216,8 +208,6 @@ static void mddi_handle_rev_data_avail(struct mddi_info *mddi)
 	rev_crc_err_count = mddi_readl(REV_CRC_ERR);
 	if (rev_data_count > 1)
 		printk(KERN_INFO "rev_data_count %d\n", rev_data_count);
-	/* printk(KERN_INFO "rev_data_count %d, INT %x\n", rev_data_count,
-	 * mddi_readl(INT)); */
 
 	if (rev_crc_err_count) {
 		printk(KERN_INFO "rev_crc_err_count %d, INT %x\n",
@@ -237,20 +227,6 @@ static void mddi_handle_rev_data_avail(struct mddi_info *mddi)
 	if (rev_data_count == 0)
 		return;
 
-	if (mddi_debug_flags & 1) {
-		printk(KERN_INFO "INT %x, STAT %x, CURR_REV_PTR %x\n",
-		       mddi_readl(INT), mddi_readl(STAT),
-		       mddi_readl(CURR_REV_PTR));
-		for (i = 0; i < MDDI_REV_BUFFER_SIZE; i++) {
-			if ((i % 16) == 0)
-				printk(KERN_INFO "\n");
-			printk(KERN_INFO " %02x", rev->raw[i]);
-		}
-		printk(KERN_INFO "\n");
-	}
-
-	/* printk(KERN_INFO "rev_data_curr %d + %d\n", mddi->rev_data_curr,
-	 * crev->hdr.length); */
 	prev_offset = mddi->rev_data_curr;
 
 	length = *((uint8_t *)mddi->rev_data + mddi->rev_data_curr);
@@ -276,23 +252,12 @@ static void mddi_handle_rev_data_avail(struct mddi_info *mddi)
 		memcpy(&tmprev.raw[0], mddi->rev_data + prev_offset, rem);
 		memcpy(&tmprev.raw[rem], mddi->rev_data, 2 + length - rem);
 		mddi_handle_rev_data(mddi, &tmprev);
-		if (mddi_debug_flags & 2) {
-			memset(mddi->rev_data + prev_offset, 0xee, rem);
-			memset(mddi->rev_data, 0xee, mddi->rev_data_curr);
-		}
 	} else {
 		mddi_handle_rev_data(mddi, crev);
-		if (mddi_debug_flags & 2)
-			memset(mddi->rev_data + prev_offset, 0xee,
-			       mddi->rev_data_curr - prev_offset);
 	}
 
-	/* if(mddi->rev_data_curr + MDDI_MAX_REV_PKT_SIZE >=
-	 * MDDI_REV_BUFFER_SIZE) { */
 	if (prev_offset < MDDI_REV_BUFFER_SIZE / 2 &&
 	    mddi->rev_data_curr >= MDDI_REV_BUFFER_SIZE / 2) {
-		/* printk(KERN_INFO "passed buffer half full: rev_data_curr
-		 * %d\n", mddi->rev_data_curr); */
 		mddi_writel(mddi->rev_addr, REV_PTR);
 	}
 }
@@ -311,9 +276,6 @@ static irqreturn_t mddi_isr(int irq, void *data)
 
 	mddi_writel(active, INT);
 
-	/* printk(KERN_INFO "%s: isr a=%08x e=%08x s=%08x\n",
-		mddi->name, active, mddi->int_enable, status); */
-
 	/* ignore any interrupts we have disabled */
 	active &= mddi->int_enable;
 
@@ -426,11 +388,7 @@ static uint16_t mddi_init_registers(struct mddi_info *mddi)
 
 	mddi_set_auto_hibernate(&mddi->client_data, 0);
 
-#if 1 /* ignore listen */
 	mddi_writel(MDDI_CMD_DISP_IGNORE, CMD);
-#else
-	mddi_writel(MDDI_CMD_DISP_LISTEN, CMD);
-#endif
 	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
 
 	mddi_init_rev_encap(mddi);
@@ -571,7 +529,6 @@ void mddi_remote_write(struct msm_mddi_client_data *cdata, uint32_t val,
 					      client_data);
 	struct mddi_llentry *ll;
 	struct mddi_register_access *ra;
-	/* unsigned s; */
 
 	mutex_lock(&mddi->reg_write_lock);
 
@@ -595,19 +552,9 @@ void mddi_remote_write(struct msm_mddi_client_data *cdata, uint32_t val,
 	ll->next = 0;
 	ll->reserved = 0;
 
-	/* s = mddi_readl(STAT); */
-	/* printk(KERN_INFO "mddi_remote_write(%x, %x), stat = %x\n", val,
-	 * reg, s); */
-
 	mddi_writel(mddi->reg_write_addr, PRI_PTR);
 
-	/* s = mddi_readl(STAT); */
-	/* printk(KERN_INFO "mddi_remote_write(%x, %x) sent, stat = %x\n",
-	 * val, reg, s); */
-
 	mddi_wait_interrupt(mddi, MDDI_INT_PRI_LINK_LIST_DONE);
-	/* printk(KERN_INFO "mddi_remote_write(%x, %x) done, stat = %x\n",
-	 * val, reg, s); */
 	mutex_unlock(&mddi->reg_write_lock);
 }
 
@@ -643,7 +590,6 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
 	ll->reserved = 0;
 
 	s = mddi_readl(STAT);
-	/* printk(KERN_INFO "mddi_remote_read(%x), stat = %x\n", reg, s); */
 
 	ri.reg = reg;
 	ri.status = -1;
@@ -654,14 +600,6 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
 		mddi_writel(mddi->reg_read_addr, PRI_PTR);
 
 		mddi_wait_interrupt(mddi, MDDI_INT_PRI_LINK_LIST_DONE);
-		/* s = mddi_readl(STAT); */
-		/* printk(KERN_INFO "mddi_remote_read(%x) sent, stat = %x\n",
-		 * reg, s); */
-
-		/* s = mddi_readl(STAT); */
-		/* while((s & MDDI_STAT_PRI_LINK_LIST_DONE) == 0){ */
-		/*	s = mddi_readl(STAT); */
-		/* } */
 
 		/* Enable Periodic Reverse Encapsulation. */
 		mddi_writel(MDDI_CMD_PERIODIC_REV_ENCAP | 1, CMD);
@@ -680,14 +618,8 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
 		if (ri.status == 0)
 			break;
 
-		/* printk(KERN_INFO "mddi_remote_read: failed, sent
-		 * MDDI_CMD_SEND_RTD: int %x, stat %x, rtd val %x\n",
-		 * mddi_readl(INT), mddi_readl(STAT), mddi_readl(RTD_VAL)); */
 		mddi_writel(MDDI_CMD_SEND_RTD, CMD);
 		mddi_writel(MDDI_CMD_LINK_ACTIVE, CMD);
-		/* printk(KERN_INFO "mddi_remote_read: failed, sent
-		 * MDDI_CMD_SEND_RTD: int %x, stat %x, rtd val %x\n",
-		 * mddi_readl(INT), mddi_readl(STAT), mddi_readl(RTD_VAL)); */
 		mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
 		printk(KERN_INFO "mddi_remote_read: failed, sent "
 		       "MDDI_CMD_SEND_RTD: int %x, stat %x, rtd val %x "
@@ -697,8 +629,6 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
 	/* Disable Periodic Reverse Encapsulation. */
 	mddi_writel(MDDI_CMD_PERIODIC_REV_ENCAP | 0, CMD);
 	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
-	/* printk(KERN_INFO "mddi_remote_read(%x) done, stat = %x,
-	 * return %x\n", reg, s, ri.result); */
 	mddi->reg_read = NULL;
 	mutex_unlock(&mddi->reg_read_lock);
 	return ri.result;
@@ -736,7 +666,7 @@ static int __init mddi_rev_data_setup(struct mddi_info *mddi)
 	void *dma;
 	dma_addr_t dma_addr;
 
-		/* set up dma buffer */
+	/* set up dma buffer */
 	dma = dma_alloc_coherent(NULL, 0x1000, &dma_addr, GFP_KERNEL);
 	if (dma == 0)
 		return -ENOMEM;
@@ -900,37 +830,6 @@ error_ioremap:
 	return ret;
 }
 
-#if 0 /* read/write mddi registers from userspace */
-module_param_named(debug, mddi_debug_flags, uint, 0644);
-
-static uint32_t selected_register;
-module_param_named(reg, selected_register, uint, 0644);
-
-static int set_reg(const char *val, struct kernel_param *kp)
-{
-	char *endp;
-	uint32_t l;
-
-	if (!val)
-		return -EINVAL;
-	l = simple_strtoul(val, &endp, 0);
-	if (endp == val || ((uint32_t)l != l))
-		return -EINVAL;
-	mddi_remote_write(kp->arg, l, selected_register);
-	return 0;
-}
-
-static int get_reg(char *buffer, struct kernel_param *kp)
-{
-	int val;
-	val = mddi_remote_read(kp->arg, selected_register);
-	return sprintf(buffer, "%x", val);
-}
-
-module_param_call(pmdh_val, set_reg, get_reg, &mddi_info[0], 0644);
-module_param_call(emdh_val, set_reg, get_reg, &mddi_info[1], 0644);
-
-#endif
 
 static struct platform_driver mddi_driver = {
 	.probe = mddi_probe,
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index 30bd3c6..ef52769 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -22,15 +22,7 @@
 #include "mdp_hw.h"
 #include "mdp_scale_tables.h"
 
-#define PPP_DEBUG_MSGS 0
-#if PPP_DEBUG_MSGS
-#define DLOG(fmt,args...) \
-	do { pdrintk(KERN_INFO "[%s:%s:%d] "fmt, __FILE__, __func__, \
-		    __LINE__, ##args); } \
-	while (0)
-#else
 #define DLOG(x...) do {} while (0)
-#endif
 
 #define MDP_DOWNSCALE_BLUR (MDP_DOWNSCALE_MAX + 1)
 static int downscale_y_table = MDP_DOWNSCALE_MAX;
@@ -218,7 +210,6 @@ static void blit_blend(struct mdp_blit_req *req, struct mdp_regs *regs)
 #define FRAC_MASK (ONE - 1)
 #define INT_MASK (~FRAC_MASK)
 
-#define ADJUST_IP
 static int scale_params(uint32_t dim_in, uint32_t dim_out, uint32_t origin,
 			uint32_t *phase_init, uint32_t *phase_step)
 {
@@ -227,9 +218,8 @@ static int scale_params(uint32_t dim_in, uint32_t dim_out, uint32_t origin,
 	int64_t k1, k2, k3, k4, tmp;
 	uint64_t n, d, os, os_p, od, od_p, oreq;
 	unsigned rpa = 0;
-#ifdef ADJUST_IP
 	int64_t ip64, delta;
-#endif
+
 	if (dim_out % 3 == 0)
 		rpa = !(dim_in % (dim_out / 3));
 
@@ -282,7 +272,6 @@ static int scale_params(uint32_t dim_in, uint32_t dim_out, uint32_t origin,
 
 	oreq = (os_p & INT_MASK) - ONE;
 
-#ifdef ADJUST_IP
 	ip64 = os_p - oreq;
 	delta = ((int64_t)(origin) << 33) - oreq;
 	ip64 -= delta;
@@ -292,9 +281,6 @@ static int scale_params(uint32_t dim_in, uint32_t dim_out, uint32_t origin,
 	while (abs((int)(ip64 >> 33)) > 4)
 		ip64 += delta;
 	*phase_init = (int)(ip64 >> 4);
-#else
-	*phase_init = (int)((os_p - oreq) >> 4);
-#endif
 	*phase_step = (uint32_t)(k1 >> 4);
 	return 0;
 }
@@ -589,40 +575,6 @@ static int valid_src_dst(unsigned long src_start, unsigned long src_len,
 	return 1;
 }
 
-#if 0
-int get_img(struct mdp_img *img, struct fb_info *info, unsigned long *start,
-	    unsigned long *len)
-{
-	int put_needed, ret = -1;
-	struct file *file = fget_light(img->memory_id, &put_needed);
-
-	if (file == NULL)
-		return -1;
-
-	if (MAJOR(file->f_dentry->d_inode->i_rdev) == FB_MAJOR) {
-		*start = info->fix.smem_start;
-		*len = info->fix.smem_len;
-		ret = 0;
-		goto end;
-	}
-#ifdef CONFIG_ANDROID_PMEM
-	if (!get_pmem_fd(img->memory_id, start, len))
-		ret = 0;
-#endif
-end:
-	fput_light(file, put_needed);
-	return ret;
-}
-
-void put_img(struct mdp_blit_req *req)
-{
-#ifdef CONFIG_ANDROID_PMEM
-	put_pmem_fd(req->src.memory_id);
-	put_pmem_fd(req->dst.memory_id);
-#endif
-}
-
-#endif
 
 static void flush_imgs(struct mdp_blit_req *req, struct mdp_regs *regs,
 		       struct file *src_file, struct file *dst_file)
diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
index 1d2251d..327a0b2 100644
--- a/drivers/video/msm/msm_fb.c
+++ b/drivers/video/msm/msm_fb.c
@@ -1,4 +1,4 @@
-/* drivers/video/msm_fb/msm_fb.c
+/* drivers/video/msm/msm_fb.c
  *
  * Core MSM framebuffer driver.
  *
@@ -33,7 +33,6 @@
 #include <linux/debugfs.h>
 #include <linux/dma-mapping.h>
 
-#define MSMFB_DEBUG 1
 #ifdef CONFIG_FB_MSM_LOGO
 #define INIT_IMAGE_FILE "/logo.rle"
 extern int load_565rle_image(char *filename);
@@ -566,44 +565,6 @@ static struct fb_ops msmfb_ops = {
 static unsigned PP[16];
 
 
-#if MSMFB_DEBUG
-static ssize_t debug_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-
-static ssize_t debug_read(struct file *file, char __user *buf, size_t count,
-			  loff_t *ppos)
-{
-	const int debug_bufmax = 4096;
-	static char buffer[4096];
-	int n = 0;
-	struct msmfb_info *msmfb = (struct msmfb_info *)file->private_data;
-	unsigned long irq_flags;
-
-	spin_lock_irqsave(&msmfb->update_lock, irq_flags);
-	n = scnprintf(buffer, debug_bufmax, "yoffset %d\n", msmfb->yoffset);
-	n += scnprintf(buffer + n, debug_bufmax, "frame_requested %d\n",
-		       msmfb->frame_requested);
-	n += scnprintf(buffer + n, debug_bufmax, "frame_done %d\n",
-		       msmfb->frame_done);
-	n += scnprintf(buffer + n, debug_bufmax, "sleeping %d\n",
-		       msmfb->sleeping);
-	n += scnprintf(buffer + n, debug_bufmax, "update_frame %d\n",
-		       msmfb->update_frame);
-	spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
-	n++;
-	buffer[n] = 0;
-	return simple_read_from_buffer(buf, count, ppos, buffer, n);
-}
-
-static struct file_operations debug_fops = {
-	.read = debug_read,
-	.open = debug_open,
-};
-#endif
 
 #define BITS_PER_PIXEL 16
 
@@ -747,11 +708,6 @@ static int msmfb_probe(struct platform_device *pdev)
 	register_early_suspend(&msmfb->earlier_suspend);
 #endif
 
-#if MSMFB_DEBUG
-	debugfs_create_file("msm_fb", S_IFREG | S_IRUGO, NULL,
-			    (void *)fb->par, &debug_fops);
-#endif
-
 	printk(KERN_INFO "msmfb_probe() installing %d x %d panel\n",
 	       msmfb->xres, msmfb->yres);
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
