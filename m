Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYIIIUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYIIIUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYIIITr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:19:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:1345 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYIIITn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=S0bQXwhkyaBBlV7FKvblhvF72658zqCd/BLg3tjUzHteg0UTuzUM0sfAuWO25nW8c6
         ThdaxL4KQbN38xZFrHzeGEiOczHacDA/V3HTLBBXSkrHjbQmP47Cx+RpN39VFeEUTLN1
         tW2ktnpk4b3hTc+MYJqu+fnzYJ2+7biz5kQ9w=
Message-ID: <48C685F6.8020108@gmail.com>
Date: Tue, 09 Sep 2008 16:19:34 +0200
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: invalid tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using spatch I have found the following occurrences where there is
an invalid test on an unsigned.

Some may be not seriously, but just redundant, others may indicate
an incorrect assumption (that the variable can be negative).
I haven't found time to sort out these.

If I have time I will write patches, but feel free to write one
yourself if you want.

Roel

What is shown below is not meant as patch, just for reporting.

----[ arch/arm/mach-davinci/psc.c, unsigned ]----
--- arch/arm/mach-davinci/psc.c	2008-07-19 23:16:48.000000000 +0200
@@ -70,7 +70,7 @@ void davinci_psc_config(unsigned int dom
 {
 	u32 epcpr, ptcmd, ptstat, pdstat, pdctl1, mdstat, mdctl, mdstat_mask;
 
-	if (id < 0)
 		return;
 
 	mdctl = davinci_readl(DAVINCI_PWR_SLEEP_CNTRL_BASE + MDCTL + 4 * id);
----[ arch/arm/mach-pxa/pwm.c, unsigned long ]----
--- arch/arm/mach-pxa/pwm.c	2008-07-19 23:16:48.000000000 +0200
@@ -60,7 +60,7 @@ int pwm_config(struct pwm_device *pwm, i
 	do_div(c, 1000000000);
 	period_cycles = c;
 
-	if (period_cycles < 0)
 		period_cycles = 1;
 	prescale = (period_cycles - 1) / 1024;
 	pv = period_cycles / (prescale + 1) - 1;
----[ arch/cris/arch-v10/kernel/dma.c, unsigned ]----
--- arch/cris/arch-v10/kernel/dma.c	2008-07-19 23:16:48.000000000 +0200
@@ -24,7 +24,7 @@ int cris_request_dma(unsigned int dmanr,
 	unsigned long int gens;
 	int fail = -EINVAL;
 
-	if ((dmanr < 0) || (dmanr >= MAX_DMA_CHANNELS)) {
 		printk(KERN_CRIT "cris_request_dma: invalid DMA channel %u
", dmanr);
 		return -EINVAL;
 	}
@@ -213,7 +213,7 @@ int cris_request_dma(unsigned int dmanr,
 void cris_free_dma(unsigned int dmanr, const char * device_id)
 {
 	unsigned long flags;
-	if ((dmanr < 0) || (dmanr >= MAX_DMA_CHANNELS)) {
 		printk(KERN_CRIT "cris_free_dma: invalid DMA channel %u
", dmanr);
 		return;
 	}
----[ arch/m32r/kernel/module.c, Elf32_Addr ]----
--- arch/m32r/kernel/module.c	2008-08-07 17:52:52.000000000 +0200
@@ -172,7 +172,7 @@ int apply_relocate_add(Elf32_Shdr *sechd
 			break;
 		case R_M32R_18_PCREL_RELA:
 	  		relocation = (relocation - (Elf32_Addr) location);
-			if (relocation < -0x20000 || 0x1fffc < relocation)
 				{
 					printk(KERN_ERR "module %s: relocation overflow: %u
",
 					me->name, relocation);
@@ -204,7 +204,7 @@ int apply_relocate_add(Elf32_Shdr *sechd
 			break;
 		case R_M32R_26_PCREL_RELA:
 	  		relocation = (relocation - (Elf32_Addr) location);
-			if (relocation < -0x2000000 || 0x1fffffc < relocation)
 				{
 					printk(KERN_ERR "module %s: relocation overflow: %u
",
 					me->name, relocation);
----[ arch/m32r/kernel/ptrace.c, unsigned long ]----
--- arch/m32r/kernel/ptrace.c	2008-07-19 23:16:48.000000000 +0200
@@ -78,7 +78,7 @@ static int ptrace_read_user(struct task_
 	struct user * dummy = NULL;
 #endif
 
-	if ((off & 3) || (off < 0) || (off > sizeof(struct user) - 3))
 		return -EIO;
 
 	off >>= 2;
@@ -140,7 +140,7 @@ static int ptrace_write_user(struct task
 	struct user * dummy = NULL;
 #endif
 
-	if ((off & 3) || off < 0 ||
 	    off > sizeof(struct user) - 3)
 		return -EIO;
 
----[ arch/mips/vr41xx/common/irq.c, unsigned ]----
--- arch/mips/vr41xx/common/irq.c	2008-07-19 23:16:48.000000000 +0200
@@ -80,7 +80,7 @@ static void irq_dispatch(unsigned int ir
 			desc->chip->ack(source_irq);
 		}
 		irq = cascade->get_irq(irq);
-		if (irq < 0)
 			atomic_inc(&irq_err_count);
 		else
 			irq_dispatch(irq);
----[ arch/powerpc/kernel/udbg_16550.c, unsigned ]----
--- arch/powerpc/kernel/udbg_16550.c	2008-07-19 23:16:48.000000000 +0200
@@ -142,7 +142,7 @@ unsigned int udbg_probe_uart_speed(void 
 	speed = (clock / prescaler) / (divisor * 16);
 
 	/* sanity check */
-	if (speed < 0 || speed > (clock / 16))
 		speed = 9600;
 
 	return speed;
----[ arch/powerpc/oprofile/cell/vma_map.c, unsigned ]----
--- arch/powerpc/oprofile/cell/vma_map.c	2008-07-19 23:16:48.000000000 +0200
@@ -229,7 +229,7 @@ struct vma_to_fileoffset_map *create_vma
 	 */
 	overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym,
 					    aSpu, &grd_val);
-	if (overlay_tbl_offset < 0) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Error finding SPU overlay table
",
 		       __func__, __LINE__);
----[ arch/powerpc/sysdev/fsl_msi.c, irq_hw_number_t ]----
--- arch/powerpc/sysdev/fsl_msi.c	2008-07-19 23:16:49.000000000 +0200
@@ -206,7 +206,7 @@ static int fsl_setup_msi_irqs(struct pci
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
 		hwirq = fsl_msi_alloc_hwirqs(msi_data, 1);
-		if (hwirq < 0) {
 			rc = hwirq;
 			pr_debug("%s: fail allocating msi interrupt
",
 					__func__);
----[ arch/s390/appldata/appldata_base.c, unsigned ]----
--- arch/s390/appldata/appldata_base.c	2008-07-19 23:16:49.000000000 +0200
@@ -424,7 +424,7 @@ out:
  */
 int appldata_register_ops(struct appldata_ops *ops)
 {
-	if ((ops->size > APPLDATA_MAX_REC_SIZE) || (ops->size < 0))
 		return -EINVAL;
 
 	ops->ctl_table = kzalloc(4 * sizeof(struct ctl_table), GFP_KERNEL);
----[ arch/sh/kernel/cpu/irq/intc.c, unsigned ]----
--- arch/sh/kernel/cpu/irq/intc.c	2008-08-07 17:53:01.000000000 +0200
@@ -466,7 +466,7 @@ static unsigned int __init intc_prio_dat
 			fn += (pr->reg_width >> 3) - 1;
 			bit = pr->reg_width - ((j + 1) * pr->field_width);
 
-			BUG_ON(bit < 0);
 
 			return _INTC_MK(fn, mode,
 					intc_get_reg(d, reg_e),
@@ -533,7 +533,7 @@ static unsigned int __init intc_sense_da
 			fn += (sr->reg_width >> 3) - 1;
 			bit = sr->reg_width - ((j + 1) * sr->field_width);
 
-			BUG_ON(bit < 0);
 
 			return _INTC_MK(fn, 0, intc_get_reg(d, sr->reg),
 					0, sr->field_width, bit);
----[ arch/sparc/kernel/process.c, unsigned long ]----
--- arch/sparc/kernel/process.c	2008-08-07 17:53:01.000000000 +0200
@@ -435,7 +435,7 @@ asmlinkage int sparc_do_fork(unsigned lo
 	 * the parent's %o1.  So detect that case and restore it
 	 * here.
 	 */
-	if ((unsigned long)ret >= -ERESTART_RESTARTBLOCK)
 		regs->u_regs[UREG_I1] = orig_i1;
 
 	return ret;
----[ arch/sparc64/kernel/process.c, unsigned long ]----
--- arch/sparc64/kernel/process.c	2008-08-07 17:53:01.000000000 +0200
@@ -593,7 +593,7 @@ asmlinkage long sparc_do_fork(unsigned l
 	 * the parent's %o1.  So detect that case and restore it
 	 * here.
 	 */
-	if ((unsigned long)ret >= -ERESTART_RESTARTBLOCK)
 		regs->u_regs[UREG_I1] = orig_i1;
 
 	return ret;
----[ drivers/acpi/processor_core.c, u32 ]----
--- drivers/acpi/processor_core.c	2008-08-07 17:53:01.000000000 +0200
@@ -667,7 +667,7 @@ static int __cpuinit acpi_processor_star
 		return 0;
 	}
 
-	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
 
 	/*
 	 * Buggy BIOS check
----[ drivers/atm/fore200e.c, u32 ]----
--- drivers/atm/fore200e.c	2008-08-07 17:53:01.000000000 +0200
@@ -2932,7 +2932,7 @@ fore200e_proc_read(struct atm_dev *dev, 
 	u32 media_index    = FORE200E_MEDIA_INDEX(fore200e->bus->read(&fore200e->cp_queues->media_type));
 	u32 oc3_index;
 
-	if ((media_index < 0) || (media_index > 4))
 	    media_index = 5;
 	
 	switch (fore200e->loop_mode) {
----[ drivers/atm/fore200e.c, unsigned long ]----
--- drivers/atm/fore200e.c	2008-08-07 17:53:01.000000000 +0200
@@ -1029,7 +1029,7 @@ int bsq_audit(int where, struct host_bsq
 		   where, scheme, magn, buffer->index, buffer->scheme);
 	}
 
-	if ((buffer->index < 0) || (buffer->index >= fore200e_rx_buf_nbr[ scheme ][ magn ])) {
 	    printk(FORE200E "bsq_audit(%d): queue %d.%d, out of range buffer index = %ld !
",
 		   where, scheme, magn, buffer->index);
 	}
----[ drivers/atm/he.c, unsigned ]----
--- drivers/atm/he.c	2008-08-07 17:53:01.000000000 +0200
@@ -2698,7 +2698,7 @@ he_ioctl(struct atm_dev *atm_dev, unsign
 			spin_lock_irqsave(&he_dev->global_lock, flags);
 			switch (reg.type) {
 				case HE_REGTYPE_PCI:
-					if (reg.addr < 0 || reg.addr >= HE_REGMAP_SIZE) {
 						err = -EINVAL;
 						break;
 					}
----[ drivers/block/swim3.c, sector_t ]----
--- drivers/block/swim3.c	2008-07-19 23:16:49.000000000 +0200
@@ -319,7 +319,7 @@ static void start_request(struct floppy_
 		       req->errors, req->current_nr_sectors);
 #endif
 
-		if (req->sector < 0 || req->sector >= fs->total_secs) {
 			end_request(req, 0);
 			continue;
 		}
----[ drivers/char/dsp56k.c, unsigned long ]----
--- drivers/char/dsp56k.c	2008-08-07 17:53:01.000000000 +0200
@@ -383,7 +383,7 @@ static long dsp56k_ioctl(struct file *fi
 			return put_user(status, &hf->status);
 		}
 		case DSP56K_HOST_CMD:
-			if (arg > 31 || arg < 0)
 				return -EINVAL;
 			lock_kernel();
 			dsp56k_host_interface.cvr = (u_char)((arg & DSP56K_CVR_HV_MASK) |
----[ drivers/char/esp.c, unsigned ]----
--- drivers/char/esp.c	2008-08-07 17:53:01.000000000 +0200
@@ -2368,7 +2368,7 @@ static int __init espserial_init(void)
 	if ((flow_on < 1) || (flow_on > 1023))
 		flow_on = 944;
 
-	if ((rx_timeout < 0) || (rx_timeout > 255))
 		rx_timeout = 128;
 
 	if (flow_on >= flow_off)
----[ drivers/char/hvc_console.c, unsigned ]----
--- drivers/char/hvc_console.c	2008-08-07 17:53:01.000000000 +0200
@@ -382,7 +382,7 @@ static void hvc_close(struct tty_struct 
 		 */
 		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
 	} else {
-		if (hp->count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d
",
 				hp->vtermno, hp->count);
 		spin_unlock_irqrestore(&hp->lock, flags);
----[ drivers/char/hvcs.c, unsigned ]----
--- drivers/char/hvcs.c	2008-08-07 17:53:01.000000000 +0200
@@ -1248,7 +1248,7 @@ static void hvcs_close(struct tty_struct
 		free_irq(irq, hvcsd);
 		kref_put(&hvcsd->kref, destroy_hvcs_struct);
 		return;
-	} else if (hvcsd->open_count < 0) {
 		printk(KERN_ERR "HVCS: vty-server@%X open_count: %d"
 				" is missmanaged.
",
 		hvcsd->vdev->unit_address, hvcsd->open_count);
----[ drivers/char/hvsi.c, unsigned ]----
--- drivers/char/hvsi.c	2008-07-19 23:16:49.000000000 +0200
@@ -908,7 +908,7 @@ static void hvsi_close(struct tty_struct
 
 			spin_lock_irqsave(&hp->lock, flags);
 		}
-	} else if (hp->count < 0)
 		printk(KERN_ERR "hvsi_close %lu: oops, count is %d
",
 		       hp - hvsi_ports, hp->count);
 
----[ drivers/char/rio/rioctrl.c, uint ]----
--- drivers/char/rio/rioctrl.c	2008-08-07 17:53:01.000000000 +0200
@@ -401,7 +401,7 @@ int riocontrol(struct rio_info *p, dev_t
 	case RIO_RESUME:
 		rio_dprintk(RIO_DEBUG_CTRL, "RIO_RESUME
");
 		port = arg;
-		if ((port < 0) || (port > 511)) {
 			rio_dprintk(RIO_DEBUG_CTRL, "RIO_RESUME: Bad port number %d
", port);
 			p->RIOError.Error = PORT_NUMBER_OUT_OF_RANGE;
 			return -EINVAL;
@@ -494,7 +494,7 @@ int riocontrol(struct rio_info *p, dev_t
 			return -EFAULT;
 		}
 		rio_dprintk(RIO_DEBUG_CTRL, "Get module type for port %d
", port);
-		if (port < 0 || port > 511) {
 			rio_dprintk(RIO_DEBUG_CTRL, "RIO_GET_MODTYPE: Bad port number %d
", port);
 			p->RIOError.Error = PORT_NUMBER_OUT_OF_RANGE;
 			return -EINVAL;
@@ -1142,7 +1142,7 @@ int riocontrol(struct rio_info *p, dev_t
 	case RIO_MAP_B110_TO_115200:
 		rio_dprintk(RIO_DEBUG_CTRL, "Baud rate mapping
");
 		port = arg;
-		if (port < 0 || port > 511) {
 			rio_dprintk(RIO_DEBUG_CTRL, "Baud rate mapping: Bad port number %d
", port);
 			p->RIOError.Error = PORT_NUMBER_OUT_OF_RANGE;
 			return -EINVAL;
----[ drivers/gpu/drm/drm_bufs.c, unsigned long ]----
--- drivers/gpu/drm/drm_bufs.c	2008-07-19 23:16:49.000000000 +0200
@@ -1537,7 +1537,7 @@ int drm_mapbufs(struct drm_device *dev, 
 					  MAP_SHARED, 0);
 			up_write(&current->mm->mmap_sem);
 		}
-		if (virtual > -1024UL) {
 			/* Real error */
 			retcode = (signed long)virtual;
 			goto done;
----[ drivers/hid/usbhid/hiddev.c, unsigned long ]----
--- drivers/hid/usbhid/hiddev.c	2008-08-07 17:53:02.000000000 +0200
@@ -572,7 +572,7 @@ static long hiddev_ioctl(struct file *fi
 		return put_user(HID_VERSION, (int __user *)arg);
 
 	case HIDIOCAPPLICATION:
-		if (arg < 0 || arg >= hid->maxapplication)
 			return -EINVAL;
 
 		for (i = 0; i < hid->maxcollection; i++)
----[ drivers/hwmon/fscpos.c, unsigned long ]----
--- drivers/hwmon/fscpos.c	2008-07-19 23:16:49.000000000 +0200
@@ -240,7 +240,7 @@ static ssize_t set_pwm(struct i2c_client
 	unsigned long v = simple_strtoul(buf, NULL, 10);
 
 	/* Range: 0..255 */
-	if (v < 0) v = 0;
 	if (v > 255) v = 255;
 
 	mutex_lock(&data->update_lock);
----[ drivers/i2c/chips/tsl2550.c, unsigned long ]----
--- drivers/i2c/chips/tsl2550.c	2008-07-19 23:16:49.000000000 +0200
@@ -221,7 +221,7 @@ static ssize_t tsl2550_store_power_state
 	unsigned long val = simple_strtoul(buf, NULL, 10);
 	int ret;
 
-	if (val < 0 || val > 1)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -253,7 +253,7 @@ static ssize_t tsl2550_store_operating_m
 	unsigned long val = simple_strtoul(buf, NULL, 10);
 	int ret;
 
-	if (val < 0 || val > 1)
 		return -EINVAL;
 
 	if (data->power_state == 0)
----[ drivers/ieee1394/dv1394.c, unsigned ]----
--- drivers/ieee1394/dv1394.c	2008-08-07 17:53:02.000000000 +0200
@@ -918,7 +918,7 @@ static int do_dv1394_init(struct video_c
 		/* default SYT offset is 3 cycles */
 		init->syt_offset = 3;
 
-	if ( (init->channel > 63) || (init->channel < 0) )
 		init->channel = 63;
 
 	chan_mask = (u64)1 << init->channel;
----[ drivers/ieee1394/video1394.c, unsigned ]----
--- drivers/ieee1394/video1394.c	2008-08-07 17:53:02.000000000 +0200
@@ -893,7 +893,7 @@ static long video1394_ioctl(struct file 
 		if (unlikely(d == NULL))
 			return -EFAULT;
 
-		if (unlikely((v.buffer<0) || (v.buffer>=d->num_desc - 1))) {
 			PRINT(KERN_ERR, ohci->host->id,
 			      "Buffer %d out of range",v.buffer);
 			return -EINVAL;
@@ -959,7 +959,7 @@ static long video1394_ioctl(struct file 
 		if (unlikely(d == NULL))
 			return -EFAULT;
 
-		if (unlikely((v.buffer<0) || (v.buffer>d->num_desc - 1))) {
 			PRINT(KERN_ERR, ohci->host->id,
 			      "Buffer %d out of range",v.buffer);
 			return -EINVAL;
@@ -1030,7 +1030,7 @@ static long video1394_ioctl(struct file 
 		d = find_ctx(&ctx->context_list, OHCI_ISO_TRANSMIT, v.channel);
 		if (d == NULL) return -EFAULT;
 
-		if ((v.buffer<0) || (v.buffer>=d->num_desc - 1)) {
 			PRINT(KERN_ERR, ohci->host->id,
 			      "Buffer %d out of range",v.buffer);
 			return -EINVAL;
@@ -1137,7 +1137,7 @@ static long video1394_ioctl(struct file 
 		d = find_ctx(&ctx->context_list, OHCI_ISO_TRANSMIT, v.channel);
 		if (d == NULL) return -EFAULT;
 
-		if ((v.buffer<0) || (v.buffer>=d->num_desc-1)) {
 			PRINT(KERN_ERR, ohci->host->id,
 			      "Buffer %d out of range",v.buffer);
 			return -EINVAL;
----[ drivers/infiniband/core/user_mad.c, __u32 ]----
--- drivers/infiniband/core/user_mad.c	2008-07-19 23:16:50.000000000 +0200
@@ -465,7 +465,7 @@ static ssize_t ib_umad_write(struct file
 		goto err;
 	}
 
-	if (packet->mad.hdr.id < 0 ||
 	    packet->mad.hdr.id >= IB_UMAD_MAX_AGENTS) {
 		ret = -EINVAL;
 		goto err;
----[ drivers/infiniband/core/user_mad.c, u32 ]----
--- drivers/infiniband/core/user_mad.c	2008-07-19 23:16:50.000000000 +0200
@@ -710,7 +710,7 @@ static int ib_umad_unreg_agent(struct ib
 	mutex_lock(&file->port->file_mutex);
 	mutex_lock(&file->mutex);
 
-	if (id < 0 || id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
 		ret = -EINVAL;
 		goto out;
 	}
----[ drivers/isdn/hardware/mISDN/hfcmulti.c, uint ]----
--- drivers/isdn/hardware/mISDN/hfcmulti.c	2008-08-07 17:53:02.000000000 +0200
@@ -4858,7 +4858,7 @@ hfcmulti_init(struct pci_dev *pdev, cons
 	hc->id = HFC_cnt;
 	hc->pcm = pcm[HFC_cnt];
 	hc->io_mode = iomode[HFC_cnt];
-	if (dslot[HFC_cnt] < 0) {
 		hc->dslot = 0;
 		printk(KERN_INFO "HFC-E1 card has disabled D-channel, but "
 			"31 B-channels
");
----[ drivers/isdn/mISDN/core.c, u_int ]----
--- drivers/isdn/mISDN/core.c	2008-08-07 17:53:02.000000000 +0200
@@ -79,7 +79,7 @@ mISDN_register_device(struct mISDNdevice
 	int	err;
 
 	dev->id = get_free_devid();
-	if (dev->id < 0)
 		return -EBUSY;
 	if (name && name[0])
 		strcpy(dev->name, name);
----[ drivers/macintosh/therm_adt746x.c, u32 ]----
--- drivers/macintosh/therm_adt746x.c	2008-08-07 17:52:52.000000000 +0200
@@ -500,7 +500,7 @@ static ssize_t store_##name(struct devic
 {								\
 	u32 val;						\
 	val = simple_strtoul(buf, NULL, 10);			\
-	if (val < 0 || val > 255)				\
 		return -EINVAL;					\
 	printk(KERN_INFO "Setting specified fan speed to %d
", val);	\
 	data = val;						\
----[ drivers/macintosh/windfarm_smu_sat.c, unsigned ]----
--- drivers/macintosh/windfarm_smu_sat.c	2008-07-19 23:16:50.000000000 +0200
@@ -88,7 +88,7 @@ struct smu_sdbp_header *smu_sat_get_sdb_
 	}
 
 	len = i2c_smbus_read_word_data(&sat->i2c, 9);
-	if (len < 0) {
 		printk(KERN_ERR "smu_sat_get_sdb_part rd len error
");
 		return NULL;
 	}
----[ drivers/media/video/bt8xx/bttv-driver.c, unsigned ]----
--- drivers/media/video/bt8xx/bttv-driver.c	2008-08-07 17:53:02.000000000 +0200
@@ -1288,7 +1288,7 @@ set_tvnorm(struct bttv *btv, unsigned in
 	const struct bttv_tvnorm *tvnorm;
 	v4l2_std_id id;
 
-	if (norm < 0 || norm >= BTTV_TVNORMS)
 		return -EINVAL;
 
 	tvnorm = &bttv_tvnorms[norm];
@@ -4632,7 +4632,7 @@ static int __init bttv_init_module(void)
 #endif
 	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
 		gbuffers = 2;
-	if (gbufsize < 0 || gbufsize > BTTV_MAX_FBUF)
 		gbufsize = BTTV_MAX_FBUF;
 	gbufsize = (gbufsize + PAGE_SIZE - 1) & PAGE_MASK;
 	if (bttv_verbose)
----[ drivers/media/video/cx18/cx18-ioctl.c, unsigned ]----
--- drivers/media/video/cx18/cx18-ioctl.c	2008-08-07 17:53:02.000000000 +0200
@@ -461,7 +461,7 @@ int cx18_s_input(struct file *file, void
 	if (ret)
 		return ret;
 
-	if (inp < 0 || inp >= cx->nof_inputs)
 		return -EINVAL;
 
 	if (inp == cx->active_input) {
----[ drivers/media/video/cx23885/cx23885-417.c, u32 ]----
--- drivers/media/video/cx23885/cx23885-417.c	2008-08-07 17:53:02.000000000 +0200
@@ -1029,7 +1029,7 @@ static int cx23885_initialize_codec(stru
 			return retval;
 		}
 		dev->cx23417_mailbox = cx23885_find_mailbox(dev);
-		if (dev->cx23417_mailbox < 0) {
 			printk(KERN_ERR "%s() mailbox < 0, error
",
 				__func__);
 			return -1;
----[ drivers/media/video/ivtv/ivtv-ioctl.c, unsigned ]----
--- drivers/media/video/ivtv/ivtv-ioctl.c	2008-08-07 17:53:02.000000000 +0200
@@ -985,7 +985,7 @@ int ivtv_s_input(struct file *file, void
 {
 	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
 
-	if (inp < 0 || inp >= itv->nof_inputs)
 		return -EINVAL;
 
 	if (inp == itv->active_input) {
----[ drivers/media/video/meye.c, unsigned ]----
--- drivers/media/video/meye.c	2008-08-07 17:53:02.000000000 +0200
@@ -1980,7 +1980,7 @@ static struct pci_driver meye_driver = {
 static int __init meye_init(void)
 {
 	gbuffers = max(2, min((int)gbuffers, MEYE_MAX_BUFNBRS));
-	if (gbufsize < 0 || gbufsize > MEYE_MAX_BUFSIZE)
 		gbufsize = MEYE_MAX_BUFSIZE;
 	gbufsize = PAGE_ALIGN(gbufsize);
 	printk(KERN_INFO "meye: using %d buffers with %dk (%dk total) "
----[ drivers/media/video/pxa_camera.c, unsigned ]----
--- drivers/media/video/pxa_camera.c	2008-08-31 16:16:33.000000000 +0200
@@ -1146,7 +1146,7 @@ static int pxa_camera_probe(struct platf
 	/* request dma */
 	pcdev->dma_chans[0] = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
 					      pxa_camera_dma_irq_y, pcdev);
-	if (pcdev->dma_chans[0] < 0) {
 		dev_err(pcdev->dev, "Can't request DMA for Y
");
 		err = -ENOMEM;
 		goto exit_iounmap;
@@ -1155,7 +1155,7 @@ static int pxa_camera_probe(struct platf
 
 	pcdev->dma_chans[1] = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
 					      pxa_camera_dma_irq_u, pcdev);
-	if (pcdev->dma_chans[1] < 0) {
 		dev_err(pcdev->dev, "Can't request DMA for U
");
 		err = -ENOMEM;
 		goto exit_free_dma_y;
@@ -1164,7 +1164,7 @@ static int pxa_camera_probe(struct platf
 
 	pcdev->dma_chans[2] = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
 					      pxa_camera_dma_irq_v, pcdev);
-	if (pcdev->dma_chans[0] < 0) {
 		dev_err(pcdev->dev, "Can't request DMA for V
");
 		err = -ENOMEM;
 		goto exit_free_dma_u;
----[ drivers/media/video/saa7134/saa7134-video.c, unsigned ]----
--- drivers/media/video/saa7134/saa7134-video.c	2008-08-07 17:53:03.000000000 +0200
@@ -1753,7 +1753,7 @@ static int saa7134_s_input(struct file *
 	if (0 != err)
 		return err;
 
-	if (i < 0  ||  i >= SAA7134_INPUT_MAX)
 		return -EINVAL;
 	if (NULL == card_in(dev, i).name)
 		return -EINVAL;
@@ -2470,7 +2470,7 @@ int saa7134_video_init1(struct saa7134_d
 	/* sanitycheck insmod options */
 	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
 		gbuffers = 2;
-	if (gbufsize < 0 || gbufsize > gbufsize_max)
 		gbufsize = gbufsize_max;
 	gbufsize = (gbufsize + PAGE_SIZE - 1) & PAGE_MASK;
 
----[ drivers/media/video/usbvision/usbvision-video.c, unsigned ]----
--- drivers/media/video/usbvision/usbvision-video.c	2008-08-07 17:53:03.000000000 +0200
@@ -617,7 +617,7 @@ static int vidioc_s_input (struct file *
 	struct usb_usbvision *usbvision =
 		(struct usb_usbvision *) video_get_drvdata(dev);
 
-	if ((input >= usbvision->video_inputs) || (input < 0) )
 		return -EINVAL;
 
 	mutex_lock(&usbvision->lock);
----[ drivers/media/video/vino.c, __u32 ]----
--- drivers/media/video/vino.c	2008-08-31 16:16:33.000000000 +0200
@@ -3220,7 +3220,7 @@ static int vino_v4l2_enum_fmt(struct vin
 
 	switch (fd->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if ((fd->index < 0) ||
 		    (fd->index >= VINO_DATA_FMT_COUNT))
 			return -EINVAL;
 		dprintk("format name = %s
",
----[ drivers/message/fusion/mptscsih.c, unsigned long ]----
--- drivers/message/fusion/mptscsih.c	2008-08-07 17:53:03.000000000 +0200
@@ -1621,7 +1621,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 
 	/* Isse the Task Mgmt request.
 	 */
-	if (hd->hard_resets < -1)
 		hd->hard_resets++;
 
 	rc = mptscsih_IssueTaskMgmt(hd, type, channel, id, lun,
@@ -1844,7 +1844,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		goto out;
 	}
 
-	if (hd->timeouts < -1)
 		hd->timeouts++;
 
 	/* Most important!  Set TaskMsgContext to SCpnt's MsgContext!
@@ -1970,7 +1970,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 	       ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
-	if (hd->timeouts < -1)
 		hd->timeouts++;
 
 	vdevice = SCpnt->device->hostdata;
@@ -2741,7 +2741,7 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 		break;
 	case MPI_EVENT_IOC_BUS_RESET:			/* 04 */
 	case MPI_EVENT_EXT_BUS_RESET:			/* 05 */
-		if (hd && (ioc->bus_type == SPI) && (hd->soft_resets < -1))
 			hd->soft_resets++;
 		break;
 	case MPI_EVENT_LOGOUT:				/* 09 */
----[ drivers/message/i2o/i2o_block.c, unsigned long ]----
--- drivers/message/i2o/i2o_block.c	2008-07-19 23:16:50.000000000 +0200
@@ -670,7 +670,7 @@ static int i2o_block_ioctl(struct inode 
 	case BLKI2OGWSTRAT:
 		return put_user(dev->wcache, (int __user *)arg);
 	case BLKI2OSRSTRAT:
-		if (arg < 0 || arg > CACHE_SMARTFETCH)
 			return -EINVAL;
 		dev->rcache = arg;
 		break;
----[ drivers/mfd/sm501.c, unsigned ]----
--- drivers/mfd/sm501.c	2008-08-07 17:53:03.000000000 +0200
@@ -1390,7 +1390,7 @@ static int sm501_plat_probe(struct platf
 	sm->mem_res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	sm->platdata = dev->dev.platform_data;
 
-	if (sm->irq < 0) {
 		dev_err(&dev->dev, "failed to get irq resource
");
 		err = sm->irq;
 		goto err_res;
----[ drivers/misc/intel_menlow.c, unsigned long ]----
--- drivers/misc/intel_menlow.c	2008-07-19 23:16:50.000000000 +0200
@@ -121,7 +121,7 @@ static int memory_set_cur_bandwidth(stru
 	if (memory_get_int_max_bandwidth(cdev, &max_state))
 		return -EFAULT;
 
-	if (max_state < 0 || state > max_state)
 		return -EINVAL;
 
 	arg_list.count = 1;
----[ drivers/mtd/devices/slram.c, unsigned long ]----
--- drivers/mtd/devices/slram.c	2008-08-07 17:53:03.000000000 +0200
@@ -273,7 +273,7 @@ static int parse_cmdline(char *devname, 
 	}
 	T("slram: devname=%s, devstart=0x%lx, devlength=0x%lx
",
 			devname, devstart, devlength);
-	if ((devstart < 0) || (devlength < 0) || (devlength % SLRAM_BLK_SZ != 0)) {
 		E("slram: Illegal start / length parameter.
");
 		return(-EINVAL);
 	}
----[ drivers/mtd/ubi/build.c, unsigned long ]----
--- drivers/mtd/ubi/build.c	2008-08-07 17:53:03.000000000 +0200
@@ -1104,7 +1104,7 @@ static int __init bytes_str_to_int(const
 	unsigned long result;
 
 	result = simple_strtoul(str, &endp, 0);
-	if (str == endp || result < 0) {
 		printk(KERN_ERR "UBI error: incorrect bytes count: \"%s\"
",
 		       str);
 		return -EINVAL;
----[ drivers/net/ax88796.c, unsigned ]----
--- drivers/net/ax88796.c	2008-07-19 23:16:50.000000000 +0200
@@ -839,7 +839,7 @@ static int ax_probe(struct platform_devi
 	/* find the platform resources */
 
 	dev->irq  = platform_get_irq(pdev, 0);
-	if (dev->irq < 0) {
 		dev_err(&pdev->dev, "no IRQ specified
");
 		ret = -ENXIO;
 		goto exit_mem;
----[ drivers/net/gianfar.c, unsigned ]----
--- drivers/net/gianfar.c	2008-08-07 17:53:05.000000000 +0200
@@ -191,11 +191,11 @@ static int gfar_probe(struct platform_de
 		priv->interruptTransmit = platform_get_irq_byname(pdev, "tx");
 		priv->interruptReceive = platform_get_irq_byname(pdev, "rx");
 		priv->interruptError = platform_get_irq_byname(pdev, "error");
-		if (priv->interruptTransmit < 0 || priv->interruptReceive < 0 || priv->interruptError < 0)
 			goto regs_fail;
 	} else {
 		priv->interruptTransmit = platform_get_irq(pdev, 0);
-		if (priv->interruptTransmit < 0)
 			goto regs_fail;
 	}
 
----[ drivers/net/ixp2000/ixpdev.c, u32 ]----
--- drivers/net/ixp2000/ixpdev.c	2008-08-07 17:53:05.000000000 +0200
@@ -96,7 +96,7 @@ static int ixpdev_rx(struct net_device *
 			goto err;
 		}
 
-		if (desc->channel < 0 || desc->channel >= nds_count) {
 			printk(KERN_ERR "ixp2000: rx err, channel %d
",
 					desc->channel);
 			goto err;
----[ drivers/net/sh_eth.c, unsigned ]----
--- drivers/net/sh_eth.c	2008-08-07 17:53:06.000000000 +0200
@@ -1183,7 +1183,7 @@ static int sh_eth_drv_probe(struct platf
 
 	ndev->dma = -1;
 	ndev->irq = platform_get_irq(pdev, 0);
-	if (ndev->irq < 0) {
 		ret = -ENODEV;
 		goto out_release;
 	}
----[ drivers/net/wireless/hermes.c, unsigned ]----
--- drivers/net/wireless/hermes.c	2008-07-19 23:16:51.000000000 +0200
@@ -439,7 +439,7 @@ int hermes_read_ltv(hermes_t *hw, int ba
 	u16 rlength, rtype;
 	unsigned nwords;
 
-	if ( (bufsize < 0) || (bufsize % 2) )
 		return -EINVAL;
 
 	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS, rid, NULL);
----[ drivers/net/wireless/iwlwifi/iwl-tx.c, u32 ]----
--- drivers/net/wireless/iwlwifi/iwl-tx.c	2008-08-07 17:53:07.000000000 +0200
@@ -126,7 +126,7 @@ int iwl_hw_txq_attach_buf_to_tfd(struct 
 	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
-	if ((num_tbs >= MAX_NUM_OF_TBS) || (num_tbs < 0)) {
 		IWL_ERROR("Error can not send more than %d chunks
",
 			  MAX_NUM_OF_TBS);
 		return -EINVAL;
----[ drivers/ps3/ps3av.c, u32 ]----
--- drivers/ps3/ps3av.c	2008-07-19 23:16:52.000000000 +0200
@@ -846,7 +846,7 @@ int ps3av_set_video_mode(u32 id)
 	u32 option;
 
 	size = ARRAY_SIZE(video_mode_table);
-	if ((id & PS3AV_MODE_MASK) > size - 1 || id < 0) {
 		dev_dbg(&ps3av->dev->core, "%s: error id :%d
", __func__, id);
 		return -EINVAL;
 	}
@@ -895,7 +895,7 @@ int ps3av_video_mode2res(u32 id, u32 *xr
 
 	id = id & PS3AV_MODE_MASK;
 	size = ARRAY_SIZE(video_mode_table);
-	if (id > size - 1 || id < 0) {
 		printk(KERN_ERR "%s: invalid mode %d
", __func__, id);
 		return -EINVAL;
 	}
----[ drivers/rtc/rtc-lib.c, unsigned ]----
--- drivers/rtc/rtc-lib.c	2008-07-19 23:16:52.000000000 +0200
@@ -63,7 +63,7 @@ void rtc_time_to_tm(unsigned long time, 
 	days -= (year - 1970) * 365
 		+ LEAPS_THRU_END_OF(year - 1)
 		- LEAPS_THRU_END_OF(1970 - 1);
-	if (days < 0) {
 		year -= 1;
 		days += 365 + LEAP_YEAR(year);
 	}
----[ drivers/rtc/rtc-sh.c, unsigned ]----
--- drivers/rtc/rtc-sh.c	2008-07-19 23:16:52.000000000 +0200
@@ -585,19 +585,19 @@ static int __devinit sh_rtc_probe(struct
 
 	/* get periodic/carry/alarm irqs */
 	rtc->periodic_irq = platform_get_irq(pdev, 0);
-	if (unlikely(rtc->periodic_irq < 0)) {
 		dev_err(&pdev->dev, "No IRQ for period
");
 		goto err_badres;
 	}
 
 	rtc->carry_irq = platform_get_irq(pdev, 1);
-	if (unlikely(rtc->carry_irq < 0)) {
 		dev_err(&pdev->dev, "No IRQ for carry
");
 		goto err_badres;
 	}
 
 	rtc->alarm_irq = platform_get_irq(pdev, 2);
-	if (unlikely(rtc->alarm_irq < 0)) {
 		dev_err(&pdev->dev, "No IRQ for alarm
");
 		goto err_badres;
 	}
----[ drivers/scsi/dpt_i2o.c, u32 ]----
--- drivers/scsi/dpt_i2o.c	2008-08-07 17:53:08.000000000 +0200
@@ -1248,7 +1248,7 @@ static struct adpt_device* adpt_find_dev
 {
 	struct adpt_device* d;
 
-	if(chan < 0 || chan >= MAX_CHANNEL)
 		return NULL;
 	
 	if( pHba->channel[chan].device == NULL){
----[ drivers/scsi/eata.c, u_int32_t ]----
--- drivers/scsi/eata.c	2008-07-19 23:16:52.000000000 +0200
@@ -2344,11 +2344,11 @@ static irqreturn_t ihdlr(struct Scsi_Hos
 		printk
 		    ("%s: ihdlr, spp->eoc == 0, irq %d, reg 0x%x, count %d.
",
 		     ha->board_name, irq, reg, ha->iocount);
-	if (spp->cpp_index < 0 || spp->cpp_index >= shost->can_queue)
 		printk
 		    ("%s: ihdlr, bad spp->cpp_index %d, irq %d, reg 0x%x, count %d.
",
 		     ha->board_name, spp->cpp_index, irq, reg, ha->iocount);
-	if (spp->eoc == 0 || spp->cpp_index < 0
 	    || spp->cpp_index >= shost->can_queue)
 		goto handled;
 
----[ drivers/scsi/u14-34f.c, unsigned ]----
--- drivers/scsi/u14-34f.c	2008-07-19 23:16:52.000000000 +0200
@@ -1127,7 +1127,7 @@ static void map_dma(unsigned int i, unsi
 
    if (scsi_bufflen(SCpnt)) {
 	   count = scsi_dma_map(SCpnt);
-	   BUG_ON(count < 0);
 
 	   scsi_for_each_sg(SCpnt, sg, count, k) {
 		   cpp->sglist[k].address = H2DEV(sg_dma_address(sg));
----[ drivers/telephony/ixj.c, unsigned long ]----
--- drivers/telephony/ixj.c	2008-08-07 17:53:08.000000000 +0200
@@ -6598,7 +6598,7 @@ static long do_ixj_ioctl(struct file *fi
 			retval = ixj_init_filter_raw(j, &jfr);
 		break;
 	case IXJCTL_GET_FILTER_HIST:
-		if(arg<0||arg>3)
 			retval = -EINVAL;
 		else
 			retval = j->filter_hist[arg];
@@ -6633,7 +6633,7 @@ static long do_ixj_ioctl(struct file *fi
 		}
 		break;
 	case IXJCTL_INTERCOM_STOP:
-		if(arg < 0 || arg >= IXJMAX)
 			return -EINVAL;
 		j->intercom = -1;
 		ixj_record_stop(j);
@@ -6645,7 +6645,7 @@ static long do_ixj_ioctl(struct file *fi
 		idle(get_ixj(arg));
 		break;
 	case IXJCTL_INTERCOM_START:
-		if(arg < 0 || arg >= IXJMAX)
 			return -EINVAL;
 		j->intercom = arg;
 		ixj_record_start(j);
----[ drivers/usb/host/ehci-dbg.c, unsigned ]----
--- drivers/usb/host/ehci-dbg.c	2008-08-07 17:53:08.000000000 +0200
@@ -454,7 +454,7 @@ static void qh_lines (
 				(scratch >> 16) & 0x7fff,
 				scratch,
 				td->urb);
-		if (temp < 0)
 			temp = 0;
 		else if (size < temp)
 			temp = size;
@@ -465,7 +465,7 @@ static void qh_lines (
 	}
 
 	temp = snprintf (next, size, "
");
-	if (temp < 0)
 		temp = 0;
 	else if (size < temp)
 		temp = size;
----[ drivers/usb/host/ehci-hcd.c, unsigned ]----
--- drivers/usb/host/ehci-dbg.c	2008-08-07 17:53:08.000000000 +0200
@@ -454,7 +454,7 @@ static void qh_lines (
 				(scratch >> 16) & 0x7fff,
 				scratch,
 				td->urb);
-		if (temp < 0)
 			temp = 0;
 		else if (size < temp)
 			temp = size;
@@ -465,7 +465,7 @@ static void qh_lines (
 	}
 
 	temp = snprintf (next, size, "
");
-	if (temp < 0)
 		temp = 0;
 	else if (size < temp)
 		temp = size;
----[ drivers/usb/misc/usbtest.c, unsigned ]----
--- drivers/usb/misc/usbtest.c	2008-08-07 17:53:08.000000000 +0200
@@ -1561,8 +1561,8 @@ usbtest_ioctl (struct usb_interface *int
 	if (code != USBTEST_REQUEST)
 		return -EOPNOTSUPP;
 
-	if (param->iterations <= 0 || param->length < 0
-			|| param->sglen < 0 || param->vary < 0)
 		return -EINVAL;
 
 	if (mutex_lock_interruptible(&dev->lock))
----[ drivers/usb/misc/usbtest.c, unsigned long ]----
--- drivers/usb/misc/usbtest.c	2008-08-07 17:53:08.000000000 +0200
@@ -192,7 +192,7 @@ static struct urb *simple_alloc_urb (
 {
 	struct urb		*urb;
 
-	if (bytes < 0)
 		return NULL;
 	urb = usb_alloc_urb (0, GFP_KERNEL);
 	if (!urb)
