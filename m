Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXDBIol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXDBIol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 04:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbXDBIol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 04:44:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37177 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXDBIok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 04:44:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: vgoyal@in.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Jurriaan <thunder7@xs4all.nl>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
	<20070331071220.GA26910@aitel.hist.no>
	<20070331005303.354411f0.akpm@linux-foundation.org>
	<20070401052932.GA9894@amd64.of.nowhere>
	<m1ircghb6w.fsf@ebiederm.dsl.xmission.com>
	<20070331232957.e1c93f19.akpm@linux-foundation.org>
	<20070402074159.GA13704@in.ibm.com>
Date: Mon, 02 Apr 2007 02:43:56 -0600
In-Reply-To: <20070402074159.GA13704@in.ibm.com> (Vivek Goyal's message of
	"Mon, 2 Apr 2007 13:11:59 +0530")
Message-ID: <m1abxrf9o3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:

> On Sat, Mar 31, 2007 at 11:29:57PM -0700, Andrew Morton wrote:
>> On Sun, 01 Apr 2007 00:15:51 -0600 ebiederm@xmission.com (Eric W. Biederman)
> wrote:
>> 
>> > Does anyone know how to express the constraint of a 2M aligned number in
> Kconfig?
>> 
>> Nope, but we could make CONFIG_PHYSICAL_START be in units of 2MB, which
>> would be a bit hard to use.
>> 
>> Adding a BUILD_BUG_ON which checks this constraint might help.  Plus a
>> useful comment right at the BUILD_BUG_ON site explaining what to do about
>> it.
>
> How about attached patch?

Looks like that will work.

Vivek.  If I can get the x86_64 vmlinux to have type ET_DYN (to mark
it as relocatable) is there any reason to keep CONFIG_PHYSICAL_START?
I think I can switch the vmlinux header type in about 100 lines or so
of code.  Assuming I can ever get 30 minutes with the appropriate
kernel.

> Thanks
> Vivek
>
>
>
> o X86_64 kernel should run from 2MB aligned address for two reasons.
> 	- Performance.
> 	- For relocatable kernels, page tables are updated based on difference
> 	  between compile time address and load time physical address.
> 	  This difference should be multiple of 2MB as kernel text and data
> 	  is mapped using 2MB pages and PMD should be pointing to a 2MB
> 	  aligned address. Life is simpler if both compile time and load time
> 	  kernel addresses are 2MB aligned.
>
> o Flag the error at compile time if one is trying to build a kernel which
>   does not meet alignment restrictions.
>
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> ---
>
>  arch/x86_64/kernel/head64.c |    8 ++++++++
>  include/asm-x86_64/page.h   |    1 +
>  2 files changed, 9 insertions(+)
>
> diff -puN
> arch/x86_64/kernel/head64.c~x86_64-check-for-config-physical-start-aligned-2M
> arch/x86_64/kernel/head64.c
> ---
> linux-2.6.21-rc5-mm3-vanilla/arch/x86_64/kernel/head64.c~x86_64-check-for-config-physical-start-aligned-2M
> 2007-04-02 20:46:43.000000000 +0530
> +++ linux-2.6.21-rc5-mm3-vanilla-root/arch/x86_64/kernel/head64.c 2007-04-02
> 21:20:45.000000000 +0530
> @@ -62,6 +62,14 @@ void __init x86_64_start_kernel(char * r
>  {
>  	int i;
>  
> +	/*
> +	 * Make sure kernel is aligned to 2MB address. Catching it at compile
> +	 * time is better. Change your config file and compile the kernel
> +	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
> +	 */
> +	BUILD_BUG_ON(ALIGN(CONFIG_PHYSICAL_START, __KERNEL_ALIGN)
> +			!= CONFIG_PHYSICAL_START);

Just as a nit.
     	BUILD_BUG_ON(CONFIG_PHYSICAL_START & (__KERNEL_ALIGN - 1))
is a little shorter...   Although maybe not quite as readable.
> +
>  	/* clear bss before set_intr_gate with early_idt_handler */
>  	clear_bss();
>  
> diff -puN
> include/asm-x86_64/page.h~x86_64-check-for-config-physical-start-aligned-2M
> include/asm-x86_64/page.h
> ---
> linux-2.6.21-rc5-mm3-vanilla/include/asm-x86_64/page.h~x86_64-check-for-config-physical-start-aligned-2M
> 2007-04-02 20:50:55.000000000 +0530
> +++ linux-2.6.21-rc5-mm3-vanilla-root/include/asm-x86_64/page.h 2007-04-02
> 20:51:34.000000000 +0530
> @@ -79,6 +79,7 @@ extern unsigned long phys_base;
>  #endif /* !__ASSEMBLY__ */
>  
>  #define __PHYSICAL_START	CONFIG_PHYSICAL_START
> +#define __KERNEL_ALIGN		0x200000
>  #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
>  #define __START_KERNEL_map	0xffffffff80000000
>  #define __PAGE_OFFSET           0xffff810000000000

Do we want to use the __KERNEL_ALIGN directive in the test in misc.c?

Eric
