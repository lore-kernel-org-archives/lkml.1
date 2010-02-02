Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0BBSlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:41:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:56055 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab0BBSls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:41:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,392,1262592000"; 
   d="scan'208";a="489072023"
Subject: Re: do_IRQ: 0.165 No irq handler for vector (irq -1)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Torsten Kaiser <just.for.lkml@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <m1r5p4grvg.fsf@fess.ebiederm.org>
References: <64bb37e1001310502p3d74bdf5ve56f63d3e8d2fd39@mail.gmail.com>
	 <4B679042.2010008@kernel.org>  <m1r5p4grvg.fsf@fess.ebiederm.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 02 Feb 2010 10:40:22 -0800
Message-Id: <1265136022.2793.33.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 20:53 -0800, Eric W. Biederman wrote:
> > It might be that the silicon implements MSI incorrectly and ends up
> > sending out invalid MSI packets under certain circumstances.  The
> > silicon hasn't changed for quite some time now and back when it came
> > out MSI wasn't too popular and I don't think SIMG's proprietary
> > drivers use it, so it's quite possible that the feature simply is
> > broken.  Is there any specific reason why you want to enable MSI
> > support?  It's not like MSI brings any actual benefit when the
> > compatibility hardware is already there.
> 
> It also seems possible that some of the recent irq handling changes
> missed something.

No Eric. This particular report is with 2.6.33-rc kernels and also only
when MSI support for sata_sil24 is enabled. Recent irq handling changes
are all in -tip tree and getting tested. So this sounds like a different
problem specific to this HW's MSI capabilities.

> Usually the message "No irq handler for vector (irq -1)" means that the irq
> was delivered to a cpu that was not ready for it.  I see that vector 165
> is being delivered on all of the different cpus with vector 165,
> and that you are getting interrupts delivered most of the time.

Also I see this in the original report:

On Sun, 2010-01-31 at 05:02 -0800, Torsten Kaiser wrote:
> What is really strange: The vector 165 is stable. It never changed
> even if I deactivate all other drivers in the kernel config (that
> changes the MSI IRQ for sata_sil24 from 29 to 28!) or if I switch off
> CONFIG_SPARSE_IRQ. In the kernel with the reduced number of drivers
> the maximum vector that gets used in __assign_irq_vector is only 137.

It looks like the HW under certain conditions is generating interrupts
with wrong vector (165), especially when the __assign_irq_vector() never
allocated the vector 165 (and hence we never setup the vector to irq
mapping for this vector on any cpu). Torsten, can you please apply the
appended patch and boot with "apic_phys" boot parameter and see if it
makes any difference?

> This smells like the initialization problems I was seeing in another
> thread.  Suresh?

No. Initialization problems in another thread happens in a small window
during cpu online (in logical flat mode, we are setting up vector to irq
mappings for the AP a little late after we have enabled interrupts).
Here the problem is not actually triggered during cpu on-lining.

Thanks.
---

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index e3c3d82..e26b2ea 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -222,6 +222,15 @@ struct apic apic_flat =  {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
 
+static int use_apic_phys;
+
+static int set_apic_phys_mode(char *arg)
+{
+        use_apic_phys = 1;
+        return 0;
+}
+early_param("apic_phys", set_apic_phys_mode);
+
 /*
  * Physflat mode is used when there are more than 8 CPUs on a AMD system.
  * We cannot use logical delivery in this case because the mask
@@ -247,7 +256,7 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	}
 #endif
 
-	return 0;
+	return use_apic_phys;
 }
 
 static const struct cpumask *physflat_target_cpus(void)




