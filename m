Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYLZOfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYLZOfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYLZOfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:35:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43733 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYLZOfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:35:37 -0500
Date: Fri, 26 Dec 2008 15:35:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, jeremy@goop.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] Remove interrupt stack table usage from x86_64
	kernel (v2)
Message-ID: <20081226143517.GA25668@elte.hu>
References: <1230301344-570-1-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230301344-570-1-git-send-email-avi@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> The interrupt stack table (IST) mechanism is the only thing preventing
> kvm from deferring saving and reloading of some significant state.  It
> is also somewhat complicated.
> 
> Remove it by switching the special exceptions to use the normal irqstack.
> 
> Changes from v1:
> - rebase on tip/master
> - as a step, consolidate stack switching into a single macro
> 
> Jeremy, Xen is also affected; please review.
> 
> Avi Kivity (4):
>   x86: drop the use of the tss interrupt stack table (IST)
>   x86: Consolidate irq stack switching to a single macro
>   x86: Make interrupt stack switching atomic
>   x86: Move NMI back to interrupt stack
> 
>  arch/x86/include/asm/desc.h      |   12 -----
>  arch/x86/include/asm/page_64.h   |    7 ---
>  arch/x86/include/asm/pda.h       |    2 +-
>  arch/x86/include/asm/processor.h |   11 ----
>  arch/x86/kernel/asm-offsets_64.c |    1 -
>  arch/x86/kernel/cpu/common.c     |   35 --------------
>  arch/x86/kernel/dumpstack_64.c   |   96 --------------------------------------
>  arch/x86/kernel/entry_64.S       |   89 ++++++++++-------------------------
>  arch/x86/kernel/traps.c          |   12 ++--
>  9 files changed, 33 insertions(+), 232 deletions(-)

applied to tip/x86/irq, thanks Avi!

They have the following commit IDs, and they are also in tip/master:

 921e521: x86: move NMI back to interrupt stack
 36ef6c9: x86: make interrupt stack switching atomic
 dd64891: x86: consolidate irq stack switching to a single macro
 955a368: x86: drop the use of the tss interrupt stack table (IST)

I also started testing them in tip-qa.

I added the standard Impact-lines that we do in the x86 tree. Note that 
this patch:

 dd64891: x86: consolidate irq stack switching to a single macro

isnt just consolidating IRQ entry assembly code, it is also changing the 
paranoidentry macros to do IRQ stack entries - and hence switches all but 
the NMI critical exception entries sequences over to the IRQ stack. Your 
later patch:

 921e521: x86: move NMI back to interrupt stack

covers the NMI entry code too.

Please double-check that we indeed now have all the critical exceptions on 
the IRQ stack (they are all rare so testing alone wont show this), and 
please also double-check that we dont have more exceptions and entry 
callpaths on the IRQ stack than what we wanted. For example on a 
preemptible kernel (or in any codepath that calls schedule()) it is fatal 
to be on the IRQ stack, so this has to be very accurately coded.

	Ingo
