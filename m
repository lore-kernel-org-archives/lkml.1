Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYLSFWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYLSFWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYLSFWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:22:12 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:49709 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYLSFWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:22:11 -0500
Date: Fri, 19 Dec 2008 00:22:06 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2.6.28-rc6] ACPICA: don't cond_resched() when
 irqs_disabled()
In-reply-to: <20081126135508.GA1891@localhost>
X-X-Sender: lenb@localhost.localdomain
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812190016120.6312@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081126135508.GA1891@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Wu Fengguang wrote:

> [add CC to <stable@kernel.org>, since this bug was introduced in the
> 2.6.27-rcX time frame, and should help 2.6.28 and 2.6.27.x alike]

Actually, ACPI_PREEMPTION_POINT() went in to 2.6.28-rc1,
it is not present in 2.6.27.stable so this patch
does not apply to 27.stable.

> The ACPI routines could be called from run_workqueue() with irqs disabled.
> So we should test irqs_disabled() before calling cond_resched().

I don't know how you provoked this failure.
The ACPI interpreter should always be run with interrupts enabled.
If it isn't then that is a (different) bug.

There is, however, one exception, and it is during suspend/resume;
and that _is_ a legal way to provoke this bug:

http://bugzilla.kernel.org/show_bug.cgi?id=12252

and thus the fix is actually correct, and I'll apply it.

thanks,
-- Len Brown, Intel Open Source Technology Center


> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -141,6 +141,10 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
>  /*
>   * We need to show where it is safe to preempt execution of ACPICA
>   */
> -#define ACPI_PREEMPTION_POINT()	cond_resched()
> +#define ACPI_PREEMPTION_POINT()		\
> +	do {				\
> +		if (!irqs_disabled())	\
> +			cond_resched();	\
> +	} while (0)
>  
>  #endif				/* __ACLINUX_H__ */
> --
