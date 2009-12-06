Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZLFXix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZLFXix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbZLFXiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:38:50 -0500
Received: from kroah.org ([198.145.64.141]:33808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130AbZLFXip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:09 2009
Message-Id: <20091206233209.736223758@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Harald Welte <HaraldWelte@viatech.com>, Dave Jones <davej@redhat.com>
Subject: [11/20] [CPUFREQ] Enable ACPI PDC handshake for VIA/Centaur CPUs
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=enable-acpi-pdc-handshake-for-via-centaur-cpus.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Harald Welte <HaraldWelte@viatech.com>

commit d77b81974521c82fa6fda38dfff1b491dcc62a32 upstream.

In commit 0de51088e6a82bc8413d3ca9e28bbca2788b5b53, we introduced the
use of acpi-cpufreq on VIA/Centaur CPU's by removing a vendor check for
VENDOR_INTEL.  However, as it turns out, at least the Nano CPU's also
need the PDC (processor driver capabilities) handshake in order to
activate the methods required for acpi-cpufreq.

Since arch_acpi_processor_init_pdc() contains another vendor check for
Intel, the PDC is not initialized on VIA CPU's.  The resulting behavior
of a current mainline kernel on such systems is:  acpi-cpufreq
loads and it indicates CPU frequency changes.  However, the CPU stays at
a single frequency

This trivial patch ensures that init_intel_pdc() is called on Intel and
VIA/Centaur CPU's alike.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/acpi/processor.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/acpi/processor.c
+++ b/arch/x86/kernel/acpi/processor.c
@@ -78,7 +78,8 @@ void arch_acpi_processor_init_pdc(struct
 	struct cpuinfo_x86 *c = &cpu_data(pr->id);
 
 	pr->pdc = NULL;
-	if (c->x86_vendor == X86_VENDOR_INTEL)
+	if (c->x86_vendor == X86_VENDOR_INTEL ||
+	    c->x86_vendor == X86_VENDOR_CENTAUR)
 		init_intel_pdc(pr, c);
 
 	return;


