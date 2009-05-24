Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZEXAY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZEXAY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 20:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZEXAYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 20:24:51 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:51499 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZEXAYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 20:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pmrqCV0RgKLHuNlOsJuT9urXXs5pX4d1MVRR/sNxnWjiJvwn545GwldT/VvSTUk7qy
         yXZHo1VhesQzjTFP4s5Zg09+jWuy3OPF5ZS7sruhozaEEtG+rPOZGaRCQnpxkl4IOvA4
         bqTtsXqB/Muzy44UKjzP+gETq4eNY8KHDGNU4=
MIME-Version: 1.0
In-Reply-To: <m13abr2w0a.fsf@fess.ebiederm.org>
References: <20090408210745.GE11159@us.ibm.com>
	 <86802c440904102346lfbc85f2w4508bded0572ec58@mail.gmail.com>
	 <20090413193717.GB8393@us.ibm.com> <m1bpr0e2au.fsf@fess.ebiederm.org>
	 <20090428000536.GA7347@us.ibm.com> <m1bpqhjco7.fsf@fess.ebiederm.org>
	 <20090429004451.GA7329@us.ibm.com> <m1eivc9qsn.fsf@fess.ebiederm.org>
	 <20090429171719.GA7385@us.ibm.com> <m13abr2w0a.fsf@fess.ebiederm.org>
Date: Sat, 23 May 2009 17:24:51 -0700
Message-ID: <86802c440905231724w6f5f3e04w424fc58dfe188c1@mail.gmail.com>
Subject: Re: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered 
	active device IRQ interrruption
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

On Wed, Apr 29, 2009 at 10:46 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
>
>>
>> So, I just rebuilt after _really_ applying the patch and got
>> the following result which probably to be what you intended.
>
> Ok.  Good to see.
>
>>> >> I propose detecting thpe cases that we know are safe to migrate in
>>> >> process context, aka logical deliver with less than 8 cpus aka "flat"
>>> >> routing mode and modifying the code so that those work in process
>>> >> context and simply deny cpu hotplug in all of the rest of the cases.
>>> >
>>> > Humm, are you suggesting that CPU offlining/onlining would not
>>> > be possible at all on systems with >8 logical CPUs (i.e. most
>>> > of our systems) or would this just force users to separately
>>> > migrate IRQ affinities away from a CPU (e.g. by shutting down
>>> > the irqbalance daemon and writing to /proc/irq/<irq>/smp_affinity)
>>> > before attempting to offline it?
>>>
>>> A separate migration, for those hard to handle irqs.
>>>
>>> The newest systems have iommus that irqs go through or are using MSIs
>>> for the important irqs, and as such can be migrated in process
>>> context.  So this is not a restriction for future systems.
>>
>> I understand your concerns but we need a solution for the
>> earlier systems that does NOT remove or cripple the existing
>> CPU hotplug functionality.  If you can come up with a way to
>> retain CPU hotplug function while doing all IRQ migration in
>> interrupt context I would certainly be willing to try to find
>> some time to help test and debug your changes on our systems.
>
> Well that is ultimately what I am looking towards.
>
> How do we move to a system that works by design, instead of
> one with design goals that are completely conflicting.
>
> Thinking about it, we should be able to preemptively migrate
> irqs in the hook I am using that denies cpu hotplug.
>
> If they don't migrate after a short while I expect we should
> still fail but that would relieve some of the pain, and certainly
> prevent a non-working system.
>
> There are little bits we can tweak like special casing irqs that
> no-one is using.
>
> My preference here is that I would rather deny cpu hotplug unplug than
> have the non-working system problems that you have seen.

and use delay work to offline cpu later after irq get moved to other cpu?

YH
