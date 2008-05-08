Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbYEHOnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbYEHOnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYEHOng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:43:36 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:48078 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYEHOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:43:34 -0400
Message-ID: <482311C9.2010603@keyaccess.nl>
Date: Thu, 08 May 2008 16:44:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com> <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org> <48226569.7010906@zytor.com> <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de>
Content-Type: multipart/mixed;
 boundary="------------020605010207070702030502"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020605010207070702030502
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 08-05-08 14:49, Thomas Gleixner wrote:

> Subject: x86: cleanup PAT cpu validation
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 08 May 2008 09:18:43 +0200

Thanks much. Definite ACK, very much including on the much better disable
message:

> +	pat_disable(cpu_has_pat ?
> +		    "PAT disabled. Not yet verified on this CPU type." :
> +		    "PAT not supported by CPU.");
> +}

However, I'm not sure, but:

> +	/* Paranoia check. */
> +	if (!cpu_has_pat) {
> +		printk(KERN_ERR "PAT enabled, but CPU feature cleared\n");
> +		/*
> +		 * Panic if this happens on the secondary CPU, and we
> +		 * switched to PAT on the boot CPU. We have no way to
> +		 * undo PAT.
> +		*/
> +		BUG_ON(boot_pat_state);
> +	}

The 'if this happens on the secondary CPU' sounds a bit like this is
directly checking the secondary CPU flag but cpu_has_pat translates into
boot_cpu_has(X86_FEATURE_PAT), refers always to the boot cpu. Yes, we
continued on on the boot CPU after the error message so this triggers,
but thought I'd make sure it was also intended this way. If so, never
mind...

I'm privately again placing this on top. If anyone has any explicit
testing suggestion, I'm all ears.

Rene.

--------------020605010207070702030502
Content-Type: text/plain;
 name="pat_duron7.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pat_duron7.diff"

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..cfa1b6b 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -57,6 +57,8 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)
 			return;
+		if (c->x86 == 6 && c->x86_model == 7)
+			return;
 		break;
 	case X86_VENDOR_INTEL:
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))

--------------020605010207070702030502--
