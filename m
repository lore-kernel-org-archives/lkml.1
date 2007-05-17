Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXEQJnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXEQJnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXEQJni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:43:38 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:34709 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXEQJnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:43:37 -0400
Date: Thu, 17 May 2007 11:43:34 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 10/10] [HEADS UP] fbdev: Move
 arch-specific bits to their respective subdirectories
In-Reply-To: <464B78BC.4080900@gmail.com>
Message-ID: <Pine.LNX.4.64.0705171140230.20754@anakin>
References: <464B78BC.4080900@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2007, Antonino A. Daplas wrote:
> diff --git a/include/asm-m68k/fb.h b/include/asm-m68k/fb.h
> new file mode 100644
> index 0000000..7d4a28f
> --- /dev/null
> +++ b/include/asm-m68k/fb.h
> @@ -0,0 +1,28 @@
> +#ifndef _ASM_FB_H_
> +#define _ASM_FB_H_
> +
> +#include <linux/fs.h>
> +#include <asm/page.h>
> +#include <asm/setup.h>
> +
> +#ifdef CONFIG_SUN3
> +static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
> +{
> +	pgprot_val(vma->vm_page_prot) |= SUN3_PAGE_NOCACHE;
> +}
> +#elif defined(CONFIG_MMU)
   ^^^^^^^^^^^^^^^^^^^^^^^^^
This can be a plain `#else', as m68knommu hasn't been merged with m68k
(yet :-)

> +static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
> +	if (CPU_IS_020_OR_030)
> +		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE030;
> +	if (CPU_IS_040_OR_060) {
> +		pgprot_val(vma->vm_page_prot) &= _CACHEMASK040;
> +		/* Use no-cache mode, serialized */
> +		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE_S;
> +	}
> +}
> +#else
   ^^^^^
So this branch can go away

> +#warning What do we have to do here??
> +#define fb_pgprotect(...) do {} while (0)
> +#endif /* CONFIG_SUN3 */
> +
> +#endif /* _ASM_FB_H_ */
> diff --git a/include/asm-m68knommu/fb.h b/include/asm-m68knommu/fb.h
> new file mode 100644
> index 0000000..dc9d1be
> --- /dev/null
> +++ b/include/asm-m68knommu/fb.h
> @@ -0,0 +1,7 @@
> +#ifndef _ASM_FB_H_
> +#define _ASM_FB_H_
> +
> +#warning What do we have to do here??
> +#define fb_pgprotect(...) do {} while (0)
> +
> +#endif /* _ASM_FB_H_ */

If the m68knommu case in fb_mmap() was empty before, it should be empty here
too, so I guess the warning can go away.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
