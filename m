Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbXCISE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbXCISE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXCISE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:04:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50597 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbXCISE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:04:27 -0500
Date: Fri, 9 Mar 2007 19:02:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309180230.GA17988@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Sure, that's clean, From that perspective the apic is a bunch of 
> > registers backed by a state machine or something.
> 
> I think you could do much worse than just decide to pick the 
> IO-APIC/lapic as your "virtual interrupt controller model". So I do 
> *not* think that APICRead/APICWrite are in any way horrible interfaces 
> for a virtual interrupt controller. In many ways, you then have a 
> tested and known interface to work with.

yes - but we already support the raw hardware ABI, in the native kernel.

paravirt_ops is not 'just another PC sub-arch'. It is not 'just another 
hardware driver'. It is not 'just another x86 CPU'. paravirt_ops is much 
wider than that, it hooks everywhere and has effect on everything!

Lets take a look at the raw numbers. Here's a typical distro kernel 
vmlinux, with and without CONFIG_PARAVIRT [with no paravirt backend 
enabled]:

     text    data     bss     dec     hex filename
   139863   49010   57672  246545   3c311 x86-kernel-built-in.o.noparavirt
   148865   49310   57672  255847   3e767 x86-kernel-built-in.o.paravirt

     text    data     bss     dec     hex filename
  5154975  586932  221184 5963091  5afd53 vmlinux.noparavirt
  5189197  587504  221184 5997885  5b853d vmlinux.paravirt

why did code size increase by +6.4% in arch/i386/ (+0.7% in the 
vmlinux)? It is purely because CONFIG_PARAVIRT adds more than _1400_ 
function call hooks to the x86 arch:

 c05c8e60 D paravirt_ops

 c0102602:       ff 15 9c 8e 5c c0       call   *0xc05c8e9c
 c0102d37:       ff 15 94 8e 5c c0       call   *0xc05c8e94
 c0102d45:       ff 15 94 8e 5c c0       call   *0xc05c8e94
 c0102d53:       ff 15 94 8e 5c c0       call   *0xc05c8e94
 c0102d61:       ff 15 94 8e 5c c0       call   *0xc05c8e94
 c0102d6f:       ff 15 94 8e 5c c0       call   *0xc05c8e94
 [...]

 $ objdump -d vmlinux | grep c05c8e | wc -l
 1463

_1463_ hooks, spread out all around the x86 arch.

Are these only trivial hooks a'ka alternatives.h? Not at all, these are 
full-blown function hooks freely modifiable by a paravirt_ops 
implementation, spread throughout the architecture in a finegrained way. 
(see my arguments and specific demonstration about the bad effects of 
this, four paragraphs below.)

As a comparison: people argued about CONFIG_SECURITY hooks and flamed 
about them no end. The reality is, there's only _269_ calls to 
security_ops in this same kernel, and i've got CONFIG_SECURITY + SELINUX 
enabled. And the only functional modification that security_ops does to 
native behavior is "deny the syscall". Not 'full control over 
behavior'... In terms of coupling, CONFIG_SECURITY hooks are a walk in 
the park, relative to CONFIG_PARAVIRT.

we dont even give /real silicon/ that many hooks! If an x86 CPU came 
along that required the addition of 1400+ function hooks then we'd say: 
'you must be joking, that's not an x86 CPU! Make it more compatible!'.

please dont get me wrong - 1463 hooks spread out might be fine in the 
end, but _if and only if_ there are safeguards in place to make sure 
they are just a trivial variation of the hardware ABI - a'ka 
asm/alternatives.h. But there is _no_ such safeguard in place today and 
we are seeing the bad effects of that _already_, with just a _single_ 
hypervisor and a _single_ abstraction topic (time), so i'm very strongly 
convinced that it's a serious issue that cannot just be glossed over 
with "relax, it will work out fine". If there's one thing we learned in 
the past 15 years is that ABI issues will haunt us forever.

Let me demonstrate some of the bad effects, and how far we've _already_ 
deviated from the 'hardware ABI'. An example: one assumes that 
paravirt_ops.safe_halt() is a trivial variation of the 'halt 
instruction', right? But vmi.c and vmitimer.c does much more than that. 
Take a look at vmi_safe_halt() which calls vmi_stop_hz_timer(): it hacks 
back a jiffies assumption into its code via paravirt_ops.safe_halt() - 
purely via changes local to vmitimer.c, by using next_timer_interrupt()! 
Thus it has created a _dual layer_ of dynticks that we specifically 
objected against. It does so in spite of our warning about why that is 
bad, it does so in spite of Xen having implemented a clockevents driver 
in 2 hours, and it does so under the cover of 'oh, this is only a 
vmitimer.c local change'. It circumvents the native dynticks framework 
and in essence brings in the bad NO_IDLE_HZ technique that we worked so 
hard for 2 years not to ever enable for the i386 arch!

so one of my very real problems with paravirt_ops is that due to its 
sheer hook-based impact it allows the modification of the hardware ABI 
on a _very_ wide scale: both unintentionally and intentionally. 

Furthermore, it allows the introduction of hard-to-remove hardwired 
quirks that bind one particular paravirt_ops method to the hypervisor 
ABI - quirks that are not present in any real silicon! Quirks 
_guaranteed by Linux_, by virtue of giving the CONFIG_VMI promise. So we 
effectively expose Linux to the hypervisor ABIs, and give hypervisors 'a 
license to arbitrary ABI coupling'. With no clear mechanism whatsoever 
to remove that coupling. At least crap hardware rots with time and gives 
us a chance to remove - but software ABIs and hence "virtual hardware" 
seldom rots.

it's hard enough to change the APIC code so that it works on both Intel 
and AMD CPUs: and those CPUs /share the ABI/ to a very large degree, by 
executing the same code.

and there are no safeguards in place whatsoever to ensure that the 
'virtual silicon ABI' matches up to the real silicon ABI. Granted, for 
VMI it probably matches up today most likely because VMI came from full 
software virtualization that /had/ to emulate all of real silicon. But 
from now on, paravirt_ops allows shortcuts, allows changes to semantics 
[a shortcut is change of semantics], allows additional ABIs, and we 
already see that happenning in vmitimer.c, which is even one of the 
/easiest/ paravirtualization topic.

Furthermore, it's only the beginning of the pain. It's the effect of 
_ONE_ hypervisor (VMWare/ESX) and _ONE_ abstraction (time). We've got 
4-5 hypervisors lined up for the paravirt_ops free-for-all and half a 
dozen of fundamental abstractions to cover (of which time is the 
simplest)! Please do the math. With paravirt_ops, the complexity of this 
is per-hypervisor and per-abstrction and there's no safeguard in place 
to let them evolve towards a saner, shared model. It wont happen because 
doing a sane, shared ABI is _HARD_. Nobody will go the effort of 
implementing the clean solution if they get to play with paravirt_ops, 
and _I_ will have the work dumped on me in the architecture, trying to 
sort out the mess.

i claim that when the 'API cut' is done at the right level then no more 
than say 100 hooks would be needed - with virtually zero kernel size 
increase. We've got all the right highlevel abstractions: genirq, gtod, 
clockevents. Whatever is missing at the moment from the framework (say 
smp_send_reschedule()) we can abstract away. The bonus? It would be 
almost directly applicable to other architectures as well. It would also 
work with /any/ hypervisor.

Unfortunately, with the current paravirt_ops policy we might end up 
seeing none of that unification. 1400+ hooks are just wide enough (by 
the law or large numbers) so that any hypervisor can implement a random 
ABI that performs close to the 'real' ABI, and has no incentive 
whatsoever to play along and make life easier for Linux by having a 
sane, unified ABI. Having provided the CONFIG_VMI ABI once, distros will 
see themselves forced adding those 1400+ hooks for many, many years to 
come, blowing up Linux' instruction cache footprint in a critical area 
of code.

And that is why the "paravirt_ops is just virtual hardware" argument is 
totally wrong. _Nothing_ limits hypervisors from adding arbitrary ABI 
bindings to Linux. For example, VMI does this already and none of the 
following are hardware ABIs:

 #define VMI_CALL_SetAlarm               68
 #define VMI_CALL_CancelAlarm            69
 #define VMI_CALL_GetWallclockTime       70
 #define VMI_CALL_WallclockUpdated       71

and these ABIs have been objected to by Thomas and me because they are 
cycle based - still paravirt_ops allows Linux to become dependent on 
these ABIs.

Finally, what would i like to see?

Firstly, i think this has been over-rushed. After years of being happy 
with forks of the Linux kernel, all the hypervisors woke up at once and 
want to have their stuff upstream /now/. This rush created a hodgepodge 
of APIs/ABIs that we now in the end promise to support /all/. (if we 
take CONFIG_VMI i can see little ethical reason to not take Xen's 
paravirt_ops, lguest's paravirt_ops, KVM's paravirt_ops and i'm sure 
Microsoft/Novell will have something nice and different for us too.)

Secondly, i'd like to see a paravirt approach that has /implicit/ 
safeguards against the following type of crap:

   vmitimer.c code has a hardwired assumption that a PIT exists:

        /* Disable PIT. */
        outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */

   it has a hardwired assumption that 'cycles' makes a sense as a way to 
   communicate time units:

        vmi_timer_ops.set_alarm(
                      VMI_ALARM_WIRED_LVTT | VMI_ALARM_IS_PERIODIC | VMI_CYCLES_AVAILABLE,
                      per_cpu(process_times_cycles_accounted_cpu, cpu) + cycles_per_alarm,
                      cycles_per_alarm);

   it has a hardwired assumption that Linux keeps time in units of 
   'jiffies':

        if (rcu_needs_cpu(cpu) || local_softirq_pending() ||
            (next = next_timer_interrupt(),
             time_before_eq(next, jiffies + HZ/CONFIG_VMI_ALARM_HZ))) {
                cpu_clear(cpu, nohz_cpu_mask);

etc. etc. paravirt_ops is _NOT_ just a random driver we can fix in the 
future. These are all assumptions that can /easily/ leak out towards the 
hypervisor and thus create ABI coupling between that quirk and a 
specific version of the hypervisor. Fixing such bad coupling needs 
changes on the /hypervisor side/.

Granted, some of these are just harmless quirks that are fixable in 
Linux only, but some of these are stiffling because they bind Linux to 
the hypervisor ABI.

i might be overreacting, but the effects of 1400+ hooks put into the 
code against my objections, which code i helped write for many years, 
and that i'd like to help write for many years to come, is no small 
issue to me.

	Ingo
