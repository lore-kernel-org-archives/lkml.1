Return-Path: <linux-kernel-owner+w=401wt.eu-S1764036AbZAQQGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764036AbZAQQGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761698AbZAQQGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:06:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34782 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbZAQQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:06:21 -0500
Date: Sat, 17 Jan 2009 16:06:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/6] omap iommu: tlb and pagetable primitives
Message-ID: <20090117160608.GA12341@n2100.arm.linux.org.uk>
References: <20090116083003.18344.38307.stgit@oreo.research.nokia.com> <20090116083709.18344.74524.stgit@oreo.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116083709.18344.74524.stgit@oreo.research.nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more simple comments...

On Fri, Jan 16, 2009 at 10:37:09AM +0200, Hiroshi DOYU wrote:
> +struct iommu_platform_data {
> +	char	*name;

const?

> +	char	*clk_name;

const?

> +	int	nr_tlb_entries;
> +};

...

> +int install_iommu_arch(const struct iommu_functions *ops)
> +{
> +	if (arch_iommu)
> +		return -EBUSY;
> +
> +	arch_iommu = ops;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(install_iommu_arch);

Exported functions should have some documentation in the standard kernel
documentation format.  See Documentation/kernel-doc-nano-HOWTO.txt

> +static int iommu_enable(struct iommu *obj)
> +{
> +	int err;
> +
> +	BUG_ON(!arch_iommu || !arch_iommu->enable);

Are these run-time BUG_ON checks really worth it?  BUG_ON is effectively:

	if (condition_is_true)
		cause_a_null_pointer_dereference;

So, if you're checking for pointers you're about dereference being NULL,
there's little point - dereferencing the when they're NULL will cause an
oops, and you won't have the overhead of the runtime tests checking them
for NULL.  Ditto elsewhere in this file.

> +static u32 *iopte_alloc(struct iommu *obj, u32 *iopgd, u32 da)
> +{
> +	u32 *iopte;
> +
> +	/* a table has already existed */
> +	if (*iopgd)
> +		goto pte_ready;
> +
> +	/*
> +	 * do the allocation outside the page table lock
> +	 */
> +	spin_unlock(&obj->page_table_lock);
> +	iopte = kmem_cache_zalloc(iopte_cachep, GFP_KERNEL);
> +	spin_lock(&obj->page_table_lock);
> +
> +	if (!*iopgd) {
> +		if (!iopte)
> +			return ERR_PTR(-ENOMEM);
> +
> +		*iopgd = virt_to_phys(iopte) | IOPGD_TABLE;
> +		flush_iopgd_range(iopgd, iopgd);
> +
> +#ifdef DEBUG_VERBOSE
> +		dev_dbg(obj->dev, "%s:\ta new pte:%p\n", __func__, iopte);
> +#endif

Not sure wrapping these in DEBUG_VERBOSE is necessary.  dev_dbg() is a
no-op unless DEBUG is defined.

> +#ifdef DEBUG
> +static void dump_tlb_entries(struct iommu *obj)
> +{
> +	int i;
> +	struct iotlb_lock l;
> +
> +	clk_enable(obj->clk);
> +
> +	pr_info("%8s %8s\n", "cam:", "ram:");
> +	pr_info("-----------------------------------------\n");
> +
> +	for (i = 0; i < obj->nr_tlb_entries; i++) {
> +		struct cr_regs cr;
> +		static char buf[4096];
> +
> +		iotlb_lock_get(obj, &l);
> +		l.vict = i;
> +		iotlb_lock_set(obj, &l);
> +		iotlb_read_cr(obj, &cr);
> +		if (!iotlb_cr_valid(&cr))
> +			continue;
> +
> +		memset(buf, 0, 4096);
> +		iotlb_dump_cr(obj, &cr, buf);
> +		pr_info("%s", buf);

Hmm.  You call this in relation to an error, but you print everything at
'info' level.  Are you sure that's correct?

> +/*
> + *	OMAP Device MMU(IOMMU) detection
> + */
> +static int __devinit omap_iommu_probe(struct platform_device *pdev)
> +{
> +	int err = -ENODEV;
> +	void *p;
> +	int irq;
> +	struct iommu *obj;
> +	struct resource *res;
> +	struct iommu_platform_data *pdata = pdev->dev.platform_data;
> +
> +	if (pdev->num_resources != 2)
> +		return -EINVAL;
> +
> +	obj = kzalloc(sizeof(*obj) + MMU_REG_SIZE, GFP_KERNEL);
> +	if (!obj)
> +		return -ENOMEM;
> +
> +	obj->clk = clk_get(NULL, pdata->clk_name);

Avoid passing a NULL struct device except when you have absolutely no other
choice.  &pdev->dev looks sensible.  By doing this, it also provides us with
a path to fixing the OMAP clk API implementation without having to fix lots
of drivers.
