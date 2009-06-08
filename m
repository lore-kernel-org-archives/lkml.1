Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbZFHDGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbZFHDGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZFHDGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:06:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:35419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZFHDGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:06:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,322,1241420400"; 
   d="scan'208";a="419682033"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Jun 2009 11:08:35 +0800
Subject: RE: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Thread-Topic: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Thread-Index: Acnml5rPjKxRjoqKT6umLv5b5GMNnwBTe7TA
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313001A45F4EA5@pdsmsx503.ccr.corp.intel.com>
References: <20090606164455.GB27257@intel.com> <4A2A4EF7.7070509@gmail.com>
In-Reply-To: <4A2A4EF7.7070509@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5837d54001475



>-----Original Message-----
>From: Jiri Slaby [mailto:jirislaby@gmail.com]
>Sent: 2009Äê6ÔÂ6ÈÕ 19:12
>To: Gao, Yunpeng
>Cc: gregkh@suse.de; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
>
>On 06/06/2009 06:44 PM, Yunpeng Gao wrote:
>> diff --git a/drivers/staging/mrst_nand/ffsport.c
>b/drivers/staging/mrst_nand/ffsport.c
>> new file mode 100644
>> index 0000000..5a919f4
>> --- /dev/null
>> +++ b/drivers/staging/mrst_nand/ffsport.c
>> @@ -0,0 +1,953 @@
>> +void glob_udelay(unsigned long usecs)
>> +{
>> +	udelay(usecs);
>> +}
>> +
>> +void glob_mdelay(unsigned long msecs)
>> +{
>> +	mdelay(msecs);
>> +}
>
>Unneeded wrappers.
>
>> +u32 *GLOB_MEMMAP_NOCACHE(unsigned long addr, unsigned long size)
>> +{
>> +#if (FLASH_NAND || FLASH_CDMA)
>> +    return (u32 *)ioremap_nocache(addr, (size+0xfff)&(~0xfff));
>
>Use ALIGN() and no cast.
>
>> +#else
>> +    return (u32 *)addr;
>> +#endif
>> +}
>> +
>> +u32 *GLOB_MEMMAP_TOBUS(u32 *ptr)
>> +{
>> +#if (FLASH_NAND || FLASH_CDMA)
>> +    return (u32 *)virt_to_bus(ptr);
>
>Aiee, virt_to_bus.
>
>> +#else
>> +    return ptr;
>> +#endif
>> +}
>...
>> +#define GLOB_SBD_IOCTL_GC
>(0x7701)
>> +#define GLOB_SBD_IOCTL_WL
>(0x7702)
>> +#define GLOB_SBD_IOCTL_FORMAT
>(0x7703)
>> +#define GLOB_SBD_IOCTL_ERASE_FLASH                             (0x7704)
>> +#define GLOB_SBD_IOCTL_FLUSH_CACHE                             (0x7705)
>> +#define GLOB_SBD_IOCTL_COPY_BLK_TABLE                       (0x7706)
>> +#define GLOB_SBD_IOCTL_COPY_WEAR_LEVELING_TABLE  (0x7707)
>> +#define GLOB_SBD_IOCTL_GET_NAND_INFO                         (0x7708)
>> +#define GLOB_SBD_IOCTL_WRITE_DATA                               (0x7709)
>> +#define GLOB_SBD_IOCTL_READ_DATA                             (0x770A)
>
>Could this be defined in an ioctl-standard way?
>
>> +static int GLOB_SBD_majornum;
>> +
>> +static char *GLOB_version = GLOB_VERSION;
>
>You will save a pointer by char [] instead of char *. Also constify it.
>
>> +/* Because the driver will allocate a lot of memory and kmalloc can not */
>> +/* allocat memory more than 4M bytes, here we use static array as */
>> +/* memory pool. This is simple but ugly. It should only be used during */
>> +/* development.*/
>> +#define LOCAL_MEM_POOL_SIZE        (1024 * 1024 * 8)
>> +static u8 local_mem_pool[LOCAL_MEM_POOL_SIZE];
>
>Bah. We have vmalloc.
>
>> +struct ioctl_rw_page_info {
>> +	u8 *data;
>> +	unsigned int page;
>> +};
>
>32/64-bit incompatible.
>
>> +static struct block_device_operations GLOB_SBD_ops = {
>> +	.owner = THIS_MODULE,
>> +	.open = GLOB_SBD_open,
>> +	.release = GLOB_SBD_release,
>> +	.locked_ioctl = GLOB_SBD_ioctl,
>
>Could this be switched to an unlocked one first?
>
>> +	.getgeo = GLOB_SBD_getgeo,
>> +};
>> +
>> +static int SBD_setup_device(struct spectra_nand_dev *dev, int which)
>> +{
>> +	int res_blks;
>> +	u32 sects;
>> +
>> +	nand_dbg_print(NAND_DBG_TRACE, "%s, Line %d, Function: %s\n",
>> +		       __FILE__, __LINE__, __func__);
>> +
>> +	memset(dev, 0, sizeof(struct spectra_nand_dev));
>> +
>> +	nand_dbg_print(NAND_DBG_WARN, "Reserved %d blocks "
>> +		"for OS image, %d blocks for bad block replacement.\n",
>> +		get_res_blk_num_os(),
>> +		get_res_blk_num_bad_blk());
>> +
>> +	res_blks = get_res_blk_num_bad_blk() + get_res_blk_num_os();
>> +
>> +	dev->size = (u64)IdentifyDeviceData.PageDataSize *
>> +		IdentifyDeviceData.PagesPerBlock *
>> +		(IdentifyDeviceData.wDataBlockNum - res_blks);
>> +
>> +	res_blks_os = get_res_blk_num_os();
>> +
>> +	spin_lock_init(&dev->qlock);
>> +
>> +	dev->tmp_buf = kmalloc(IdentifyDeviceData.PageDataSize, GFP_ATOMIC);
>> +	if (!dev->tmp_buf) {
>> +		printk(KERN_ERR "Failed to kmalloc memory in %s Line %d, exit.\n",
>> +			__FILE__, __LINE__);
>> +		goto out_vfree;
>> +	}
>> +
>> +	dev->queue = blk_init_queue(GLOB_SBD_request, &dev->qlock);
>> +	if (dev->queue == NULL) {
>> +		printk(KERN_ERR
>> +		       "Spectra: Request queue could not be initialized."
>> +			" Aborting\n ");
>
>memleak? and further in that function.
>
>> +		goto out_vfree;
>
>> diff --git a/drivers/staging/mrst_nand/lld_cdma.c
>b/drivers/staging/mrst_nand/lld_cdma.c
>> new file mode 100644
>> index 0000000..19650c2
>> --- /dev/null
>> +++ b/drivers/staging/mrst_nand/lld_cdma.c
>> @@ -0,0 +1,2736 @@
>...
>> +static u16 do_ecc_for_desc(u16 c, u8 *buf,
>> +				u16 page)
>> +{
>> +	u16 event = EVENT_NONE;
>> +	u16 err_byte;
>> +	u8 err_sector;
>> +	u8 err_page = 0;
>> +	u8 err_device;
>> +	u16 ecc_correction_info;
>> +	u16 err_address;
>> +	u32 eccSectorSize;
>> +	u8 *err_pos;
>> +
>> +	eccSectorSize   = ECC_SECTOR_SIZE * (DeviceInfo.wDevicesConnected);
>> +
>> +	do {
>> +		if (0 == c)
>> +			err_page = ioread32(FlashReg + ERR_PAGE_ADDR0);
>
>FlashReg doesn't look like an iomap memory. Use readl/writel all over
>the driver.
>
>> +static int check_for_ording(struct pending_cmd (*p)[MAX_CHANS + MAX_DESCS],
>> +	int *chis, int *chMaxIndexes, int (*namb)[MAX_CHANS])
>> +{
>> +	int i, done, ch1, ch2, syncNum, syncNum2;
>> +	u8 indexchgd;
>> +
>> +	indexchgd = 0;
>> +	for (i = 0; (i < totalUsedBanks) && !done && !indexchgd; i++) {
>> +		if (!EOLIST(i) &&
>> +			get_sync_ch_pcmd(p, i, chis[i], &syncNum, &ch1)) {
>> +			debug_boundary_error(ch1, totalUsedBanks, 0);
>> +			if (!EOLIST(ch1) && get_sync_ch_pcmd(p, ch1,
>> +					chis[ch1], &syncNum2, &ch2)) {
>> +				debug_boundary_error(ch2, totalUsedBanks, 0);
>> +				if ((syncNum == syncNum2) &&
>> +					(syncNum != FORCED_ORDERED_SYNC)) {
>> +					if (ch2 != i) {
>> +						nand_dbg_print(NAND_DBG_DEBUG,
>> +						"SYNCCHECK: ILLEGAL CASE: "
>> +						"Channel %d, cmdindx %d, "
>> +						"tag %d is waiting for "
>> +						"sync number %d "
>> +						"from channel %d, "
>> +						"which is waiting for "
>> +						"the same sync number "
>> +						"from channel %d. "
>> +						"Sync checking is aborting\n",
>> +						i, chis[i],
>> +						p[i][chis[i]].Tag,
>> +						syncNum, ch1, ch2);
>> +						done = 1;
>> +					} else {
>> +						if (!(debug_sync_cnt %
>> +							DBG_SNC_PRINTEVERY)) {
>> +							nand_dbg_print(
>> +							NAND_DBG_DEBUG,
>> +							"SYNCCHECK: "
>> +							"syncnum %d "
>> +							"betn Ch %d, "
>> +							"cmdindx %d, "
>> +							"tag %d & Ch %d, "
>> +							"cmdindx %d, tag %d. "
>> +							"chis="
>> +							"{%d, %d, %d, %d}\n",
>> +							syncNum, i,
>> +							chis[i],
>> +							p[i][chis[i]].Tag,
>> +							ch1, chis[ch1],
>> +							p[ch1][chis[ch1]].Tag,
>> +							chis[0], chis[1],
>> +							chis[2], chis[3]);
>> +						}
>> +						if (!check_ordering(p, i,
>> +							namb[ch1][i]+1,
>> +							chis[i], ch1,
>> +							namb[i][ch1]+1,
>> +							chis[ch1]))
>> +							nand_dbg_print(
>> +							NAND_DBG_DEBUG,
>> +							"Above problem "
>> +							"occured when "
>> +							"analyzing "
>> +							"sync %d "
>> +							"between "
>> +							"(ch:%d, indx:%d, "
>> +							"tag:%d) & "
>> +							"(ch:%d, indx:%d, "
>> +							"tag:%d)\n",
>> +							syncNum, i, chis[i],
>> +							p[i][chis[i]].Tag,
>> +							ch1, chis[ch1],
>> +							p[ch1][chis[ch1]].Tag);
>
>Hmm, pretty unreadable. You seem to need to refactor the code.
>
>> diff --git a/drivers/staging/mrst_nand/lld_nand.c
>b/drivers/staging/mrst_nand/lld_nand.c
>> new file mode 100644
>> index 0000000..56ef843
>> --- /dev/null
>> +++ b/drivers/staging/mrst_nand/lld_nand.c
>> @@ -0,0 +1,3113 @@
>...
>> +#define CEIL_DIV(X, Y) (((X)%(Y)) ? ((X)/(Y)+1) : ((X)/(Y)))
>
>Is this DIV_ROUND_UP?
>
>> +u16 conf_parameters[] = {
>
>const?
>
>> +static u16 get_onfi_nand_para(void)
>> +{
>> +	int i;
>> +	u16 blks_lun_l, blks_lun_h, n_of_luns;
>> +	u32 blockperlun, id;
>> +
>> +	iowrite32(DEVICE_RESET__BANK0, FlashReg + DEVICE_RESET);
>> +
>> +	while (!((ioread32(FlashReg + INTR_STATUS0) &
>> +		INTR_STATUS0__RST_COMP) |
>> +		(ioread32(FlashReg + INTR_STATUS0) &
>> +		INTR_STATUS0__TIME_OUT)))
>> +		;
>
>cpu_relax(); And the same further in this function.
>
>> +static const struct pci_device_id nand_pci_ids[] = {
>> +	{
>> +	 .vendor = 0x8086,
>> +	 .device = 0x0809,
>> +	 .subvendor = PCI_ANY_ID,
>> +	 .subdevice = PCI_ANY_ID,
>
>PCI_DEVICE()
>
>> +	 },
>> +	{ /* end: all zeroes */ }
>> +};
>> +
>> +static int dump_pci_config_register(struct pci_dev *dev)
>
>What is this good for?
>
>> +static struct pci_driver nand_pci_driver = {
>
>const
>
>> +	.name = SPECTRA_NAND_NAME,
>> +	.id_table = nand_pci_ids,
>> +	.probe = nand_pci_probe,
>> +	.remove = nand_pci_remove,
>> +};
>> +
>> +u16 NAND_Flash_Init(void)
>> +{
>...
>> +	FlashReg = GLOB_MEMMAP_NOCACHE(GLOB_HWCTL_REG_BASE,
>> +			GLOB_HWCTL_REG_SIZE);
>> +	if (!FlashReg) {
>> +		printk(KERN_ERR "Spectra: ioremap_nocache failed!");
>> +		return -ENOMEM;
>> +	}
>> +	nand_dbg_print(NAND_DBG_WARN,
>> +		"Spectra: Remapped reg base address: "
>> +		"0x%p, len: %d\n",
>> +		FlashReg, GLOB_HWCTL_REG_SIZE);
>> +
>> +	FlashMem = GLOB_MEMMAP_NOCACHE(GLOB_HWCTL_MEM_BASE,
>> +			GLOB_HWCTL_MEM_SIZE);
>> +	if (!FlashMem) {
>
>unmap?
>
>> +		printk(KERN_ERR "Spectra: ioremap_nocache failed!");
>> +		return -ENOMEM;
>> +	}
>...
>> +	/* Enable the 2 lines code will enable pipeline_rw_ahead feature */
>> +	/* and improve performance for about 10%. But will also cause a */
>> +	/* 1 or 2 bit error when do a 300MB+ file copy/compare testing. */
>> +	/* Suspect it's an ECC FIFO overflow issue. -- Yunpeng 2009.03.26 */
>> +	/* iowrite32(1, FlashReg + CACHE_WRITE_ENABLE); */
>> +	/* iowrite32(1, FlashReg + CACHE_READ_ENABLE); */
>> +
>> +	retval = pci_register_driver(&nand_pci_driver);
>> +	if (retval)
>
>unmap?
>
>> +		return -ENOMEM;
>> +
>> +	return PASS;
>> +}
>> +
>> +#endif
>
>HTH.

Thank you very much for the review. All the comments are very helpful to me. As this driver is still under development (some functional feature is not implemented yet), I'll address these comments after enable some new features and then submit new patches. 

Thanks.

Rgds,
Yunpeng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
