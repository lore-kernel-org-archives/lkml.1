Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYHSXeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYHSXeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYHSXeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:34:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbYHSXeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:34:11 -0400
Date: Tue, 19 Aug 2008 16:23:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <JosephChan@via.com.tw>
Cc: JosephChan@via.com.tw, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [PATCH 3/13 v2] viafb: accel.c, accel.h
Message-Id: <20080819162303.5fc89c63.akpm@linux-foundation.org>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698F@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698F@exchtp03.taipei.via.com.tw>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 18:11:05 +0800
<JosephChan@via.com.tw> wrote:

> 2D and HW cursor stuff of viafb driver.

x86_64 allmodconfig throws a lot of warnings:

drivers/video/via/viafbdev.c: In function 'viafb_fillrect':
drivers/video/via/viafbdev.c:904: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:904: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c: In function 'viafb_copyarea':
drivers/video/via/viafbdev.c:955: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:955: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:959: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:959: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c: In function 'viafb_imageblit':
drivers/video/via/viafbdev.c:1016: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:1016: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c: In function 'via_pci_probe':
drivers/video/via/viafbdev.c:2119: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:2119: warning: cast to pointer from integer of different size
drivers/video/via/viafbdev.c:2121: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:2121: warning: cast to pointer from integer of different size
drivers/video/via/viafbdev.c:2123: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:2123: warning: cast to pointer from integer of different size
drivers/video/via/viafbdev.c:2125: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:2125: warning: cast to pointer from integer of different size
drivers/video/via/viafbdev.c:2127: warning: cast from pointer to integer of different size
drivers/video/via/viafbdev.c:2127: warning: cast to pointer from integer of different size

due to things like this:

        MMIO_OUT32(VIA_REG_DSTBASE,
                   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);

now, we could just shut the warnings up by casting to (long) instead.

But I wonder what's going on in there.  ->screen_base came from
ioremap_nocache() and AFAIK there's no guarantee that this virtual
address will be less than 4G on 64-bit machines?



Also, from a stylistic point ov view, this:

#define VIA_MMIO 1

#if VIA_MMIO
#define MMIO_OUT32(reg, val) writel(val, viaparinfo->io_virt + reg)
#define MMIO_IN32(reg)      readl(viaparinfo->io_virt + reg)

#else
#define MMIO_OUT32(reg, val) outl(val, reg)
#define MMIO_IN32(reg)      inl(reg)
#endif

is quite ugly.

If the !VIA_MMIO code has no valid use then please just remove it.

The VIA_MMIO!=0 macros inplicitly reference a local variable which is
the kind of dopey programming trick which should not be performed in
new code.  It would be much better to do

static inline void via_writel(struct viafb_par *viaparinfo, int reg, u32 val)
{
	writel(val, viaparinfo->io_virt + reg);
}

and use that everywhere.

It would also be quite acceptable to simply open-code the

	writel(val, viaparinfo->io_virt + reg);

at all callsites.

Those macros may have made it easier to _write_ the code, but they make
it harder to _read_ it.  That's a wrong tradeoff.


