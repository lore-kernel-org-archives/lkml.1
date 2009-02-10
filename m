Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZBJQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZBJQWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 11:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZBJQWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 11:22:07 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:43747 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZBJQWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:22:05 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Content-class: urn:content-classes:message
Date: Tue, 10 Feb 2009 17:21:57 +0100
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com>
In-Reply-To: <4990E90D.30005@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Thread-Index: AcmLKP7P/zEvQLfrSaaXqIGHMnGDlAAcgN4Q
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Yinghai Lu" <yinghai@kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Feb 2009 16:21:57.0852 (UTC) FILETIME=[B1F401C0:01C98B9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> please try:
> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c
b/arch/x86/kernel/cpu/mtrr/generic.c
> index 0c0a455..7a359ce 100644
> --- a/arch/x86/kernel/cpu/mtrr/generic.c
> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -397,7 +397,8 @@ static void generic_get_mtrr(unsigned int reg,
unsigned long *base,
> 		tmp |= ~((1<<(hi - 1)) - 1);
> 
> 		if (tmp != mask_lo) {
> -			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set
up an incorrect mask, fixing it up.\n");
> +			printk(KERN_INFO "mtrr: BIOS set mask_lo: %x
should be %x, fixing it up\n", mask_lo, tmp);
> +			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set
up an incorrect mask.\n");
>			mask_lo = tmp;
> 		}
> 	}

result:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:405
generic_get_mtrr+0xd0/0x10a()
[    0.000000] mtrr: your BIOS has set up an incorrect mask.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28.4-ibm #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8023acca>] warn_slowpath+0xb4/0xda
[    0.000000]  [<ffffffff8023b8c6>] vprintk+0x2a4/0x2d1
[    0.000000]  [<ffffffff80221bea>] default_spin_lock_flags+0x6/0x8
[    0.000000]  [<ffffffff80451cf9>] printk+0x4e/0x5d
[    0.000000]  [<ffffffff80453e6a>] _spin_lock_irqsave+0x25/0x2c
[    0.000000]  [<ffffffff802194c0>] mtrr_wrmsr+0x1b/0x48
[    0.000000]  [<ffffffff805e5f88>] get_mtrr_state+0x2e5/0x2f1
[    0.000000]  [<ffffffff8021960e>] generic_get_mtrr+0xd0/0x10a
[    0.000000]  [<ffffffff805e4e0d>] mtrr_bp_init+0x1f5/0xc39
[    0.000000]  [<ffffffff805e58e4>]
mtrr_trim_uncached_memory+0x93/0x374
[    0.000000]  [<ffffffff805f07c9>] early_iounmap+0x13d/0x19d
[    0.000000]  [<ffffffff805f07c9>] early_iounmap+0x13d/0x19d
[    0.000000]  [<ffffffff805da140>] early_idt_handler+0x0/0x71
[    0.000000]  [<ffffffff805e0d56>] setup_arch+0x407/0x78c
[    0.000000]  [<ffffffff805f4c81>] cgroup_init_subsys+0x2a/0xd9
[    0.000000]  [<ffffffff805f4f5e>] cgroup_init_early+0x1a4/0x1b6
[    0.000000]  [<ffffffff80453f10>] _spin_lock+0x6/0x7
[    0.000000]  [<ffffffff805da931>] start_kernel+0x7b/0x38b
[    0.000000]  [<ffffffff805da140>] early_idt_handler+0x0/0x71
[    0.000000]  [<ffffffff805da3a1>] x86_64_start_kernel+0xe7/0xf4
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---



-----Original Message-----
From: Yinghai Lu [mailto:yinghai@kernel.org] 
Sent: Tuesday, February 10, 2009 3:40 AM
To: Ingo Molnar
Cc: Morten P.D. Stevens; Thomas Gleixner; H. Peter Anvin; Arjan van de
Ven; linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with
2.6.29-rc3 on IBM x3400

Ingo Molnar wrote:
> * Morten P.D. Stevens <mstevens@win-professional.com> wrote:
> 
>> Hi,
>>
>> Update:
>>
>> the same issue with a linux 2.6.28.4 kernel.
>>
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404
generic_get_mtrr+0xdf/0x119()
>> [    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing
it up.
> 
> buggy BIOS most likely. Had the kernel not fixed up the MTRRs you'd
have
> a very slow and unhappy system now.

please try:
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c
b/arch/x86/kernel/cpu/mtrr/generic.c
index 0c0a455..7a359ce 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -397,7 +397,8 @@ static void generic_get_mtrr(unsigned int reg,
unsigned long *base,
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set
up an incorrect mask, fixing it up.\n");
+			printk(KERN_INFO "mtrr: BIOS set mask_lo: %x
should be %x, fixing it up\n", mask_lo, tmp);
+			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set
up an incorrect mask.\n");
 			mask_lo = tmp;
 		}
 	}
