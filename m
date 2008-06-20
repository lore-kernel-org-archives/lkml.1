Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYFTSaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYFTSaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYFTSaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:30:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36201 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750931AbYFTSaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:30:22 -0400
Message-ID: <485BF73C.7010802@sgi.com>
Date: Fri, 20 Jun 2008 11:30:20 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org> <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 20 Jun 2008, Jeremy Fitzhardinge wrote:
> 
>> So it seems the problem is that the pre-initialized gdt_page is being lost and
>> replaced with zero.  Linker script bug?
> 
> Is the pre initialized gdt page in the per cpu area? Does not look like 
> it. The loader setup for the percpu section changes with zero basing. 
> Maybe that has bad side effects?

Yes, it is... The fixup logic is this:

0000000000004000 D per_cpu__gdt_page
ffffffff81911000 A __per_cpu_load

arch/x86/kernel/cpu/common.c:

DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
        [GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
...


arch/x86/kernel/head_64.S:

startup_64:
...
       /*
         * Fix up per_cpu__gdt_page offset when basing percpu
         * variables at zero.  This is only needed for the boot cpu.
         */
        addq    $__per_cpu_load, early_gdt_descr_base(%rip)

ENTRY(secondary_startup_64)
...
        /*
         * We must switch to a new descriptor in kernel space for the GDT
         * because soon the kernel won't have access anymore to the userspace
         * addresses where we're currently running on. We have to do that here
         * because in 32bit we couldn't load a 64bit linear address.
         */
        lgdt    early_gdt_descr(%rip)
...
        .globl early_gdt_descr
early_gdt_descr:
        .word   GDT_ENTRIES*8-1
early_gdt_descr_base:
        .quad   per_cpu__gdt_page

