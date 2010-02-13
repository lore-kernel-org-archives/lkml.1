Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0BMVeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 16:34:37 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:55128 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0BMVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 16:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jkWeL5JGa8FEVzi//oPzNek4/E+1C+rNg4WEgIBfp+0u3QfyhZFGtnOOOabdqJQuxW
         n8hiCPZGMlDW2eWN60exIY4K+pXgkIi0WtiwLIgNWZeJHEpuAOskLWp5djAXnYBjjVM0
         oB5f38TjQoqi+tqlVHd/yqAgNRzg/qRgsBaV8=
MIME-Version: 1.0
In-Reply-To: <1266085107.2677.37.camel@sbs-t61>
References: <64bb37e1001310502p3d74bdf5ve56f63d3e8d2fd39@mail.gmail.com>
	 <4B679042.2010008@kernel.org> <m1r5p4grvg.fsf@fess.ebiederm.org>
	 <1265136022.2793.33.camel@sbs-t61.sc.intel.com>
	 <64bb37e1002021156s6e8e3ba7p6192e15bc431eb87@mail.gmail.com>
	 <64bb37e1002130125r7013832brc9b3b695daaf6f91@mail.gmail.com>
	 <1266085107.2677.37.camel@sbs-t61>
Date: Sat, 13 Feb 2010 22:34:33 +0100
Message-ID: <64bb37e1002131334n361753v3003d9585aef384a@mail.gmail.com>
Subject: Re: do_IRQ: 0.165 No irq handler for vector (irq -1)
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 7:18 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Sat, 2010-02-13 at 02:25 -0700, Torsten Kaiser wrote:
>> Ping?
>>
>> I reported this problem one day after -rc1 was out and it's still
>> there in -rc8, the probably last -rc for 2.6.33.
>> (I also reported it against -rc2, -rc3, -rc4 and -rc6)
>>
>> Apart from the patches related to the SiI register HOST_CTRL_MSIACK
>> (that did not fix the problem) I have the feeling, that I'm not one
>> step further to any fix.
>>
>> Is this a bug in the MSI-enable code in sata_sil24?
>> Is this a bug in the MSI code in libata?
>> Is this a bug in the IRQ system?
>> Is this a bug in the x86 apic code?
>
> There are primarily two issues you reported.
>
> One is the spurious interrupt issue (for which you see "no irq handler
> for vector messages). From your experimental results you verified that
> this problem doesn't happen in physical apic mode. This shows that there
> is some problem with the way this HW subsystem (involving sata_sil24)
> handles logical mode. Most likely some bug either in the sata_sil24 or
> in the platform paths (bridges etc) handling the sata_sil24 interrupts
> (as you say, other devices work fine with MSI on this platform).

Yes, I understand that this message is more a symptom then the cause.
But it was the only error message I had, as the sata timeouts also
look more like symptoms from a missing interrupt then a real error in
the ATA request or response.
So I hoped that with this error and the vector number 165 that was
strangely constant it would be possible to trace this to what causes
the interrrupts to go missing or misrouted.

> And the second problem is the sata timeouts (which happen irrespective
> of the above spurious interrupts). It looks like interrupts are dropped
> (which might be the reason why your ERR count -- apic error count --
> increases).

But as I never hat and error about the dropped interrupts, I didn't
have anything to look for further clues.

Thanks to your hint about smp_error_interrupt, I redid the read- and
write-tests with 2.6.33-rc8 and got these additional messages:

(Short topology info about the system: It is a 2-socket-NUMA, each
socket with a dual core opteron. CPU0+CPU1 should be the first socket
that is connected via hyper-transport to the MCP55. The second cpu
(CPU2+CPU3) is only attached to the first cpu, not directly to the
chipset)

write-test:
[   55.228997] XFS mounting filesystem sdb2
[   55.351787] Starting XFS recovery on filesystem: sdb2 (logdev: internal)
[   55.390223] Ending XFS recovery on filesystem: sdb2 (logdev: internal)
-> test filesystem mounted, I start the writing for /dev/zero to a
scratch file via dd
[   95.026546] APIC error on CPU0: 00(08)
[   95.026559] APIC error on CPU1: 00(08)
[   95.030385] APIC error on CPU1: 08(08)
[   95.034211] APIC error on CPU1: 08(08)
[   95.030007] APIC error on CPU0: 08(08)
-> interrupt gets lost
[  125.950064] ata2.00: exception Emask 0x0 SAct 0x7c000fff SErr 0x0
action 0x6 frozen
[  125.962292] ata2.00: failed command: WRITE FPDMA QUEUED
-> libata times out

read-test:
[   65.576434] XFS mounting filesystem sdb2
[   65.696894] Starting XFS recovery on filesystem: sdb2 (logdev: internal)
[   65.729396] Ending XFS recovery on filesystem: sdb2 (logdev: internal)
-> test filesystem mounted, I start reading a file to /dev/null via dd
[   86.361071] APIC error on CPU0: 00(08)
[   86.361079] APIC error on CPU1: 00(08)
[   86.362541] APIC error on CPU1: 08(08)
[   86.363562] APIC error on CPU1: 08(08)
-> interupt gets lost
[   86.364603] do_IRQ: 2.165 No irq handler for vector (irq -1)
[   86.364613] do_IRQ: 1.165 No irq handler for vector (irq -1)
[   86.364628] do_IRQ: 3.165 No irq handler for vector (irq -1)
-> ??? during the write test the APIC errors did not result in
suprious interrupts...
[   86.371063] APIC error on CPU0: 08(08)
[   86.371063] do_IRQ: 0.165 No irq handler for vector (irq -1)
[  117.040055] ata2.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
[  117.052198] ata2.00: failed command: READ FPDMA QUEUED
-> libata times out
[snip]
-> libatas error handler tries to fix it:
[  117.140359] ata2: hard resetting link
[  119.340055] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  119.345013] do_IRQ: 3.165 No irq handler for vector (irq -1)
[  119.345024] do_IRQ: 1.165 No irq handler for vector (irq -1)
[  119.345038] do_IRQ: 0.165 No irq handler for vector (irq -1)
[  119.345049] do_IRQ: 2.165 No irq handler for vector (irq -1)
-> first try loses the interrupt via do_IRQ
[  124.340036] ata2.00: qc timeout (cmd 0xec)
[  124.348502] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  124.358887] ata2.00: revalidation failed (errno=-5)
-> revalidation fails, error handler tries again:
[  124.367937] ata2: hard resetting link
[  126.560054] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  126.565014] APIC error on CPU1: 08(48)
[  126.565021] APIC error on CPU0: 08(48)
[  126.565031] APIC error on CPU2: 00(40)
[  126.565038] APIC error on CPU3: 00(40)
-> but this time it fails in the APIC? On all CPU, not only 0+1?
[  136.560036] ata2.00: qc timeout (cmd 0xec)
[  136.567602] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  136.577016] ata2.00: revalidation failed (errno=-5)
-> revalidation still stuck, next try with lower speed
[  136.585140] ata2: limiting SATA link speed to 1.5 Gbps
[  136.593535] ata2: hard resetting link
[  138.780049] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  138.785001] APIC error on CPU0: 48(08)
[  138.785005] APIC error on CPU1: 48(08)
[  138.785089] APIC error on CPU1: 08(08)
[  138.785114] ata2.00: failed to read native max address (err_mask=0x1)
[  138.785118] ata2.00: HPA support seems broken, skipping HPA handling
[  138.825683] APIC error on CPU0: 08(08)
-> diffenent APIC error, this time like the original read error on CPU0+1
[  143.780029] ata2.00: qc timeout (cmd 0xef)
[  143.787523] ata2.00: failed to set xfermode (err_mask=0x4)
[  143.796412] ata2.00: disabled
[  143.802753] ata2.00: device reported invalid CHS sector 0
-> libata switches off, does not try a fourth IDENTIFY

If I'm reading the comment in smp_error_interrupt right, this would
mean there is a "Receive accept error" in the APIC.
But only after each CPU gets two! errors from do_IRQ the flag for
"Received illegal vector" gets triggered?

Something strange in the irq-cpu-affinity?
(The test installation where I ran these tests does not have
irqbalance installed...)

> Based on your experimental results, we can say that it is not the bug
> with x86 apic code and irq subsystem.

For my experiments I only see that sata_sil24 and sata_nv sometimes
lose interrupts in MSI mode, while tg3, hda-intel and radeon do not.
But I don't see a real pattern to pinpoint a cause.

Both the tg3's and the sata_sil24 are onboard chips that are connected
to PCIe links from the MCP55.
Both the onboard audio (driven by hda-intel) and the sata_nv-ports are
part of the chipset itself.
That would suggest that neither the PCIe bridge nor the chipset itself
is to blame.
And as the system without MSI is perfectly stable, I also can't blame
the cableling or the hard drives.

But when I looked into the code from tg3,radeon and sata_sil24 about
the MSI enables I also did not see any fundamental differences. All
just seemed to call pci_enable_msi()...
That would point in the direction of the common code: libata or irq system.
And as I can't see anything MSI related in the libata core, my prime
suspect is this still something weird with the irq system.

I'm willing to investigate this further, but I lack the needed
background information about how innards of the IO-APIC and the other
involved parts work...

>> Is this a hardware bug in the SiI 3132?
>> Is this a hardware bug in the MCP55?
>> Is this a fatal bug or does it just need the right quirk?
>>
>> What should I do now?
>> Keep posting that it's still broken at each -rc?
>> Open a bug at bugzilla.kernel.org? Against what subsytem?
>> Should I just not use the sata_sil.msi=1 commandline?
>
> You should n't use that command line as your experiments showed that
> sata_sil msi mode is clearly broken on this platform and perhaps report
> the issue to the HW vendor (you should include in that report, the
> spurious vector 165 that you see in logical mode and also the apic error
> you see -- you can enable debug to see the error message that gets
> printed in smp_error_interrupt() for this --)

OK, the easy "solution" for me would be to just ignore this new MSI
support for sata_sil24.
But should the kernel have a commandline option
"randomly_disconnect_harddrives_and_lose_unwritten_data"?

Torsten
