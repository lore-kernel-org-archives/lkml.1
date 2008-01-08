Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYAHDlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYAHDlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbYAHDlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:41:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYAHDlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:41:15 -0500
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
From: Tony Camuso <tcamuso@redhat.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matthew Wilcox <matthew@wil.cx>, Loic Prylli <loic@myri.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Nagananda Chumbalkar <nagananda.chumbalkar@hp.com>,
       Pat Schoeller <patrick.schoeller@hp.com>
In-Reply-To: <20071220195021.GA427@jurassic.park.msu.ru>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de>
	 <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com>
	 <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com>
	 <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org>
	 <20071220195021.GA427@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 22:41:00 -0500
Message-Id: <1199763660.16420.119.camel@dhcp83-188.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-20 at 22:50 +0300, Ivan Kokshaysky wrote:

> Use type 1 just for the first 64 bytes and tg3 will be happy. All we need
> is to avoid touching BARs with mmconfig.
> 
> Ivan.

I've tried Ivan's suggestion, and it works. 

The patch is appended below. 

My question is, do we want to incorporate this full-time upstream?

It would fix a lot of existing and potential problems, and the cost
is very small. 

Regards,
Tony

diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 1bf5816..42e7d4a 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -73,7 +73,8 @@ static int pci_mmcfg_read(unsigned int seg, unsigned int bus,
 	}
 
 	base = get_base_addr(seg, bus, devfn);
-	if (!base)
+	if ((!addr) || (reg < 0x40))
+
 		return pci_conf1_read(seg,bus,devfn,reg,len,value);
 
 	spin_lock_irqsave(&pci_config_lock, flags);
@@ -106,7 +107,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 		return -EINVAL;
 
 	base = get_base_addr(seg, bus, devfn);
-	if (!base)
+	if ((!addr) || (reg < 0x40))
 		return pci_conf1_write(seg,bus,devfn,reg,len,value);
 
 	spin_lock_irqsave(&pci_config_lock, flags);
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index 4095e4d..4ad1fcb 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -61,7 +61,7 @@ static int pci_mmcfg_read(unsigned int seg, unsigned int bus,
 	}
 
 	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr)
+	if ((!addr) || (reg < 0x40))
 		return pci_conf1_read(seg,bus,devfn,reg,len,value);
 
 	switch (len) {
@@ -89,7 +89,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 		return -EINVAL;
 
 	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr)
+	if ((!addr) || (reg < 0x40))
 		return pci_conf1_write(seg,bus,devfn,reg,len,value);
 
 	switch (len) {


