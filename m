Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZF3Ikv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZF3Ikv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZF3Ikn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:40:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48346 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZF3Ikm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:40:42 -0400
Subject: Re: WARNING: at mm/bootmem.c:535 alloc_arch_preferred_bootmem
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, jeremy.fitzhardinge@citrix.com
In-Reply-To: <alpine.DEB.2.01.0906291950280.6439@bogon>
References: <alpine.DEB.2.01.0906291950280.6439@bogon>
Date: Tue, 30 Jun 2009 11:40:42 +0300
Message-Id: <1246351243.8014.14.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Mon, 2009-06-29 at 20:01 -0700, Christian Kujau wrote:
> Hi there,
> 
> this topic has been discussed [0] already and a bug for powerpc[1] has 
> been opened, I'm still seeing this with the latest -git in a x86_64 Xen 
> DomU. The domain continues to boot however, no oopses or crashes so far, 
> it's just this warning during bootup. The thread about the "early boot 
> SLAB" came to a halt, but the warning is still there - is a fix for this 
> still in the works?
> 
> Full dmesg/.config: http://nerdbynature.de/bits/2.6.31-rc1/
> 
> Thanks,
> Christian.
> 
> [0] http://bugzilla.kernel.org/show_bug.cgi?id=13650 / Badness on the Warp
> [1] http://lkml.org/lkml/2009/6/10/396 / Early boot SLAB for 2.6.31

I think you're the first one to report this. The warning is harmless but
the following patch should fix things up. Thanks!

			Pekka

>From dc231c59194a973b80e6932bb4c162f2076635cb Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Tue, 30 Jun 2009 11:35:19 +0300
Subject: [PATCH] xen: Use kcalloc() in xen_init_IRQ()

The init_IRQ() function is now called with slab allocator initialized.
Therefore, we must not use the bootmem allocator in xen_init_IRQ().
Fixes the following boot-time warning:

  [    0.000000] Linux version 2.6.30 (dummy@sid) (gcc version 4.4.0 (Debian 4.4.0-8) ) #1 Tue Jun 23 02:13:42 CEST 2009
  [    0.000000] Command line: root=/dev/xvda1 console=hvc0 init=/sbin/init
  [    0.000000] KERNEL supported cpus:
  [    0.000000]   Intel GenuineIntel
  [    0.000000]   AMD AuthenticAMD
  [    0.000000]   Centaur CentaurHauls
  [    0.000000] BIOS-provided physical RAM map:
  [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
  [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
  [    0.000000]  Xen: 0000000000100000 - 0000000008000000 (usable)
  [    0.000000] DMI not present or invalid.
  [    0.000000] last_pfn = 0x8000 max_arch_pfn = 0x400000000
  [    0.000000] initial memory mapped : 0 - 20000000

Reported-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/xen/events.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 891d2e9..abad71b 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -927,9 +927,9 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 void __init xen_init_IRQ(void)
 {
 	int i;
-	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
 
-	cpu_evtchn_mask_p = alloc_bootmem(size);
+	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
+				    GFP_KERNEL);
 	BUG_ON(cpu_evtchn_mask_p == NULL);
 
 	init_evtchn_cpu_bindings();
-- 
1.5.6.3



