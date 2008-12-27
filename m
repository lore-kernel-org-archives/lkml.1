Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYL0WvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYL0WvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 17:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbYL0WvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 17:51:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbYL0WvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 17:51:11 -0500
Date: Sat, 27 Dec 2008 23:51:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
Message-ID: <20081227225102.GA17822@elte.hu>
References: <20081227155019.GA15493@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227155019.GA15493@elte.hu>
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


[ resend - i have restored the Cc: list ]

* Andi Kleen <ak@linux.intel.com> wrote:

>> We really need to get rid of /dev/mcelog. It's a quirky binary logging 
>> facility not available on 32-bit on current kernels and it has a couple 
>> of limitations:
>
> It's a bit more complicated than it looks first. I'm not in principle 
> opposed to an ASCII interface, but there are some complications in 
> practice. I'll write up all the details tomorrow too
>
> (just some quick comments below, but there's more to it)
>
>> A far more useful design for handling MCE events would be to feed them 
>> into printk logging.
>
> If there's ASCII logging it should be separate from normal printk.

Well, why? Sure, MCE exceptions themselves cannot generally printk 
[because they are in essence non-maskable contexts] unless they get a 
fatal MCE [in which case we have no other choice but to try to printk and 
hope for the best]. But they can sprintf into a buffer which then gets 
printk-d (or passed to whatever ASCII based facility).

'struct mce' is pointless complexity and a pointless restriction - and so 
is /dev/mcelog.

> I started that originally because I was sick of machine checks getting 
> reported as kernel bugs, and I got a lot of feedback over the years that 
> people like that.  Later on it turned out there are more good reasons to 
> separate logging.

Hm, such as? Right now i see mcelog as a facility that gets used only in 
the rarest of circumstances. 99% of the time mcelog is just used in mcelog 
--ascii mode to decode something quirky that the kernel could have (and 
should have) printed out in a much more human-accessible format.

>> So instead of printing such rather cryptic error messages:
>>
>>    MCE 0
>>    HARDWARE ERROR. This is *NOT* a software problem!
>>    Please contact your hardware vendor
>>    CPU 0 BANK 6 MISC 202d ADDR ffeef740
>>    This is not a software problem!
>>    Run through mcelog --ascii to decode and contact your hardware vendor
>>
>> and expecting people to run mcelog, we should print plain-text 
>> something like:
>>
>>    MCE 0
>>    HARDWARE ERROR. This is *NOT* a software problem!
>>    Please contact your hardware vendor
>>    CPU 1 4 northbridge TSC 89a560bb249
>>    ADDR 1dfa49690
>>      Northbridge Chipkill ECC error
>
> It turns out that users don't really find this more enlightening (most 
> users have no clue what a Northbridge is).  They think it's some kind of 
> kernel bug even with the HARDWARE ERROR header.

You should not assume that administrators/users reading kernel crash 
messages are dumb. (an ordinary user wont see it most of the time anyway) 

The usage patterns i see is that admins who get an MCE crash often fail to 
write down the whole MCE message (not realizing that it is important) and 
have to go back and reproduce the MCE crash once again before they can get 
any meaningful information.

Printing out cryptic hexadecimal error codes, requiring people to write 
them down and decode them in user-space is the technology of the 80s - i 
didnt think i'd have to argue too much about this ;-)

Reducing the amount of information presented to the user in such a crash 
situation is a dumb idea. (especially here where the MCE information is 
rather dense and single-screen anyway - so there's no screen real estate 
considerations.)

> The only people who really care about the micro architectural details in 
> full are chip developers, and those typically decode using other methods 
> anyways.

People do care about getting meaningful crash information from the kernel. 
That's why we by default print out something like:

Call Trace:
 [<c013463d>] warn_slowpath+0x6d/0x90
 [<c07a03fb>] ? _spin_lock_irqsave+0x1b/0x60
 [<c07a07fc>] ? _spin_unlock_irqrestore+0x3c/0x60
 [<c07a07fc>] ? _spin_unlock_irqrestore+0x3c/0x60
 [<c015547b>] ? trace_hardirqs_off+0xb/0x10
 [<c079e77c>] ? __mutex_unlock_slowpath+0x9c/0x170
 [<c015fc1c>] smp_call_function_mask+0x1ac/0x1c0

and not:

Call Trace:
 [<c013463d>]
 [<c07a03fb>]
 [<c07a07fc>]
 [<c07a07fc>]
 [<c015547b>]
 [<c079e77c>]
 [<c015fc1c>]

This is a basic principle in the Linux kernel. We try to print out as 
useful information as possible - and only cut down on it if the 
information physically does not fit on the screen. (which is not a problem 
here)

	Ingo
