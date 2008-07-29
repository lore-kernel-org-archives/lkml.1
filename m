Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYG2Uhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYG2Uhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYG2Uhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:37:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:8753 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYG2Uhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PqZBaL7yZx18dZNZ27fxP8QzircnLgkXFJxU0OuUx6jSEkcAVQf9VtdDOif4t+DcPk
         64Zzh548JHzmrclQHrndf3x9wgZYDp61sDiy+lQYDPMNRUeY+vPOZ+aCwc2YGocdxujL
         vM8HuZWFYrB2JhYQzdxzZBrB67YCO3t36PPbE=
Message-ID: <86802c440807291337u7dda53e0s8f36cfaa5277f793@mail.gmail.com>
Date: Tue, 29 Jul 2008 13:37:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, "Mike Travis" <travis@sgi.com>
In-Reply-To: <m1d4kwbg8f.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	 <86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	 <86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	 <m1d4kwbg8f.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 1:14 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
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
>>>
>>> can you boot with "debug apic=verbose pci=routeirq"?
>>
>> please try attached patch
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

x3950 has 8 ioapic
ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 15, version 0, address 0xfec00000, GSI 0-35
ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[36])
IOAPIC[1]: apic_id 14, version 0, address 0xfec01000, GSI 36-71
ACPI: IOAPIC (id[0x0d] address[0xfec02000] gsi_base[72])
IOAPIC[2]: apic_id 13, version 0, address 0xfec02000, GSI 72-107
ACPI: IOAPIC (id[0x0c] address[0xfec03000] gsi_base[108])
IOAPIC[3]: apic_id 12, version 0, address 0xfec03000, GSI 108-143
ACPI: IOAPIC (id[0x0b] address[0xfec04000] gsi_base[144])
IOAPIC[4]: apic_id 11, version 0, address 0xfec04000, GSI 144-179
ACPI: IOAPIC (id[0x0a] address[0xfec05000] gsi_base[180])
IOAPIC[5]: apic_id 10, version 0, address 0xfec05000, GSI 180-215
ACPI: IOAPIC (id[0x09] address[0xfec06000] gsi_base[216])
IOAPIC[6]: apic_id 9, version 0, address 0xfec06000, GSI 216-251
ACPI: IOAPIC (id[0x08] address[0xfec07000] gsi_base[252])
IOAPIC[7]: apic_id 8, version 0, address 0xfec07000, GSI 252-287

that is crazy.  I only played that kind of layout in SimNow.

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

good.
wonder if you can make 32bit support same vector on different cpu
support different irq.
or not needed.
also we should dump the irq balance on 32 bit kernel.

YH
