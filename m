Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbXHUFD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbXHUFD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 01:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbXHUFDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 01:03:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbXHUFDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 01:03:45 -0400
Date: Mon, 20 Aug 2007 22:03:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       wbrana@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][bugzilla #8679] therm_throt.c: Fix section mismatch
Message-Id: <20070820220328.438e8a4d.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708211003390.2774@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708211003390.2774@enigma.security.iitk.ac.in>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007 10:07:31 +0530 (IST) Satyam Sharma <satyam@infradead.org> wrote:

> 
> WARNING: arch/i386/kernel/built-in.o(.data+0x2148): Section mismatch: reference
> to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mtrr_mutex')
> 
> comes because struct notifier_block thermal_throttle_cpu_notifier in
> arch/i386/kernel/cpu/mcheck/therm_throt.c goes in .data section but
> the notifier callback function itself has been marked __cpuinit which
> becomes __init == .init.text when HOTPLUG_CPU=n. The warning is bogus
> because the callback will never be called out if HOTPLUG_CPU=n in the
> first place (as one can see from kernel/cpu.c, the cpu_chain itself
> is __cpuinitdata :-)
> 
> So, let's mark thermal_throttle_cpu_notifier as __cpuinitdata to fix
> the section mismatch warning.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 
> ---
> 
> [The other section mismatch mentioned in bugzilla #8679 is already fixed.]
> 
>  arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/i386/kernel/cpu/mcheck/therm_throt.c b/arch/i386/kernel/cpu/mcheck/therm_throt.c
> index 1203dc5..494d320 100644
> --- a/arch/i386/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/i386/kernel/cpu/mcheck/therm_throt.c
> @@ -152,7 +152,7 @@ static __cpuinit int thermal_throttle_cpu_callback(struct notifier_block *nfb,
>  	return NOTIFY_OK;
>  }
>  
> -static struct notifier_block thermal_throttle_cpu_notifier =
> +static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
>  {
>  	.notifier_call = thermal_throttle_cpu_callback,
>  };

okay...  However we're not being very consistent here.

register_hotcpu_notifier() is cunning.  If CONFIG_HOTPLUG_CPU=y, we need
the notifier block and the function to which it points to be in .data and
in .text.  If CONFIG_HOTPLUG_CPU=n, we don't need them to be present at all.

So what we can do is to just leave the notifier block in .data and the
function in .text and then the compiler/linker will notice that nothing
references them and they will be omitted at build time.

So basically, the register_hotcpu_notifier() implementation (in league with
the compiler) is taking the place of the manual notations.

Note that because this works at compile time, it is also effective within
modules.  I'm not sure that we discard the unneeded sections from within
modules? (I forget).

So...  what to do?  I guess for consistency one could hunt down all the
register_hotcpu_notifier() sites and remove all the __initfoo tags from all of
them.  But that makes register_hotcpu_notifier() inconsistent from
everything else, so there's an argument that we should make all these
things __cpuinit and __cpuinitdata for consistency rather than relying upon
register_hotcpu_notifier()'s magical properties as a special case.  Dunno.

<looks at blk_cpu_notifier>

There are a few things to clear up here...

