Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXDDUwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXDDUwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXDDUwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:52:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38918 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXDDUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:52:07 -0400
Date: Wed, 4 Apr 2007 13:52:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Imre Deak <imre.deak@solidboot.com>
Subject: Re: [PATCH 68/90] ARM: OMAP: FB sync with N800 tree (support for
 dynamic SRAM allocations)
Message-Id: <20070404135254.9233a2db.randy.dunlap@oracle.com>
In-Reply-To: <11757101533672-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757100713004-git-send-email-tony@atomide.com>
	<11757100752021-git-send-email-tony@atomide.com>
	<11757100781275-git-send-email-tony@atomide.com>
	<11757100811771-git-send-email-tony@atomide.com>
	<11757100821353-git-send-email-tony@atomide.com>
	<11757100853841-git-send-email-tony@atomide.com>
	<1175710087578-git-send-email-tony@atomide.com>
	<11757100911247-git-send-email-tony@atomide.com>
	<1175710093864-git-send-email-tony@atomide.com>
	<11757100952384-git-send-email-tony@atomide.com>
	<11757100982726-g!
 it-send-email-tony@atomide.com>
	<11757101012787-git-send-email-tony@atomide.com>
	<1175710103340-git-send-email-tony@atomide.com>
	<11757101072553-git-send-email-tony@atomide.com>
	<11757101101180-git-send-email-tony@atomide.com>
	<11757101123620-git-send-email-tony@atomide.com>
	<11757101141643-git-send-email-tony@atomide.com>
	<11757101533672-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:05:47 -0400 Tony Lindgren wrote:

Referring to multiple places in this patch, please use the preferred
kernel "long comment" style as documented in
Documentation/CodingStyle, Ch. 8, Commenting:

The preferred style for long (multi-line) comments is:

	/*
	 * This is the preferred style for multi-line
	 * comments in the Linux kernel source code.
	 * Please use it consistently.
	 *
	 * Description:  A column of asterisks on the left side,
	 * with beginning and ending almost-blank lines.
	 */


> +/* Get the region_idx`th region from board config/ATAG and convert it to
> + * our internal format.
> + */
> +static int get_fbmem_region(int region_idx, struct omapfb_mem_region *rg)
> +{
> +	const struct omap_fbmem_config	*conf;
> +	u32				paddr;
>  
> -		if (i == OMAPFB_PLANE_NUM) {
> -			printk(KERN_ERR "ignoring extra plane info\n");
> +	conf = omap_get_nr_config(OMAP_TAG_FBMEM,
> +				  struct omap_fbmem_config, region_idx);
> +	if (conf == NULL)
> +		return -ENOENT;
> +
> +	paddr = conf->start;
> +	/* Low bits encode the page allocation mode, if high bits
> +	 * are zero. Otherwise we need a page aligned fixed
> +	 * address.
> +	 */
> +	memset(rg, 0, sizeof(*rg));
> +	rg->type = paddr & ~PAGE_MASK;
> +	rg->paddr = paddr & PAGE_MASK;
> +	rg->size = PAGE_ALIGN(conf->size);
> +	return 0;
> +}
> +
> +static int set_fbmem_region_type(struct omapfb_mem_region *rg, int mem_type,
> +				  unsigned long mem_start,
> +				  unsigned long mem_size)
> +{
> +	/* Check if the configuration specifies the type explicitly.
> +	 * type = 0 && paddr = 0, a default don't care case maps to
> +	 * the SDRAM type.
> +	 */
> +	if (rg->type || (!rg->type && !rg->paddr))
> +		return 0;
> +	if (ranges_overlap(rg->paddr, rg->size, mem_start, mem_size)) {
> +		rg->type = mem_type;
> +		return 0;
> +	}
> +	/* Can't determine it. */
> +	return -1;
> +}
> +
> +/* Called from map_io. We need to call to this early enough so that we
> + * can reserve the fixed SDRAM regions before VM could get hold of them.
> + */
> +void omapfb_reserve_sdram(void)
> +{
> +	struct bootmem_data	*bdata;
> +	unsigned long		sdram_start, sdram_size;
> +	unsigned long		reserved;
> +	int			i;
> +
> +	if (config_invalid)
> +		return;
> +
> +	bdata = NODE_DATA(0)->bdata;
> +	sdram_start = bdata->node_boot_start;
> +	sdram_size = (bdata->node_low_pfn << PAGE_SHIFT) - sdram_start;
> +	reserved = 0;
> +	for (i = 0; ; i++) {
> +		struct omapfb_mem_region	rg;
> +
> +		if (get_fbmem_region(i, &rg) < 0)
>  			break;
> +		if (i == OMAPFB_PLANE_NUM) {
> +			printk(KERN_ERR
> +				"Extraneous FB mem configuration entries\n");
> +			config_invalid = 1;
> +			return;
>  		}
> -		start = fbmem_conf->start;
> -		size  = fbmem_conf->size;
> -		omapfb_config.mem_desc.region[i].paddr = start;
> -		omapfb_config.mem_desc.region[i].size = size;
> -		if (omap_fb_sram_plane != i && start) {
> -			reserve_bootmem(start, size);
> -			total_size += size;
> +		/* Check if it's our memory type. */
> +		if (set_fbmem_region_type(&rg, OMAPFB_MEMTYPE_SDRAM,
> +				          sdram_start, sdram_size) < 0 ||
> +		    (rg.type != OMAPFB_MEMTYPE_SDRAM))
> +			continue;
> +		BUG_ON(omapfb_config.mem_desc.region[i].size);
> +		if (check_fbmem_region(i, &rg, sdram_start, sdram_size) < 0) {
> +			config_invalid = 1;
> +			return;
>  		}
> -		i++;
> +		if (rg.paddr)
> +			reserve_bootmem(rg.paddr, rg.size);
> +		reserved += rg.size;
> +		omapfb_config.mem_desc.region[i] = rg;
> +		configured_regions++;
>  	}
>  	omapfb_config.mem_desc.region_cnt = i;
> -	if (total_size)
> +	if (reserved)
>  		pr_info("Reserving %lu bytes SDRAM for frame buffer\n",
> -			 total_size);
> +			 reserved);
> +}
>  
> +/* Called at sram init time, before anything is pushed to the SRAM stack.
> + * Because of the stack scheme, we will allocate everything from the
> + * start of the lowest address region to the end of SRAM. This will also
> + * include padding for page alignment and possible holes between regions.
> + *
> + * As opposed to the SDRAM case, we'll also do any dynamic allocations at
> + * this point, since the driver built as a module would have problem with
> + * freeing / reallocating the regions.
> + */
> +unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
> +				  unsigned long sram_vstart,
> +				  unsigned long sram_size,
> +				  unsigned long pstart_avail,
> +				  unsigned long size_avail)
> +{
> +	struct omapfb_mem_region	rg;
> +	unsigned long			pend_avail;
> +	unsigned long			reserved;
> +	int				i;
> +
> +	if (config_invalid)
> +		return 0;
> +
> +	reserved = 0;
> +	pend_avail = pstart_avail + size_avail;
> +	for (i = 0; ; i++) {
> +		if (get_fbmem_region(i, &rg) < 0)
> +			break;
> +		if (i == OMAPFB_PLANE_NUM) {
> +			printk(KERN_ERR
> +				"Extraneous FB mem configuration entries\n");
> +			config_invalid = 1;
> +			return 0;
> +		}
> +
> +		/* Check if it's our memory type. */
> +		if (set_fbmem_region_type(&rg, OMAPFB_MEMTYPE_SRAM,
> +				          sram_pstart, sram_size) < 0 ||
> +		    (rg.type != OMAPFB_MEMTYPE_SRAM))
> +			continue;
> +		BUG_ON(omapfb_config.mem_desc.region[i].size);
> +
> +		if (check_fbmem_region(i, &rg, pstart_avail, size_avail) < 0) {
> +			config_invalid = 1;
> +			return 0;
> +		}
> +
> +		if (!rg.paddr) {
> +			/* Dynamic allocation */
> +			if ((size_avail & PAGE_MASK) < rg.size) {
> +				printk("Not enough SRAM for FB region %d\n",
> +					i);
> +				config_invalid = 1;
> +				return 0;
> +			}
> +			size_avail = (size_avail - rg.size) & PAGE_MASK;
> +			rg.paddr = pstart_avail + size_avail;
> +		}
> +		/* Reserve everything above the start of the region.
> +		 */
> +		if (pend_avail - rg.paddr > reserved)
> +			reserved = pend_avail - rg.paddr;
> +		size_avail = pend_avail - reserved - pstart_avail;
> +
> +		/* We have a kernel mapping for this already, so the
> +		 * driver won't have to make one.
> +		 */
> +		rg.vaddr = (void *)(sram_vstart + rg.paddr - sram_pstart);
> +		omapfb_config.mem_desc.region[i] = rg;
> +		configured_regions++;
> +	}
> +	omapfb_config.mem_desc.region_cnt = i;
> +	if (reserved)
> +		pr_info("Reserving %lu bytes SRAM for frame buffer\n",
> +			 reserved);
> +	return reserved;
>  }
>  
>  void omapfb_set_ctrl_platform_data(void *data)
> @@ -104,10 +300,19 @@ static inline int omap_init_fb(void)
>  {
>  	const struct omap_lcd_config *conf;
>  
> +	if (config_invalid)
> +		return 0;
> +	if (configured_regions != omapfb_config.mem_desc.region_cnt) {
> +		printk(KERN_ERR "Invalid FB mem configuration entries\n");
> +		return 0;
> +	}
>  	conf = omap_get_config(OMAP_TAG_LCD, struct omap_lcd_config);
> -	if (conf == NULL)
> +	if (conf == NULL) {
> +		if (configured_regions)
> +			/* FB mem config, but no LCD config? */
> +			printk(KERN_ERR "Missing LCD configuration\n");
>  		return 0;
> -
> +	}
>  	omapfb_config.lcd = *conf;
>  
>  	return platform_device_register(&omap_fb_device);

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
