Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbZDKHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbZDKHoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZDKHoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:44:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:27126 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbZDKHoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:44:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hy8hoLNiE0nLZlEl8Wx4mqReN1TqQ0vAUw4DQfI2iYlEbMSjKcYZjmNpmfkd2QW2L7
         QA2LSPbtn1AbUOD6y/drxx8ImWvm9T+/TVo+vZ/R7aY3nuyZm/OAkB46Gb02KZWcLX4u
         vpRGaTy0cUA++npAScCGHLOED2GKC5/QQg5xU=
MIME-Version: 1.0
In-Reply-To: <m1tz4wcgm8.fsf@fess.ebiederm.org>
References: <20090408210735.GD11159@us.ibm.com>
	 <m1r601fg9l.fsf@fess.ebiederm.org> <20090410200919.GA7242@us.ibm.com>
	 <m1tz4wcgm8.fsf@fess.ebiederm.org>
Date: Sat, 11 Apr 2009 00:44:01 -0700
Message-ID: <86802c440904110044t7a932c41w95c32de1acaf7c5@mail.gmail.com>
Subject: Re: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered 
	inactive device IRQ interrruption
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Gary Hade <garyhade@us.ibm.com>, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 3:02 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
>
>> On Thu, Apr 09, 2009 at 06:29:10PM -0700, Eric W. Biederman wrote:
>>> Gary Hade <garyhade@us.ibm.com> writes:
>>>
>>> > Impact: Eliminates a race that can leave the system in an
>>> >         unusable state
>>> >
>>> > During rapid offlining of multiple CPUs there is a chance
>>> > that an IRQ affinity move destination CPU will be offlined
>>> > before the IRQ affinity move initiated during the offlining
>>> > of a previous CPU completes.  This can happen when the device
>>> > is not very active and thus fails to generate the IRQ that is
>>> > needed to complete the IRQ affinity move before the move
>>> > destination CPU is offlined.  When this happens there is an
>>> > -EBUSY return from __assign_irq_vector() during the offlining
>>> > of the IRQ move destination CPU which prevents initiation of
>>> > a new IRQ affinity move operation to an online CPU.  This
>>> > leaves the IRQ affinity set to an offlined CPU.
>>> >
>>> > I have been able to reproduce the problem on some of our
>>> > systems using the following script.  When the system is idle
>>> > the problem often reproduces during the first CPU offlining
>>> > sequence.
>>>
>>> You appear to be focusing on the IBM x460 and x3835.
>>
>> True.  I have also observed IRQ interruptions on an IBM x3950 M2
>> which I believe, but am not certain, were due to the other
>> "I/O redirection table register write with Remote IRR bit set"
>> caused problem.
>>
>> I intend to do more testing on the x3950 M2 and other
>> IBM System x servers but I unfortunately do not currently
>> have access to any Intel based non-IBM MP servers.  I was
>> hoping that my testing request might at least get some
>> others interested in running the simple test script on their
>> systems and reporting their results.  Have you perhaps tried
>> the test on any of the Intel based MP systems that you have
>> access to?
>>
>>> Can you describe
>>> what kind of interrupt setup you are running.
>>
>> Being somewhat of a ioapic neophyte I am not exactly sure
>> what you are asking for here.  This is ioapic information
>> logged during boot if that helps at all.
>> x3850:
>>     ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
>>     IOAPIC[0]: apic_id 15, version 0, address 0xfec00000, GSI 0-35
>>     ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[36])
>>     IOAPIC[1]: apic_id 14, version 0, address 0xfec01000, GSI 36-71
>> x460:
>>     ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
>>     IOAPIC[0]: apic_id 15, version 17, address 0xfec00000, GSI 0-35
>>     ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[36])
>>     IOAPIC[1]: apic_id 14, version 17, address 0xfec01000, GSI 36-71
>>     ACPI: IOAPIC (id[0x0d] address[0xfec02000] gsi_base[72])
>>     IOAPIC[2]: apic_id 13, version 17, address 0xfec02000, GSI 72-107
>>     ACPI: IOAPIC (id[0x0c] address[0xfec03000] gsi_base[108])
>>     IOAPIC[3]: apic_id 12, version 17, address 0xfec03000, GSI 108-143
>
> Sorry.  My real question is which mode you are running the ioapics in.
>

looks like ack_level_irq.

YH
