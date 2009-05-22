Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZEVIWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZEVIWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZEVIWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:22:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42015 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZEVIWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:22:05 -0400
Message-ID: <4A1660A1.20909@jp.fujitsu.com>
Date: Fri, 22 May 2009 17:21:53 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [x86] [MCE] Updated 32bit merge for tip x86 mce2 branch
References: <20090519215631.GA15626@basil.nowhere.org>
In-Reply-To: <20090519215631.GA15626@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The following changes since commit dd9869965a301d0f35e32c42eb87d5f94883443a:
>   Ingo Molnar (1):
>         x86, mce: print number of MCE banks
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce-32bit-merge
> 
> Andi Kleen (20):
>       x86: MCE: Make mce_amd_64.c compile again
>       Revert "x86, mce: Add mce=nopoll option to disable timer polling"
>       x86: MCE: Move ifdef X86_64 to the beginning of the file
>       x86: MCE: Initial steps to make 64bit mce code 32bit clean
>       x86: MCE: Implement the PPro bank 0 quirk in the 64bit machine check code
>       x86: MCE: Port K7 bank 0 quirk to 64bit mce code
>       x86: MCE: Use a call vector to call the 64bit mce handler
>       x86: MCE: Rename 64bit mce_dont_init to mce_disabled
>       x86: MCE: Move mce_disabled option into common 64bit/64bit code
>       x86: MCE: Remove machine check handler idle notify on 64bit
>       x86: MCE: Remove oops_begin() use in 64bit machine check
>       x86: MCE: Remove unused stop/restart_mce on 32bit
>       x86: MCE: Use 64bit machine check code on 32bit
>       x86: MCE: Deprecate old 32bit machine check code
>       x86: MCE: Enable MCE_INTEL for 32bit new MCE
>       x86: MCE: Enable MCE_AMD for 32bit NEW_MCE
>       x86: MCE: Document new 32bit mcelog requirement in Documentation/Changes
>       Export add_timer_on for modules
>       x86: MCE: Add MSR read wrappers for easier error injection
>       x86: MCE: Add basic error injection infrastructure

I reviewed them again...

#####

[1]: in x86: MCE: Deprecate old 32bit machine check code

> @@ -1,4 +1,4 @@
> -The following is a list of files and features that are going to be
> +he following is a list of files and features that are going to be
>  removed in the kernel source tree.  Every entry should contain what
>  exactly is going away, why it is happening, and who is going to be doing
>  the work.  When the feature is removed from the kernel, it should also

Is it necessary?

#####

[2]: in x86: MCE: Enable MCE_INTEL for 32bit new MCE

> @@ -88,12 +88,13 @@
>  #define THERMAL_APIC_VECTOR            0xfa
> 
>  #ifdef CONFIG_X86_32
> -/* 0xf8 - 0xf9 : free */
> +/* 0xf9 : free */
>  #else
> -# define THRESHOLD_APIC_VECTOR         0xf9
>  # define UV_BAU_MESSAGE                        0xf8
>  #endif
> 
> +#define THRESHOLD_APIC_VECTOR          0xf9
> +
>  /* f0-f7 used for spreading out TLB flushes: */
>  #define INVALIDATE_TLB_VECTOR_END      0xf7
>  #define INVALIDATE_TLB_VECTOR_START    0xf0

"/* 0xf8 : free :/" ?

And please place vectors in numerical order, like: 

>  #define THERMAL_APIC_VECTOR            0xfa
> +#define THRESHOLD_APIC_VECTOR          0xf9
> 
>  #ifdef CONFIG_X86_32
> -/* 0xf8 - 0xf9 : free */
> +/* 0xf8 : free */
>  #else
> -# define THRESHOLD_APIC_VECTOR         0xf9
>  # define UV_BAU_MESSAGE                        0xf8
>  #endif
> 
>  /* f0-f7 used for spreading out TLB flushes: */

#####

[3]: in x86: MCE: Add basic error injection infrastructure

> @@ -744,6 +778,7 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
>         mce_cpu_features(c);
>         mce_init_timer();
>  }
> +EXPORT_SYMBOL_GPL(do_machine_check);
> 
>  /*
>   * Character device to read and clear the MCE log.
> @@ -870,6 +905,7 @@ timeout:
> 
>         return err ? -EFAULT : buf - ubuf;
>  }
> +EXPORT_SYMBOL_GPL(mce_notify_user);
> 
>  static unsigned int mce_poll(struct file *file, poll_table *wait)
>  {

These EXPORT_SYMBOL_GPLs are located in wrong place.

#####

[trivial]: in x86: MCE: Use 64bit machine check code on 32bit

> @@ -793,6 +809,15 @@ config X86_MCE_AMD
>            Additional support for AMD specific MCE features such as
>            the DRAM Error Threshold.
> 
> +config X86_ANCIENT_MCE
> +       def_bool n
> +       depends on X86_32
> +       prompt "Support for old Pentium 5 / WinChip machine checks"
> +       help
> +         Include support for machine check handling on old Pentium 5 or WinChip
> +        systems. These typically need to be enabled explicitely on the command
> +        line.
> +
>  config X86_MCE_THRESHOLD
>         depends on X86_MCE_AMD || X86_MCE_INTEL
>         bool

It would be better to use "---help---" instead of "help".

And also it would be better to clean trailing spaces and spaces before tabs etc.,
that can be seen here and there.


Thanks,
H.Seto

