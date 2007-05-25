Return-Path: <linux-kernel-owner+w=401wt.eu-S1763948AbXEYQgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763948AbXEYQgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXEYQgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:36:48 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:5453 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbXEYQgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WAI4aNzJbOz1uAAyTeex3T/TWJUQG3WHnxhzgN0gjdzn6ikCDNDJt+dovpein4lmS480rvynBBxGdIdhIxEbomoTRjEGfRgux7X33PVF9+CqoZ4rtB9X7adLQaxBDmMqFQ2wepjULaRvdKHvi7rE8JNqDUE702rZKfqxFuoHGoE=
Message-ID: <e9c3a7c20705250936n2689c1f3wce8ccb0ee4a22b9e@mail.gmail.com>
Date: Fri, 25 May 2007 09:36:31 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [patch] Introduce CONFIG_HAS_DMA.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Kyle McMartin" <kyle@parisc-linux.org>, linux-kernel@vger.kernel.org,
       James.Bottomley@steeleye.com, "Tejun Heo" <htejun@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>, geert@linux-m68k.org,
       zippel@linux-m68k.org, spyro@f2s.com, uclinux-v850@lsi.nec.co.jp,
       ysato@users.sourceforge.jp, "Cornelia Huck" <cornelia.huck@de.ibm.com>
In-Reply-To: <20070226135743.GB7925@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070223005945.GA13084@tuxdriver.com>
	 <20070223034243.GA7988@osiris.ibm.com>
	 <20070223061332.GB27126@osiris.ibm.com>
	 <20070223135740.GA28270@athena.road.mcmartin.ca>
	 <20070223143938.GA5815@tuxdriver.com>
	 <20070226135743.GB7925@osiris.boeblingen.de.ibm.com>
X-Google-Sender-Auth: c78c5aafc342f41d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ apologies for reviving an old conversation ]

On 2/26/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> Architectures that don't support DMA can say so by adding a
> config NO_DMA to their Kconfig file. This will prevent compilation
> of some dma specific driver code. Also dma-mapping-broken.h isn't
> needed anymore on at least s390.
> This avoids compilation and linking of otherwise dead/broken code.
>

I went back and read the thread leading up to this patch and I am of
the opinion that John's approach (adding more stubs to
dma-mapping-broken.h:
http://marc.info/?l=linux-kernel&m=117219377712232&w=2)  is needed in
_addition_ to this Kconfig option.  In my particular case I have an
API with a DMA and a non-DMA path written in such a way that the DMA
path can be compiled away.  Without dma-mapping-broken.h support the
API is unnecessarily forced to violate point 2 of
Documentation/SubmittingPatches (#ifdefs are ugly).

In other words let CONFIG_HAS_DMA prevent pure DMA code from being
built, but do not preclude "clever" implementations from calling
broken code.

If there are no objections I plan to resubmit John's changes with the
addition below, which allows CONFIG_HAS_DMA=n architectures to delete
their respective dma-mapping.h file.

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 9a663c6..2dc21cb 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -31,7 +31,11 @@ static inline int valid_dma_direction(int dma_direction)
                (dma_direction == DMA_FROM_DEVICE));
 }

+#ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
+#else
+#include <asm-generic/dma-mapping-broken.h>
+#endif

 /* Backwards compat, remove in 2.7.x */
 #define dma_sync_single                dma_sync_single_for_cpu
