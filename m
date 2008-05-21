Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbYEUIy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbYEUIy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYEUIyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:54:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:15823 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbYEUIyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:54:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,519,1204531200"; 
   d="scan'208";a="283513593"
Subject: Re: [BISECTED] pata_jmicron: no drives found on post 2.6.25 kernels
From: Shaohua Li <shaohua.li@intel.com>
To: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Cc: linux-kernel@vger.kernel.org, Luca Tettamanti <kronos.it@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <courier.4832F7AF.00000DCD@fs.ru.acad.bg>
References: <courier.4832011A.000041C2@fs.ru.acad.bg>
	 <1211248108.19834.2.camel@sli10-desk.sh.intel.com>
	 <courier.4832F7AF.00000DCD@fs.ru.acad.bg>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 May 2008 16:58:40 +0800
Message-Id: <1211360320.22210.5.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 19:09 +0300, Plamen Petrov wrote:
> Shaohua Li написа: 
> 
> > On Tue, 2008-05-20 at 01:37 +0300, Plamen Petrov wrote:
> >> Hello, folks!  
> >> 
> >> After 2.6.26 merge window opened, the optical drives in my
> >> computer, hanging off a JMicron controler were not detected
> >> by linux any more.  
> >> 
> >> Luca Tettamanti reported similar troubles:
> >> http://marc.info/?l=linux-kernel&m=120958791323911&w=2  
> >> 
> >> Its been 20 days, so I decided to bisect.
> >> git bisect revealed that commit
> >> 7d715a6c1ae5785d00fb9a876b5abdfc43abc44b
> >> is the one causing pata_jmicron to fail to detect drives,
> >> connected to the JMicron controler on my motherboard.
> >> At least in my case, anyway...
> >> Changing kernel config to CONFIG_PCIEASPM=n makes the drives
> >> attached to the JMicron SATA/PATA controller usable again. 
> > When you enable this option, did you change any ASPM policy? By default,
> > we are using the BIOS setting, so it shouldn't change any thing. 
> > 
> 
> No, I did not change any ASPM policy, mainly because I do not how. 
> 
> > Also can you please send me the 'lspci -vvvxxxx' output with/without the
> > ASPM enabled? 
> > 
Can you please try below patch?
The Slot 03:00.* of JMicron controller has two functions, but one is
PCIE endpoint the other isn't PCIE device, very strange. PCIE spec
defines all functions should have the same config for ASPM, so disable
ASPM for the whole slot in this case.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Index: linux/drivers/pci/pcie/aspm.c
===================================================================
--- linux.orig/drivers/pci/pcie/aspm.c	2008-05-21 16:38:17.000000000 +0800
+++ linux/drivers/pci/pcie/aspm.c	2008-05-21 16:52:35.000000000 +0800
@@ -506,6 +506,23 @@ static void free_link_state(struct pci_d
 	pdev->link_state = NULL;
 }
 
+static int pcie_aspm_sanity_check(struct pci_dev *pdev)
+{
+	struct pci_dev *child_dev;
+	int child_pos;
+
+	/*
+	 * Some functions in a slot might not all be PCIE functions, very
+	 * strange. Disable ASPM for the whole slot
+	 */
+	list_for_each_entry(child_dev, &pdev->subordinate->devices, bus_list) {
+		child_pos = pci_find_capability(child_dev, PCI_CAP_ID_EXP);
+		if (!child_pos)
+			return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * pcie_aspm_init_link_state: Initiate PCI express link state.
  * It is called after the pcie and its children devices are scaned.
@@ -526,6 +543,9 @@ void pcie_aspm_init_link_state(struct pc
 	if (list_empty(&pdev->subordinate->devices))
 		goto out;
 
+	if (pcie_aspm_sanity_check(pdev))
+		goto out;
+
 	mutex_lock(&aspm_lock);
 
 	link_state = kzalloc(sizeof(*link_state), GFP_KERNEL);


