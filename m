Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYHMRfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYHMRfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYHMRfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:35:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40399 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYHMRfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:35:36 -0400
Date: Wed, 13 Aug 2008 19:35:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
Message-ID: <20080813173507.GA30911@elte.hu>
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813164728.GD5720@elte.hu> <48A31188.4050904@zytor.com> <20080813170133.GA16557@elte.hu> <48A319AB.9030707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A319AB.9030707@zytor.com>
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
>>>>
>>> Spurious interrupt of what kind?  The only things that could come in  
>>> would not be non-INT type interrupts, and those aren't affected by  
>>> CLI.
>>
>> nothing should come in really at that point - but say IRQ#7 on older  
>> platforms used to trigger at various points in time, even unprompted. 
>> Or an APIC error interrupt in the last moment? All device irqs should  
>> indeed be turned off at this stage, but since it costs us nothing to 
>> add another cli, and because the failure mode is subtle memory 
>> corruption, does it hurt to have it?
>>
>
> Not significantly, but I cannot for my life figure out how it could 
> help.
>
> Either the interrupts will be blocked by the CLI already in effect, or 
> the additional CLI will not help, either (in fact, it will just 
> slightly increase the window for something like that to slip in.)

ah, the main point i tried to make was to have the CLI _before_ the 
WBINVD - which Mark's patch didnt do.

Note the original sequence:

        wbinvd();
        mb();
        /* Ack it */
        __get_cpu_var(cpu_state) = CPU_DEAD;

        /*
         * With physical CPU hotplug, we should halt the cpu
         */
        local_irq_disable();

and Mark's patched sequence:

        wbinvd();
        local_irq_disable();
        while (1)
                halt();
 
both had wbinvd before the cli.

in my suggestion the second cli doesnt matter indeed - a single one 
suffices.

	Ingo
