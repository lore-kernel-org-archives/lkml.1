Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYKXKKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYKXKKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYKXKKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:10:24 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:19006 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYKXKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:10:23 -0500
Date: Mon, 24 Nov 2008 11:06:05 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Jan Beulich <jbeulich@novell.com>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] x86: include ENTRY/END in entry handlers in entry_64.S
Message-ID: <20081124100604.GB8187@mailshack.com>
References: <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123092136.GC24818@localhost> <20081123112354.GA31667@mailshack.com> <4929B95E.4@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4929B95E.4@zytor.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Mon, 24 Nov 2008 11:07:58 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.126; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 12:13:18PM -0800, H. Peter Anvin wrote:
> Alexander van Heukelum wrote:
> > 
> > I put a ".p2align 5" in earlier in the series which caused the
> > apicinterrupts to be 32-byte aligned. But it is a hack, really,
> > relying on the generated code per stub to be between 17 and 32
> > bytes, on the default alignment to be 16 bytes and all stubs
> > to be in the .text section.
> > 
> > I'm in favour of aligning all of the interrupt/exception stubs
> > to 32 bytes, but it should be implemented the right way ;),
> > which means that we need KPROBE_ENTRY_P5ALIGNED and so on :-/.
> > 
> 
> I'm sorry, I really don't follow that logic at all.  Why the heck would
> KPROBE_ENTRY_P5ALIGNED be better than .p5align?

Hello hpa,

KPROBE_ENTRY_P5ALIGNED It isn't better, that's the point.
It's needed, because we have this problem:

	.p2align 5
	KPROBE_ENTRY(something)
		somecode	
	KPROBE_END(something)

This does not align "something", because something is not in the
same section as the ".p2align 5".

> For the record, I think we already have way to much macro crappage.  It
> makes the code painful to read and hard to figure out what the real
> constraints on it is.

I agree with that to some point. But even without the macro's, the
code is hard to read. As an alternative to more macro's, what do you
think of Cyrills suggestion of putting CFI-annotations next to the
instuctions, like:

	pushq %rax			; CFI_ADJUST_CFA_OFFSET 8
	movq %rax, RAX+8(%rsp)		; CFI_REL_OFFSET rax, RAX+8

instead? That still leaves the problem that the instruction and the
annotation might not match, but it leaves the code more readable for
someone who is used to reading x86 assembly.

Greetings,
	Alexander

> 	-hpa
