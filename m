Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbYEHRtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbYEHRtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764710AbYEHRnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:51 -0400
Received: from mail.suse.de ([195.135.220.2]:47836 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764489AbYEHRnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:49 -0400
Date: Thu, 8 May 2008 10:42:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Michal Schmidt <mschmidt@redhat.com>,
       Andy Gospodarek <andy@greyhouse.net>, john.cagle@hp.com,
       Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>
Subject: [patch 12/16] x86 PCI: call dmi_check_pciprobe()
Message-ID: <20080508174224.GM855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-pci-call-dmi_check_pciprobe.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Yinghai Lu <yhlu.kernel@gmail.com>

This is a backport of the noted commit which is in 2.6.26-rc1
now.  This is necessary to enable pci=bfsort automatically on a number
of Dell and HP servers, as well as pci=assign-busses for a few other
systems, which was broken between 2.6.22 and 2.6.23.

commit 0df18ff366853cdf31e5238764ec5c63e6b5a398 upstream

x86 PCI: call dmi_check_pciprobe()

this change:

| commit 08f1c192c3c32797068bfe97738babb3295bbf42
| Author: Muli Ben-Yehuda <muli@il.ibm.com>
| Date:   Sun Jul 22 00:23:39 2007 +0300
|
|    x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata
|
|    This patch introduces struct pci_sysdata to x86 and x86-64, and
|    converts the existing two users (NUMA, Calgary) to use it.
|
|    This lays the groundwork for having other users of sysdata, such as
|    the PCI domains work.
|
|    The Calgary bits are tested, the NUMA bits just look ok.

replaces pcibios_scan_root with pci_scan_bus_parented...

but in pcibios_scan_root we have a DMI check:

dmi_check_system(pciprobe_dmi_table);

when when have several peer root buses this could be called multiple
times (which is bad), so move that call to pci_access_init().

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/pci/common.c |    7 +++++--
 arch/x86/pci/init.c   |    2 ++
 arch/x86/pci/pci.h    |    2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -372,13 +372,16 @@ static struct dmi_system_id __devinitdat
 	{}
 };
 
+void __init dmi_check_pciprobe(void)
+{
+	dmi_check_system(pciprobe_dmi_table);
+}
+
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
 
-	dmi_check_system(pciprobe_dmi_table);
-
 	while ((bus = pci_find_next_bus(bus)) != NULL) {
 		if (bus->number == busnum) {
 			/* Already scanned */
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -32,6 +32,8 @@ static __init int pci_access_init(void)
 		printk(KERN_ERR
 		"PCI: Fatal: No config space access function found\n");
 
+ 	dmi_check_pciprobe();
+
 	return 0;
 }
 arch_initcall(pci_access_init);
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -39,6 +39,8 @@ enum pci_bf_sort_state {
 	pci_dmi_bf,
 };
 
+extern void __init dmi_check_pciprobe(void);
+
 /* pci-i386.c */
 
 extern unsigned int pcibios_max_latency;

-- 
