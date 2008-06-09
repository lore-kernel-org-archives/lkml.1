Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbYFIKN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbYFIKN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760142AbYFIKNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:13:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40220 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759399AbYFIKNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:13:37 -0400
Date: Mon, 9 Jun 2008 12:13:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7 - fix
Message-ID: <20080609101318.GA23873@elte.hu>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805251600.26325.yhlu.kernel@gmail.com> <200806011317.38622.yhlu.kernel@gmail.com> <200806081953.26877.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806081953.26877.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> [PATCH] x86: update mptable v7 - fix
> 
> need to call early_reserve_e820 to prelocate mptable for 32bit
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> Index: linux-2.6/arch/x86/kernel/setup_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup_32.c
> +++ linux-2.6/arch/x86/kernel/setup_32.c
> @@ -761,6 +761,8 @@ void __init setup_arch(char **cmdline_p)
>  	 */
>  	max_pfn = e820_end_of_ram();
>  
> +	/* pre allocte 4k for mptable mpc */
> +	early_reserve_e820_mpc_new();

applied, thanks. It needed the small build fix below as well, for UP 
32-bit.

	Ingo

--------------->
commit 3c803fb3e1972566f7a1613f53f7e5a70fbde83f
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun May 25 21:16:06 2008 +0200

    x86, mpparse: build fix
    
    fix:
    
      LD      .tmp_vmlinux1
      arch/x86/kernel/built-in.o: In function `setup_arch':
      : undefined reference to `early_reserve_e820_mpc_new'
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index 6e9c958..b8ba374 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -46,7 +46,11 @@ extern unsigned long mp_lapic_addr;
 
 extern void find_smp_config(void);
 extern void get_smp_config(void);
+#ifdef CONFIG_X86_MPPARSE
 extern void early_reserve_e820_mpc_new(void);
+#else
+static inline void early_reserve_e820_mpc_new(void) { }
+#endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI

