Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZEKPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZEKPB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZEKPAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:00:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28841 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbZEKPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:00:43 -0400
X-IronPort-AV: E=Sophos;i="4.40,328,1238990400"; 
   d="scan'208";a="50779243"
Subject: Re: [tip:x86/xen] x86: use flush_tlb_others to implement
	flush_tlb_all, fix
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20090511131230.GA32693@elte.hu>
References: <1241797927.15972.51.camel@zakaz.uk.xensource.com>
	 <tip-636afdbe85d50d9b88f5283b5e6d0f8518431aac@git.kernel.org>
	 <20090511131230.GA32693@elte.hu>
Content-Type: text/plain; charset="utf-8"
Organization: Citrix Systems, Inc.
Date: Mon, 11 May 2009 16:00:41 +0100
Message-ID: <1242054041.29990.88.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 09:12 -0400, Ingo Molnar wrote:

> which then does:
> 
> init/main.c:728: error: implicit declaration of function ‘init_smp_flush’

Er, yeah, that change is pretty bogus for !x86 (I guess you were
compiling for some other $ARCH?)

You could either take the original patch which made it an early initcall
instead (http://marc.info/?l=linux-kernel&m=124179652227660&w=2) or we
could move it much earlier into setup arch, as per:

Subject: Call init_smp_flush() from arch code

init_smp_flush() is x86 specific so call it from arch code rather than
generic code.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1b1c851..aade391 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -985,6 +985,8 @@ void __init setup_arch(char **cmdline_p)
 
 	e820_setup_gap();
 
+	init_smp_flush();
+
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
 	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
diff --git a/init/main.c b/init/main.c
index f798501..33ce929 100644
--- a/init/main.c
+++ b/init/main.c
@@ -651,7 +651,6 @@ asmlinkage void __init start_kernel(void)
 	vfs_caches_init_early();
 	cpuset_init_early();
 	page_cgroup_init();
-	init_smp_flush();
 	mem_init();
 	enable_debug_pagealloc();
 	cpu_hotplug_init();


