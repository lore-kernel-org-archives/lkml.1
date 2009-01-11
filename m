Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZAKTqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZAKTqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZAKTqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:46:37 -0500
Received: from relay3.sgi.com ([192.48.171.31]:56847 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751836AbZAKTqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:46:36 -0500
Message-ID: <496A4C8F.8070005@sgi.com>
Date: Sun, 11 Jan 2009 11:46:23 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christophe Saout <christophe@saout.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]: xen: fix too early kmalloc call
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: xen: fix too early kmalloc call

From: Christophe Saout <christophe@saout.de> 

Impact: fixes bootup of xen.

Christophe reported the following problem:

>  (basically it seems that SLAB is not yet up, with earlyprintk it is
>  giving me an Oops in __kmalloc before)

Replace call to kmalloc with alloc_bootmem.

Also from Christophe:
> (me)
> > Or I could copy the text and submit it as a new patch?
>
> Yes, I would prefer that.  Also, my commit message was not really
> following Kernel standards and it's only a very simple change.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/xen/events.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6-for-ingo.orig/drivers/xen/events.c
+++ linux-2.6-for-ingo/drivers/xen/events.c
@@ -26,6 +26,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/bootmem.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq.h>
@@ -831,8 +832,8 @@ void __init xen_init_IRQ(void)
 	int i;
 	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
 
-	cpu_evtchn_mask_p = kmalloc(size, GFP_KERNEL);
-	BUG_ON(cpu_evtchn_mask == NULL);
+	cpu_evtchn_mask_p = alloc_bootmem(size);
+	BUG_ON(cpu_evtchn_mask_p == NULL);
 
 	init_evtchn_cpu_bindings();
 
