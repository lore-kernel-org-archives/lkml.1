Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZEMIxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZEMIxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZEMIw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:52:57 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59470 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZEMIw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:52:56 -0400
X-IronPort-AV: E=Sophos;i="4.41,186,1241409600"; 
   d="scan'208";a="4232546"
Subject: Re: [PATCH FIXED] x86: use flush_tlb_others to implement
	flush_tlb_all
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4A0A154C.9080000@goop.org>
References: <4A09E5FE.2080507@goop.org> <4A0A0D7C.8050206@zytor.com>
	 <4A0A154C.9080000@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Wed, 13 May 2009 09:52:55 +0100
Message-ID: <1242204775.24976.7.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 20:33 -0400, Jeremy Fitzhardinge wrote:

> -static void do_flush_tlb_all(void *info)
> +void flush_tlb_all(void)
>  {
> -	unsigned long cpu = smp_processor_id();
> +	/* flush_tlb_others expects preempt to be disabled */
> +	get_cpu();
> +
> +	flush_tlb_others(cpu_online_mask, NULL, TLB_FLUSH_ALL);
>  
>  	__flush_tlb_all();
>  	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
> -		leave_mm(cpu);
> -}
> +		leave_mm(smp_processor_id());

get_cpu() returns smp_processor_id() so wouldn't this be more normally
written as:
	/* flush_tlb_others expects preempt to be disabled */
	unsigned long cpu = get_cpu();
	[....]
	if ([....] == TLBSTATE_LAZY)
		leave_mm(cpu)
	put_cpu();

Ian.

