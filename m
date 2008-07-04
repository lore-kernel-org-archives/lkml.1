Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbYGDOYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbYGDOYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYGDOY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:24:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35347 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbYGDOY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:24:27 -0400
Date: Fri, 4 Jul 2008 16:24:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: next-0704: x86_64 panics on booting
Message-ID: <20080704142409.GA18824@elte.hu>
References: <a4423d670807040720o3e8e350ds5c13dfca8e8adc58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670807040720o3e8e350ds5c13dfca8e8adc58@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Hi
> 
> 
> Booting the kernel.
> 
> Kernel alive
> Kernel really alive
> PANIC: early exception 0e rip 10:ffffffff80604f47 error 2 cr2 ffffffffff300000
> 
> It is x86_64 SMP (opteron).

does the patch below fix it?

	Ingo

-------------->
commit 181b3601a1a7d2ac3ace6b23cb3204450a4f9a27
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Sun Jun 29 20:02:44 2008 -0700

    x86: setup_arch() && early_ioremap_init()
    
    Looks like the setup.c unification missed the early_ioremap init from
    the early_ioremap unification.  Unconditionally call early_ioremap_init().
    
    needed for "x86/paravirt: groundwork for 64-bit Xen support".
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: Mark McLoughlin <markmc@redhat.com>
    Cc: xen-devel <xen-devel@lists.xensource.com>
    Cc: Eduardo Habkost <ehabkost@redhat.com>
    Cc: Vegard Nossum <vegard.nossum@gmail.com>
    Cc: Stephen Tweedie <sct@redhat.com>
    Cc: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index fb318ed..caec79f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -523,12 +523,13 @@ void __init setup_arch(char **cmdline_p)
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
-	early_ioremap_init();
 	reserve_setup_data();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	early_ioremap_init();
+
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;

