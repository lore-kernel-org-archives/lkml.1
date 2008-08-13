Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYHMRB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYHMRB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYHMRBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:01:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYHMRBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:01:47 -0400
Date: Wed, 13 Aug 2008 19:01:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
Message-ID: <20080813170133.GA16557@elte.hu>
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813164728.GD5720@elte.hu> <48A31188.4050904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A31188.4050904@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>>
>> also, we might be safer if the wbinvd(), the CLI and the halt was in a  
>> single assembly sequence:
>>
>> 	if (cpu >= i486)
>> 		asm ("cli; wbinvd; cli; 1: hlt; jmp 1b")
>> 	else
>> 		asm ("cli; 1: hlt; jmp 1b")
>>
>> to make sure the compiler doesnt ever insert something into this  
>> codepath? [ And note the double cli which would be further  
>> robustification - in theory we could get a spurious interrupt straight  
>> after the wbinvd. ] Hm?
>>
>
> Spurious interrupt of what kind?  The only things that could come in 
> would not be non-INT type interrupts, and those aren't affected by 
> CLI.

nothing should come in really at that point - but say IRQ#7 on older 
platforms used to trigger at various points in time, even unprompted. Or 
an APIC error interrupt in the last moment? All device irqs should 
indeed be turned off at this stage, but since it costs us nothing to add 
another cli, and because the failure mode is subtle memory corruption, 
does it hurt to have it?

	Ingo
