Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbYFFAyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbYFFAyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 20:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYFFAyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 20:54:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:61747 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYFFAyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 20:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qOvGEW2EjnXHHsvYPgxTMXblehz0ii/C9b7/z/AXHBIC48+0H7mBmHEApC4iszPtnO
         LWVq6ZwIVqn9AQ5OquvbWaMQYkZWDx/3MOB7kmPbpOD+YF/BuvlgXy8KTnh4lEdMS327
         BB1G2Ixe1m6djYZeTRo7DVt0wYWxhqP7G9QQI=
Message-ID: <86802c440806051754l5c921437o15ab12882f42a25d@mail.gmail.com>
Date: Thu, 5 Jun 2008 17:54:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] x86: make generic arch support NUMAQ v2
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806051714.54932.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806050309.11197.yhlu.kernel@gmail.com>
	 <200806051714.54932.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 5:14 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> so it could fallback to normal numa.
>
> NUMAQ depends on GENERICARCH
>
> also decouple genericarch numa with acpi.
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -264,17 +264,6 @@ config X86_VOYAGER
>          If you do not specifically know you have a Voyager based machine,
>          say N here, otherwise the kernel you build will not be bootable.
>
> -config X86_NUMAQ
> -       bool "NUMAQ (IBM/Sequent)"
> -       depends on SMP && X86_32 && PCI
> -       select NUMA
> -       help
> -         This option is used for getting Linux to run on a (IBM/Sequent) NUMA
> -         multiquad box. This changes the way that processors are bootstrapped,
> -         and uses Clustered Logical APIC addressing mode instead of Flat Logical.
> -         You will need a new lynxer.elf file to flash your firmware with - send
> -         email to <Martin.Bligh@us.ibm.com>.
> -
>  config X86_SUMMIT
>        bool "Summit/EXA (IBM x440)"
>        depends on X86_32 && SMP
> @@ -307,12 +296,12 @@ config X86_VISWS
>          and vice versa. See <file:Documentation/sgi-visws.txt> for details.
>
>  config X86_GENERICARCH
> -       bool "Generic architecture (Summit, bigsmp, ES7000, default)"
> +       bool "Generic architecture (NUMAQ, Summit, bigsmp, ES7000, default)"
>        depends on X86_32
>        help
> -          This option compiles in the Summit, bigsmp, ES7000, default subarchitectures.
> -         It is intended for a generic binary kernel.
> -         If you want a NUMA kernel, select ACPI.   We need SRAT for NUMA.
> +          This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
> +         subarchitectures.  It is intended for a generic binary kernel.
> +         You need enable NUMA, otherwise NUMAQ is skipped.
>
>  config X86_ES7000
>        bool "Support for Unisys ES7000 IA32 series"
> @@ -348,6 +337,17 @@ config X86_VSMP
>
>  endchoice
>
> +config X86_NUMAQ
> +       bool "NUMAQ (IBM/Sequent)"
> +       depends on SMP && X86_32 && PCI && X86_GENERICARCH
> +       select NUMA
> +       help
> +         This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
> +         NUMA multiquad box. This changes the way that processors are
> +         bootstrapped, and uses Clustered Logical APIC addressing mode instead
> +         of Flat Logical.  You will need a new lynxer.elf file to flash your
> +         firmware with - send email to <Martin.Bligh@us.ibm.com>.
> +
>  config SCHED_NO_NO_OMIT_FRAME_POINTER
>        def_bool y
>        prompt "Single-depth WCHAN output"
> @@ -908,9 +908,9 @@ config X86_PAE
>  config NUMA
>        bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
>        depends on SMP
> -       depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL)
> +       depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_GENERICARCH || X86_SUMMIT && ACPI) && EXPERIMENTAL)
>        default n if X86_PC
> -       default y if (X86_NUMAQ || X86_SUMMIT)
> +       default y if (X86_NUMAQ || X86_SUMMIT || X86_GENERICARCH)
>        help
>          Enable NUMA (Non Uniform Memory Access) support.
>          The kernel will try to allocate memory used by a CPU on the

Sam,

now NUMAQ depends on GENERICARCH.

and Ingo want to make oldconfig to migration NUMAQ....to select GENERICARCH...

but if i add select X86_GENERICARCH, make oldconfig will get

> make ARCH=i386 oldconfig
scripts/kconfig/conf -o arch/x86/Kconfig
arch/x86/Kconfig:299:error: found recursive dependency:
X86_GENERICARCH -> X86_NUMAQ -> X86_GENERICARCH -> <choice>
make[1]: *** [oldconfig] Error 1
make: *** [oldconfig] Error 2

YH
