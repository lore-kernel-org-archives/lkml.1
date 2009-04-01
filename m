Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbZDAQjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbZDAQjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZDAQjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:39:01 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:52699 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbZDAQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lggfANw/PZsFmRxUNr5/XrtAa4YN5/IUVRQ5t9xuVidivY5bpo9zDxBbkFvCcrOHsr
         1xjrzCNN/l2JD1j4xBrBJeZ4QYJMSqso4J3PVZFhgJMpCbaVmyNrS5rP2AV9fA6p9SOJ
         qYiSxk0hQ9PVtGusqXMD8rTHfWKZaNcvUW3mM=
Date: Wed, 1 Apr 2009 20:40:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 4/6] x86: irqinit - merge native_init_IRQ
Message-ID: <20090401164001.GE15781@localhost>
References: <20090329201545.470255691@openvz.org> <20090329202208.155551990@openvz.org> <20090401145328.GB6196@elte.hu> <20090401161609.GD15781@localhost> <20090401162250.GA22517@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401162250.GA22517@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Apr 01, 2009 at 06:22:50PM +0200]
...
| > I just remember -- I thought about that and since 
| > x86_quirk_pre_intr_init described as external BUT implemented for 
| > x86-32 only I needed to indroduce new x86-64 versions for this 
| > (and since I know that there no need to do anything else except 
| > calling init_ISA_irqs I desided to have separate wrapper for 
| > that).
| > 
| > And btw x86-32 already has init_ISA_irqs call and quirks are used 
| > in x86-32 mode only so for 64bit it will be just a not needed 
| > check. Which means - I could just use original 
| > x86_quirk_pre_intr_init function which will call all I need.
| > 
| > Or you meant something else?
| 
| The typical solution there is to make the entry NULL in the 64-bit 
| case. All the quirk handlers are conditional like this:
| 
| arch/x86/kernel/mpparse.c:      if (x86_quirks->mpc_apic_id)
| arch/x86/kernel/mpparse.c:              apicid = x86_quirks->mpc_apic_id(m);
| 
| or am i missing something?
| 
| 	Ingo
| 

The problem is that 

	x86_quirk_pre_intr_init
	x86_quirk_intr_init
	...

are guarded by CONFIG_X86_32. So I thought
to call x86_quirk_pre_intr_init which is implemented
as following

void __init x86_quirk_pre_intr_init(void)
{
	if (x86_quirks->arch_pre_intr_init) {
		if (x86_quirks->arch_pre_intr_init())
			return;
	}
	init_ISA_irqs();
}

-- it will call init_ISA_irqs for us. But as I said
it's bound by CONFIG_X86_32. So we could remove this
limitation and use these function on x86-64 as well
and don't call for x86_quirks->arch_pre_intr_init.

The only reason I didn't do that -- we test
if x86_quirks->arch_pre_intr_init is defined for
nothing -- it's always NULL on x86-64.

Another reason for that -- irqinit_32.c calls for
x86_quirk_pre_intr_init and using the same name
for x86-64 will make code a bit cleaner I believe.

Maybe I better post a patch for review -- it'll
say more then me with my english :) ?

        Cyrill
