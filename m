Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYIRVxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYIRVxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYIRVx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:53:29 -0400
Received: from www.tglx.de ([62.245.132.106]:45701 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYIRVx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:53:28 -0400
Date: Thu, 18 Sep 2008 23:53:18 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] [UIO] Add alignment warnings for uio-mem
Message-ID: <20080918215318.GD2991@local>
References: <20080918144615.GD4226@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918144615.GD4226@pengutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 04:46:15PM +0200, Wolfram Sang wrote:
> 
> mmap works page aligned. If uio-mem areas were set up unaligned, mmap
> would silently align it and the corresponding attributes in sysfs would
> not reflect it. This patch fixes such values during init to what the
> kernel will do anyway and adds a warning.

Hi Wolfram,
thanks for mentioning this. I already know of one case where such a
situation lead to ugly workarounds, so the problem needs to be
addressed. However, I'd like to choose a different approach. Let's take
the following situation as an example:

- A chip with 16 bytes of registers
- Its base address is 0x12345080 (4k page size, not aligned)

With your approach, sysfs would report a base address of 0x12345000 and
a size of 0x90. Both is a lie. We don't want to encourage the user to
access addresses outside the 16 bytes range the driver author originally
announced.

UIO drivers are often used in embedded devices, where developers usually
know the physical addresses of their devices and have them hardcoded in
a #define. It's confusing if sysfs suddenly reports something different.

The userspace part of the driver expects a 16 bytes range but is told
there are 0x90 bytes at his disposal. It has to guess where the devices
registers are (or if this is a completely different device...). It might
also check the physical base address and find that this is wrong, too.

The situation becomes even worse if you have two such chips on your
board, and each reports a different size. If their addresses were in the
same page, both would have the same base address, but different sizes...

Another issue: You print a warning if a mem->addr is not page aligned.
Why? Either the driver (both kernel and userspace) can handle this, or
it can't. In the first case, nothing needs to be printed, in the second
case it's not a warning but an error. IMO a warning only makes sense if
there's something the driver author can do to fix it. But if you've got
hardware with certain addresses, there's usually nothing you can do.

I'd like to suggest the following solution (patch at the end of this
mail):

Let's leave it to userspace. All userspace needs is the "offset"
information you calculate in your patch. If we add a new sysfs attribute
for that, userspace can simply add it to the address returned by mmap().
This way, the userspace part of the driver will always work, no matter
if the memory is page aligned or not. The "addr" and "size" attributes
still report the true physical base address and size. _Every_ userspace
driver, existing or yet to be written, can (and should) simply do
something like

base_addr = address_returned_by_mmap + offset_from_sysfs;

What do you think about this? If you think this might work for you,
could you please test the patch below? I haven't got such a hardware
handy at the moment, so my patch is just compile-tested (but it looks
obvious).

Thanks again for pointing this out,
Hans

> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  drivers/uio/uio.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> Index: drivers/uio/uio.c
> ===================================================================
> --- drivers/uio/uio.c.orig
> +++ drivers/uio/uio.c
> @@ -656,6 +656,8 @@
>  			  struct uio_info *info)
>  {
>  	struct uio_device *idev;
> +	struct uio_mem *mem;
> +	unsigned int offset;
>  	int ret = 0;
>  
>  	if (!parent || !info || !info->name || !info->version)
> @@ -691,6 +693,16 @@
>  		goto err_device_create;
>  	}
>  
> +	for (mem = info->mem; mem->size; mem++) {
> +		offset = mem->addr & ~PAGE_MASK;
> +		if (offset) {
> +			mem->addr -= offset;
> +			mem->size += offset;
> +			dev_warn(idev->dev, "mem[%d] not page aligned!"
> +				"Fixing values.\n", mem - info->mem);
> +		}
> +	}
> +
>  	ret = uio_dev_add_attributes(idev);
>  	if (ret)
>  		goto err_uio_dev_add_attributes;

------------------8<------------------------------------------------

This patch adds an "offset" attribute for UIO mappings. It shows the
difference between the actual start address of the memory and the start
address of the page.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
drivers/uio/uio.c |    8 ++++++++
1 file changed, 8 insertions(+)

Index: linux-2.6.27-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.27-rc.orig/drivers/uio/uio.c	2008-09-18 21:25:44.000000000 +0200
+++ linux-2.6.27-rc/drivers/uio/uio.c	2008-09-18 21:33:54.000000000 +0200
@@ -67,6 +67,11 @@
 	return sprintf(buf, "0x%lx\n", mem->size);
 }
 
+static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", mem->addr & ~PAGE_MASK);
+}
+
 struct uio_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct uio_mem *, char *);
@@ -77,10 +82,13 @@
 	__ATTR(addr, S_IRUGO, map_addr_show, NULL);
 static struct uio_sysfs_entry size_attribute =
 	__ATTR(size, S_IRUGO, map_size_show, NULL);
+static struct uio_sysfs_entry offset_attribute =
+	__ATTR(offset, S_IRUGO, map_offset_show, NULL);
 
 static struct attribute *attrs[] = {
 	&addr_attribute.attr,
 	&size_attribute.attr,
+	&offset_attribute.attr,
 	NULL,	/* need to NULL terminate the list of attributes */
 };
 
