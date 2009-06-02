Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbZFBUpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbZFBUpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZFBUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:45:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:52731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZFBUpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:45:36 -0400
Message-ID: <4A258F1C.7030707@kernel.org>
Date: Tue, 02 Jun 2009 13:44:12 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pascal Terjan <pterjan@mandriva.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, stable <stable@kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
References: <1243625720.4426.0.camel@plop>  <4A203BFD.7040000@kernel.org>	 <1243949325.19053.100.camel@plop>  <4A256050.2020305@kernel.org> <1243969741.27062.11.camel@plop>
In-Reply-To: <1243969741.27062.11.camel@plop>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan wrote:
> Le mardi 02 juin 2009 à 10:24 -0700, Yinghai Lu a écrit :
> ACPI: Using IOAPIC for interrupt routing
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
> PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
> PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
> PCI: Using MMCONFIG for extended config space

please check

[PATCH] x86/pci: fix mmconfig detection with 32bit need 4g

Pascal reported and bisected to commit:
|	x86/PCI: don't call e820_all_mapped with -1 in the mmconfig case

for 32bit, mcfg_res->end could be 32bit only ( if 64 res is not used)
use end - 1 to pass the value in mcfg->end to avoid overflow

don't need to worry about e820 path. they are 64 bit always

Reported-by: Pascal Terjan <pterjan@mandriva.com>
Bisected-by: Pascal Terjan <pterjan@mandriva.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 arch/x86/pci/mmconfig-shared.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -375,7 +375,7 @@ static acpi_status __init check_mcfg_res
 		if (!fixmem32)
 			return AE_OK;
 		if ((mcfg_res->start >= fixmem32->address) &&
-		    (mcfg_res->end <= (fixmem32->address +
+		    (mcfg_res->end < (fixmem32->address +
 				      fixmem32->address_length))) {
 			mcfg_res->flags = 1;
 			return AE_CTRL_TERMINATE;
@@ -392,7 +392,7 @@ static acpi_status __init check_mcfg_res
 		return AE_OK;
 
 	if ((mcfg_res->start >= address.minimum) &&
-	    (mcfg_res->end <= (address.minimum + address.address_length))) {
+	    (mcfg_res->end < (address.minimum + address.address_length))) {
 		mcfg_res->flags = 1;
 		return AE_CTRL_TERMINATE;
 	}
@@ -418,7 +418,7 @@ static int __init is_acpi_reserved(u64 s
 	struct resource mcfg_res;
 
 	mcfg_res.start = start;
-	mcfg_res.end = end;
+	mcfg_res.end = end - 1;
 	mcfg_res.flags = 0;
 
 	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
