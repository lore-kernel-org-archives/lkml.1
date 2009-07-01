Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZGAKzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZGAKzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZGAKzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:55:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:33541 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbZGAKzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:55:32 -0400
Date: Wed, 1 Jul 2009 10:54:47 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, jeremy.fitzhardinge@citrix.com,
       lists@nerdbynature.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, jeremy.fitzhardinge@citrix.com,
       lists@nerdbynature.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246438278.22417.28.camel@penberg-laptop>
References: <1246438278.22417.28.camel@penberg-laptop>
Subject: [tip:x86/urgent] xen: Use kcalloc() in xen_init_IRQ()
Message-ID: <tip-a70c352a37671fe1ebcbd317b439aa4760f4ccb7@git.kernel.org>
Git-Commit-ID: a70c352a37671fe1ebcbd317b439aa4760f4ccb7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 10:54:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a70c352a37671fe1ebcbd317b439aa4760f4ccb7
Gitweb:     http://git.kernel.org/tip/a70c352a37671fe1ebcbd317b439aa4760f4ccb7
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Wed, 1 Jul 2009 11:51:18 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 11:19:47 +0200

xen: Use kcalloc() in xen_init_IRQ()

The init_IRQ() function is now called with slab allocator initialized.
Therefore, we must not use the bootmem allocator in xen_init_IRQ().

Fixes the following boot-time warning:

  ------------[ cut here ]------------
  WARNING: at mm/bootmem.c:535 alloc_arch_preferred_bootmem+0x27/0x45()
  Modules linked in:
  Pid: 0, comm: swapper Not tainted 2.6.30 #1
  Call Trace:
   [<ffffffff8102d6e3>] ? warn_slowpath_common+0x73/0xb0
   [<ffffffff810210d9>] ? pvclock_clocksource_read+0x49/0x90
   [<ffffffff812e522f>] ? alloc_arch_preferred_bootmem+0x27/0x45
   [<ffffffff812e5761>] ? ___alloc_bootmem_nopanic+0x39/0xc9
   [<ffffffff812e57fa>] ? ___alloc_bootmem+0x9/0x2f
   [<ffffffff812e9e21>] ? xen_init_IRQ+0x25/0x61
   [<ffffffff812d69ee>] ? start_kernel+0x1b5/0x29e
  ---[ end trace 4eaa2a86a8e2da22 ]---

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: lists@nerdbynature.de
Cc: jeremy.fitzhardinge@citrix.com
LKML-Reference: <1246438278.22417.28.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
