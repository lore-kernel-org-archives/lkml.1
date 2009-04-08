Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbZDHQVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbZDHQVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZDHQVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:21:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:9655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbZDHQVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V+5pNnepPzwbJhiamv/CeXMFlF2fwX3r3K5BnDztUqDiEqbnR69FofrQOJF9c5GUcD
         8vOZpw0p/aIuW8/i/0t97EgOsdvFCjDZbrfuC89yULhC6551iWpALNpQxjRmV8UALZ1Y
         W4QN0XXk3pn3WSuOOanbmXaO73tBM5bhQQ3H4=
Date: Wed, 8 Apr 2009 20:21:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -tip] x86: do_IRQ - send EOI for x86-32 on irq without
	handler v2
Message-ID: <20090408162101.GD7556@lenovo>
References: <20090408145017.GB7556@lenovo> <20090408145218.GM12931@elte.hu> <20090408154558.GC7556@lenovo> <20090408155500.GD3741@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408155500.GD3741@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Apr 08, 2009 at 05:55:00PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Ingo Molnar - Wed, Apr 08, 2009 at 04:52:18PM +0200]
| > | 
| > | * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| > | 
| > | > Ingo, I think introducing additional dummy here would be a bit 
| > | > expencive -- a number of callers of ack_APIC_irq just should not 
| > | > check for disable_apic since it's not needed. disable_apic is to 
| > | > depend on CONFIG_X86_LOCAL_APIC rather then CONFIG_X86_64 
| > | > actually. So make it then. Or you mean something else? Like new 
| > | > apic->write_eoi operation? (I'm a bit tired so brain is a half 
| > | > functional now :)
| > | 
| > | no, i meant a dummy apic->write() method in the !apic case. Check 
| > | what ack_APIC_irq() does internally.
| > | 
| > | 	Ingo
| > |
| > 
| > Of course I saw how ack_APIC_irq implemented :) It's already guarded
| > by CONFIG_X86_LOCAL_APIC and I could just move check for disable_apic
| > right here (ie it could be like
| > 
| > static inline void ack_APIC_irq(void)
| > {
| > #ifdef CONFIG_X86_LOCAL_APIC
| > 	/*
| > 	 * ack_APIC_irq() actually gets compiled as a single instruction
| > 	 * ... yummie.
| > 	 */
| > 
| > 	if (!disable_apic)
| > 		/* Docs say use 0 for future compatibility */
| > 		apic_write(APIC_EOI, 0);
| > #endif
| > }
| > 
| > but what is bothering me is that a number of ack_APIC_irq callers
| > will pass execution with always disable_apic=0 and as result
| > this checking would be just spedning cycles for free.
| > 
| > So Ingo, it seems I miss something on what you mean. apic->write 
| > is already called only for CONFIG_X86_LOCAL_APIC here as well and 
| > the arguable point is where to check for disable_apic variable. 
| > But do_IRQ is a special case (wrt to say smp_apic_timer_interrupt 
| > or setup_local_APIC. I mean as example -- setup_local_APIC is not 
| > even called for disable_apic=1).
| > 
| > /me: scratching the head heavily
| 
| You should look into how apic_write() is implemented. It is a call 
| to apic->write().
| 
| So my suggestion is that you could implement a freely callable 
| ack_APIC_irq() by replacing the apic->write() method with a NOP 
| method in the apic-disabled case.
| 
| Does that sound good to you?
| 
| 	Ingo
|

Ah, Ingo, now I see what you mean :)

You should only say me like -- implement dynamic apic->write
depending on disabled_apic, now it's clear :-)

Will do.
 
        Cyrill
