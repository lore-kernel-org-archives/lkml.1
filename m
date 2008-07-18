Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYGRH21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYGRH21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYGRH2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:28:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:26751 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYGRH2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FDZt9ExX0nEgjwcQPLOWUnzBlvgucPvxQJb2/+kPMFAnxdADo/hXPGAdXfY7Ui0CdM
         bOiQ+Ge0z+cZDggtoQF715EKXGF66WjjKFjNUQN6mCIrIB+BI6JywCGYNe3WKnToYluJ
         T3FmsPumjf4WUI/LTEix0KvLuphKh0Z1aLIIY=
Message-ID: <19f34abd0807180028y2be61c06ueab5fcc305956f80@mail.gmail.com>
Date: Fri, 18 Jul 2008 09:28:17 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #11035] System hangs on 2.6.26-rc8
Cc: "Roman Mindalev" <lists@r000n.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080718071121.GB6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <uBi7uNfg81L.A.xt.SzLcIB@albercik> <4878D259.7050403@r000n.net>
	 <487CA8E5.8020208@r000n.net> <20080718071121.GB6875@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 9:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Vegard - would it be possible to make DEBUG_PAGEALLOC faults single-shot
> and non-fatal, just like kmemcheck does it? That way people would see a
> nice kernel message instead of an immediate crash. That means we'd have
> to find a reliable filter for DEBUG_PAGEALLOC-provoked pagefaults though
> ...

Hm.. Yes, we could do it in a similar fashion using single-stepping.
It should take little effort; we already have most of the code to do
it; mmiotrace does the same thing too, after all.

These are some considerations:

1. If the page is kernel space but currently unmapped, does it point
to a valid page of RAM even though it is non-present?
2. Should we allow reading/writing of the underlying physical page (if
it exists), or should we prevent writes (i.e. allow the instruction to
proceed, but don't really write anything) and reads (i.e. allow the
instruction to read 0 or another magic number).

For the filter you mentioned, we could perhaps use one more bit in the
PTE. This is what we do for kmemcheck, and IIRC DEBUG_PAGEALLOC is
incompatible with kmemcheck anyway (I don't remember why exactly), so
we could reuse the same bit.

BTW, I didn't consider that argument (of continuing as far as
possible) before, but it's a good one; if we don't crash completely,
the user can still copy the log we have a better report of it. I guess
kerneloops.org is currently missing out a great deal of reports which
all shut down the machine immediately without a chance to go into the
log.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
