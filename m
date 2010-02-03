Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab0BCKdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 05:33:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:41627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080Ab0BCKdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 05:33:43 -0500
Message-ID: <4B6950B2.9060301@kernel.org>
Date: Wed, 03 Feb 2010 02:32:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Brandon Philips <bphilips@suse.de>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       YinghaiLu@suse.de, Suresh Siddha <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       stable <stable@kernel.org>
Subject: Re: x86: fix race in create_irq_nr on irq_desc
References: <20100203033109.GA17985@jenkins.home.ifup.org>
In-Reply-To: <20100203033109.GA17985@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2010 07:31 PM, Brandon Philips wrote:
> Race in create_irq_nr():
> 
> - Thread 1 loops through and calls irq_to_desc_alloc_node with new=0x66.
> 
> - Thread 2 has exited the loop with irq=0x66 and calls dynamic_irq_init(0x66)
>   setting desc->chip_data = NULL
> 
> - Thread 1 then dereferences NULL via desc_new->chip_data->vector
> 
> Fix by moving holding vector_lock until after the dynamic_irq_init().
> 
> 
> Index: linux-2.6.32-SLE11-SP1/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.32-SLE11-SP1.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6.32-SLE11-SP1/arch/x86/kernel/apic/io_apic.c

can you check if 

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=37ef2a3029fde884808ff1b369677abc7dd9a79a

fix your problem with 2.6.32?

>From 37ef2a3029fde884808ff1b369677abc7dd9a79a Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Sat, 21 Nov 2009 00:23:37 -0800
Subject: [PATCH] x86: Re-get cfg_new in case reuse/move irq_desc

When irq_desc is moved, we need to make sure to use the right cfg_new.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B07A739.3030104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ff23719..085e60e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3186,6 +3186,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 			continue;
 
 		desc_new = move_irq_desc(desc_new, node);
+		cfg_new = desc_new->chip_data;
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
-- 
1.6.6.1

