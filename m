Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZFEVRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZFEVRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZFEVRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:17:25 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:60716 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZFEVRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:17:24 -0400
Date: Fri, 5 Jun 2009 17:09:05 -0400
From: Woody Suwalski <woodys@xandros.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, jbarnes@virtuousgeek.org,
       eric@anholt.net, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       stable@kernel.org
Message-ID: <4A298971.5080006@xandros.com>
In-Reply-To: <20090605130033.5ff3d0b5.akpm@linux-foundation.org>
References: <4A242C81.6020906@cs.helsinki.fi>
References: <20090604112738.4c01d35e@jbarnes-x200>
References: <1244188941.23533.16.camel@penberg-laptop>
References: <20090605130033.5ff3d0b5.akpm@linux-foundation.org>
Subject: Re: Intel 915GM MCHBAR bug
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------020003060208010101030009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------020003060208010101030009
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline

Andrew Morton wrote:
> On Fri, 05 Jun 2009 11:02:21 +0300
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>   
>> Hi Jesse,
>>
>> (I am cc'ing linux-kernel.)
>>
>> On Mon, 01 Jun 2009 22:31:13 +0300
>>     
>>> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>>
>>>       
>>>> Hi Jesse,
>>>>
>>>> I am seeing this on my Eee PC 701 which is running a Ubuntu 
>>>> 2.6.28-11.42-generic stock kernel:
>>>>
>>>> [   76.826966] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't
>>>> read from MCHBAR.  Disabling tiling.
>>>> [   76.827215] [drm] Initialized i915 1.6.0 20080730 on minor 0
>>>> [   76.834037] [drm:i915_setparam] *ERROR* unknown parameter 4
>>>> [   76.834104] [drm:i915_getparam] *ERROR* Unknown parameter 6
>>>>
>>>> Google turned up this patch
>>>>
>>>> http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html
>>>>
>>>> but I don't seem to find it mainline kernel.
>>>>
>>>> Was the bug fixed in some other way? It seem that distributions have
>>>> not yet picked up your patch and I am unsure if it's in any of the
>>>> -stable kernels.
>>>>         
>> On Thu, 2009-06-04 at 11:27 +0100, Jesse Barnes wrote:
>>     
>>> I think Eric acked it but may not have pushed it to drm-intel-next
>>> yet.  Should happen in the next week or two though as we prepare the
>>> merge window series.
>>>       
>> OK, thanks for the info! FYI, I tested 2.6.30-rc8 with your patch
>> applied and everything works smoothly on my EeePC 701. I did not test
>> plain 2.6.30-rc8 as I expect it to show same kind of behavior as Ubuntu
>> distro kernel. Is this correct or do you want me to test 2.6.30-rc8 too?
>>
>> I wonder why the patch hasn't received more attention as it's a pretty
>> critical bug. The _default_ Ubuntu 9.04 netbook remix installation is
>> completely broken for EeePC 701 (and probably others as well) without
>> the patch. And it's not as if I'm the only one that suffers from it. A
>> quick Google search reveals that a lot of people are hitting it.
>>
>> So I really do think we need to merge this patch to the upcoming 2.6.31
>> ASAP and backport it to -stable after it has gotten some more testing.
>>
>>     
>
> Wanna show us the patch?
>
> Because the world could certainly do with more i915 bugfixes :(
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Here is Jesse's patch from 
http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html 
adopted for 2.6.30-rc8... (needed to redo hunk #3 for i915_gem_tile.c)

Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414


--------------020003060208010101030009
Content-Type: text/plain;
	name="i915_tile.patch.txt"
Content-Disposition: inline;
	filename="i915_tile.patch.txt"

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 9851589..5919537 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -143,6 +143,8 @@ typedef struct drm_i915_private {
 	drm_local_map_t hws_map;
 	struct drm_gem_object *hws_obj;
 
+	struct resource mch_res;
+
 	unsigned int cpp;
 	int back_offset;
 	int front_offset;
diff --git a/drivers/gpu/drm/i915/i915_gem_tiling.c 
b/drivers/gpu/drm/i915/i915_gem_tiling.c
index fe7877a..1441a9e 100644
--- a/drivers/gpu/drm/i915/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
@@ -24,6 +24,7 @@
  *    Eric Anholt <eric@anholt.net>
  *
  */
+#include <linux/acpi.h>
 
 #include "linux/string.h"
 #include "linux/bitops.h"
@@ -81,6 +82,176 @@
  * to match what the GPU expects.
  */
 
+#define MCHBAR_I915 0x44
+#define MCHBAR_I965 0x48
+#define MCHBAR_SIZE (4*4096)
+
+#define DEVEN_REG 0x54
+#define   DEVEN_MCHBAR_EN (1 << 28)
+
+/*
+ * ACPI resource checking fun.  So the MCHBAR has *probably* been set
+ * up by the BIOS since drivers need to poke at it, but out of paranoia
+ * or whatever, many BIOSes disable the MCHBAR at boot.  So we check
+ * to make sure any existing address is reserved before using it.  If
+ * we can't find a match or there is no address, allocate some new PCI
+ * space for it, and then enable it.  And of course 915 has to be different
+ * and put its enable bit somewhere else...
+ */
+static acpi_status __init check_mch_resource(struct acpi_resource *res,
+					     void *data)
+{
+	struct resource *mch_res = data;
+	struct acpi_resource_address64 address;
+	acpi_status status;
+
+	if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
+		struct acpi_resource_fixed_memory32 *fixmem32 =
+			&res->data.fixed_memory32;
+		if (!fixmem32)
+			return AE_OK;
+
+		if ((mch_res->start >= fixmem32->address) &&
+		    (mch_res->end < (fixmem32->address +
+				      fixmem32->address_length))) {
+			mch_res->flags = 1;
+			return AE_CTRL_TERMINATE;
+		}
+	}
+	if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
+	    (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
+		return AE_OK;
+
+	status = acpi_resource_to_address64(res, &address);
+	if (ACPI_FAILURE(status) ||
+	   (address.address_length <= 0) ||
+	   (address.resource_type != ACPI_MEMORY_RANGE))
+		return AE_OK;
+
+	if ((mch_res->start >= address.minimum) &&
+	    (mch_res->end < (address.minimum + address.address_length))) {
+		mch_res->flags = 1;
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
+					       void *context, void **rv)
+{
+	struct resource *mch_res = context;
+
+	acpi_walk_resources(handle, METHOD_NAME__CRS,
+			    check_mch_resource, context);
+
+	if (mch_res->flags)
+		return AE_CTRL_TERMINATE;
+
+	return AE_OK;
+}
+
+static int __init is_acpi_reserved(u64 start, u64 end, unsigned not_used)
+{
+	struct resource mch_res;
+
+	mch_res.start = start;
+	mch_res.end = end;
+	mch_res.flags = 0;
+
+	acpi_get_devices("PNP0C01", find_mboard_resource, &mch_res, NULL);
+
+	if (!mch_res.flags)
+		acpi_get_devices("PNP0C02", find_mboard_resource, &mch_res,
+				 NULL);
+
+	return mch_res.flags;
+}
+
+/* Allocate space for the MCH regs if needed, return nonzero on error */
+static int
+intel_alloc_mchbar_resource(struct drm_device *dev)
+{
+	struct pci_dev *bridge_dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	int reg = IS_I965G(dev) ? MCHBAR_I965 : MCHBAR_I915;
+	u32 temp_lo, temp_hi = 0;
+	u64 mchbar_addr;
+	int ret;
+
+	bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (!bridge_dev) {
+		DRM_DEBUG("no bridge dev?!\n");
+		return -ENODEV;
+	}
+
+	if (IS_I965G(dev))
+		pci_read_config_dword(bridge_dev, reg + 4, &temp_hi);
+	pci_read_config_dword(bridge_dev, reg, &temp_lo);
+	mchbar_addr = ((u64)temp_hi << 32) | temp_lo;
+
+	/* If ACPI doesn't have it, assume we need to allocate it ourselves */
+	if (mchbar_addr &&
+	    is_acpi_reserved(mchbar_addr, mchbar_addr + MCHBAR_SIZE, 0))
+		return 0;
+
+	/* Get some space for it */
+	ret = pci_bus_alloc_resource(bridge_dev->bus, &dev_priv->mch_res,
+				     MCHBAR_SIZE, MCHBAR_SIZE,
+				     PCIBIOS_MIN_MEM,
+				     0,   pcibios_align_resource,
+				     bridge_dev);
+	if (ret) {
+		DRM_DEBUG("failed bus alloc: %d\n", ret);
+		dev_priv->mch_res.start = 0;
+		return ret;
+	}
+
+	if (IS_I965G(dev))
+		pci_write_config_dword(bridge_dev, reg + 4,
+				       upper_32_bits(dev_priv->mch_res.start));
+
+	pci_write_config_dword(bridge_dev, reg,
+			       lower_32_bits(dev_priv->mch_res.start));
+
+	return 0;
+}
+
+static void
+intel_setup_mchbar(struct drm_device *dev)
+{
+	struct pci_dev *bridge_dev;
+	int mchbar_reg = IS_I965G(dev) ? MCHBAR_I965 : MCHBAR_I915;
+	u32 temp;
+
+	bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (!bridge_dev) {
+		DRM_DEBUG("no bridge dev?!\n");
+		return;
+	}
+
+	if (intel_alloc_mchbar_resource(dev))
+		return;
+
+	/* Now enable it */
+	if (IS_I915G(dev) || IS_I915GM(dev)) {
+		pci_read_config_dword(bridge_dev, DEVEN_REG, &temp);
+		pci_write_config_dword(bridge_dev, DEVEN_REG,
+				       temp | DEVEN_MCHBAR_EN);
+	} else {
+		pci_read_config_dword(bridge_dev, mchbar_reg, &temp);
+		pci_write_config_dword(bridge_dev, mchbar_reg, temp | 1);
+	}
+}
+
+static void
+intel_teardown_mchbar(struct drm_device *dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+
+	if (dev_priv->mch_res.start)
+		release_resource(&dev_priv->mch_res);
+}
+
 /**
  * Detects bit 6 swizzling of address lookup between IGD access and CPU
  * access through main memory.
@@ -101,6 +272,9 @@ i915_gem_detect_bit_6_swizzle(struct drm
 	} else if (IS_MOBILE(dev)) {
 		uint32_t dcc;
 
+    		/* Try to make sure MCHBAR is enabled before poking at it */
+		intel_setup_mchbar(dev);
+
 		/* On mobile 9xx chipsets, channel interleave by the CPU is
 		 * determined by DCC.  For single-channel, neither the CPU
 		 * nor the GPU do swizzling.  For dual channel interleaved,
@@ -140,6 +314,8 @@ i915_gem_detect_bit_6_swizzle(struct drm
 			swizzle_x = I915_BIT_6_SWIZZLE_UNKNOWN;
 			swizzle_y = I915_BIT_6_SWIZZLE_UNKNOWN;
 		}
+
+		intel_teardown_mchbar(dev);
 	} else {
 		/* The 965, G33, and newer, have a very flexible memory
 		 * configuration.  It will enable dual-channel mode

--------------020003060208010101030009--
