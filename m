Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbZATRzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbZATRzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZATRyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:54:53 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:35334 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZATRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:54:52 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4975CBF8.90101@redhat.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	 <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>
	 <1232410363.4768.21.camel@kulgan.wumi.org.au>
	 <20090120113546.GA26571@elte.hu>
	 <1232455343.4895.4.camel@kulgan.wumi.org.au>  <4975CBF8.90101@redhat.com>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Wed, 21 Jan 2009 04:24:41 +1030
Message-Id: <1232474081.4895.76.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 15:04 +0200, Avi Kivity wrote:
> Kevin Shanahan wrote:
> > On Tue, 2009-01-20 at 12:35 +0100, Ingo Molnar wrote:
> >> This only seems to occur under KVM, right? I.e. you tested it with -no-kvm 
> >> and the problem went away, correct?
> >>     
> >
> > Well, the I couldn't make the test conditions identical, but it the
> > problem didn't occur with the test I was able to do:
> >
> >   http://marc.info/?l=linux-kernel&m=123228728416498&w=2
> >
> >   
> 
> Can you also try with -no-kvm-irqchip?
> 
> You will need to comment out the lines
> 
>     /* ISA IRQs map to GSI 1-1 except for IRQ0 which maps
>      * to GSI 2.  GSI maps to ioapic 1-1.  This is not
>      * the cleanest way of doing it but it should work. */
> 
>     if (vector == 0)
>         vector = 2;
> 
> in qemu/hw/apic.c (should also fix -no-kvm smp).  This will change kvm 
> wakeups to use signals rather than the in-kernel code, which may be buggy.

Okay, I commented out those lines and compiled a new kvm-82 userspace
and kernel modules. Using those on a vanilla 2.6.28 kernel, with all
guests run with -no-kvm-irqchip added.

As before a number of the XP guests wanted to chug away at 100% CPU
usage for a long time. Three of the guests clocked up ~40 minutes CPU
time before I decided to just shut them down. Perhaps coincidentally,
these three guests are the only ones with Office 2003 installed on them.
That could be the difference between those guests and the other XP
guests, but that's probably not important for now.

The two Linux SMP guests booted okay this time, though they seem to only
use one CPU on the host (I guess kvm is not multi-threaded in this
mode?). "hermes-old", the guest I am pinging in all my tests, had a lot
of trouble running the apache2 setup - it was so slow it was difficult
to load a complete page from our RT system. The kvm process for this
guest was taking up 100% cpu on the host constantly and all sorts of
wierd stuff could be seen by watching top in the guest:

top - 03:44:17 up 43 min,  1 user,  load average: 3.95, 1.55, 0.80
Tasks: 101 total,   4 running,  97 sleeping,   0 stopped,   0 zombie
Cpu(s): 79.7%us, 10.4%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  9.9%si,
0.0%st
Mem:   2075428k total,   391128k used,  1684300k free,    13044k buffers
Swap:  3502160k total,        0k used,  3502160k free,   118488k cached
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND             
 2956 postgres  20   0 19704  11m  10m S 1658  0.6   2:55.99 postmaster          
 2934 www-data  20   0 60392  40m 5132 R   31  2.0   0:17.28 apache2             
 2958 postgres  20   0 19700  11m 9.8m R   28  0.6   0:20.41 postmaster          
 2940 www-data  20   0 58652  38m 5016 S   27  1.9   0:04.87 apache2             
 2937 www-data  20   0 60124  40m 5112 S   18  2.0   0:11.00 apache2             
 2959 postgres  20   0 19132 5424 4132 S   10  0.3   0:01.50 postmaster          
 2072 postgres  20   0  8064 1416  548 S    7  0.1   0:23.71 postmaster          
 2960 postgres  20   0 19132 5368 4060 R    6  0.3   0:01.55 postmaster          
 2071 postgres  20   0  8560 1972  488 S    5  0.1   0:08.33 postmaster    

Running the ping test with without apache2 running in the guest:

--- hermes-old.wumi.org.au ping statistics ---
900 packets transmitted, 900 received, 0% packet loss, time 902740ms
rtt min/avg/max/mdev = 0.568/3.745/272.558/16.990 ms

And with apache2 running:

--- hermes-old.wumi.org.au ping statistics ---
900 packets transmitted, 900 received, 0% packet loss, time 902758ms
rtt min/avg/max/mdev = 0.625/25.634/852.739/76.586 ms

In both cases it's quite variable, but the max latency is still not as
bad as when running with the irq chip enabled.

Anyway, the test is again not ideal, but I hope we're proving something.
That's all I can do for tonight - should be ready for more again
tomorrow night.

Regards,
Kevin.


