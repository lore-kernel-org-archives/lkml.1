Return-Path: <linux-kernel-owner+w=401wt.eu-S1422993AbXD3FBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422993AbXD3FBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423001AbXD3FBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:01:40 -0400
Received: from smtp104.plus.mail.re2.yahoo.com ([206.190.53.29]:23217 "HELO
	smtp104.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422993AbXD3FBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:01:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=gduxkGZGeQgFNx1AqbxxZuPqsft85qMkJ4iAL5YzmzXwfLMcmc1cxRvOW/vgwD8C9jhBCEmBVQPtbmxiFzC1T0VrJQLb/9vC1DkTs7pAkwhBzYhOZaCrJHjK2tCFya0UsjnwXmAohhGLVG2OZZ+YWy3Wk6a0TFhVK1oQLnuK8UE=  ;
X-YMail-OSG: _y1ncNUVM1lpmCXScZBE55Q6YyWnElEDbiYjBbvDfna9af_nVBl_4Tpeosp2g5rf3X_feNP0WV.gp_c7yi9E01c4CPMNjnaBD5.VSGsz37ZfzT.MsBtEbu3ePBLftK7JkhFgHNi2F2_r13E-
Date: Mon, 30 Apr 2007 07:01:33 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/26] x86_64: Fix vmalloc_32 to really allocate <4GB on 64bit platforms
Message-ID: <20070430050133.GA4772@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070430146.588463000@suse.de> <20070429234618.4CC7E150F2@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070429234618.4CC7E150F2@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 01:46:18AM +0200, Andi Kleen wrote:
> 
> Ugly ifdef, but should handle all 64bit platforms that have suitable
> zones. On some like Altix it's probably impossible without IOMMU
> use to get memory <4GB this way,  but they have to live with that.
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  mm/vmalloc.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Index: linux/mm/vmalloc.c
> ===================================================================
> --- linux.orig/mm/vmalloc.c
> +++ linux/mm/vmalloc.c
> @@ -577,6 +577,14 @@ void *vmalloc_exec(unsigned long size)
>  	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC);
>  }
>  
> +#if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
> +#define GFP_VMALLOC32 GFP_DMA32
> +#elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
> +#define GFP_VMALLOC32 GFP_DMA
> +#else
> +#define GFP_VMALLOC32 GFP_KERNEL
> +#endif
> +

Isn't the following shorter:


Index: 2.6.21/mm/vmalloc.c
===================================================================
--- 2.6.21.orig/mm/vmalloc.c
+++ 2.6.21/mm/vmalloc.c
@@ -577,6 +577,15 @@ void *vmalloc_exec(unsigned long size)
 	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC);
 }

+#if defined(CONFIG_64BIT)
+  #if defined(CONFIG_ZONE_DMA32)
+  #define GFP_VMALLOC32 GFP_DMA32
+  #elif defined(CONFIG_ZONE_DMA)
+  #define GFP_VMALLOC32 GFP_DMA
+#else
+  #define GFP_VMALLOC32 GFP_KERNEL
+#endif
+
 /**
  *	vmalloc_32  -  allocate virtually contiguous memory (32bit addressable)
  *	@size:		allocation size
-- 
Regards/Gruﬂ,
    Boris.
