Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbZKDXGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbZKDXGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZKDXGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:06:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:12753 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbZKDXGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:06:00 -0500
X-ExtLoop1: 1
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
In-Reply-To: <1257301490.2668.280.camel@sbs-t61.sc.intel.com>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>
	 <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>
	 <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>
	 <1257301490.2668.280.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 04 Nov 2009 15:04:35 -0800
Message-Id: <1257375875.4716.24.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 18:24 -0800, Suresh Siddha wrote:
> Maciej, There might be some confusion (mostly on my side). When I looked
> at ICH2 spec http://www.intel.com/assets/pdf/datasheet/290687.pdf it
> says it has an EOI register and it is version 2.

Ok, Issue is in the specs documentation. ICH2 to ICH5 seems to document
that they use version 0x2 ioapic's, while infact they use 0x20 version
and has a working EOI register. So we should use 0x20 as the version
check and not 0x2.

Maciej, can I have your ack for the appended patch?
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, ioapic: fix io-apic version check for the EOI reg presence

Maciej W. Rozycki reported:
> 82093AA I/O APIC has its version set to 0x11 and it 
> does not support the EOI register.  Similarly I/O APICs integrated into 
> the 82379AB south bridge and the 82374EB/SB EISA component.

IO-APIC versions below 0x20 don't support EOI register.

Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
version as 0x2. This is an error with documentation and these ICH chips
use io-apic's of version 0x20 and indeed has a working EOI register
for the io-apic.

Fix the ioapic_supports_eoi() to check for version 0x20 and beyond.

Reported-by: Maciej W. Rozycki <macro@linux-mips.org>
Acked-by: Rajesh Sankaran <rajesh.sankaran@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 47d95c3..68510d4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2520,13 +2520,29 @@ static void eoi_ioapic_irq(struct irq_desc *desc)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+/*
+ * IO-APIC versions below 0x20 don't support EOI register.
+ * For the record, here is the information about various versions:
+ * 	0Xh	82489DX
+ * 	1Xh	I/OAPIC or I/O(x)APIC which are not PCI 2.2 Compliant
+ * 	2Xh     I/O(x)APIC which is PCI 2.2 Compliant
+ *	30h-FFh Reserved
+ *
+ * Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
+ * version as 0x2. This is an error with documentation and these ICH chips
+ * use io-apic's of version 0x20.
+ */
 static int ioapic_supports_eoi(void)
 {
 	struct pci_dev *root;
 
 	root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+	/*
+ 	 * Perhaps we can do this for all vendors. But for now,
+ 	 * no one else seems to have version >= 0x20 ??
+ 	 */
 	if (root && root->vendor == PCI_VENDOR_ID_INTEL &&
-	    mp_ioapics[0].apicver >= 0x2) {
+	    mp_ioapics[0].apicver >= 0x20) {
 		use_eoi_reg = 1;
 		printk(KERN_INFO "IO-APIC supports EOI register\n");
 	} else


