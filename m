Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0BMSWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:22:20 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:33193 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0BMSWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:22:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Xtc5EQh1QL6TB97CY04qEOTR9FBXxlqtvWP1O2wHgb6tRY9LQ9T4cXtjDwiuIRP+ar
         Q2K+J0W3BmEq6831JIBwFizsf3MV4rRs73z5aPH7LDJiLJ3FkWjqGBgIKVPJRXC4fDj6
         i+l1Bzcegl21t+lzPTPANNLctGsC2xdbEV5jY=
MIME-Version: 1.0
In-Reply-To: <1266085107.2677.37.camel@sbs-t61>
References: <64bb37e1001310502p3d74bdf5ve56f63d3e8d2fd39@mail.gmail.com>
	 <4B679042.2010008@kernel.org> <m1r5p4grvg.fsf@fess.ebiederm.org>
	 <1265136022.2793.33.camel@sbs-t61.sc.intel.com>
	 <64bb37e1002021156s6e8e3ba7p6192e15bc431eb87@mail.gmail.com>
	 <64bb37e1002130125r7013832brc9b3b695daaf6f91@mail.gmail.com>
	 <1266085107.2677.37.camel@sbs-t61>
Date: Sat, 13 Feb 2010 12:22:18 -0600
Message-ID: <51f3faa71002131022t5e77dfe3w61ab840537fc63fe@mail.gmail.com>
Subject: Re: do_IRQ: 0.165 No irq handler for vector (irq -1)
From: Robert Hancock <hancockrwd@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 12:18 PM, Suresh Siddha
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
>
> And the second problem is the sata timeouts (which happen irrespective
> of the above spurious interrupts). It looks like interrupts are dropped
> (which might be the reason why your ERR count -- apic error count --
> increases).
>
> Based on your experimental results, we can say that it is not the bug
> with x86 apic code and irq subsystem.
>
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

Since the MCP55 onboard controller also fails, this seems rather like
a chipset problem. Maybe some of the PCI-E links spuriously fail MSI
sometimes? Does anyone have any good chipset contacts at NVIDIA these
days? Peer Chen was CCed on the Bugzilla report, but didn't respond.
