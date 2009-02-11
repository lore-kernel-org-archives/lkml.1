Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZBKJIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZBKJIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZBKJHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:07:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:38627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbZBKJHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:07:50 -0500
Message-ID: <49929533.6040602@kernel.org>
Date: Wed, 11 Feb 2009 01:06:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pawel Dziekonski <dzieko@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CPU scheduler question/problem
References: <2cd4df870902031544h5f0b4e59na2c0a0804125dd9a@mail.gmail.com>	 <2cd4df870902040600r2974362r4e9eabf2608b05b4@mail.gmail.com>	 <20090204142455.GE4411@elte.hu>	 <2cd4df870902040751l19332473ic36e2642723f5ec8@mail.gmail.com>	 <20090205192502.GC27422@elte.hu>	 <2cd4df870902051514k31582fbal11113b37b756dda0@mail.gmail.com>	 <1233914595.10894.1.camel@laptop> <20090206155311.GQ18368@elte.hu>	 <2cd4df870902061444p335a9433l73fe6e820ec11c6@mail.gmail.com>	 <20090209122538.GI17782@elte.hu> <2cd4df870902091056v7287e53fx8e7c8c5599b856b3@mail.gmail.com>
In-Reply-To: <2cd4df870902091056v7287e53fx8e7c8c5599b856b3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Dziekonski wrote:
> 2009/2/9 Ingo Molnar <mingo@elte.hu>:
> 
>> What you need to do after this is to:
>>  git checkout tip/master
>> to be on the latest tip/master tree.
> 
> looks good.
> 
> again I got warnings (not errors!) around MODPOST about mismatch.
> make CONFIG_DEBUG_SECTION_MISMATCH=y
> shows 2 warning about some acpi related functions having (or not)
> necesary __init prefix.
> 
> after reboot I got this:
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:616 check_early_ioremap_leak+0x52/0x67()
> Hardware name:
> Debug warning: early ioremap leak of 1 areas detected.
> Modules linked in:


please check

[PATCH] pci: fix one early_ioremap leaking

Impact: fix map leaking

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

---
 drivers/pci/dmar.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -42,6 +42,7 @@
 LIST_HEAD(dmar_drhd_units);
 
 static struct acpi_table_header * __initdata dmar_tbl;
+static acpi_size dmar_tbl_size;
 
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 {
@@ -288,8 +289,9 @@ static int __init dmar_table_detect(void
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
 
