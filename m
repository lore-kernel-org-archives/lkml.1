Return-Path: <linux-kernel-owner+w=401wt.eu-S1764845AbZAQQ5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764845AbZAQQ5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbZAQQ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:57:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56874 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292AbZAQQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:57:37 -0500
Date: Sat, 17 Jan 2009 16:57:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/6] omap iommu: simple virtual address space management
Message-ID: <20090117165726.GC12341@n2100.arm.linux.org.uk>
References: <20090116083003.18344.38307.stgit@oreo.research.nokia.com> <20090116083725.18344.82076.stgit@oreo.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116083725.18344.82076.stgit@oreo.research.nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 10:37:25AM +0200, Hiroshi DOYU wrote:
> +static struct iovm_struct *__find_iovm_area(struct iommu *obj, const void *_da)
> +{
> +	struct iovm_struct *tmp;
> +	u32 da = (u32)_da;
...

> +static struct iovm_struct *alloc_iovm_area(struct iommu *obj, void *da,
> +					   size_t bytes, u32 flags)
> +{
> +	struct iovm_struct *new, *tmp;
> +	u32 start, prev_end, alignement;
> +
> +	if (!obj || !bytes)
> +		return ERR_PTR(-EINVAL);
> +
> +	start = (u32)da;
...

> +/* template function for all unmapping */
> +static struct sg_table *unmap_vm_area(struct iommu *obj, const void *da,
> +				      void (*fn)(const void *), u32 flags)
> +{
> +	struct sg_table *sgt = NULL;
> +	struct iovm_struct *area;
> +
> +	BUG_ON(in_interrupt());
> +
> +	if (!IS_ALIGNED((u32)da, PAGE_SIZE)) {
...etc

I've been wondering whether 'void *' is the right type for the device
address, and I've pretty much come to the conclusion that it isn't.
'void *' is a pointer, so one might expect it to point at memory.  It
may point at memory, just not on the host CPU.  So using a pointer
seems wrong to me.

I know that screws up error handling in the code somewhat since you're
using IS_ERR and friends - but have you also considered whether a
valid device address falls within the space used for error values
(iow, small negative numbers)?

Lastly, I'm not entirely sold on the four different interfaces and
whether they're the right approach.  I've not yet seen users of each
of these interfaces so I don't think I can really comment yet - but
I think it's important to have some examples before acking this patch.
