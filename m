Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZELCr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZELCr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbZELCrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:47:16 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44962 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755328AbZELCrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:47:15 -0400
Date: Tue, 12 May 2009 11:47:15 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 03/11] Xen: Rename the balloon lock
Message-ID: <20090512024715.GD22497%yamahata@valinux.co.jp>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <1241732737-7669-4-git-send-email-jeremy@goop.org> <20090508020123.GE25512%yamahata@valinux.co.jp> <4A0875C7.7070305@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0875C7.7070305@goop.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 12:00:23PM -0700, Jeremy Fitzhardinge wrote:
> Isaku Yamahata wrote:
> >Hi. Please please don't move the arch common variable
> >into x86 specific file. It causes link error on ia64.
> >
> >Before I sent the patches to fix it twice or so,
> >but it seems to be dropped.
> >  
> 
> Sorry, I can't seem to find them.  Could you resend?
> 
> I guess there's the larger issue of whether the 
> xen_create_contiguous_region() code is also useful on ia64.  It seems to 
> me the options are:
> 
>    * it is, so we should move the code somewhere common (along with the
>      lock)
>    * it isn't so ia64 will have its own version (in which case it can
>      define its own version of the lock without much impact)
>    * or we could move the lock anyway, but there's no very obvious
>      place to put it
> 

I see now the issue. My choice at the moment is the last option.
The copyright notice was taken from drivers/xen/balloon.c.
I don't have strong opinion about the place, so feel free to move it
as long as it is linked on IA64.

Non-pv_ops ia64 xen kernel has its own xen_create_contiguous_region().
But I suppose the code can be consolidated if you accept sprinkle some
if (xen_feature(XENFEAT_auto_translated_physmap)), so I'm willing to work on
the first option once the x86 pv_ops dom0 is stabilized/committed.

thanks,

commit 2017dc931ca350eaad9cacd97e74b9c2eb4990b9
Author: Isaku Yamahata <yamahata@valinux.co.jp>
Date:   Tue May 12 11:22:05 2009 +0900

    Impact: link fix on ia64
    
    Move the variable, xen_reservation_lock, to common place.
    IA64 also needs it.
    
    Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 360e546..e25a78e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -65,13 +65,6 @@
 
 #define MMU_UPDATE_HISTO	30
 
-/*
- * Protects atomic reservation decrease/increase against concurrent increases.
- * Also protects non-atomic updates of current_pages and driver_pages, and
- * balloon lists.
- */
-DEFINE_SPINLOCK(xen_reservation_lock);
-
 #ifdef CONFIG_XEN_DEBUG_FS
 
 static struct {
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index ff8accc..ec6ddab 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y	+= grant-table.o features.o events.o manage.o
+obj-y	+= grant-table.o features.o events.o manage.o reslock.o
 obj-y	+= xenbus/
 
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
diff --git a/drivers/xen/reslock.c b/drivers/xen/reslock.c
new file mode 100644
index 0000000..cfe0638
--- /dev/null
+++ b/drivers/xen/reslock.c
@@ -0,0 +1,36 @@
+/******************************************************************************
+ * revlock.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/spinlock.h>
+
+/*
+ * Protects atomic reservation decrease/increase against concurrent increases.
+ * Also protects non-atomic updates of current_pages and driver_pages, and
+ * balloon lists.
+ */
+DEFINE_SPINLOCK(xen_reservation_lock);


-- 
yamahata
