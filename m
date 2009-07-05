Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZGENhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZGENhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZGENhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:37:14 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:42744 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZGENhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wZQqgw6AZPkDenMRNwL0NHX6tAD1Fc+OvHiJ9uVfgGBaV46CvEsyPhLuBqVhV8AFp7
         1skPBqutfKbhfOFF2IcfUTlTc4gSrUy+7A4ieGhzogaXA5K+mC98w3dZms/MQKXKLca0
         RTksOA6g74TmOoK6hKWok3tyIJPH8evXjebjg=
MIME-Version: 1.0
In-Reply-To: <20090705204418.44fc38c1@linux-lm>
References: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
	 <200907051319.37169.arnd@arndb.de> <20090705204418.44fc38c1@linux-lm>
Date: Sun, 5 Jul 2009 21:37:16 +0800
Message-ID: <d82e647a0907050637l532d40e8u4b67ecefa303415e@mail.gmail.com>
Subject: Re: [PATCH 0/3] dma-mapping:remove CONFIG_HAVE_DMA_ATTRS
From: Ming Lei <tom.leiming@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/5 Ming Lei <tom.leiming@gmail.com>:
> On Sun, 5 Jul 2009 13:19:36 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
>
>> On Saturday 04 July 2009, tom.leiming@gmail.com wrote:
>> > 2,Disabling CONFIG_HAVE_DMA_ATTRS may lead to a compile failure;
>>
>> I'm not sure I understand this point. CONFIG_HAVE_DMA_ATTRS tells
>> the common code whether the architecture understands dma attributes.
>
> If a new arch does not define CONFIG_HAVE_DMA_ATTRS but uses
> dma-mapping-common.h, it will lead to a compile failure.
>
> include/asm-generic/dma-mapping-common.h
>
>        #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a,
>        s, r, NULL)
>        ...
>
> include/linux/dma-mapping.h
>
>        #ifndef CONFIG_HAVE_DMA_ATTRS
>        struct dma_attrs;
>
>        #define dma_map_single_attrs(dev, cpu_addr, size, dir, attrs) \
>        dma_map_single(dev, cpu_addr, size, dir)
>        ...
>        #endif
>
>

I have another idea to fix the possible compile failure.  Does the
following patch
work?

diff --git a/include/asm-generic/dma-mapping-common.h
b/include/asm-generic/dma-mapping-common.h
index 5406a60..39e2ec5 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -6,6 +6,8 @@
 #include <linux/dma-debug.h>
 #include <linux/dma-attrs.h>

+#define ARCH_USE_DMA_MAPPING_COMMON
+
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      size_t size,
 					      enum dma_data_direction dir,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 07dfd46..4be1121 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -219,6 +219,7 @@ static inline void
dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */

+#ifndef ARCH_USE_DMA_MAPPING_COMMON
 #ifndef CONFIG_HAVE_DMA_ATTRS
 struct dma_attrs;

@@ -235,5 +236,7 @@ struct dma_attrs;
 	dma_unmap_sg(dev, sgl, nents, dir)

 #endif /* CONFIG_HAVE_DMA_ATTRS */
+#endif /* ARCH_USE_DMA_MAPPING_COMMON */
+

 #endif



-- 
Lei Ming
