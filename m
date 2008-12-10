Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYLIX4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYLIX4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYLIX4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:56:31 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:49738 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956AbYLIX4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:56:30 -0500
Subject: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
From: Zachary Amsden <zach@vmware.com>
To: norman@thebacks.co.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, mingo <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Alok Kataria <alokkataria1@gmail.com>,
       Bruno =?ISO-8859-1?Q?Pr=E9mont?= <"bruno .premont"@restena.lu>,
       xl@xlsigned.net, dsd@gentoo.org
Content-Type: multipart/mixed; boundary="=-l97DT3D8bSmjKwqAn0/3"
Date: Tue, 09 Dec 2008 16:50:21 -0800
Message-Id: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-l97DT3D8bSmjKwqAn0/3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Patches backported into 2.6.27.4 caused a regression with VMI kernels
running on VMware which ends in a page fault during boot.  I have a fix
which still allows DMI checks to be done early.

VMI initialiation can relocate the fixmap, causing early_ioremap
to malfunction if it is initialized before the relocation.  The
ioremap area is low enough in virtual address space that no actual
collision occurs, however, because the pagetables for it were not
allocated under VMI mode, the pagetable updates are dropped by
the hypervisor as irrelevant, resulting in a crash on boot.

The best fix is perhaps to move early_ioremap_init() after vmi_init().
The only things done before VMI init are basic memory access, things
like collating the memory map, collecting boot CPUID capabilities, and
parsing the early command line options... which vmi_init needs.

Since this went back into 2.6.27, it needs to go to both 2.6.28 and
eventually to stable.  I didn't add any comments or anything as there
could be some debate what the proper ordering should be.  In case that
becomes an interesting discussion, there are two relevant facts in git
today:

1) no clients of early_ioremap occur before DMI.
2) VMI requires access to early boot params.

If any can suggest a better ordering, I am certainly open to that as
well.

Thanks,

Zach

--=-l97DT3D8bSmjKwqAn0/3
Content-Disposition: attachment; filename=x86-vmi-boot-ioremap-fix.patch
Content-Type: text/x-patch; name=x86-vmi-boot-ioremap-fix.patch; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

VMI initialiation can relocate the fixmap, causing early_ioremap
to malfunction if it is initialized before the relocation.  The
ioremap area is low enough in virtual address space that no actual
collision occurs, however, because the pagetables for it were not
allocated under VMI mode, the pagetable updates are dropped by
the hypervisor as irrelevant, resulting in a crash on boot.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..9627753 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -795,7 +795,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	early_cpu_init();
-	early_ioremap_init();
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
@@ -888,6 +887,8 @@ void __init setup_arch(char **cmdline_p)
 	vmi_init();
 #endif
 
+	early_ioremap_init();
+
 	/* after early param, so could get panic from serial */
 	reserve_early_setup_data();
 

--=-l97DT3D8bSmjKwqAn0/3--

