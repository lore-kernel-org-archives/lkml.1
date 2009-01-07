Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbZAGXa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbZAGXa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbZAGXaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:30:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54403
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbZAGXaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:30:03 -0500
Date: Wed, 07 Jan 2009 15:30:05 -0800 (PST)
Message-Id: <20090107.153005.136649913.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, rmk+kernel@arm.linux.org.uk,
       adobriyan@gmail.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: hardirq.h removal broke sparc64 build...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090107145822.625960f2.akpm@linux-foundation.org>
References: <20090107.144310.79937111.davem@davemloft.net>
	<20090107145822.625960f2.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n07NUUwM013463

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Jan 2009 14:58:22 -0800

> On Wed, 07 Jan 2009 14:43:10 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > I've spent most of last night and this morning trying to figure out
> > a way to fix this, it is very non-trivial.
> > 
> > Adding a simple asm/cpudata.h include into asm/topology_64.h for the
> > SMP case does not work.
> > 
> > asm/cpudata.h brings in percpu.h which wants SLAB which wants to use
> > GFP_* values and thus includes gfp.h
> > 
> > And thus because of the include loop:
 ...
> > we can't include asm/cpudata.h into asm/topology.h otherwise
> > we get:
 ...
> > for the drivers/base/topology.o build failure case above.
> 
> yes, there were some nasty problems like that.  In several cases we wimped
> out and added the necessary includes to the .c file.  Will that (sad hack)
> work here?

Ok, this works.

Linus, please apply, thanks!

topology: Fix sparc64 build.

Due to changeset ba84be2338d3a2b6020d39279335bb06fcd332e1
("remove linux/hardirq.h from asm-generic/local.h") the
sparc64 build started failing on drivers/base/topology.c:

drivers/base/topology.c: In function â€˜show_physical_package_idâ€™:
drivers/base/topology.c:103: error: implicit declaration of function â€˜cpu_dataâ€™
drivers/base/topology.c:103: error: request for member â€˜proc_idâ€™ in something not a structure or union
drivers/base/topology.c: In function â€˜show_core_idâ€™:
drivers/base/topology.c:106: error: request for member â€˜core_idâ€™ in something not a structure or union

Adding the obvious fix of including asm/cpudata.h into
asm/topology.h on sparc64 doesn't fix it, in fact it
makes things worse because of the header file dependency
chain:

	linux/gfp.h --> linux/mmzone.h --> linux/topology.h -->
	asm/topology.h --> asm/cpudata.h --> linux/percpu.h -->
	linux/slab.h

which results in:

include/linux/slub_def.h: In function â€˜kmalloc_largeâ€™:
include/linux/slub_def.h:209: error: implicit declaration of function â€˜__get_free_pagesâ€™
include/linux/slub_def.h:209: error: â€˜__GFP_COMPâ€™ undeclared (first use in this function)
include/linux/slub_def.h:209: error: (Each undeclared identifier is reported only once
include/linux/slub_def.h:209: error: for each function it appears in.)
include/linux/slub_def.h:209: warning: cast to pointer from integer of different size

The simplest thing to do is to add yet another one-off hack like
parts of the guilty changeset did, by putting an explicit
linux/hardirq.h include into drivers/base/topology.c

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index a8bc1cb..a778fb5 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
+#include <linux/hardirq.h>
 #include <linux/topology.h>
 
 #define define_one_ro(_name) 		\
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
