Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZCJPdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZCJPdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZCJPdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:33:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43257 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZCJPdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:33:22 -0400
Date: Tue, 10 Mar 2009 16:32:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: reason for delay in arch/x86/kernel/traps.c::io_check_error()?
Message-ID: <20090310153242.GA23463@elte.hu>
References: <49B56F18.1050904@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B56F18.1050904@nortel.com>
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


* Chris Friesen <cfriesen@nortel.com> wrote:

> Hi all,
>
> I was just wondering about the basis for the delay in 
> io_check_error().  The ICH7 manual doesn't have any mention of 
> a delay being required here--is it necessary for other 
> hardware, something not mentioned in the manual, or just an 
> accident?

That code has seriously bitrotten along the years. All those 
port 61H accesses:

arch/x86/kernel/traps.c:                reason = get_nmi_reason();
arch/x86/kernel/traps.c:        outb(reason, 0x61);
arch/x86/kernel/traps.c:        outb(reason, 0x61);
arch/x86/kernel/traps.c:        outb(reason, 0x61);

... are often wrong on modern chipsets - including the logic in 
io_check_error(). But we dont really have lowlevel chipset 
drivers on this level in Linux, so there's nothing suitable to 
replace it with and it never got fixed.

Can you see this trigger on a box perhaps? Or are you worried 
about the potential unbound execution time of this function 
which can be up to 2 seconds in NMI context?

	Ingo
