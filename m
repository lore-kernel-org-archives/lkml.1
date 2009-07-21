Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZGUKnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZGUKnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZGUKnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:43:19 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:60352 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZGUKnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:43:18 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 06:43:18 EDT
Date: Tue, 21 Jul 2009 12:36:42 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: detect use of extended APIC ID for AMD CPUs
Message-ID: <20090721103642.GA10071@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	xen-devel@lists.xensource.com,
	Jeremy Fitzhardinge <jeremy@goop.org>
References: <20090604104016.GT5736@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090604104016.GT5736@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:40:16PM +0200, Andreas Herrmann wrote:
> Booting a 32-bit kernel on Magny-Cours results in the following panic

This patch breaks Xen really bad. It uses read_pci_config without
knowing that there is something accessible. Also read_pci_config does
not define fault handlers.

| (XEN) traps.c:413:d375 Unhandled general protection fault fault/trap [#13] on VCPU 0 [ec=0000]
| (XEN) domain_crash_sync called from entry.S
| (XEN) Domain 375 (vcpu#0) crashed on cpu#1:
| (XEN) ----[ Xen-3.2-1  x86_64  debug=n  Not tainted ]----
| (XEN) CPU:    1
| (XEN) RIP:    e033:[<ffffffff80401d6b>]
| (XEN) RFLAGS: 0000000000000282   CONTEXT: guest
| (XEN) rax: 000000008000c068   rbx: ffffffff80618a40   rcx: 0000000000000068
| (XEN) rdx: 0000000000000cf8   rsi: 000000000000c000   rdi: 0000000000000000
| (XEN) rbp: 0000000000000018   rsp: ffffffff80621eb0   r8:  ffffffff80621efc
| (XEN) r9:  00000000ffffffff   r10: ffffffff80621ef8   r11: 00000000ffffffff
| (XEN) r12: ffffffffffffffff   r13: ffffffff80621fd8   r14: 0000002040404030
| (XEN) r15: 00000000015bb600   cr0: 000000008005003b   cr4: 00000000000006f0
| (XEN) cr3: 00000002077be000   cr2: 000000204316b000
| (XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
| (XEN) Guest stack trace from rsp=ffffffff80621eb0:
| (XEN)    0000000000000068 00000000ffffffff 0000000000000000 ffffffff80401d6b
| (XEN)    000000010000e030 0000000000010082 ffffffff80621ef0 000000000000e02b
| (XEN)    ffffffff804aeb3a 0000000100000000 0000302800000000 ffffffff805bcb20
| (XEN)    ffffffff80651552 0000000000000000 0000000000000000 0000000000fdfd88
| (XEN)    ffffffff8064e47c 0000000001fb9000 ffffffff80545875 0000000000000800
| (XEN)    0000000000002c00 ffffffff81fb9000 ffffffff80650026 ffffffff805ca1c0

| ffffffff80401d44 T read_pci_config
| ffffffff804aeb41 t early_init_amd

I see several ways to fix this:
- Define fault handlers for *_pci_config
- Check for Xen
- Disable early PCI access from Xen if running unpriviledged and check
  that in either in *_pci_config or early_init_amd

Bastian

-- 
Insults are effective only where emotion is present.
		-- Spock, "Who Mourns for Adonais?"  stardate 3468.1
