Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbZFJDm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbZFJDm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbZFJDfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:35:41 -0400
Received: from kroah.org ([198.145.64.141]:57147 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104AbZFJDfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:38 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:47 2009
Message-Id: <20090610002347.756939203@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:14:03 -0700
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
       alan@lxorguk.ukuu.org.uk, Brian Maly <bmaly@redhat>,
       Yinghai Lu <yinghai@kernel.org>, ying.huang@intel.com,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 35/60] x86: fix DMI on EFI
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=x86-fix-dmi-on-efi.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Brian Maly <bmaly@redhat.com>

commit ff0c0874905fb312ca1491bbdac2653b0b48c20b upstream.

Impact: reactivate DMI quirks on EFI hardware

DMI tables are loaded by EFI, so the dmi calls must happen after
efi_init() and not before.

Currently Apple hardware uses DMI to determine the framebuffer mappings
for efifb. Without DMI working you also have no video on MacBook Pro.

This patch resolves the DMI issue for EFI hardware (DMI is now properly
detected at boot), and additionally efifb now loads on Apple hardware
(i.e. video works).

Signed-off-by: Brian Maly <bmaly@redhat>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: ying.huang@intel.com
LKML-Reference: <49ADEDA3.1030406@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -730,6 +730,9 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	if (efi_enabled)
+		efi_init();
+
 	dmi_scan_machine();
 
 	dmi_check_system(bad_bios_dmi_table);
@@ -743,8 +746,6 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-	if (efi_enabled)
-		efi_init();
 
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {


