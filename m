Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0BMJdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 04:33:01 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:62414 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab0BMJc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 04:32:58 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 04:32:57 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TXv6KsPh+X2V5cdDriW5JrNWWYAA4vfk5kW8PKoBaXJYF9fia+IQKDmZ/glGdxU1oS
         bYrZjFt0bvzft0H1bAv7qoOYOEQgSCjeAmiUkiKhhENbFaOsgL1m0unpWu4Iki3nFpDF
         OYjfGAjgbedUuFAhCKuNU9ZShrRrQdNh2Nlvc=
MIME-Version: 1.0
In-Reply-To: <64bb37e1002021156s6e8e3ba7p6192e15bc431eb87@mail.gmail.com>
References: <64bb37e1001310502p3d74bdf5ve56f63d3e8d2fd39@mail.gmail.com>
	 <4B679042.2010008@kernel.org> <m1r5p4grvg.fsf@fess.ebiederm.org>
	 <1265136022.2793.33.camel@sbs-t61.sc.intel.com>
	 <64bb37e1002021156s6e8e3ba7p6192e15bc431eb87@mail.gmail.com>
Date: Sat, 13 Feb 2010 10:25:46 +0100
Message-ID: <64bb37e1002130125r7013832brc9b3b695daaf6f91@mail.gmail.com>
Subject: Re: do_IRQ: 0.165 No irq handler for vector (irq -1)
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

I reported this problem one day after -rc1 was out and it's still
there in -rc8, the probably last -rc for 2.6.33.
(I also reported it against -rc2, -rc3, -rc4 and -rc6)

Apart from the patches related to the SiI register HOST_CTRL_MSIACK
(that did not fix the problem) I have the feeling, that I'm not one
step further to any fix.

Is this a bug in the MSI-enable code in sata_sil24?
Is this a bug in the MSI code in libata?
Is this a bug in the IRQ system?
Is this a bug in the x86 apic code?

Is this a hardware bug in the SiI 3132?
Is this a hardware bug in the MCP55?
Is this a fatal bug or does it just need the right quirk?

What should I do now?
Keep posting that it's still broken at each -rc?
Open a bug at bugzilla.kernel.org? Against what subsytem?
Should I just not use the sata_sil.msi=1 commandline? Or should
dae77214fa71898b84514e43721fb7bf260b026a be reverted?

On Tue, Feb 2, 2010 at 8:56 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Tue, Feb 2, 2010 at 7:40 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>> On Mon, 2010-02-01 at 20:53 -0800, Eric W. Biederman wrote:
>>> > It might be that the silicon implements MSI incorrectly and ends up
>>> > sending out invalid MSI packets under certain circumstances.  The
>>> > silicon hasn't changed for quite some time now and back when it came
>>> > out MSI wasn't too popular and I don't think SIMG's proprietary
>>> > drivers use it, so it's quite possible that the feature simply is
>>> > broken.  Is there any specific reason why you want to enable MSI
>>> > support?  It's not like MSI brings any actual benefit when the
>>> > compatibility hardware is already there.
>
>  19:      34618          3          2       4862   IO-APIC-fasteoi
> sata_sil24, bttv0, Bt87x audio
> [    6.038918] IRQ 19/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
>
> The interrupt that the sata_sil24 is currently using is shared, so I
> thought that switching this to MSI might be a good idea.
> And I wanted to test a new feature. ;-)
>
>>> It also seems possible that some of the recent irq handling changes
>>> missed something.
>>
>> No Eric. This particular report is with 2.6.33-rc kernels and also only
>> when MSI support for sata_sil24 is enabled. Recent irq handling changes
>> are all in -tip tree and getting tested. So this sounds like a different
>> problem specific to this HW's MSI capabilities.
>
> Just to repeat this so not get this information lost:
> MSI seems to work an this system.
> The drivers radeon (X300), HDA intel (onboard sound from the MCP55
> chipset) and tg3 (two BCM5754) all work without any problems.
>
>>> Usually the message "No irq handler for vector (irq -1)" means that the irq
>>> was delivered to a cpu that was not ready for it.  I see that vector 165
>>> is being delivered on all of the different cpus with vector 165,
>>> and that you are getting interrupts delivered most of the time.
>>
>> Also I see this in the original report:
>>
>> On Sun, 2010-01-31 at 05:02 -0800, Torsten Kaiser wrote:
>>> What is really strange: The vector 165 is stable. It never changed
>>> even if I deactivate all other drivers in the kernel config (that
>>> changes the MSI IRQ for sata_sil24 from 29 to 28!) or if I switch off
>>> CONFIG_SPARSE_IRQ. In the kernel with the reduced number of drivers
>>> the maximum vector that gets used in __assign_irq_vector is only 137.
>>
>> It looks like the HW under certain conditions is generating interrupts
>> with wrong vector (165), especially when the __assign_irq_vector() never
>> allocated the vector 165 (and hence we never setup the vector to irq
>> mapping for this vector on any cpu). Torsten, can you please apply the
>> appended patch and boot with "apic_phys" boot parameter and see if it
>> makes any difference?
>
> I tried the patch and the message from do_IRQ is gone, but reading the
> file still fails with the same errors from libata.
> (Earlier tests with writing a large file to this disk also failed with
> timeouts, but never trigger the do_IRQ error)
>
> I added a diff between the dmesg from the testrun with your patch to
> the previous run at the end of the mail.
>
>>> This smells like the initialization problems I was seeing in another
>>> thread.  Suresh?
>>
>> No. Initialization problems in another thread happens in a small window
>> during cpu online (in logical flat mode, we are setting up vector to irq
>> mappings for the AP a little late after we have enabled interrupts).
>> Here the problem is not actually triggered during cpu on-lining.
>
> FWIW: # CONFIG_HOTPLUG_CPU is not set
>
> I don't use suspend/resume on that system, so I never enabled CPU
> hotplug in the .config.
>
> Thanks for looking at this.
>
> Torsten
>
>
> The changes in dmesg from you patch:
> 1,2c1,2
> < x Linux version 2.6.33-rc6 (root@treogen) (gcc version 4.4.2 (Gentoo
> 4.4.2 p1.0) ) #1 SMP Sat Jan 30 10:38:39 CET 2010
> < x Command line: root=/dev/sdc1 console=ttyS0,115200 console=tty1
> sata_sil24.msi=1 radeon.modeset=1 raid=noautodetect apic=debug
> ---
>> x Linux version 2.6.33-rc6 (root@treogen) (gcc version 4.4.2 (Gentoo 4.4.2 p1.0) ) #2 SMP Tue Feb 2 20:22:21 CET 2010
>> x Command line: root=/dev/sdc1 console=ttyS0,115200 console=tty1 sata_sil24.msi=1 radeon.modeset=1 raid=noautodetect apic=debug apic_phys
> 61a62
>> x Setting APIC routing to physical flat.
> 130a132
>> x Setting APIC routing to physical flat.
> 159c161
> < x Kernel command line: root=/dev/sdc1 console=ttyS0,115200
> console=tty1 sata_sil24.msi=1 radeon.modeset=1 raid=noautodetect
> apic=debug
> ---
>> x Kernel command line: root=/dev/sdc1 console=ttyS0,115200 console=tty1 sata_sil24.msi=1 radeon.modeset=1 raid=noautodetect apic=debug apic_phys
> 163,164c165,166
> < x Node 0: aperture @ a7f2000000 size 32 MB
> < x Aperture beyond 4GB. Ignoring.
> ---
>> x Node 0: aperture @ 20000000 size 32 MB
>> x Aperture pointing to e820 RAM. Ignoring.
> 202c204
> < x Setting APIC routing to flat
> ---
>> x Setting APIC routing to physical flat
> 234,235c236,237
> < x ... lapic delta = 1249998
> < x ... PM-Timer delta = 357954
> ---
>> x ... lapic delta = 1249989
>> x ... PM-Timer delta = 357951
> 237,241c239,243
> < x ..... delta 1249998
> < x ..... mult: 53687005
> < x ..... calibration result: 1999996
> < x ..... CPU clock speed is 2599.9959 MHz.
> < x ..... host bus clock speed is 199.9996 MHz.
> ---
>> x ..... delta 1249989
>> x ..... mult: 53686618
>> x ..... calibration result: 1999982
>> x ..... CPU clock speed is 2599.9751 MHz.
>> x ..... host bus clock speed is 199.9982 MHz.
> 248c250
> < x Total of 4 processors activated (20800.14 BogoMIPS).
> ---
>> x Total of 4 processors activated (20799.96 BogoMIPS).
> 430,431c432,433
> < x ... APIC ICR: 000008fd
> < x ... APIC ICR2: 08000000
> ---
>> x ... APIC ICR: 000000fd
>> x ... APIC ICR2: 03000000
> 437,438c439,440
> < x ... APIC TMICT: 0001e847
> < x ... APIC TMCCT: 000174b3
> ---
>> x ... APIC TMICT: 0001e846
>> x ... APIC TMCCT: 000185ee
> 462,476c464,478
> < x  01 00F 0    0    0   0   0    1    1    31
> < x  02 00F 0    0    0   0   0    1    1    30
> < x  03 00F 0    0    0   0   0    1    1    33
> < x  04 00F 0    0    0   0   0    1    1    34
> < x  05 00F 1    0    0   0   0    1    1    35
> < x  06 00F 0    0    0   0   0    1    1    36
> < x  07 00F 0    0    0   0   0    1    1    37
> < x  08 00F 0    0    0   0   0    1    1    38
> < x  09 00F 0    1    0   0   0    1    1    39
> < x  0a 00F 1    0    0   0   0    1    1    3A
> < x  0b 00F 1    0    0   0   0    1    1    3B
> < x  0c 00F 0    0    0   0   0    1    1    3C
> < x  0d 00F 0    0    0   0   0    1    1    3D
> < x  0e 00F 0    0    0   0   0    1    1    3E
> < x  0f 00F 0    0    0   0   0    1    1    3F
> ---
>> x  01 000 0    0    0   0   0    0    0    31
>> x  02 000 0    0    0   0   0    0    0    30
>> x  03 000 0    0    0   0   0    0    0    33
>> x  04 000 0    0    0   0   0    0    0    34
>> x  05 000 1    0    0   0   0    0    0    35
>> x  06 000 0    0    0   0   0    0    0    36
>> x  07 000 0    0    0   0   0    0    0    37
>> x  08 000 0    0    0   0   0    0    0    38
>> x  09 000 0    1    0   0   0    0    0    39
>> x  0a 000 1    0    0   0   0    0    0    3A
>> x  0b 000 1    0    0   0   0    0    0    3B
>> x  0c 000 0    0    0   0   0    0    0    3C
>> x  0d 000 0    0    0   0   0    0    0    3D
>> x  0e 000 0    0    0   0   0    0    0    3E
>> x  0f 000 0    0    0   0   0    0    0    3F
>
