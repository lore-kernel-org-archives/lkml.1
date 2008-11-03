Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYKCTbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYKCTbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYKCTba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:31:30 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:33995 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844AbYKCTb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:31:29 -0500
Subject: Re: [PATCH 2/4] Hypervisor detection and get tsc_freq from
	hypervisor
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <1225129306.28018.9.camel@alok-dev1>
References: <1224894104.28224.72.camel@alok-dev1>
	 <20081027110134.GC13641@elte.hu>  <1225129306.28018.9.camel@alok-dev1>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 03 Nov 2008 11:31:28 -0800
Message-Id: <1225740688.8168.41.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

The patch below fixes a problem with the implementation of
vmware_get_tsc_khz.

Please pick this patch too.

Thanks,
Alok

--

x86-VMware: Fix vmware_get_tsc code

From: Alok N Kataria <akataria@vmware.com>

The current version of the code to get the tsc frequency from
the VMware hypervisor, will be broken on processor with frequency
(4G-1) HZ, because on such processors eax will have UINT_MAX
and that would be legitimate.
We instead check that EBX did change to decide if we were able to
read the frequency from the hypervisor.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
---

 arch/x86/kernel/cpu/vmware.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 89bc346..b781e50 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -36,7 +36,7 @@
 			"=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :	\
 			"0"(VMWARE_HYPERVISOR_MAGIC),			\
 			"1"(VMWARE_PORT_CMD_##cmd),			\
-			"2"(VMWARE_HYPERVISOR_PORT), "3"(0) :		\
+			"2"(VMWARE_HYPERVISOR_PORT), "3"(UINT_MAX) :	\
 			"memory");
 
 static inline int __vmware_platform(void)
@@ -53,7 +53,7 @@ static unsigned long __vmware_get_tsc_khz(void)
 
         VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
 
-        if (eax == (uint32_t)-1)
+        if (ebx == UINT_MAX)
                 return 0;
         tsc_hz = eax | (((uint64_t)ebx) << 32);
         do_div(tsc_hz, 1000);


