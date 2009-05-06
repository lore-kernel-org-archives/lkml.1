Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbZEFApl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbZEFApl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZEFApc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:45:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:62192 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbZEFApb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:45:31 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	<d6200be20905051358m34c2be02ped84ad4158cd9865@mail.gmail.com>
	<87eiv35eg6.fsf@deeprootsystems.com> <200905060127.24777.rjw@sisk.pl>
	<87y6tb3x6r.fsf@deeprootsystems.com>
	<878wlb3w18.fsf@deeprootsystems.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 05 May 2009 17:45:29 -0700
In-Reply-To: <878wlb3w18.fsf@deeprootsystems.com> (Kevin Hilman's message of "Tue\, 05 May 2009 17\:38\:43 -0700")
Message-ID: <873abj3vpy.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman <khilman@deeprootsystems.com> writes:

> Kevin Hilman <khilman@deeprootsystems.com> writes:
>
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>
>>> On Wednesday 06 May 2009, Kevin Hilman wrote:
>>>> Arve Hjønnevåg <arve@android.com> writes:
>>>> 
>>>> > On Tue, May 5, 2009 at 8:52 AM, Kevin Hilman
>>>> > <khilman@deeprootsystems.com> wrote:
>>>> >> Andrew Morton <akpm@linux-foundation.org> writes:
>>>> >>
>>>> >>> On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:
>>>> >>>
>>>> >>>> Interrupts that are flagged as wakeup sources via set_irq_wake()
>>>> >>>> should not be disabled for suspend.
>>>> >>>>
>>>> >>>
>>>> >>> Why not?
>>>> >>>
>>>> >>
>>>> >> If an interrupt is a wakeup source, and it is disabled at the chip
>>>> >> level, it will no longer generate interrupts, and thus no longer wake
>>>> >> up the system.
>>>> >>
>>>> >> I'd be interested in hearing why wakeup interrupts should be disabled
>>>> >> during suspend.
>>>
>>> That depends on whether or not they are used for anything else than wake-up.
>>>
>>>> 
>>>> [...]
>>>> 
>>>> >>>
>>>> >>> If this fixes some bug then please provide a description of that bug?
>>>> >>
>>>> >> The bug is that on TI OMAP, interrupts that are used for wakeup events
>>>> >> are disabled by this code causing the system to no longer wake up.
>>>> >
>>>> > What do you do if the interrupt triggers right after your driver has
>>>> > returned from its late suspend hook?  
>>>> 
>>>> If it's a wakeup IRQ, I assume you want it to prevent suspend.
>>>> 
>>>> But I don't see how that can happen in the current code. IIUC, by the
>>>> time your late suspend hook is run, your device IRQ is already
>>>> disabled, so it won't trigger an interrupt that will be caught by
>>>> check_wakeup_irqs() anyways.
>>>
>>> My understanding of __disable_irq() was that it didn't actually disable the
>>> IRQ at the hardware level, allowing the CPU to actually receive the interrupt
>>> and acknowledge it, but preventing the device driver for receiving it.  
>>
>> Hmm, that's not normally what I think of as disabled.  ;)
>>
>>> Does it work differently on the affected systems?
>>
>> Yes.
>>
>> __disable_irq() calls the irq_chip's disable method which is platform
>> specific.  On OMAP, this masks the IRQ at the hardware level
>> preventing the CPU from seeing the interrupt.
>
> So just as a test, I just removed the 'disable' hook from my platforms
> irq_chip and this allows me to wakeup without using my proposed patch,
> although I'm not sure it is the right behavior either.
>
> The 'struct irq_chip' comments are a bit misleading here as it says
>
>  * @disable:		disable the interrupt (defaults to chip->mask if NULL)
>
> And since my irq_chip->disable was doing basically the same thing as
> my irq_chip->mask, I didn't expect it to change behavior.  But in
> kernel/irq/chip.c, disable gets set to an empty default_disable if the
> irq_chip's version is NULL.
>
> The result is that if irq_chip->disable == NULL, suspend_device_irqs() is a 
> big NOP, albiet one that does lots of locking. :)
>
> So, should the irq_chip code be fixed to match the comment?  Something
> like the patch below?  If I fix the IRQ chip code, then I'm back to
> needing my patch since my irq_chip mask function still masks the IRQ
> at the hardware.

Please ignore my suggested patch.  I just saw Ingo's commit that
modified the default_disable().

Kevin

>
> Kevin
>
>
> commit f9b534f23ac7835eead99fb0a9cec7c505fe1e85
> Author: Kevin Hilman <khilman@deeprootsystems.com>
> Date:   Tue May 5 17:32:59 2009 -0700
>
>     IRQ: chip->disable should default to chip->mask if NULL
>     
>     The struct irq_chip comments in <linux/irq.h> state:
>     
>      * @disable:	disable the interrupt (defaults to chip->mask if NULL)
>     
>     However, the code in kernel/irq/chip.c does otherwise by setting
>     a NULL disable hook to an empty default_disable function.
>     
>     This patch makes the default_disable function call the ->mask hook
>     to match the comments.
>     
>     Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index c687ba4..0fb690a 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -238,6 +238,10 @@ static void default_enable(unsigned int irq)
>   */
>  static void default_disable(unsigned int irq)
>  {
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	desc->chip->mask(irq);
> +	desc->status |= IRQ_MASKED;
>  }
>  
>  /*
