Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYKGSkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYKGSkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYKGSkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:40:42 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:39690 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYKGSkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:40:41 -0500
Date: Fri, 7 Nov 2008 12:40:17 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
In-Reply-To: <20081107162114.2a41c623.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811071235040.5387@quilx.com>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
 <20081106183939.GA26925@x200.localdomain> <Pine.LNX.4.64.0811061310350.6009@quilx.com>
 <20081107162114.2a41c623.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Stephen Rothwell wrote:

> > Or did you use generic percpu support and set
> > CONFIG_HAVE_ZERO_BASED_PER_CPU?
>
> Also a avr32 allnoconfig
> (http://kisskb.ellerman.id.au/kisskb/buildresult/53233/) gets:
>
> backing-dev.c:(.init.text+0xc4c): undefined reference to `__per_cpu_start'
> backing-dev.c:(.init.text+0xc50): undefined reference to `__per_cpu_end'
>
> and avr32 defconfig
> (http://kisskb.ellerman.id.au/kisskb/buildresult/53225/) gets:
>
> vmstat.c:(.init.text+0xff0): undefined reference to `__per_cpu_start'
> vmstat.c:(.init.text+0xff4): undefined reference to `__per_cpu_end'

All of these have no invocation of the PERCPU macro from
asm-generic/vmlinus.lds.h in their arch vmlinux.lds.S. Thus the symbols
are missing. They are kind of irrelevant since we are only interested in
the difference between those...

Either we add the PERCPU() macro invocations to each arches vmlinux.lds.S
file or we need to special case each time __per_cpu_end/__start is used.
The only use added for the cpu allocator is in include/linux/percpu.h

Make it conditional on CONFIG_SMP

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-next/include/linux/percpu.h
===================================================================
--- linux-next.orig/include/linux/percpu.h	2008-11-06 10:03:22.985665656 -0600
+++ linux-next/include/linux/percpu.h	2008-11-07 12:38:06.223165740 -0600
@@ -61,8 +61,13 @@
 #ifndef PERCPU_AREA_SIZE
 #define PERCPU_RESERVE_SIZE	8192

+#ifdef CONFIG_SMP
 #define PERCPU_AREA_SIZE						\
 	(__per_cpu_end - __per_cpu_start + percpu_reserve)
+#else
+#define PERCPU_AREA_SIZE percpu_reserve
+#endif
+
 #endif	/* PERCPU_AREA_SIZE */

 /*

