Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbXIZONH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbXIZONH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXIZOMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:12:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbXIZOMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:12:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc: fix pci domain detection
Date: Wed, 26 Sep 2007 16:02:05 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: paulus@samba.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709261602.06214.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/jmqCFtY4wHMCUl1oiYDofBu7Hk5MxtOxc7Ab
 SHm18MxmIa3P//wh0r9HjGZj5sc/LKGN6XC8mSII5+9Hq+DmcQ
 xdMW+PCAUMbdHKiB+iwyw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/bus/pci/* files list PCI domain numbers only for
devices that claim to be on a multi-domain system. The check
for this is broken on powerpc, because the buid value is
truncated to 32 bits.

There is at least one machine (IBM QS21) that only uses
the high-order bits of the buid, so the return value
of pci_proc_domain() ends up being always zero, which
makes /proc/bus/pci useless.

Change the logic to always return '1' for a nonzero
buid value.

Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>

diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 291ffbc..9f63bdc 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -588,7 +588,7 @@ int pci_proc_domain(struct pci_bus *bus)
 		return 0;
 	else {
 		struct pci_controller *hose = pci_bus_to_host(bus);
-		return hose->buid;
+		return hose->buid != 0;
 	}
 }
 
