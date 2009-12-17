Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZLQHuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZLQHuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZLQHuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:50:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53371 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZLQHun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:50:43 -0500
Date: Thu, 17 Dec 2009 08:50:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Myron Stowe <myron.stowe@hp.com>
Subject: -tip: origin tree build failure
Message-ID: <20091217075025.GA314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's -tip failed to build because commit 
9e368fa011d4e0aa050db348d69514900520e40b ("ipmi: add PNP discovery (ACPI 
namespace via PNPACPI)") from today's upstream kernel causes the following 
build failure on x86, for CONFIG_ACPI=n && CONFIG_IPMI_SI=y:

 drivers/char/ipmi/ipmi_si_intf.c:3208: error: 'ipmi_pnp_driver' undeclared (first use in this function)
 drivers/char/ipmi/ipmi_si_intf.c:3208: error: (Each undeclared identifier is reported only once
 drivers/char/ipmi/ipmi_si_intf.c:3208: error: for each function it appears in.)
 drivers/char/ipmi/ipmi_si_intf.c:3334: error: 'ipmi_pnp_driver' undeclared (first use in this function)

The reason is that the ipmi_pnp_driver depends on ACPI facilities and is only 
made available under ACPI - while the registration and unregistration is made 
dependent on CONFIG_PNP:

 #ifdef CONFIG_PNP
 	pnp_register_driver(&ipmi_pnp_driver);
 #endif

The solution is to only register this driver under ACPI. (Also, the CONFIG_PNP 
dependency is not needed because pnp_register_driver() is stubbed out in the 
!CONFIG_PNP case.)

I've applied the patch below to tip:out-of-tree for now.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 679cd08..176f175 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3204,7 +3204,7 @@ static __devinit int init_ipmi_si(void)
 #ifdef CONFIG_ACPI
 	spmi_find_bmc();
 #endif
-#ifdef CONFIG_PNP
+#ifdef CONFIG_ACPI
 	pnp_register_driver(&ipmi_pnp_driver);
 #endif
 
@@ -3330,7 +3330,7 @@ static __exit void cleanup_ipmi_si(void)
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&ipmi_pci_driver);
 #endif
-#ifdef CONFIG_PNP
+#ifdef CONFIG_ACPI
 	pnp_unregister_driver(&ipmi_pnp_driver);
 #endif
 
