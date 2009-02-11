Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZBKK3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZBKK3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZBKK3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:29:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33387 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZBKK3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:29:31 -0500
Date: Wed, 11 Feb 2009 11:29:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Yinghai Lu <yinghai@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86, apic: make generic_apic_probe() generally available
Message-ID: <20090211102919.GA11000@elte.hu>
References: <1234297715.24155.29.camel@alok-dev1> <86802c440902101303u2fe671b0xe811543d40e0cd9@mail.gmail.com> <1234303240.24155.36.camel@alok-dev1> <49921C4F.9050601@kernel.org> <1234313137.30391.13.camel@alok-dev1> <20090211094659.GA20518@elte.hu> <20090211094858.GB20518@elte.hu> <20090211102534.GA9976@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211102534.GA9976@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > I've applied your patch as an interim measure so far, to fix the crash, so 
> > please do the cleaner patch ontop of your first patch. Thanks,
> 
> I removed it again. generic_apic_probe() is not always available on 32-bit either.

applied the fix below instead.

	Ingo

------------------>
>From 160d8dac12932ad6eb4a359b66521e2e3282ea7d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 11 Feb 2009 11:27:39 +0100
Subject: [PATCH] x86, apic: make generic_apic_probe() generally available

Impact: build fix

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h |    6 ++++++
 arch/x86/kernel/setup.c     |    2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f4835a1..fba49f6 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -33,7 +33,13 @@
 	} while (0)
 
 
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
 extern void generic_apic_probe(void);
+#else
+static inline void generic_apic_probe(void)
+{
+}
+#endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 150e6d0..8fce6c7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -936,9 +936,7 @@ void __init setup_arch(char **cmdline_p)
 	map_vsyscall();
 #endif
 
-#ifdef CONFIG_X86_32
 	generic_apic_probe();
-#endif
 
 	early_quirks();
 
