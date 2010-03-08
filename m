Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0CHQ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:28:08 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:45903 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab0CHQ16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:27:58 -0500
X-AuditID: c1b4fb3d-b7c72ae00000040e-80-4b95258c110d
From: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
To: Thomas Renninger <trenn@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "jbohac@novell.com" <jbohac@novell.com>, Yinghai Lu <yinghai@kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Avi Kivity <avi@redhat.com>
Date: Mon, 8 Mar 2010 17:25:36 +0100
Subject: RE: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec -
 V4
Thread-Topic: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec -
 V4
Thread-Index: Acq+tN8jo/m89duFSg64DuYa73CBbgAJxy5k
Message-ID: <C64F1A8E3F9E3C409DFC005F502C40D0020D8F2A@ESESSCMS0359.eemea.ericsson.se>
References: <20100308113452.GK6004@lenovo>,<1268048582-12219-1-git-send-email-trenn@suse.de>
In-Reply-To: <1268048582-12219-1-git-send-email-trenn@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Renninger [trenn@suse.de]
> Sent: Monday, March 08, 2010 12:43 PM
> To: linux-kernel@vger.kernel.org
> Cc: Kerstin Jonsson; jbohac@novell.com; Yinghai Lu; akpm@linux-foundation.org; mingo@elte.hu; Avi Kivity; Thomas Renninger
> Subject: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec - V4
>
> From: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
>
> When the SMP kernel decides to crash_kexec() the local APICs may have
> pending interrupts in their vector tables.
> The setup routine for the local APIC has a deficient mechanism for
> clearing these interrupts, it only handles interrupts that has already
> been dispatched to the local core for servicing (the ISR register)
> safely, it doesn't consider lower prioritized queued interrupts stored
> in the IRR register.
>
> If you have more than one pending interrupt within the same 32 bit word
> in the LAPIC vector table registers you may find yourself entering the
> IO APIC setup with pending interrupts left in the LAPIC. This is a
> situation for wich the IO APIC setup is not prepared. Depending of
> what/which interrupt vector/vectors are stuck in the APIC tables your
> system may show various degrees of malfunctioning.
> That was the reason why the check_timer() failed in our system, the
> timer interrupts was blocked by pending interrupts from the old kernel
> when routed trough the IO APIC.
>
> Additional comment from Jiri Bohac:
> ==============
> If this should go into stable release,
> I'd add some kind of limit on the number of iterations, just to be safe from
> hard to debug lock-ups:
>
> +if (loops++  > MAX_LOOPS) {
> +        printk("LAPIC pending clean-up")
> +        break;
> +}
>  while (queued);
>
> with MAX_LOOPS something like 1E9 this would leave plenty of time for the
> pending IRQs to be cleared and would and still cause at most a second of delay
> if the loop were to lock-up for whatever reason.
> ==============
>
> >From trenn@suse.de:
> V2: Use tsc if avail to bail out after 1 sec due to possible virtual apic_read
>     calls which may take rather long (suggested by: Avi Kivity <avi@redhat.com>)
>     If no tsc is available bail out quickly after cpu_khz, if we broke out too
>     early and still have irqs pending (which should never happen?) we still
>     get a WARN_ON...
>
> V3: - Fixed indentation -> checkpatch clean
>     - max_loops must be signed
>
> V4: - Fix typo, mixed up tsc and ntsc in first rdtscll() call
>
> CC: jbohac@novell.com
> CC: "Yinghai Lu" <yinghai@kernel.org>
> CC: akpm@linux-foundation.org
> CC: mingo@elte.hu
> CC: "Kerstin Jonsson" <kerstin.jonsson@ericsson.com>
> CC: "Avi Kivity" <avi@redhat.com>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> ---
>  arch/x86/kernel/apic/apic.c |   41 +++++++++++++++++++++++++++++++++--------
>  1 files changed, 33 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 3987e44..414a5df 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -51,6 +51,7 @@
>  #include <asm/smp.h>
>  #include <asm/mce.h>
>  #include <asm/kvm_para.h>
> +#include <asm/tsc.h>
>
>  unsigned int num_processors;
>
> @@ -1151,8 +1152,13 @@ static void __cpuinit lapic_setup_esr(void)
>   */
>  void __cpuinit setup_local_APIC(void)
>  {
> -       unsigned int value;
> -       int i, j;
> +       unsigned int value, queued;
> +       int i, j, acked = 0;
> +       unsigned long long tsc = 0, ntsc;
> +       long long max_loops = cpu_khz;
> +
> +       if (cpu_has_tsc)
> +               rdtscll(tsc);
>
>         if (disable_apic) {
>                 arch_disable_smp_support();
> @@ -1204,13 +1210,32 @@ void __cpuinit setup_local_APIC(void)
>          * the interrupt. Hence a vector might get locked. It was noticed
>          * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
>          */
> -       for (i = APIC_ISR_NR - 1; i >= 0; i--) {
> -               value = apic_read(APIC_ISR + i*0x10);
> -               for (j = 31; j >= 0; j--) {
> -                       if (value & (1<<j))
> -                               ack_APIC_irq();
> +       do {
> +               queued = 0;
> +               for (i = APIC_ISR_NR - 1; i >= 0; i--)
> +                       queued |= apic_read(APIC_IRR + i*0x10);
> +
> +               for (i = APIC_ISR_NR - 1; i >= 0; i--) {
> +                       value = apic_read(APIC_ISR + i*0x10);
> +                       for (j = 31; j >= 0; j--) {
> +                               if (value & (1<<j)) {
> +                                       ack_APIC_irq();
> +                                       acked++;
> +                               }
> +                       }
>                 }
> -       }
> +               if (acked > 256) {
> +                       printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
> +                              acked);
> +                       break;
> +               }
> +               if (cpu_has_tsc) {
> +                       rdtscll(ntsc);
> +                       max_loops = (cpu_khz << 10) - (ntsc - tsc);
> +               } else
> +                       max_loops--;
> +       } while (queued && max_loops > 0);
> +       WARN_ON(!max_loops);
>
>         /*
>          * Now that we are all set up, enable the APIC
> --
> 1.6.3
>
>
>  
Are you quite done now? Anyhow, I was doing documentation, which I hate
intensively! any excuse to defer is appreciated.

I have verified the patch on target HW:

model name      : Dual Core AMD Opteron(tm) Processor 165
cpu MHz         : 1800.056


model name      : Intel(R) Xeon(R) CPU           L5408  @ 2.13GHz
cpu MHz         : 2127.988

and in kvm:

(QEMU PC emulator version 0.10.6 (qemu-kvm-78.0.10.6-0.3.1))

hosted by a:

model name      : Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
cpu MHz         : 1994.988

It still flushes multiple pending interrupts in the APIC tables -
i.e. my crash kernel boots up OK even when subjected to "ISR mayhem"
prior to crash.
If I force it to stay in the flush loop, it times out in approx. 1.02s in
all different target environments, close enough I'd say.

I do, however, have tsc support in all of them, had I not I'd probably
found it a bit tedious to wait for the kvm loop (if against all odds it
would get stuck) due to longer loop-time in kvm it would take ~100s to
perform (max_loops=cpu_khz) rounds. But then again, my host machine is
old, with better virtualization support in more modern machines and it
is an unlikely case, etc. I guess it won't really be a problem.

