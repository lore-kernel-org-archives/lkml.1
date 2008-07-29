Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbYG2UXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbYG2UXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYG2UW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:22:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36016 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYG2UWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:22:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, "Mike Travis" <travis@sgi.com>
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
Date: Tue, 29 Jul 2008 13:14:08 -0700
In-Reply-To: <86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	(Yinghai Lu's message of "Tue, 29 Jul 2008 12:20:01 -0700")
Message-ID: <m1d4kwbg8f.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2601]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Tue, Jul 29, 2008 at 11:35 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Tue, Jul 29, 2008 at 9:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com>
> wrote:
>>> Hi Ingo, Thomas,
>>>
>>> Hit this on 2.6.27-rc1
>>>
>>> (The kernel bug is at line 356 (Its 357 as I applied a debug patch to
>>> print out the irq) (Full dmesg and .config attached)
>>
>> can you boot with "debug apic=verbose pci=routeirq"?
>
> please try attached patch

Ugh. Yuck bleh nasty gag.

Yes please try the YH's patch that should fix the worst of the
problem.

YH I think you have hit the root cause of the bug with NR_IRQS being
defined a ridiculously low value on x86_64.  At first glance your
patch looks reasonable, I had to stop and look why it was needed.  At
second glance it looks like it doesn't go far enough.

The commit that unified interrupt vector defines appears substantially
fumbled.  YH your description of why your patch is needed is not
especially useful.

To be perfectly clear.  The maximum number of interrupts we can handle is:
NR_CPUS*NR_VECTORS.  Defining NR_IRQS to a lower value is essentially a
hack to allows us to use less memory as we seldom push that limit.

Further the only valid definition of NR_IRQ_VECTORS is NR_IRQS
as we index it by irq.  Which really means now that we are unifying
the code we should simply kill NR_IRQ_VECTORS.

I expect there is a lot more in that mess that can be cleaned up.
Right now irq_vectors.h reads like nonsense to me.  I will see if
I can find some time soon to look into what we should be doing.

Increasing the size of the next field in the irq_pin_list is a good
idea.  Frankly I think we never use the next field (especially on
x86_64 and should just remove it) but I have not been brave enough
to try.

commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri May 2 20:10:09 2008 +0200

    x86: unify interrupt vector defines
    
    The interrupt vector defines are copied 4 times around with minimal
    differences. Move them all into asm-x86/irq_vectors.h
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

> [PATCH] x86: 64bit support more than 256 irq
>
> because 64bit allow same vector for different cpu to serve different irq
>
> also change next in irq_pin_list from short to next. because for 4096 NR_IRQS
> is 2^(5+12)+224.
>
> need to create that array dynamically later
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> ---
>  arch/x86/kernel/io_apic_64.c  |    3 ++-
>  include/asm-x86/irq_vectors.h |    6 +++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/include/asm-x86/irq_vectors.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/irq_vectors.h
> +++ linux-2.6/include/asm-x86/irq_vectors.h
> @@ -113,9 +113,13 @@
>  
>  # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) ||
> defined(CONFIG_X86_VISWS)/include/asm-x86/irq_vectors.h
>  
> +#ifdef CONFIG_X86_64
> +#  define NR_IRQS		(32 * NR_CPUS + 224)
> +#else
>  #  define NR_IRQS		224
> +#endif
>  
> -#  if (224 >= 32 * NR_CPUS)
> +#  if (NR_IRQS >= 32 * NR_CPUS)
>  #   define NR_IRQ_VECTORS	NR_IRQS
>  #  else
>  #   define NR_IRQ_VECTORS	(32 * NR_CPUS)
> Index: linux-2.6/arch/x86/kernel/io_apic_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
> +++ linux-2.6/arch/x86/kernel/io_apic_64.c
> @@ -140,7 +140,8 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BU
>   */
>  
>  static struct irq_pin_list {
> -	short apic, pin, next;
> +	short apic, pin;
> +	int next;
>  } irq_2_pin[PIN_MAP_SIZE];
>  
>  struct io_apic {
