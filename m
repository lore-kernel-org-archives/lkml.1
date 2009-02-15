Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZBOPY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZBOPY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 10:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZBOPYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 10:24:47 -0500
Received: from [78.227.24.35] ([78.227.24.35]:58033 "HELO
	briare1.fullpliant.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S1751715AbZBOPYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 10:24:47 -0500
From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
To: Eric Anholt <eric@anholt.net>
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: i915 KMS framebuffer oops report (2.6.29-rc5)
Date: Sun, 15 Feb 2009 16:26:40 GMT
Message-ID: <092CLOG11@briare1.fullpliant.org>
X-Mailer: Pliant 106
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added some printk (see code bellow), and now get the following oops report:

Seems like 'read_mapping_page' is not happy with the first provided parameter.

<6>agpgart-intel 0000:00:00.0: Intel 945GM Chipset
<6>agpgart-intel 0000:00:00.0: detected 7932K stolen memory
<6>agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
<6>pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>pci 0000:00:02.0: setting latency timer to 64
<4>i915 page map: 0/32 (f6db5148)
<1>BUG: unable to handle kernel NULL pointer dereference at (null)
<1>IP: [<(null)>] (null)
<4>*pde = 00000000 
<0>Oops: 0000 [#1] SMP 
<0>last sysfs file: 
<4>Modules linked in: i915(+) intel_agp cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit drm i2c_core agpgart battery [last unloaded: i915]
<4>
<4>Pid: 1531, comm: insmod Not tainted (2.6.29-rc5 #2) Latitude D820                   
<4>EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 1
<4>EIP is at 0x0
<4>EAX: 00000000 EBX: c1fa6520 ECX: c2008560 EDX: c1fa6520
<4>ESI: 00000000 EDI: f6db5148 EBP: f6561ba4 ESP: f6561b88
<4> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
<0>Process insmod (pid: 1531, ti=f6560000 task=f6563ac0 task.ti=f6560000)
<0>Stack:
<4> c015671c 000000d0 00000000 00000000 00000000 00000000 00000000 f6561bc4
<0> c0156793 00000000 00000000 f6db5148 00000000 00000000 f6db5148 f6561bd4
<0> c0156832 00000000 f64ca9c0 f6561c04 f7d13d51 00000000 00000000 00000020
<0>Call Trace:
<0> [<c015671c>] ? __read_cache_page+0x6c/0xb0
<0> [<c0156793>] ? read_cache_page_async+0x33/0xc0
<0> [<c0156832>] ? read_cache_page+0x12/0x60
<0> [<f7d13d51>] ? i915_gem_object_get_page_list+0xa1/0x130 [i915]
<0> [<f7d146bd>] ? i915_gem_object_bind_to_gtt+0xed/0x220 [i915]
<0> [<f7d1587b>] ? i915_gem_object_pin+0x7b/0x180 [i915]
<0> [<f7ccf5db>] ? drm_gem_object_alloc+0x8b/0xb0 [drm]
<0> [<f7d16312>] ? i915_gem_init_ringbuffer+0x62/0x340 [i915]
<0> [<f7cd65f5>] ? drm_mm_create_tail_node+0x25/0x80 [drm]
<0> [<f7d0efb7>] ? i915_load_modeset_init+0x197/0x420 [i915]
<0> [<f7d0f4cf>] ? i915_driver_load+0x23f/0x350 [i915]
<0> [<f7cd35d1>] ? drm_get_dev+0x1a1/0x1d0 [drm]
<0> [<c02101b0>] ? match_pci_dev_by_id+0x0/0x70
<0> [<c0260def>] ? put_device+0xf/0x20
<0> [<c01ff302>] ? kobject_get+0x12/0x20
<0> [<f7cce10c>] ? drm_init+0x8c/0xf0 [drm]
<0> [<f7c52000>] ? i915_init+0x0/0x6f [i915]


static int
i915_gem_object_get_page_list(struct drm_gem_object *obj)
{
	struct drm_i915_gem_object *obj_priv = obj->driver_private;
	int page_count, i;
	struct address_space *mapping;
	struct inode *inode;
	struct page *page;
	int ret;

	if (obj_priv->page_list)
		return 0;

	/* Get the list of pages out of our struct file.  They'll be pinned
	 * at this point until we release them.
	 */
	page_count = obj->size / PAGE_SIZE;
	BUG_ON(obj_priv->page_list != NULL);
	obj_priv->page_list = drm_calloc(page_count, sizeof(struct page *),
					 DRM_MEM_DRIVER);
	if (obj_priv->page_list == NULL) {
		DRM_ERROR("Faled to allocate page list\n");
		return -ENOMEM;
	}

	inode = obj->filp->f_path.dentry->d_inode;
	mapping = inode->i_mapping;
	for (i = 0; i < page_count; i++) {
  	printk("i915 page map: %d/%d (%x)\n", i, page_count, (int)mapping);
		page = read_mapping_page(mapping, i, NULL);
		if (IS_ERR(page)) {
			ret = PTR_ERR(page);
			DRM_ERROR("read_mapping_page failed: %d\n", ret);
			i915_gem_object_free_page_list(obj);
			return ret;
		}
		obj_priv->page_list[i] = page;
	}
	printk("i915 page map done\n");
	return 0;
}


