Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZCEIrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZCEIrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZCEIrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:47:03 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33668 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZCEIrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:47:01 -0500
Date: Thu, 5 Mar 2009 17:43:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Johannes Weiner <jw@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -v2] flat: fix data sections alignment
Message-ID: <20090305084307.GB16451@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Johannes Weiner <jw@emlix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org
References: <E1LerUo-0000NE-Q3@mailer.emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LerUo-0000NE-Q3@mailer.emlix.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 02:51:17PM +0100, Johannes Weiner wrote:
> Paul, please note that on sh ARCH_SLAB_MINALIGN is defined to be 8
> while the userspace stack was aligned to 4 before.  I suppose aligning
> the stack (and data sections) to 8 as well is the right thing...?
> 
This is intentional. As I noted before, the ARCH_SLAB_MINALIGN on SH
refers specifically to SH-5 (or anything implementing a 32-bit sh64 ABI),
which presently does not support nommu, but could in theory. The SH parts
that do nommu today generally need ARCH_KMALLOC_MINALIGN, but do not have
the ARCH_SLAB_MINALIGN requirement that SH-5 does.

> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -41,6 +41,7 @@
>  #include <asm/uaccess.h>
>  #include <asm/unaligned.h>
>  #include <asm/cacheflush.h>
> +#include <asm/page.h>
>  
>  /****************************************************************************/
>  
> @@ -54,6 +55,12 @@
>  #define	DBG_FLT(a...)
>  #endif
>  
> +#ifdef ARCH_SLAB_MINALIGN
> +#define FLAT_DATA_ALIGN	(ARCH_SLAB_MINALIGN)
> +#else
> +#define FLAT_DATA_ALIGN	(sizeof(void *))
> +#endif
> +
As it's not entirely obvious what this is used for outside of the slab
context, you will want to have a comment here explaining the situation,
and particularly what the implication for stack alignment is.
