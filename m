Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYLPMGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYLPMGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYLPMG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:06:28 -0500
Received: from paperi.tontut.fi ([193.166.234.15]:43394 "EHLO paperi.tontut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbYLPMG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:06:28 -0500
X-Greylist: delayed 1629 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2008 07:06:28 EST
Message-ID: <4947938D.3010004@tut.fi>
Date: Tue, 16 Dec 2008 13:39:57 +0200
From: Janne Kulmala <janne.t.kulmala@tut.fi>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: x86: Fix HPET for Fujitsu u9200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPET timer is listed in the ACPI table, but needs a quirk entry in order to
work. Unfortunately, the quirk code runs after first HPET hpet_enable() which
has already determined that the timer doesn't work (reads 0xFFFFFFFF). This
patch allows hpet_enable() to be called again after running the quirk code.

Signed-off-by: Janne Kulmala <janne.t.kulmala@tut.fi>

--- linux-2.6.28/arch/x86/kernel/quirks.c~	2008-12-16 12:58:48.000000000 +0200
+++ linux-2.6.28/arch/x86/kernel/quirks.c	2008-12-16 12:59:14.000000000 +0200
@@ -168,6 +168,8 @@
  			 ich_force_enable_hpet);
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_1,
  			 ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_4,
+			 ich_force_enable_hpet);
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
  			 ich_force_enable_hpet);

--- linux-2.6.28/arch/x86/kernel/hpet.c~	2008-12-16 13:08:06.000000000 +0200
+++ linux-2.6.28/arch/x86/kernel/hpet.c	2008-12-16 13:10:29.000000000 +0200
@@ -811,7 +811,7 @@

  out_nohpet:
  	hpet_clear_mapping();
-	boot_hpet_disable = 1;
+	hpet_address = 0;
  	return 0;
  }


