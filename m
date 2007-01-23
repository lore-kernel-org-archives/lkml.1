Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbXAWEia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbXAWEia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 23:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbXAWEia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 23:38:30 -0500
Received: from theorix.CeNTIE.NET.au ([202.9.6.84]:44316 "HELO
	theorix.centie.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932268AbXAWEia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 23:38:30 -0500
Message-ID: <45B59140.3050606@usherbrooke.ca>
Date: Tue, 23 Jan 2007 15:38:24 +1100
From: Jean-Marc Valin <jean-marc.valin@usherbrooke.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM generates oops and general protection fault
References: <45B422D3.9040409@usherbrooke.ca> <200701221259.06817.rjw@sisk.pl>
In-Reply-To: <200701221259.06817.rjw@sisk.pl>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> I just encountered the following oops and general protection fault
>> trying to suspend/resume my laptop. I've got a Dell D820 laptop with a 2
>> GHz Core 2 Duo CPU. It usually suspends/resumes fine but not always. The
>> relevant errors are below but the full dmesg log is at
>> http://people.xiph.org/~jm/suspend_resume_oops.txt and my config is in
>> http://people.xiph.org/~jm/config-2.6.20-rc5.txt
>>
>> This happens when I'm running 2.6.20-rc5. The previous kernel version I
>> was using is 2.6.19-rc6 and was much more broken (second attempt
>> *always* failed), so it's probably not a regression.
> 
> This is a shot against the odds, but could you please check if the attached
> patch has any effect?

Thanks, I'll try that. It may take a while because the problem only
happened once in dozens of suspend/resume cycles.

	Jean-Marc

> Rafael
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> Both process_zones()and drain_node_pages() check for populated zones before
> touching pagesets. However, __drain_pages does not do so,
> 
> This may result in a NULL pointer dereference for pagesets in unpopulated
> zones if a NUMA setup is combined with cpu hotplug.
> 
> Initially the unpopulated zone has the pcp pointers pointing to the boot
> pagesets.  Since the zone is not populated the boot pageset pointers will
> not be changed during page allocator and slab bootstrap.
> 
> If a cpu is later brought down (first call to __drain_pages()) then the pcp
> pointers for cpus in unpopulated zones are set to NULL since __drain_pages
> does not first check for an unpopulated zone.
> 
> If the cpu is then brought up again then we call process_zones() which will ignore
> the unpopulated zone. So the pageset pointers will still be NULL.
> 
> If the cpu is then again brought down then __drain_pages will attempt to drain
> pages by following the NULL pageset pointer for unpopulated zones.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  mm/page_alloc.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.20-rc4/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.20-rc4.orig/mm/page_alloc.c
> +++ linux-2.6.20-rc4/mm/page_alloc.c
> @@ -714,6 +714,9 @@ static void __drain_pages(unsigned int c
>  		if (!populated_zone(zone))
>  			continue;
>  
> +		if (!populated_zone(zone))
> +			continue;
> +
>  		pset = zone_pcp(zone, cpu);
>  		for (i = 0; i < ARRAY_SIZE(pset->pcp); i++) {
>  			struct per_cpu_pages *pcp;
