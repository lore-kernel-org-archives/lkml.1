Return-Path: <linux-kernel-owner+w=401wt.eu-S1763152AbZAGWnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152AbZAGWnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762380AbZAGWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:43:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbZAGWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:43:09 -0500
Date: Wed, 07 Jan 2009 14:43:10 -0800 (PST)
Message-Id: <20090107.144310.79937111.davem@davemloft.net>
To: rmk+kernel@arm.linux.org.uk
CC: adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: hardirq.h removal broke sparc64 build...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n07MhWwM013117


[ Andrew, read carefully, I think some part of a patch you
  merged might have been lost while reshuffling or whatever. ]

This change:

commit ba84be2338d3a2b6020d39279335bb06fcd332e1
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Tue Jan 6 14:41:07 2009 -0800

    remove linux/hardirq.h from asm-generic/local.h

broke the build on sparc64:

drivers/base/topology.c: In function â€˜show_physical_package_idâ€™:
drivers/base/topology.c:103: error: implicit declaration of function â€˜cpu_dataâ€™
drivers/base/topology.c:103: error: request for member â€˜proc_idâ€™ in something not a structure or union
drivers/base/topology.c: In function â€˜show_core_idâ€™:
drivers/base/topology.c:106: error: request for member â€˜core_idâ€™ in something not a structure or union

Even though there is a footnote there from Alexey saying that
sparc64 was fixed up :-)

    [adobriyan@gmail.com: fix sparc64]

I've spent most of last night and this morning trying to figure out
a way to fix this, it is very non-trivial.

Adding a simple asm/cpudata.h include into asm/topology_64.h for the
SMP case does not work.

asm/cpudata.h brings in percpu.h which wants SLAB which wants to use
GFP_* values and thus includes gfp.h

And thus because of the include loop:

	linux/gfp.h --> linux/mmzone.h --> linux/topology.h -->
	asm/topology.h --> asm/cpudata.h --> linux/percpu.h -->
	linux/slab.h

we can't include asm/cpudata.h into asm/topology.h otherwise
we get:

include/linux/slub_def.h: In function â€˜kmalloc_largeâ€™:
include/linux/slub_def.h:209: error: implicit declaration of function â€˜__get_free_pagesâ€™
include/linux/slub_def.h:209: error: â€˜__GFP_COMPâ€™ undeclared (first use in this function)
include/linux/slub_def.h:209: error: (Each undeclared identifier is reported only once
include/linux/slub_def.h:209: error: for each function it appears in.)
include/linux/slub_def.h:209: warning: cast to pointer from integer of different size

for the drivers/base/topology.o build failure case above.

Actually, looking at the patch, where is the part from Alexey
that does the "fix sparc64"?  I see nothing in the patch that
would even appear to possibly be for that.  The diffstat is:

 arch/avr32/kernel/traps.c     |    1 +
 arch/sh/kernel/traps_32.c     |    1 +
 drivers/acpi/processor_idle.c |    1 +
 include/asm-generic/local.h   |    1 -
 4 files changed, 3 insertions(+), 1 deletion(-)

Was Alexey's fix removed or lost? :-/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
