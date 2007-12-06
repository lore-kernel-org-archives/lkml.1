Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbXLFVtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbXLFVtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXLFVsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:48:54 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4340 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbXLFVsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:48:53 -0500
Date: Thu, 6 Dec 2007 16:39:51 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Neil Horman <nhorman@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ben Woodard <woodard@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071206213951.GB28898@hmsreliant.think-freely.org>
References: <20071127194220.GG14887@hmsendeavour.rdu.redhat.com> <20071127200011.GA3703@redhat.com> <20071127222408.GH24223@one.firstfloor.org> <474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com> <20071128160206.GA21286@hmsendeavour.rdu.redhat.com> <20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com> <20071130144250.GC23810@redhat.com> <20071130145131.GB5822@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130145131.GB5822@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 09:51:31AM -0500, Neil Horman wrote:
> On Fri, Nov 30, 2007 at 09:42:50AM -0500, Vivek Goyal wrote:
<snip>
> 
> Thats what I'm doing at the moment.  I'm working on a RHEL5 patch at the moment
> (since thats whats on the production system thats failing), and will forward
> port it once its working
> 
> And not to split hairs, but techically thats not our _only_ choice.  We could
> force kdump boots on cpu0 as well ;)
> 
> Thanks
> Neil
> 
> > Thanks
> > Vivek
> 


Sorry to have been quiet on this issue for a few days. Interesting news to
report, though.  So I was working on a patch to do early apic enabling on
x86_64, and had something working for the old 2.6.18 kernel that we were
origionally testing on.  Unfortunately while it worked on 2.6.18 it failed
miserably on 2.6.24-rc3-mm2, causing check_timer to consistently report that the
timer interrupt wasn't getting received (even though we could successfully run
calibrate_delay).  Vivek and I were digging into this, when I ran accross the
description of the hypertransport configuration register in the opteron
specification.  It contains a bit that, suprise, configures the ht bus to either
unicast interrupts delivered accross the ht bus to a single cpu, or to broadcast
it to all cpus.  Since it seemed more likely that the 8259 in the nvidia
southbridge was transporting legacy mode interrupts over the ht bus than
directly to cpu0 via an actual wire, I wrote the attached patch to add a quirk
for nvidia chipsets, which scanned for hypertransport controllers, and ensured
that that broadcast bit was set.  Test results indicate that this solves the
problem, and kdump kernels boot just fine on the affected system.

I understand that enabling the apic early in the boot process is a nice general
solution, but given the wide range of apic configurations possible, and the
need for large amounts of testing of such a change, this approach seems like it
might be the better way to go, as it corrects a bad behavior only in systems
that would be affected by this problem.  It introduces no further complexity in
the kdump shutdown path, and creates no additional instability in systems that
would otherwise be unaffected by this bug. 

I think this is the best way for us to go forward.  Attached patch applies
cleanly against 2.6.24-rc3-mm2 and works for me on serveral systems unaffected
by the kdump crash problem I origionally reported and fixes the bug on the
affected system.

Thanks & Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

 
 early-quirks.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)


diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 88bb83e..ea16b53 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -44,6 +44,45 @@ static int __init nvidia_hpet_check(struct acpi_table_header *header)
 #endif /* CONFIG_X86_IO_APIC */
 #endif /* CONFIG_ACPI */
 
+static void __init fix_hypertransport_config(int num, int slot, int func)
+{
+	u32 htcfg;
+	/*
+	 *we found a hypertransport bus
+	 *make sure that are broadcasting
+	 *interrupts to all cpus on the ht bus
+	 */
+	htcfg = read_pci_config(num, slot, func, 0x68);
+	if ((htcfg & (1 << 17)) == 0)	
+		printk(KERN_INFO "Enabling hypertransport interrupt broadcast\n");
+	htcfg |= (1 << 17);
+	write_pci_config(num, slot, func, 0x68, htcfg);
+	
+}
+
+static void __init check_hypertransport_config()
+{
+	int num, slot, func;
+	u32 device, vendor;
+	func = 0;
+	for (num = 0; num < 32; num++) {
+		for (slot = 0; slot < 32; slot++) {
+			vendor = read_pci_config(num,slot,func,
+						PCI_VENDOR_ID); 
+			device = read_pci_config(num,slot,func,
+						PCI_DEVICE_ID);
+			vendor &= 0x0000ffff;
+			device >>= 16;
+			if ((vendor == PCI_VENDOR_ID_AMD) &&
+			    (device == PCI_DEVICE_ID_AMD_K8_NB))
+				fix_hypertransport_config(num,slot,func);
+		}
+	}
+
+	return;
+
+}
+
 static void __init nvidia_bugs(void)
 {
 #ifdef CONFIG_ACPI
@@ -69,7 +108,7 @@ static void __init nvidia_bugs(void)
 #endif
 #endif
 	/* RED-PEN skip them on mptables too? */
-
+	check_hypertransport_config();
 }
 
 static void __init ati_bugs(void)
