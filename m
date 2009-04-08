Return-Path: <linux-kernel-owner+w=401wt.eu-S934486AbZDHRFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbZDHRFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934602AbZDHRC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:02:58 -0400
Received: from gw.goop.org ([64.81.55.164]:44483 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934595AbZDHRC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:02:57 -0400
Message-ID: <49DCD8BE.2090408@goop.org>
Date: Wed, 08 Apr 2009 10:02:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] early-quirks: remove duplicate #ifdef
References: <49DA7E18.1050209@goop.org> <20090408121757.GA18581@elte.hu>
In-Reply-To: <20090408121757.GA18581@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> "#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)" was repeated
>> twice.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>     
>
> hm, this was due to the patch below. Your patch essentially reverts 
> that patch?
>   

Is that patch the result of a merge?

With that patch in place, the code structure is essentially:

#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
{
	...
}
#endif

...
#endif


I can't see how the inner #if is doing anything useful at all.

    J
> 	Ingo
>
> --------------->
> From a59dacfdc9ba06903652fa4883bf1106278b18ec Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 17 Oct 2008 14:38:08 +0200
> Subject: [PATCH] x86 early quirks: eliminate unused function
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
>
> Impact: cleanup
>
> this warning:
>
>   arch/x86/kernel/early-quirks.c:99: warning: ‘ati_ixp4x0_rev’ defined but not used
>
> triggers because ati_ixp4x0_rev() is only used in the
> ACPI && X86_IO_APIC case.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/early-quirks.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 76b8cd9..ebdb85c 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -97,6 +97,7 @@ static void __init nvidia_bugs(int num, int slot, int func)
>  }
>  
>  #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
> +#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
>  static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
>  {
>  	u32 d;
> @@ -114,6 +115,7 @@ static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
>  	d &= 0xff;
>  	return d;
>  }
> +#endif
>  
>  static void __init ati_bugs(int num, int slot, int func)
>  {
>   

