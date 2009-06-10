Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbZFJDm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbZFJDm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZFJDfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:35:31 -0400
Received: from kroah.org ([198.145.64.141]:57107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336AbZFJDf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:29 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:47 2009
Message-Id: <20090610002347.308215897@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:14:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 33/60] x86/pci: fix mmconfig detection with 32bit near 4g
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=x86-pci-fix-mmconfig-detection-with-32bit-near-4g.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Yinghai Lu <yinghai@kernel.org>

commit 75e613cdc7bb2ba3795b1bc3ddf19476c767ba68 upstream.

Pascal reported and bisected a commit:
|	x86/PCI: don't call e820_all_mapped with -1 in the mmconfig case

which broke one system system.

ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space

it didn't have
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
anymore, and try to use 0xf000000 - 0xffffffff for mmconfig

For 32bit, mcfg_res->end could be 32bit only (if 64 resources aren't used)
So use end - 1 to pass the value in mcfg->end to avoid overflow.

We don't need to worry about the e820 path, they are always 64 bit.

Reported-by: Pascal Terjan <pterjan@mandriva.com>
Bisected-by: Pascal Terjan <pterjan@mandriva.com>
Tested-by: Pascal Terjan <pterjan@mandriva.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/mmconfig-shared.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -255,7 +255,7 @@ static acpi_status __init check_mcfg_res
 		if (!fixmem32)
 			return AE_OK;
 		if ((mcfg_res->start >= fixmem32->address) &&
-		    (mcfg_res->end <= (fixmem32->address +
+		    (mcfg_res->end < (fixmem32->address +
 				      fixmem32->address_length))) {
 			mcfg_res->flags = 1;
 			return AE_CTRL_TERMINATE;
@@ -272,7 +272,7 @@ static acpi_status __init check_mcfg_res
 		return AE_OK;
 
 	if ((mcfg_res->start >= address.minimum) &&
-	    (mcfg_res->end <= (address.minimum + address.address_length))) {
+	    (mcfg_res->end < (address.minimum + address.address_length))) {
 		mcfg_res->flags = 1;
 		return AE_CTRL_TERMINATE;
 	}
@@ -298,7 +298,7 @@ static int __init is_acpi_reserved(u64 s
 	struct resource mcfg_res;
 
 	mcfg_res.start = start;
-	mcfg_res.end = end;
+	mcfg_res.end = end - 1;
 	mcfg_res.flags = 0;
 
 	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);


