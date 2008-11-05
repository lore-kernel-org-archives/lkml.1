Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYKENqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYKENqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYKENqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:46:12 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:39115 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYKENqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:46:11 -0500
Date: Wed, 5 Nov 2008 07:45:35 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: rusty@rustcorp.com.au, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Broken "cpualloc: the allocator" patch
In-Reply-To: <20081105084254.GA3429@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0811050741450.11741@quilx.com>
References: <20081104034237.GA15227@x200.localdomain>
 <Pine.LNX.4.64.0811040934180.12886@quilx.com> <20081105084254.GA3429@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008, Alexey Dobriyan wrote:

> Same thing. For reference f622b9e43c8ba1902d4423bef9ae9d89b0254b45 aka
> "cpualloc: the allocator".
>
> It's BUG_ON(!size) at mm/bootmem.c:438. At cpu_alloc_init():
>
> __per_cpu_start = ff...80555000
> __per_cpu_end   = ff...8055d3e0
> UNIT_SIZE = 4
> base_percpu_in_units = 8440
> PERCPU_AREA_SIZE = 33760
> nr_units = 0 (bang!)
>
> MODULES are off.

Oww.. Ok we need to skip ahead to have a hunk from the second stage
to make sure PERCPU_RESERVE_SIZE is always > 0.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2008-11-05 07:41:22.134646124 -0600
+++ linux-2.6/include/linux/percpu.h	2008-11-05 07:44:28.603155403 -0600
@@ -44,11 +44,7 @@
  extern unsigned int percpu_reserve;
  /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
  #ifndef PERCPU_AREA_SIZE
-#ifdef CONFIG_MODULES
  #define PERCPU_RESERVE_SIZE	8192
-#else
-#define PERCPU_RESERVE_SIZE	0
-#endif

  #define PERCPU_AREA_SIZE						\
  	(__per_cpu_end - __per_cpu_start + percpu_reserve)
