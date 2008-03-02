Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbYCBW4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbYCBW4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbYCBW4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:56:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:46126 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbYCBW4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:56:40 -0500
Subject: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: linuxppc-dev@ozlabs.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, airlied@linux.ie
In-Reply-To: <20080302223012.90210@gmx.net>
References: <20071125234254.B4405DDE49@ozlabs.org>
	 <20080302110505.175270@gmx.net> <1204490829.15052.482.camel@pasglop>
	 <20080302223012.90210@gmx.net>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 09:56:09 +1100
Message-Id: <1204498569.15052.488.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, I think I found the problem:

+static inline void *drm_vmalloc_dma(unsigned long size)
+{
+#if defined(__powerpc__) && defined(CONFIG_NOT_COHERENT_CACHE)
+       return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM,
+                        PAGE_KERNEL | _PAGE_NO_CACHE);
+#else
+       return vmalloc_32(size);
+#endif
+}
+

Remove the GFP_HIGHMEM from the above. It looks like our cache
flushing isn't going to work for highmem, it would need some
kmap's for that.

Ben.




