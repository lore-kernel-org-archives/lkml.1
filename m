Return-Path: <linux-kernel-owner+w=401wt.eu-S1751065AbXBQUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbXBQUzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbXBQUzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:55:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:62310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbXBQUzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:55:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Subject: Re: [PATCH 12/44 take 2] [UBI] allocation unit implementation
Date: Sat, 17 Feb 2007 21:55:12 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165525.5845.78155.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165525.5845.78155.sendpatchset@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702172155.14289.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+EldQJgG3HeeoOzYN74eHdlvV0U4PLVly2MEAGESlaWBDwRgnvY/8mfnw5U+O9ZU2BZ4tmCVrdUV+u7VoYFiVafyHBLmgvzLCpt+9mVTVFow==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 17:55, Artem Bityutskiy wrote:
> diff -auNrp tmp-from/drivers/mtd/ubi/alloc.c tmp-to/drivers/mtd/ubi/alloc.c

> +#include "ubi.h"
> +#include "alloc.h"
> +#include "io.h"
> +#include "background.h"
> +#include "wl.h"
> +#include "debug.h"
> +#include "eba.h"
> +#include "scan.h"

I don't see much point in having one local header for each of these,
you could simply put all of the declarations into one header in the
ubi directory.

> +
> +#define BGT_WORK_SLAB_NAME        "ubi_bgt_work_slab"
> +#define WL_ERASE_WORK_SLAB_NAME   "ubi_wl_erase_work_slab"
> +#define WL_ENTRY_SLAB_NAME        "ubi_wl_entry_slab"
> +#define WL_PROT_ENTRY_SLAB_NAME   "ubi_wl_prow_entry_slab"
> +#define EBA_LTREE_ENTRY_SLAB_NAME "ubi_eba_ltree_entry_slab"
> +#define SCAN_EB_SLAB_NAME         "ubi_scan_leb"
> +#define SCAN_VOLUME_SLAB_NAME     "ubi_scan_volume"

These macros seem rather pointless, each of them is only used
once, and the macro name directly corresponds to the contents.

> +static struct kmem_cache *bgt_work_slab;
> +static struct kmem_cache *wl_erase_work_slab;
> +static struct kmem_cache *wl_entries_slab;
> +static struct kmem_cache *wl_prot_entry_slab;
> +static struct kmem_cache *eba_ltree_entry_slab;
> +static struct kmem_cache *scan_eb_slab;
> +static struct kmem_cache *scan_volume_slab;

Do you really need all these slab caches? If a cache only contains
a small number of objects, e.g. one per volume, then you're much
better off using a regular kmalloc.

> +void *ubi_kzalloc(size_t size)
> +{
> +	void *ret;
> +
> +	ret = kzalloc(size, GFP_KERNEL);
> +	if (unlikely(!ret)) {
> +		ubi_err("cannot allocate %zd bytes", size);
> +		dump_stack();
> +		return NULL;
> +	}
> +
> +	return ret;
> +}
> +
> +void *ubi_kmalloc(size_t size)
> +{
> +	void *ret;
> +
> +	ret = kmalloc(size, GFP_KERNEL);
> +	if (unlikely(!ret)) {
> +		ubi_err("cannot allocate %zd bytes", size);
> +		dump_stack();
> +		return NULL;
> +	}
> +
> +	return ret;
> +}
> +
> +void ubi_kfree(const void *obj)
> +{
> +	if (unlikely(!obj))
> +		return;
> +	kfree(obj);
> +}

These look somewhat too complex. Don't introduce your own generic
infrastructure if you can help it. IIRC, when kmalloc fails, you
already get the full stack trace from the buddy allocator, so
this is just duplication. Better use the regular kzalloc/kfree
calls directly.

> +struct ubi_ec_hdr *ubi_zalloc_ec_hdr(const struct ubi_info *ubi)
> +{
> +	struct ubi_ec_hdr *ec_hdr;
> +	const struct ubi_io_info *io = ubi->io;
> +
> +	ec_hdr = kzalloc(io->ec_hdr_alsize, GFP_KERNEL);
> +	if (unlikely(!ec_hdr)) {
> +		ubi_err("cannot allocate %d bytes", io->ec_hdr_alsize);
> +		dump_stack();
> +		return NULL;
> +	}
> +
> +	return ec_hdr;
> +}
> +
> +void ubi_free_ec_hdr(const struct ubi_info *ubi, struct ubi_ec_hdr *ec_hdr)
> +{
> +	if (unlikely(!ec_hdr))
> +		return;
> +	kfree(ec_hdr);
> +}

same for this and the others. Unless the allocation is done in many
places in the code from a single slab cache, just call kmem_cache_alloc
or kmalloc directly.

	Arnd <><
