Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXFWKh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXFWKh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXFWKhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:37:16 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:40583 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbXFWKhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:37:14 -0400
To: mingo@elte.hu
CC: torvalds@linux-foundation.org, cebbert@redhat.com, jarkao2@o2.pl,
       miklos@szeredi.hu, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
In-reply-to: <20070622081702.GA14746@elte.hu> (message from Ingo Molnar on
	Fri, 22 Jun 2007 10:17:02 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621201624.GD22303@elte.hu> <20070622081702.GA14746@elte.hu>
Message-Id: <E1I22yO-0004TX-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 23 Jun 2007 12:36:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > the freezes that Miklos was seeing were hardirq contexts blocking in 
> > task_rq_lock() - that is done with interrupts disabled. (Miklos i 
> > think also tried !NOHZ kernels and older kernels, with a similar 
> > result.)
> > 
> > plus on the ptrace side, the wait_task_inactive() code had most of its 
> > overhead in the atomic op, so if any timer IRQ hit _that_ core, it was 
> > likely while we were still holding the runqueue lock!
> > 
> > i think the only thing that eventually got Miklos' laptop out of the 
> > wedge were timer irqs hitting the ptrace CPU in exactly those 
> > instructions where it was not holding the runqueue lock. (or perhaps 
> > an asynchronous SMM event delaying it for a long time)
> 
> even considering that the 'LOCK'-ed intruction was the heaviest in the 
> busy-loop, the numbers still just dont add up to 'tens of seconds of 
> lockups', so there must be something else happening too.
> 
> So here's an addition to the existing theories: the Core2Duo is a 
> 4-issue CPU architecture. Now, why does this matter? It matters to the 
> timing of the delivery of interrupts. For example, on a 3-issue 
> architecture, the instruction level profile of well-cached workloads 
> often looks like this:
> 
> c05a3b71:      710      89 d6                   mov    %edx,%esi
> c05a3b73:        0      8b 55 c0                mov    0xffffffc0(%ebp),%edx
> c05a3b76:        0      89 c3                   mov    %eax,%ebx
> c05a3b78:      775      8b 82 e8 00 00 00       mov    0xe8(%edx),%eax
> c05a3b7e:        0      8b 48 18                mov    0x18(%eax),%ecx
> c05a3b81:        0      8b 45 c8                mov    0xffffffc8(%ebp),%eax
> c05a3b84:      792      89 1c 24                mov    %ebx,(%esp)
> c05a3b87:        0      89 74 24 04             mov    %esi,0x4(%esp)
> c05a3b8b:        0      ff d1                   call   *%ecx
> c05a3b8d:        0      8b 4d c8                mov    0xffffffc8(%ebp),%ecx
> c05a3b90:      925      8b 41 6c                mov    0x6c(%ecx),%eax
> c05a3b93:        0      39 41 10                cmp    %eax,0x10(%ecx)
> c05a3b96:        0      0f 85 a8 01 00 00       jne    c05a3d44 <schedule+0x2a4>
> c05a3b9c:      949      89 da                   mov    %ebx,%edx
> c05a3b9e:        0      89 f1                   mov    %esi,%ecx
> c05a3ba0:        0      8b 45 c8                mov    0xffffffc8(%ebp),%eax
> 
> the second column is the number of times the profiling interrupt has hit 
> that particular instruction.
> 
> Note the many zero entries - this means that for instructions that are 
> well-cached, the issue order _prevents_ interrupts from _ever_ hitting 
> to within a bundle of micro-ops that the decoder will issue! The above 
> workload was a plain lat_ctx, so nothing special, and interrupts and DMA 
> traffic were coming and going. Still the bundling of instructions was 
> very strong.
> 
> There's no guarantee of 'instruction bundling': a cachemiss can still 
> stall the pipeline and allow an interrupt to hit any instruction [where 
> interrupt delivery is valid], but on a well-cached workload like the 
> above, even a 3-issue architecture can effectively 'merge' instructions 
> to each other, and can make them essentially 'atomic' as far as external 
> interrupts go.
> 
> [ also note another interesting thing in the profile above: the
>   CALL *%ecx was likely BTB-optimized and hence we have a 'bundling' 
>   effect that is even larger than 3 instructions. ]
> 
> i think that is what might have happened on Miklos's laptop too: the 
> 'movb' of the spin_unlock() done by the wait_task_inactive() got 
> 'bundled' together with the first LOCK instruction that took it again, 
> making it very unlikely for a timer interrupt to ever hit that small 
> window in wait_task_inactive(). The cpu_relax()'s "REP; NOP" was likely 
> a simple NOP, because the Core2Duo is not an SMT platform.
> 
> to check this theory, adding 3 NOPs to the critical section should make 
> the lockups a lot less prominent too. (While NOPs are not actually 
> 'issued', they do take up decoder bandwidth, so they hopefully are able 
> to break up any 'bundle' of instructions.)
> 
> Miklos, if you've got some time to test this - could you revert the 
> fa490cfd15d7 commit and apply the patch below - does it have any impact 
> on the lockups you were experiencing?

No.  If anything it made the freezes somwhat more frequent.

And it's not a NO_HZ kernel.

What I notice is that the interrupt distribution between the CPUs is
very asymmetric like this:

           CPU0       CPU1
  0:     220496         42   IO-APIC-edge      timer
  1:       3841          0   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc
  9:       2756          0   IO-APIC-fasteoi   acpi
 12:       2638          0   IO-APIC-edge      i8042
 14:       7776          0   IO-APIC-edge      ide0
 16:       6083          0   IO-APIC-fasteoi   uhci_hcd:usb2
 17:      34414          3   IO-APIC-fasteoi   uhci_hcd:usb3, HDA Intel
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:         32          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb5
313:      11405          1   PCI-MSI-edge      eth0
314:      29417         10   PCI-MSI-edge      ahci
NMI:        164        118
LOC:     220499     220463
ERR:          0

and the freezes don't really change that.  And the NMI traces show,
that it's always CPU1 which is spinning in wait_task_inactive().

Miklos
