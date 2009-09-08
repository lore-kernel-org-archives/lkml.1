Return-Path: <linux-kernel-owner+w=401wt.eu-S1751122AbZIHPjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbZIHPjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZIHPjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:39:00 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:20314 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZIHPjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:39:00 -0400
Date: Tue, 08 Sep 2009 11:38:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH] C2 could be mapped to C3 so need a flush cache
In-reply-to: <3877989d0909071926q77aac67cj532137513710025d@mail.gmail.com>
Message-id: <alpine.LFD.2.00.0909081126080.6720@localhost.localdomain>
References: <3877989d0909071926q77aac67cj532137513710025d@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Luming Yu wrote:

> Hi there,
> 
> I came across acpi_idle_enter_simple, noticed it looks like a bug if
> we don't flush cache for C2.
> Because some platforms just map C2 to C3.
> 
> Please review. If make sense, please apply.
> 
> Ps. The patch is enclosed in attachment. The inlined one
> is c&p of it for reading.
> 
> 
> Thanks,
> Luming
> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>
> 
>  processor_idle.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 0efa59e..4fa9582 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -893,7 +893,7 @@ static int acpi_idle_enter_simple(struct
> cpuidle_device *dev,
>  	 */
>  	lapic_timer_state_broadcast(pr, cx, 1);
> 
> -	if (cx->type == ACPI_STATE_C3)
> +	if (cx->type == ACPI_STATE_C3 || cx->type == ACPI_STATE_C2)
>  		ACPI_FLUSH_CPU_CACHE();
> 
>  	kt1 = ktime_get_real();
> 

Thanks for noticing this inconsistency, Luming.

I agree with Arjan on this one -- the cache flush
semantics regarding C2-type and C3-type are very clear,
and we should not add the C3-type overhead to C2-type
unless we can absolutely prove we need it.
(And if we did so, do it with a black-list, rather than
penalizing every system)

The reason I feel this way, is basically I expect
that Windows got this part right.

Our issues with timers and C-states crept into an ad-hoc
defintion of the C-state types because Linux uses
the timer hardware differently than Windows does.

Finally, the happy news here is that the very latest
processors don't require C3-type overhead at all,
even when their BIOS claims that they do.  They
declare ACPI C3-type for hardware C2-type states
just to satisfy the installed base that expect there
to be 3 c-state types.

We've discussed moving Linux to a native C-state
driver on this latest hardware, to escape from
the extra overhead that legacy compatibility carries,
and I think it would be a good idea.
(ie. on your NHM, there would be no flush, even
 for a state that the BIOS calls a C3-type, because
 it is really a hardware C2-type)

cheers,
Len Brown, Intel Open Source Technology Center


