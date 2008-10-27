Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbYJ0K4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbYJ0K4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYJ0K4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:56:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56117 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbYJ0K4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:56:13 -0400
Date: Mon, 27 Oct 2008 11:55:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Damato <ice799@gmail.com>
Cc: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 00/12] x86: Cleanup idt, gdt/ldt/tss structs
Message-ID: <20081027105559.GA13895@elte.hu>
References: <1224904532-9586-1-git-send-email-ice799@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224904532-9586-1-git-send-email-ice799@gmail.com>
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


* Joe Damato <ice799@gmail.com> wrote:

> Hi -
> 
> This is my first submission to the kernel, so (beware!) please let 
> me know if I can make any improvements on these patches.
> 
> I attempted to clean up the x86 structs for 32bit cpus that store 
> IDT/LDT/GDT data by removing the fields labeled "a" and "b" in favor 
> of more descriptive field names. I added some macros and went 
> through the kernel cleaning up the various places where "a" and "b" 
> were used.
> 
> I tried building my kernel with my .config and then also did a make 
> allyesconfig build to help ensure I found everything that was using 
> the old structure names. I also tried a few grep patterns. Hopefully 
> I got everyone out.

hm, a couple of comments.

Firstly, a patch logistical one: we moved all the x86 header files 
from include/asm-x86/ to arch/x86/include/asm/ in v2.6.28-rc1 - your 
patchset is against an older kernel. Should be easy enough to fix up.

Secondly, i'm not that convinced about the expanded use of bitfields 
that your patchset implements. Their semantics are notoriously fragile 
so we'd rather get _away_ from them, not expand them. _But_, this area 
could be cleaned up some more - just in a different way. I'd suggest 
you introduce field accessor inline functions to descriptors.

I.e. instead of:

        if (!idt_present(cpu->arch.idt[num].a, cpu->arch.idt[num].b))

we could do a more compact form:

	if (!idt_present(cpu->arch.idt + num))

and get away from the open-coded use of desc->a and desc->b fields, 
with proper inlined helpers.

Small detail, the syntactic form you chose:

+       if (!cpu->arch.idt[num].p)

is not very readable because it's not obvious at first sight that ".p" 
intends to mean "present bit". If then idt[num].present would have 
been the better choice - but it's even better to not do bitfields at 
all but an idt_present(desc *) helper inline function.

Thirdly, as you can see it form my comments, this is not something 
that is really a best choice for a newbie, as it's a wide patchset 
that impacts a lot of critical code, wich has very high quality 
requirements.

But if you dont mind having to go through a couple of iterations to 
get it right (with the inevitable feeling of ftrustration about such a 
difficult process) then sure, feel free to work on this!

	Ingo
