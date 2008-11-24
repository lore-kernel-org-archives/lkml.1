Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYKXSIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYKXSIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYKXSIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:08:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYKXSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:08:36 -0500
Message-ID: <492AED4B.30108@zytor.com>
Date: Mon, 24 Nov 2008 10:07:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Jan Beulich <jbeulich@novell.com>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] x86: include ENTRY/END in entry handlers in entry_64.S
References: <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123092136.GC24818@localhost> <20081123112354.GA31667@mailshack.com> <4929B95E.4@zytor.com> <20081124100604.GB8187@mailshack.com>
In-Reply-To: <20081124100604.GB8187@mailshack.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> Hello hpa,
> 
> KPROBE_ENTRY_P5ALIGNED It isn't better, that's the point.
> It's needed, because we have this problem:
> 
> 	.p2align 5
> 	KPROBE_ENTRY(something)
> 		somecode	
> 	KPROBE_END(something)
> 
> This does not align "something", because something is not in the
> same section as the ".p2align 5".
> 

I think that is braindamaged.  If KPROBE_ENTRY() changes the section
behind the programmers back, that's completely and totally stupid in an
utterly reckless sort of way.  The author of a macro like that should be
taken out and shot, because it makes the programmer think the code does
something completely different than what the code actually does.

This isn't merely ugly, it is downright dangerous.

>> For the record, I think we already have way to much macro crappage.  It
>> makes the code painful to read and hard to figure out what the real
>> constraints on it is.
> 
> I agree with that to some point. But even without the macro's, the
> code is hard to read. As an alternative to more macro's, what do you
> think of Cyrills suggestion of putting CFI-annotations next to the
> instuctions, like:
> 
> 	pushq %rax			; CFI_ADJUST_CFA_OFFSET 8
> 	movq %rax, RAX+8(%rsp)		; CFI_REL_OFFSET rax, RAX+8
> 
> instead? That still leaves the problem that the instruction and the
> annotation might not match, but it leaves the code more readable for
> someone who is used to reading x86 assembly.

I think using the macros for opcodes make sense, as the CFI operation is
tied to the operation.  That is a good way to use macros.

	-hpa
