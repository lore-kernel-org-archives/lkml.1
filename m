Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYJaIos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYJaIos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 04:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYJaIoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 04:44:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbYJaIoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 04:44:37 -0400
Date: Fri, 31 Oct 2008 09:44:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix missing cpu_index initialisation
Message-ID: <20081031084418.GA7702@elte.hu>
References: <1225401217.19324.28.camel@localhost.localdomain> <20081030231723.GB1985@elte.hu> <20081030234529.GA19298@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030234529.GA19298@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Depends on [VOYAGER] x86: add ability to test for boot CPU
> > 
> > applied both to tip/x86/urgent:
> > 
> >  6b5496e: x86/voyager: fix missing cpu_index initialisation
> >  3b25aec: x86/voyager: fix compile breakage caused by dc1e35c6e95e8923cf1d35104
> 
> this broke the x86 build:
> 
>  arch/x86/kernel/cpu/common.c: In function 'early_identify_cpu':
>  arch/x86/kernel/cpu/common.c:553: error: 'struct cpuinfo_x86' has no member named 'cpu_index'
> 
> fixed via the patch below.

i just found a third build failure as well, caused by the voyager 
fixes:

 arch/x86/kernel/cpu/common.c: In function 'cpu_init':
 arch/x86/kernel/cpu/common.c:1141: error: 'boot_cpu_id' undeclared (first use in this function)
 arch/x86/kernel/cpu/common.c:1141: error: (Each undeclared identifier is reported only once
 arch/x86/kernel/cpu/common.c:1141: error: for each function it appears in.)

(see the fix below)

this raises the urgency the conversion of x86/Voyager to normal x86 
platform APIs.

	Ingo

---------------->
>From b342797c1e5116a130841527b47dfaa462ed0968 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 31 Oct 2008 09:31:38 +0100
Subject: [PATCH] x86: build fix

Impact: build fix on certain UP configs

fix:

 arch/x86/kernel/cpu/common.c: In function 'cpu_init':
 arch/x86/kernel/cpu/common.c:1141: error: 'boot_cpu_id' undeclared (first use in this function)
 arch/x86/kernel/cpu/common.c:1141: error: (Each undeclared identifier is reported only once
 arch/x86/kernel/cpu/common.c:1141: error: for each function it appears in.)

Pull in asm/smp.h on UP, so that we get the definition of
boot_cpu_id.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 003a653..b9c9ea0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -20,6 +20,7 @@
 #include <asm/pat.h>
 #include <asm/asm.h>
 #include <asm/numa.h>
+#include <asm/smp.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
