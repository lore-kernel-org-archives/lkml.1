Return-Path: <linux-kernel-owner+w=401wt.eu-S1764545AbYFFG1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764545AbYFFG1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYFFG1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:27:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:46420 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYFFG1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u+e3c3nmfjWgEyz2GizmhYrYJp8rxr1G6yNjOHAzZnE7GH1Bf69CMQFC54DMYPbBoi
         jTkB+2Wz4ud8rmLgMIgK19DSH59KOtClHX/hD+hEv5WTLboWmQSlH8geeC7SlOCHs5IQ
         C2Vdc7in8TSGadPbPATiHuqlmqH40m2wy18pI=
Message-ID: <86802c440806052327v14428d4dhf54e13874c1f0a5a@mail.gmail.com>
Date: Thu, 5 Jun 2008 23:27:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] x86: make generic arch support NUMAQ v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080606061744.GA6399@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806050309.11197.yhlu.kernel@gmail.com>
	 <200806051714.54932.yhlu.kernel@gmail.com>
	 <86802c440806051754l5c921437o15ab12882f42a25d@mail.gmail.com>
	 <20080606061744.GA6399@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 11:17 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Jun 05, 2008 at 05:54:40PM -0700, Yinghai Lu wrote:
>> On Thu, Jun 5, 2008 at 5:14 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >
>> > so it could fallback to normal numa.
>> >
>> > NUMAQ depends on GENERICARCH
>> >
>> > also decouple genericarch numa with acpi.
>> >
>> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> >
>> > Index: linux-2.6/arch/x86/Kconfig
>> > ===================================================================
>> > --- linux-2.6.orig/arch/x86/Kconfig
>> > +++ linux-2.6/arch/x86/Kconfig
>> > @@ -264,17 +264,6 @@ config X86_VOYAGER
>> >          If you do not specifically know you have a Voyager based machine,
>> >          say N here, otherwise the kernel you build will not be bootable.
>> >
>> > -config X86_NUMAQ
>> > -       bool "NUMAQ (IBM/Sequent)"
>> > -       depends on SMP && X86_32 && PCI
>> > -       select NUMA
>> > -       help
>> > -         This option is used for getting Linux to run on a (IBM/Sequent) NUMA
>> > -         multiquad box. This changes the way that processors are bootstrapped,
>> > -         and uses Clustered Logical APIC addressing mode instead of Flat Logical.
>> > -         You will need a new lynxer.elf file to flash your firmware with - send
>> > -         email to <Martin.Bligh@us.ibm.com>.
>> > -
>> >  config X86_SUMMIT
>> >        bool "Summit/EXA (IBM x440)"
>> >        depends on X86_32 && SMP
>> > @@ -307,12 +296,12 @@ config X86_VISWS
>> >          and vice versa. See <file:Documentation/sgi-visws.txt> for details.
>> >
>> >  config X86_GENERICARCH
>> > -       bool "Generic architecture (Summit, bigsmp, ES7000, default)"
>> > +       bool "Generic architecture (NUMAQ, Summit, bigsmp, ES7000, default)"
>> >        depends on X86_32
>> >        help
>> > -          This option compiles in the Summit, bigsmp, ES7000, default subarchitectures.
>> > -         It is intended for a generic binary kernel.
>> > -         If you want a NUMA kernel, select ACPI.   We need SRAT for NUMA.
>> > +          This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
>> > +         subarchitectures.  It is intended for a generic binary kernel.
>> > +         You need enable NUMA, otherwise NUMAQ is skipped.
>> >
>> >  config X86_ES7000
>> >        bool "Support for Unisys ES7000 IA32 series"
>> > @@ -348,6 +337,17 @@ config X86_VSMP
>> >
>> >  endchoice
>> >
>> > +config X86_NUMAQ
>> > +       bool "NUMAQ (IBM/Sequent)"
>> > +       depends on SMP && X86_32 && PCI && X86_GENERICARCH
>> > +       select NUMA
>> > +       help
>> > +         This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
>> > +         NUMA multiquad box. This changes the way that processors are
>> > +         bootstrapped, and uses Clustered Logical APIC addressing mode instead
>> > +         of Flat Logical.  You will need a new lynxer.elf file to flash your
>> > +         firmware with - send email to <Martin.Bligh@us.ibm.com>.
>> > +
>> >  config SCHED_NO_NO_OMIT_FRAME_POINTER
>> >        def_bool y
>> >        prompt "Single-depth WCHAN output"
>> > @@ -908,9 +908,9 @@ config X86_PAE
>> >  config NUMA
>> >        bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
>> >        depends on SMP
>> > -       depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL)
>> > +       depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_GENERICARCH || X86_SUMMIT && ACPI) && EXPERIMENTAL)
>> >        default n if X86_PC
>> > -       default y if (X86_NUMAQ || X86_SUMMIT)
>> > +       default y if (X86_NUMAQ || X86_SUMMIT || X86_GENERICARCH)
>> >        help
>> >          Enable NUMA (Non Uniform Memory Access) support.
>> >          The kernel will try to allocate memory used by a CPU on the
>>
>> Sam,
>>
>> now NUMAQ depends on GENERICARCH.
>>
>> and Ingo want to make oldconfig to migration NUMAQ....to select GENERICARCH...
>>
>> but if i add select X86_GENERICARCH, make oldconfig will get
>
> It is my understanding that special support for NUMAQ should die,
> so the only remaning usage of CONFIG_NUMAQ is if set to select GENERICARCH.
> In other words that you should not use CONFIG_NUMAQ anywhere in the code
> but solely rely on GENERICARCH and then do runtime detection of the
> other things.

in case someone don't want to build that special numaq code in.

I think we should make ES7000, Summit depend to GENERICARCH too.

YH
