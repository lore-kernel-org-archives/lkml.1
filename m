Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYFTTBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYFTTBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYFTTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:01:27 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:51860 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYFTTBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:01:25 -0400
Date: Fri, 20 Jun 2008 15:00:58 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
In-reply-to: <20080620135639.GA5073@damson.getinternet.no>
X-X-Sender: lenb@localhost.localdomain
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Message-id: <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080620135639.GA5073@damson.getinternet.no>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jun 2008, Vegard Nossum wrote:

> Hi Ingo,
> 
> Can you see if this patch solves your problem? There might be other
> functions that needs this guard as well, though. I wonder if maybe this test
> should just be included at the top of every driver that uses ACPI in some
> way. But I'm pretty sure that this lack of initialization is the root of your
> problem in any case :-)
> 
> (By the way, I don't know why this problem popped up at this time, maybe it
> was just bad timing/bad luck... How far back do your AE_BAD_PARAMETER in the
> logs go?)
> 
> 
> Vegard
> 
> 
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 20 Jun 2008 15:39:09 +0200
> Subject: [PATCH] ACPI: don't walk tables if ACPI was disabled
> 
> Ingo Molnar wrote:
> > -tip auto-testing started triggering this spinlock corruption message
> > yesterday:
> >
> > [    3.976213] calling  acpi_rtc_init+0x0/0xd3
> > [    3.980213] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread F7C50000 could not acquire Mutex [3] [20080321]
> > [    3.992213] BUG: spinlock bad magic on CPU#0, swapper/1
> > [    3.992213]  lock: c2508dc4, .magic: 00000000, .owner: swapper/1, .owner_cpu: 0
> 
> This is apparently because some parts of ACPI, including mutexes, are not
> initialized when acpi=off is passed to the kernel.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  drivers/acpi/glue.c               |    3 +++
>  drivers/acpi/namespace/nsxfeval.c |    3 +++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index 2808dc6..9b227d4 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -333,6 +333,9 @@ static int __init acpi_rtc_init(void)
>  {
>  	struct device *dev = get_rtc_dev();
>  
> +	if (acpi_disabled)
> +		return 0;
> +

hmm, i would expect dev to be 0 for acpi=off,
since pnp_match would fail, no?

>  	if (dev) {
>  		rtc_wake_setup();
>  		rtc_info.wake_on = rtc_wake_on;
> diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval.c
> index a8d5491..c274d1d 100644
> --- a/drivers/acpi/namespace/nsxfeval.c
> +++ b/drivers/acpi/namespace/nsxfeval.c
> @@ -391,6 +391,9 @@ acpi_walk_namespace(acpi_object_type type,
>  
>  	ACPI_FUNCTION_TRACE(acpi_walk_namespace);
>  
> +	if (acpi_disabled)
> +		return_ACPI_STATUS(AE_NO_NAMESPACE);
> +

We should probably BUG_ON(acpi_disabled) here,
since it takes a programming bug to hit this case.

-Len

>  	/* Parameter validation */
>  
>  	if ((type > ACPI_TYPE_LOCAL_MAX) || (!max_depth) || (!user_function)) {
> -- 
> 1.5.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
