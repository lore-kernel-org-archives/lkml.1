Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbYG2WRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbYG2WRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYG2WRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:17:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51072 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbYG2WRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:17:04 -0400
Message-ID: <488F96DD.6020505@sgi.com>
Date: Tue, 29 Jul 2008 15:17:01 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, Cliff Wickman <cpw@sgi.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
References: <20080729160939.GA4484@linux.vnet.ibm.com>	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com> <m1d4kwbg8f.fsf@frodo.ebiederm.org>
In-Reply-To: <m1d4kwbg8f.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> 
>> On Tue, Jul 29, 2008 at 11:35 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>> On Tue, Jul 29, 2008 at 9:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com>
>> wrote:
>>>> Hi Ingo, Thomas,
>>>>
>>>> Hit this on 2.6.27-rc1
>>>>
>>>> (The kernel bug is at line 356 (Its 357 as I applied a debug patch to
>>>> print out the irq) (Full dmesg and .config attached)
>>> can you boot with "debug apic=verbose pci=routeirq"?
>> please try attached patch

I didn't follow this from the start but one reason why NR_IRQS based on
NR_CPUS is a bad idea, is the huge (nearly 300Mb) increase in memory usage
(that's mostly wasted.)  I believe there's another patch coming real soon
now to make irq allocations dynamic.  (I had also hoped to look closer at
your irq abstraction patch you sent a while back.  Does that also address
this issue?)

But this would be a show stopper for SGI being able to ship systems if the
distros do not want to waste this much memory and won't set NR_CPUS=4096.

Thanks,
Mike

====== Data (-l 500)

    1 - 4k-defconfig
    2 - 4k-defconfig-tmp (has this patch)

     .1.         .2.    ..final..
  258048  +150994944 151252992 +58514%  irq_desc(.data.cacheline_aligned)
  231168  +135266304 135497472 +58514%  irq_cfg(.data.read_mostly)
    3584    +2097152   2100736 +58514%  irq_lists(.bss)
    2688    +2098048   2100736 +78052%  irq_2_pin(.bss)
    1792    +1048576   1050368 +58514%  irq_timer_state(.bss)
     968     +524288    525256 +54161%  per_cpu__kstat(.data.percpu)
 498248 +292029312 292527560 +58611%  Totals

====== Sections (-l 500)

    1 - 4k-defconfig
    2 - 4k-defconfig-tmp

       .1.         .2.    ..final..
  10379571  +292028228 302407799 +2813%  Total
   1118924    +5242880   6361804  +468%  .bss
    742016  +150994944 151736960 +20349%  .data.cacheline_aligned
    274416  +135266304 135540720 +49292%  .data.read_mostly
     44928     +524288    569216 +1166%  .data.percpu
 12559855 +584056644 596616499 +4650%  Totals

====== Text/Data ()

    1 - 4k-defconfig
    2 - 4k-defconfig-tmp

      .1.         .2.    ..final..
  1118208    +5242880   6361088  +468%  BssSize
  1232896     +524288   1757184   +42%  InitSize
    45056     +524288    569344 +1163%  PerCPU
  1077248  +286261248 287338496 +26573%  OtherSize
 3473408 +292552704 296026112 +8422%  Totals

> 
> Ugh. Yuck bleh nasty gag.
> 
> Yes please try the YH's patch that should fix the worst of the
> problem.
> 
> YH I think you have hit the root cause of the bug with NR_IRQS being
> defined a ridiculously low value on x86_64.  At first glance your
> patch looks reasonable, I had to stop and look why it was needed.  At
> second glance it looks like it doesn't go far enough.
> 
> The commit that unified interrupt vector defines appears substantially
> fumbled.  YH your description of why your patch is needed is not
> especially useful.
> 
> To be perfectly clear.  The maximum number of interrupts we can handle is:
> NR_CPUS*NR_VECTORS.  Defining NR_IRQS to a lower value is essentially a
> hack to allows us to use less memory as we seldom push that limit.
> 
> Further the only valid definition of NR_IRQ_VECTORS is NR_IRQS
> as we index it by irq.  Which really means now that we are unifying
> the code we should simply kill NR_IRQ_VECTORS.
> 
> I expect there is a lot more in that mess that can be cleaned up.
> Right now irq_vectors.h reads like nonsense to me.  I will see if
> I can find some time soon to look into what we should be doing.
> 
> Increasing the size of the next field in the irq_pin_list is a good
> idea.  Frankly I think we never use the next field (especially on
> x86_64 and should just remove it) but I have not been brave enough
> to try.
> 
> commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri May 2 20:10:09 2008 +0200
> 
>     x86: unify interrupt vector defines
>     
>     The interrupt vector defines are copied 4 times around with minimal
>     differences. Move them all into asm-x86/irq_vectors.h
>     
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
>> [PATCH] x86: 64bit support more than 256 irq
>>
>> because 64bit allow same vector for different cpu to serve different irq
>>
>> also change next in irq_pin_list from short to next. because for 4096 NR_IRQS
>> is 2^(5+12)+224.
>>
>> need to create that array dynamically later
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  arch/x86/kernel/io_apic_64.c  |    3 ++-
>>  include/asm-x86/irq_vectors.h |    6 +++++-
>>  2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/include/asm-x86/irq_vectors.h
>> ===================================================================
>> --- linux-2.6.orig/include/asm-x86/irq_vectors.h
>> +++ linux-2.6/include/asm-x86/irq_vectors.h
>> @@ -113,9 +113,13 @@
>>  
>>  # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) ||
>> defined(CONFIG_X86_VISWS)/include/asm-x86/irq_vectors.h
>>  
>> +#ifdef CONFIG_X86_64
>> +#  define NR_IRQS		(32 * NR_CPUS + 224)
>> +#else
>>  #  define NR_IRQS		224
>> +#endif
>>  
>> -#  if (224 >= 32 * NR_CPUS)
>> +#  if (NR_IRQS >= 32 * NR_CPUS)
>>  #   define NR_IRQ_VECTORS	NR_IRQS
>>  #  else
>>  #   define NR_IRQ_VECTORS	(32 * NR_CPUS)
>> Index: linux-2.6/arch/x86/kernel/io_apic_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
>> +++ linux-2.6/arch/x86/kernel/io_apic_64.c
>> @@ -140,7 +140,8 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BU
>>   */
>>  
>>  static struct irq_pin_list {
>> -	short apic, pin, next;
>> +	short apic, pin;
>> +	int next;
>>  } irq_2_pin[PIN_MAP_SIZE];
>>  
>>  struct io_apic {

