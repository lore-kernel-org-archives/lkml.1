Return-Path: <linux-kernel-owner+w=401wt.eu-S2992815AbXCHBBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992815AbXCHBBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992816AbXCHBBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:01:45 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53433 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992815AbXCHBBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:01:45 -0500
Message-ID: <45EF6077.9090302@vmware.com>
Date: Wed, 07 Mar 2007 17:01:43 -0800
From: Daniel Arai <arai@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20050920
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Zachary Amsden <zach@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	<45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	<20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>	<1173178774.24738.311.camel@localhost.localdomain>	<45EDD82F.90204@vmware.com>	<1173225182.24738.507.camel@localhost.localdomain>	<45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>	<1173228544.24738.514.camel@localhost.localdomain>	<45EE0D10.7070807@vmware.com>	<1173230305.24738.529.camel@localhost.localdomain>	<45EE1EA3.90803@vmware.com>	<1173256666.24738.576.camel@localhost.localdomain>	<45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>	<45EF0CF5.5090305@goop.org>  <45EF175D.6030609@vmware.com>	<1173302503.24738.795.camel@localhost.localdomain>	<45EF372E.7030600@goop.org>	<1173308717.24738.898.camel@localhost.localdomain>	<45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain>
In-Reply-To: <1173313373.24738.937.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> You managed to avoid the usage of other code (i.e. PIT / HPET) already,
> so why is it sooo desireable to emulate apics instead of substituting it
> by a small and sane replacement ? Just because you happen to have an
> LAPIC emulator ? That's no reason to wire yourself into the kernel code
> and make it harder to change and maintain.

There are several reasons why it's desirable to emulate the APIC.  As you 
mentioned, we already have APIC emulation, and APIC emulation isn't a huge 
bottleneck on most workloads.  Our code works, the Linux code works, and 
replacing both pieces of code with something "small and sane" isn't going to 
improve performance very much, so why bother?  Any hypervisor implementation is 
going to be a tradeoff between what's easy to implement in the hypervisor, 
what's easy to implement in the guest operating system, and what's performance 
critical.

Secondly, not all (para-)virtualized operating systems will want to use 
abstracted devices.  Some virtual operating systems will be given direct access 
to hardware devices, and will need to run the actual driver for that device and 
not some abstracted device driver.  So I don't buy your argument that every 
piece of the kernel that interacts with a paravirtualized driver should have a 
"small and sane replacement."

But more importantly, we want a kernel that can run both on native hardware and 
in a paravirtualized environment.  Linux doesn't really provide abstractions for 
  replacing the appropriate code.  We tried to hook into the source code at a 
level that seemed possible.

For example, take smp_call_function().  What this essentially does is call 
send_IPI_allbutself().

void fastcall send_IPI_self(int vector)
{
         __send_IPI_shortcut(APIC_DEST_SELF, vector);
}

void __send_IPI_shortcut(unsigned int shortcut, int vector)
{
         /*
          * Subtle. In the case of the 'never do double writes' workaround
          * we have to lock out interrupts to be safe.  As we don't care
          * of the value read we use an atomic rmw access to avoid costly
          * cli/sti.  Otherwise we use an even cheaper single atomic write
          * to the APIC.
          */
         unsigned int cfg;

         /*
          * Wait for idle.
          */
         apic_wait_icr_idle();

         /*
          * No need to touch the target chip field
          */
         cfg = __prepare_ICR(shortcut, vector);

         /*
          * Send the IPI. The write to APIC_ICR fires this off.
          */
         apic_write_around(APIC_ICR, cfg);
}


There's no good way to override __send_IPI_shortcut.  I suppose we could add 
paravirt ops for __send_IPI_shortcut and every other op that touches the APIC. 
But there are dozens of functions in apic.c that would need to be included in 
paravirt ops.  And for our implementation, we really just want to override 
apic_read and apic_write, since we can make these faster when done through 
hypercalls than through memory accesses.  If we were to make these paravirt ops, 
their implementations would be the same, except with a different apic_read and 
apic_write.  This is a whole lot of useless code duplication.

Most of the interrupt system is not written in such a way that multiple APICs 
implementations can be selected from at boot time.  This is an absolute 
requirement so that the same kernel can boot on native and in a paravirtualized 
environment.  While this could be implemented, it seems like a waste of time, 
since we can just emulate something similar to a real interrupt system and not 
change things very much.

Dan Arai
VMware, Inc.
