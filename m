Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab0CLJyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:54:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52501 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168Ab0CLJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:54:40 -0500
Subject: Re: [RFC] kmemleak: Is DMI supported ?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1268328868.2986.547.camel@edumazet-laptop>
References: <1268328868.2986.547.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 12 Mar 2010 09:54:35 +0000
Message-ID: <1268387675.3068.19.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2010 09:54:36.0162 (UTC) FILETIME=[05FECE20:01CAC1CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, 2010-03-11 at 17:34 +0000, Eric Dumazet wrote:
> On my i686 machine, I have
> CONFIG_DMI=y
> 
> and 12 entries in /sys/firmware/memmap/ like first one named "0" :
> 
> $ grep . /sys/firmware/memmap/0/*
> /sys/firmware/memmap/0/end:0x9f3ff
> /sys/firmware/memmap/0/start:0x0
> /sys/firmware/memmap/0/type:System RAM
> 
> 
> All 12 kobjects are allocated in DMI zone between
> c1001000 b .brk.dmi_alloc
> c1011000 B __brk_limit)
> 
> see arch/x86/kernel/setup.c:124
> 
> #ifdef CONFIG_DMI
> RESERVE_BRK(dmi_alloc, 65536);
> #endif
> 
> Still kmemleak seems to thing their names are unreferenced objects.

By default, kmemleak only scans the Data and BSS sections, any other
memory block that's not allocated via slab needs to be added explicitly.
In this case, you can add the line below somewhere in the x86 setup.c
file:

kmemleak_alloc(dmi_alloc, 65536, 0, 0);

An alternative would be to add x86 brk scanning explicitly in
kmemleak.c. It has the advantage that only the initialised parts of the
BRK are scanned. Something like below (untested):

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 5b069e4..2183f99 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -98,6 +98,9 @@
 #include <asm/sections.h>
 #include <asm/processor.h>
 #include <asm/atomic.h>
+#ifdef CONFIG_X86
+#include <asm/setup.h>
+#endif
 
 #include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
@@ -1166,6 +1169,9 @@ static void kmemleak_scan(void)
 	/* data/bss scanning */
 	scan_block(_sdata, _edata, NULL, 1);
 	scan_block(__bss_start, __bss_stop, NULL, 1);
+#ifdef CONFIG_X86
+	scan_block(__brk_base, _brk_end, NULL, 1);
+#endif
 
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */



-- 
Catalin

