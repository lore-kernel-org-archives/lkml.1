Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYHUIBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYHUIBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYHUIBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:01:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:31084 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbYHUIBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=LzLTtWZqx41drnzqWIuoU6Xq39J9sK2/pwnBoHYtVbDHh54zykYGzfgypMilQ9UtUt
         z/dvbPg4oiABsYxbVCVKaVLwHpd+iKx1ifFCFmfnensSfAAvm27JyxJPbxi8dGCPhIre
         w6v7ELva6mhS9cixWQLjbgZsi2VrFwtIP7q9M=
Message-ID: <86802c440808210101u1101b480p74ee387082ebdcb6@mail.gmail.com>
Date: Thu, 21 Aug 2008 01:01:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: apic version warning.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after following patch,

commit 1b313f4a6d7bee7b2c034b3f1e203bc360a71cca
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Mon Aug 18 20:45:57 2008 +0400

    x86: apic - generic_processor_info

    - use physid_set instead of phys_cpu and physids_or
    - set phys_cpu_present_map bit AFTER check for allowed
      number of processors
    - add checking for APIC valid version in 64bit mode
      (mostly not needed but added for merging purpose)
    - add apic_version definition for 64bit mode which
      is used now

we are getting warning for acpi path on 64 bit system

please add #ifdef for that.
actually, 64 bit doesn't use that apic_version[]


or using following patch?

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 301678b..fc64412 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -252,10 +252,8 @@ static void __cpuinit acpi_register_lapic(int id,
u8 enabled)
                return;
        }

-#ifdef CONFIG_X86_32
        if (boot_cpu_physical_apicid != -1U)
                ver = apic_version[boot_cpu_physical_apicid];
-#endif

        generic_processor_info(id, ver);
 }
@@ -775,10 +773,8 @@ static void __init
acpi_register_lapic_address(unsigned long address)
        set_fixmap_nocache(FIX_APIC_BASE, address);
        if (boot_cpu_physical_apicid == -1U) {
                boot_cpu_physical_apicid  = read_apic_id();
-#ifdef CONFIG_X86_32
                apic_version[boot_cpu_physical_apicid] =
                         GET_APIC_VERSION(apic_read(APIC_LVR));
-#endif
        }
 }


YH
