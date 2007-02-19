Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbXBSLH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbXBSLH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbXBSLH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:07:26 -0500
Received: from smtp.nokia.com ([131.228.20.170]:46086 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbXBSLHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:07:25 -0500
Subject: Re: [PATCH 12/44 take 2] [UBI] allocation unit implementation
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <200702172155.14289.arnd@arndb.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165525.5845.78155.sendpatchset@localhost.localdomain>
	 <200702172155.14289.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 13:05:15 +0200
Message-Id: <1171883115.13817.5.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 11:05:15.0649 (UTC) FILETIME=[D5826F10:01C75415]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219130152-23707BB0-000BC889/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 21:55 +0100, Arnd Bergmann wrote:
> On Saturday 17 February 2007 17:55, Artem Bityutskiy wrote:
> > +#include "wl.h"
> > +#include "debug.h"
> > +#include "eba.h"
> > +#include "scan.h"
> 
> I don't see much point in having one local header for each of these,
> you could simply put all of the declarations into one header in the
> ubi directory.

I'll put them all to ubi.h to start with. I am still not convinced
having one big header is more readable then per-unit headers.

> > +#define WL_PROT_ENTRY_SLAB_NAME   "ubi_wl_prow_entry_slab"
> > +#define EBA_LTREE_ENTRY_SLAB_NAME "ubi_eba_ltree_entry_slab"
> > +#define SCAN_EB_SLAB_NAME         "ubi_scan_leb"
> > +#define SCAN_VOLUME_SLAB_NAME     "ubi_scan_volume"
> 
> These macros seem rather pointless, each of them is only used
> once, and the macro name directly corresponds to the contents.

Done.

> > +static struct kmem_cache *bgt_work_slab;
> > +static struct kmem_cache *wl_erase_work_slab;
> > +static struct kmem_cache *wl_entries_slab;
> > +static struct kmem_cache *wl_prot_entry_slab;
> > +static struct kmem_cache *eba_ltree_entry_slab;
> > +static struct kmem_cache *scan_eb_slab;
> > +static struct kmem_cache *scan_volume_slab;
> 
> Do you really need all these slab caches? If a cache only contains
> a small number of objects, e.g. one per volume, then you're much
> better off using a regular kmalloc.

Good point, done. Left only wl_entries_slab, wl_prot_entry_slab, and
eba_ltree_entry_slab.


> > +void ubi_kfree(const void *obj)
> > +{
> > +	if (unlikely(!obj))
> > +		return;
> > +	kfree(obj);
> > +}
> 
> These look somewhat too complex. Don't introduce your own generic
> infrastructure if you can help it. IIRC, when kmalloc fails, you
> already get the full stack trace from the buddy allocator, so
> this is just duplication. Better use the regular kzalloc/kfree
> calls directly.

Done.

> > +void ubi_free_ec_hdr(const struct ubi_info *ubi, struct ubi_ec_hdr *ec_hdr)
> > +{
> > +	if (unlikely(!ec_hdr))
> > +		return;
> > +	kfree(ec_hdr);
> > +}
> 
> same for this and the others. Unless the allocation is done in many
> places in the code from a single slab cache, just call kmem_cache_alloc
> or kmalloc directly.

I need a wrapper for VID header allocation, so better to leave this for
symmetry.

Thanks, Artem.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

