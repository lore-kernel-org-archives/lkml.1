Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYHYPM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYHYPM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYHYPMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:12:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYHYPMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:12:16 -0400
Date: Mon, 25 Aug 2008 10:19:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
Message-ID: <20080825141901.GE18914@redhat.com>
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 03:44:57PM -0700, Yinghai Lu wrote:
> may need user to have new kexec tools that could create e820 table
> from /sys/firmware/memmap instead of /proc/iomem for second kernel
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Bernhard Walle <bwalle@suse.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Index: linux-2.6/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820.c
> +++ linux-2.6/arch/x86/kernel/e820.c
> @@ -1279,6 +1279,10 @@ void __init e820_reserve_resources(void)
>  
>  	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
>  	for (i = 0; i < e820.nr_map; i++) {
> +		if (e820.map[i].type != E820_RAM) {
> +			res++;
> +			continue;
> +		}
>  		end = e820.map[i].addr + e820.map[i].size - 1;
>  #ifndef CONFIG_RESOURCES_64BIT
>  		if (end > 0x100000000ULL) {

I think this will wipe out ACPI related entries also from /proc/iomem
and kdump will be broken as second kernel needs to know about the ACPI
areas.

Though, if all these entries are available in /sys/firmware/memap then
probably one can modify kexec-tools to grep RAM entries from /proc/iomem and
rest of the entries from /sys/firmware/memmap.

I would not prefer doing that it makes the logic twisted.

Thanks
Vivek
