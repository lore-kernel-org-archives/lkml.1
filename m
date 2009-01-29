Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZA2L1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZA2L1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 06:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZA2L1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 06:27:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZA2L1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 06:27:19 -0500
Date: Thu, 29 Jan 2009 12:27:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old
	subarchitecture code
Message-ID: <20090129112700.GA9624@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu> <1233193977.15801.72.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233193977.15801.72.camel@vayu>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Wed, 2009-01-28 at 15:41 -0800, Ingo Molnar wrote:
> > This series of 114 patches implements a long desired restructuring,
> > unification and cleanup of the x86 APIC/SMP/subarch code:
> > 
> >   - unifies the 32-bit and 64-bit genapic code
> > 
> >   - sorts out all the subarch details into standalone and boot-time
> >     probable quirk modules
> > 
> >   - removes the build-time subarch hacks that we had on 32-bit.
> > 
> > This inevitably touches an awful lot of x86 code, and rather intrusively
> > so:
> > 
> >     112 files changed, 3277 insertions(+), 3209 deletions(-)
> > 
> > So breakages are to be expected. 
> 
> Here's one :)
> 
> diff --git a/arch/x86/include/asm/genapic.h
> b/arch/x86/include/asm/genapic.h
> index 4bbcf26..273b994 100644
> --- a/arch/x86/include/asm/genapic.h
> +++ b/arch/x86/include/asm/genapic.h
> @@ -145,7 +145,7 @@ static inline unsigned int read_apic_id(void)
>  {
>  	unsigned int reg;
>  
> -	reg = *(u32 *)(APIC_BASE + APIC_ID);
> +	reg = apic_read(APIC_ID);
>  

ah, indeed - hardcoded mmio access to the lapic isnt quite 
xapic_ops-compatible ;-)

Applied to tip/x86/apic (see the commit below), thanks Suresh! The xapic 
bisection breakage is 40 commits so i'll likely rebase those bits.

Did it work fine on xapic otherwise?

	Ingo

---------------->
>From 97918fc3a0e1a31407df298392a12451b289ed1f Mon Sep 17 00:00:00 2001
From: Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 28 Jan 2009 17:52:57 -0800
Subject: [PATCH] x86: remove mach_apic.h, fix

Use apic_read() instead of open-coded mmio.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 4bbcf26..273b994 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -145,7 +145,7 @@ static inline unsigned int read_apic_id(void)
 {
 	unsigned int reg;
 
-	reg = *(u32 *)(APIC_BASE + APIC_ID);
+	reg = apic_read(APIC_ID);
 
 	return apic->get_apic_id(reg);
 }
