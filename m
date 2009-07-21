Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZGUQ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZGUQ4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZGUQ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:56:47 -0400
Received: from claw.goop.org ([74.207.240.146]:52498 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZGUQ4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:56:46 -0400
Message-ID: <4A65F34D.40506@goop.org>
Date: Tue, 21 Jul 2009 09:56:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Bastian Blank <bastian@waldi.eu.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH] x86: detect use of extended APIC ID for AMD CPUs
References: <20090604104016.GT5736@alberich.amd.com> <20090721103642.GA10071@wavehammer.waldi.eu.org>
In-Reply-To: <20090721103642.GA10071@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/09 03:36, Bastian Blank wrote:
> On Thu, Jun 04, 2009 at 12:40:16PM +0200, Andreas Herrmann wrote:
>   
>> Booting a 32-bit kernel on Magny-Cours results in the following panic
>>     
>
> This patch breaks Xen really bad. It uses read_pci_config without
> knowing that there is something accessible. Also read_pci_config does
> not define fault handlers.
>
> | (XEN) traps.c:413:d375 Unhandled general protection fault fault/trap [#13] on VCPU 0 [ec=0000]
> | (XEN) domain_crash_sync called from entry.S
> | (XEN) Domain 375 (vcpu#0) crashed on cpu#1:
> | (XEN) ----[ Xen-3.2-1  x86_64  debug=n  Not tainted ]----
> | (XEN) CPU:    1
> | (XEN) RIP:    e033:[<ffffffff80401d6b>]
> | (XEN) RFLAGS: 0000000000000282   CONTEXT: guest
> | (XEN) rax: 000000008000c068   rbx: ffffffff80618a40   rcx: 0000000000000068
> | (XEN) rdx: 0000000000000cf8   rsi: 000000000000c000   rdi: 0000000000000000
> | (XEN) rbp: 0000000000000018   rsp: ffffffff80621eb0   r8:  ffffffff80621efc
> | (XEN) r9:  00000000ffffffff   r10: ffffffff80621ef8   r11: 00000000ffffffff
> | (XEN) r12: ffffffffffffffff   r13: ffffffff80621fd8   r14: 0000002040404030
> | (XEN) r15: 00000000015bb600   cr0: 000000008005003b   cr4: 00000000000006f0
> | (XEN) cr3: 00000002077be000   cr2: 000000204316b000
> | (XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
> | (XEN) Guest stack trace from rsp=ffffffff80621eb0:
> | (XEN)    0000000000000068 00000000ffffffff 0000000000000000 ffffffff80401d6b
> | (XEN)    000000010000e030 0000000000010082 ffffffff80621ef0 000000000000e02b
> | (XEN)    ffffffff804aeb3a 0000000100000000 0000302800000000 ffffffff805bcb20
> | (XEN)    ffffffff80651552 0000000000000000 0000000000000000 0000000000fdfd88
> | (XEN)    ffffffff8064e47c 0000000001fb9000 ffffffff80545875 0000000000000800
> | (XEN)    0000000000002c00 ffffffff81fb9000 ffffffff80650026 ffffffff805ca1c0
>
> | ffffffff80401d44 T read_pci_config
> | ffffffff804aeb41 t early_init_amd
>
> I see several ways to fix this:
> - Define fault handlers for *_pci_config
> - Check for Xen
> - Disable early PCI access from Xen if running unpriviledged and check
>   that in either in *_pci_config or early_init_amd
>
>   

I assume "d375" is a domU.  cpu_has_apic should be false, and this code
shouldn't be running if the CPU has no (visible) apic.

Does this work?  (Completely untested.)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 28e5f59..e2485b0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -356,7 +356,7 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
 	/* check CPU config space for extended APIC ID */
-	if (c->x86 >= 0xf) {
+	if (cpu_has_apic && c->x86 >= 0xf) {
 		unsigned int val;
 		val = read_pci_config(0, 24, 0, 0x68);
 		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))


	J


