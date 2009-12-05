Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbZLEB0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbZLEB0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 20:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932713AbZLEB0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 20:26:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45755 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703AbZLEB0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 20:26:13 -0500
Message-ID: <4B19B680.9050700@zytor.com>
Date: Fri, 04 Dec 2009 17:25:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86: Call __va() to get trampoline_base.
References: <b9df5fa10912040826s52e82f2cpd53604835be50c27@mail.gmail.com>
In-Reply-To: <b9df5fa10912040826s52e82f2cpd53604835be50c27@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 08:26 AM, Rakib Mullick wrote:
>  x86, tboot: Call __va() to get trampoline_base.
> 
>  Do not pass trampoline_base as parameter of virt_to_phys.
> Because trampoline_base is in .cpuinit.data section, but its
> called from non-cpuinit function. So use __va(TRAMPOLINE_BASE)
> instead of trampoline_base, which helps to fix section mismatch.
> 
> We were warned by the following warning:
> 
>   LD      arch/x86/kernel/built-in.o
> WARNING: arch/x86/kernel/built-in.o(.text+0x13c5f): Section mismatch
> in reference from the function tboot_setup_sleep() to the variable
> .cpuinit.data:trampoline_base
> The function tboot_setup_sleep() references
> the variable __cpuinitdata trampoline_base.
> This is often because tboot_setup_sleep lacks a __cpuinitdata
> annotation or the annotation of trampoline_base is wrong.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

This is a bug, but this isn't the right fix.

trampoline.c has:

#if defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
#define __trampinit
#define __trampinitdata
#else
#define __trampinit __cpuinit
#define __trampinitdata __cpuinitdata
#endif

... because on i386 we don't use the trampoline for ACPI return.

This means one of these is true:

- Either we need the AP trampoline for tboot on i386, and the above
definition in trampoline.c needs to be fixed; or
- The CONFIG_X86_TRAMPOLINE in tboot.c is too generous, and in fact it
needs to be set to defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
just like the above code.

Sending to Joseph and Shane to figure out...

	-hpa
