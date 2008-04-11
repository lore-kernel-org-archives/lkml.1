Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbYDKVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbYDKVpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYDKVpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:45:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:33078 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbYDKVpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HxhJbHJxihxJXtvXVuvGCtYOfsjD4Iq+EQ0Y5PdWbp0Jq75bD4gFtiOS2rNOIsaCTEwZ5fO0yOnRDVMOwdS8bXhllC1xi7J+o0TkZbBShQd7oEAg4RHK3N7Puj304F27z8Bo6iQwv1AdtXXNf6YH2qROx5xQM9Rjz0B0T/VF6j4=
Message-ID: <47FFDBFF.1030809@gmail.com>
Date: Fri, 11 Apr 2008 23:45:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
CC: York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com> <12053582231281-git-send-email-yorksun@freescale.com> <47D8572C.8090501@gmail.com>
In-Reply-To: <47D8572C.8090501@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping.

Seeing this in -mm yet. Are those comments all wrong? Are you working on it?

On 03/12/2008 11:20 PM, Jiri Slaby wrote:
> On 03/12/2008 10:43 PM, York Sun wrote:
>> +static int fsl_diu_open(struct fb_info *info, int user)
>> +{
>> +    struct mfb_info *mfbi = info->par;
>> +    int res = 0;
>> +
>> +    spin_lock(&diu_lock);
>> +    mfbi->count++;
>> +    if (mfbi->count == 1) {
>> +        DPRINTK("open plane index %d\n", mfbi->index);
>> +        fsl_diu_check_var(&info->var, info);
>> +        fsl_diu_set_par(info);
> 
> Please retest your code (at least) with sleep-inside spinlock debug 
> option. If I see correctly you call GFP_KERNEL allocation somewhere 
> deeper in this function, which might sleep.
> 
>> +        res = fsl_diu_enable_panel(info);
>> +        if (res < 0)
>> +            mfbi->count--;
>> +    }
>> +
>> +    spin_unlock(&diu_lock);
>> +    return res;
>> +}
> 
>> +static void __exit uninstall_fb(struct fb_info *info)
>> +{
>> +    struct mfb_info *mfbi = info->par;
>> +
>> +    DPRINTK("Entered: uninstall_fb\n");
> 
> You don't need this stuff everywhere (kprobes).
> 
>> +    if (!mfbi->registered)
>> +        return;
>> +
>> +    unregister_framebuffer(info);
>> +    unmap_video_memory(info);
>> +    if (&info->cmap)
>> +        fb_dealloc_cmap(&info->cmap);
>> +
>> +    mfbi->registered = 0;
>> +}
> [...]
>> +static int fsl_diu_probe(struct platform_device *pdev)
>> +{
>> +    struct mfb_info *mfbi;
>> +    unsigned long dummy_ad_addr;
>> +    int ret, i, error = 0;
>> +
>> +    DPRINTK("Entered: fsl_diu_probe\n");
>> +
>> +    /* Area descriptor memory pool aligns to 64-bit boundary */
>> +    allocate_buf(&pool.ad, sizeof(struct diu_ad) * FSL_AOI_NUM, 8);
>> +
>> +    /* Get memory for Gamma Table  - 32-byte aligned memory */
>> +    allocate_buf(&pool.gamma, 768, 32);
>> +
>> +    /* For performance, cursor bitmap buffer aligns to 32-byte 
>> boundary */
>> +    allocate_buf(&pool.cursor, MAX_CURS * MAX_CURS * 2, 32);
>> +
>> +    i = sizeof(fsl_diu_info) / sizeof(struct fb_info);
>> +    dummy_ad = (struct diu_ad *)((u32)pool.ad.vaddr + pool.ad.offset) 
>> + i;
>> +    dummy_ad->paddr = pool.ad.paddr + i * sizeof(struct diu_ad);
>> +    dummy_aoi_virt = fsl_diu_alloc(64, &dummy_ad_addr);
>> +    dummy_ad->addr = cpu_to_le32(dummy_ad_addr);
>> +    dummy_ad->pix_fmt = 0x88882317;
>> +    dummy_ad->src_size_g_alpha = cpu_to_le32((4 << 12) | 4);
>> +    dummy_ad->aoi_size = cpu_to_le32((4 << 16) |  2);
>> +    dummy_ad->offset_xyi = 0;
>> +    dummy_ad->offset_xyd = 0;
>> +    dummy_ad->next_ad = 0;
>> +    memset(dummy_aoi_virt, 0x00, 64);
>> +    write_reg(&(dr.diu_reg->desc[0]), dummy_ad->paddr);
>> +    write_reg(&(dr.diu_reg->desc[1]), dummy_ad->paddr);
>> +    write_reg(&(dr.diu_reg->desc[2]), dummy_ad->paddr);
>> +
>> +    for (i = 0; i < sizeof(fsl_diu_info) / sizeof(struct fb_info); 
>> i++) {
>> +        fsl_diu_info[i].fix.smem_start = 0;
>> +        mfbi = fsl_diu_info[i].par;
>> +        mfbi->ad = (struct diu_ad *)((u32)pool.ad.vaddr
>> +                    + pool.ad.offset) + i;
>> +        mfbi->ad->paddr = pool.ad.paddr + i * sizeof(struct diu_ad);
>> +        ret = install_fb(&fsl_diu_info[i], pdev);
>> +        if (ret) {
>> +            printk(KERN_ERR "Failed to register framebuffer %d\n",
>> +                    i);
>> +            return ret;
> 
> some kind of free here
> 
>> +        }
>> +    }
> [...]
>> +int __init fsl_diu_init(void)
>> +{
>> +    struct device_node *np;
>> +    struct resource r;
>> +    int error;
>> +    DPRINTK("Entered: fsl_diu_init\n");
>> +    np = of_find_compatible_node(NULL, NULL, "fsl-diu");
>> +    if (!np) {
>> +        printk(KERN_ERR "Err: can't find device node 'fsl-diu'\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    of_address_to_resource(np, 0, &r);
>> +    of_node_put(np);
>> +
>> +    DPRINTK("%s, r.start: 0x%08x\n", __func__, r.start);
>> +
>> +    dr.diu_reg = ioremap(r.start, sizeof(struct diu));
> 
> The arch never fails with remapping?
> 
>> +
>> +    write_reg(&(dr.diu_reg->diu_mode), 0);        /* disable DIU 
>> anyway*/
>> +
>> +    spin_lock_init(&dr.reg_lock);
>> +
>> +
>> +    /*
>> +     * For kernel boot options (in 'video=xxxfb:<options>' format)
>> +     */
>> +#ifndef MODULE
>> +    {
>> +        char *option;
>> +
>> +        if (fb_get_options("fslfb", &option))
>> +            return -ENODEV;
>> +        fsl_diu_setup(option);
>> +    }
>> +#endif
>> +    error = platform_driver_register(&fsl_diu_driver);
>> +
>> +    if (!error) {
>> +        error = platform_device_register(&fsl_diu_device);
>> +        if (error) {
>> +            printk(KERN_ERR "Err: "
>> +                    "can't register FB device driver!\n");
>> +            platform_driver_unregister(&fsl_diu_driver);
> 
> iounmap
> 
>> +        }
>> +        printk(KERN_INFO "FSL_DIU_FB: registed FB device driver!\n");
>> +    }
> 
> else iounmap
> 
>> +
>> +    return error;
>> +}
> [...]
>> diff --git a/drivers/video/fsl-diu-fb.h b/drivers/video/fsl-diu-fb.h
>> new file mode 100644
>> index 0000000..294d0bf
>> --- /dev/null
>> +++ b/drivers/video/fsl-diu-fb.h
>> @@ -0,0 +1,388 @@
> [...]
>> +#ifndef __FSL_DIU_FB_H__
>> +#define __FSL_DIU_FB_H__
>> +
>> +/* FIXME: This should be changed to dev_dbg this will be done as soon as
>> + * we can obtain dev through the dts setup
> 
> then use at least pr_debug() here:
> 
>> + */
>> +#ifdef DEBUG
>> +#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__, 
>> ## args)
>> +#else
>> +#define DPRINTK(fmt, args...)
>> +#endif
