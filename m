Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbYDQBYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbYDQBYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760791AbYDQBI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:59 -0400
Received: from sous-sol.org ([216.99.217.87]:58966 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760763AbYDQBI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:58 -0400
Message-Id: <20080417010334.951283202@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kenichi Ohmichi <oomichi@mxs.nes.nec.co.jp>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: vmcoreinfo: add the symbol "phys_base"
Content-Disposition: inline; filename=vmcoreinfo-add-the-symbol-phys_base.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

upstream commit: 629c8b4cdb354518308663aff2f719e02f69ffbe

Fix the problem that makedumpfile sometimes fails on x86_64 machine.

This patch adds the symbol "phys_base" to a vmcoreinfo data.  The
vmcoreinfo data has the minimum debugging information only for dump
filtering.  makedumpfile (dump filtering command) gets it to distinguish
unnecessary pages, and makedumpfile creates a small dumpfile.

On x86_64 kernel which compiled with CONFIG_PHYSICAL_START=0x0 and
CONFIG_RELOCATABLE=y, makedumpfile fails like the following:

 # makedumpfile -d31 /proc/vmcore dumpfile
 The kernel version is not supported.
 The created dumpfile may be incomplete.
 _exclude_free_page: Can't get next online node.

 makedumpfile Failed.
 #

The cause is the lack of the symbol "phys_base" in a vmcoreinfo data.
If the symbol "phys_base" does not exist, makedumpfile considers an
x86_64 kernel as non relocatable.  As the result, makedumpfile
misunderstands the physical address where the kernel is loaded, and it
cannot translate a kernel virtual address to physical address correctly.

To fix this problem, this patch adds the symbol "phys_base" to a
vmcoreinfo data.

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/machine_kexec_64.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -233,6 +233,7 @@ NORET_TYPE void machine_kexec(struct kim
 
 void arch_crash_save_vmcoreinfo(void)
 {
+	VMCOREINFO_SYMBOL(phys_base);
 	VMCOREINFO_SYMBOL(init_level4_pgt);
 
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE

-- 
