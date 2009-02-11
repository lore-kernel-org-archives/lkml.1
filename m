Return-Path: <linux-kernel-owner+w=401wt.eu-S1751209AbZBKNWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbZBKNWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZBKNWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:22:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50887 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbZBKNWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:22:42 -0500
Date: Wed, 11 Feb 2009 14:22:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <lenb@kernel.org>
Cc: Pawel Dziekonski <dzieko@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci, x86, acpi: fix early_ioremap() leak
Message-ID: <20090211132223.GP16535@elte.hu>
References: <20090204142455.GE4411@elte.hu> <2cd4df870902040751l19332473ic36e2642723f5ec8@mail.gmail.com> <20090205192502.GC27422@elte.hu> <2cd4df870902051514k31582fbal11113b37b756dda0@mail.gmail.com> <1233914595.10894.1.camel@laptop> <20090206155311.GQ18368@elte.hu> <2cd4df870902061444p335a9433l73fe6e820ec11c6@mail.gmail.com> <20090209122538.GI17782@elte.hu> <2cd4df870902091056v7287e53fx8e7c8c5599b856b3@mail.gmail.com> <49929533.6040602@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49929533.6040602@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> > after reboot I got this:
> > 
> > ------------[ cut here ]------------
> > WARNING: at arch/x86/mm/ioremap.c:616 check_early_ioremap_leak+0x52/0x67()
> > Hardware name:
> > Debug warning: early ioremap leak of 1 areas detected.
> > Modules linked in:
> 
> 
> please check
> 
> [PATCH] pci: fix one early_ioremap leaking

Jesse, Len, i've picked up Yinghai's fix into tip:x86/acpi, as it is a direct
consequence of the early-ioremap cleanups contained there:

 8e1568f: pci, x86, acpi: fix early_ioremap() leak
 b825e6c: x86, es7000: fix ACPI table mappings
 7d97277: acpi/x86: introduce __apci_map_table, v4
 05876f8: acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
 eecb9a6: x86: always explicitly map acpi memory
 1c14fa4: x86: use early_ioremap in __acpi_map_table

Let me know if that's not OK with you.

Thanks,

	Ingo

----------------->
>From 8e1568f3500287d0b36c9776132cb53a42d5651d Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 11 Feb 2009 01:06:59 -0800
Subject: [PATCH] pci, x86, acpi: fix early_ioremap() leak

Pawel reported:
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:616 check_early_ioremap_leak+0x52/0x67()
Hardware name:
Debug warning: early ioremap leak of 1 areas detected.
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.29-rc4-tip #2
...

Reported-by: Pawel Dziekonski <dzieko@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/dmar.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index f5a662a..519f5f9 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -42,6 +42,7 @@
 LIST_HEAD(dmar_drhd_units);
 
 static struct acpi_table_header * __initdata dmar_tbl;
+static acpi_size dmar_tbl_size;
 
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 {
@@ -288,8 +289,9 @@ static int __init dmar_table_detect(void)
 	acpi_status status = AE_OK;
 
 	/* if we could find DMAR table, then there are DMAR devices */
-	status = acpi_get_table(ACPI_SIG_DMAR, 0,
-				(struct acpi_table_header **)&dmar_tbl);
+	status = acpi_get_table_with_size(ACPI_SIG_DMAR, 0,
+				(struct acpi_table_header **)&dmar_tbl,
+				&dmar_tbl_size);
 
 	if (ACPI_SUCCESS(status) && !dmar_tbl) {
 		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
@@ -481,6 +483,7 @@ void __init detect_intel_iommu(void)
 			iommu_detected = 1;
 #endif
 	}
+	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
 }
 
