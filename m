Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYHTVkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYHTVkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYHTVjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:39:54 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:35698 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYHTVjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:39:53 -0400
Message-ID: <48AC8F69.4050201@keyaccess.nl>
Date: Wed, 20 Aug 2008 23:40:57 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@gmail.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl> <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com>
In-Reply-To: <20080820194127.GA10887@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-08-08 21:41, Venki Pallipadi wrote:

> OK. I have reproduced this list size issue locally and this order 1 
> allocation and set_memory_uc on that allocation is actually coming
> from agp_allocate_memory() -> agp_generic_alloc_page() ->
> map_page_into_agp() agp_allocate_memory breaks higher order page
> requests into order 1 allocs.
> 
> On my system I see multiple agp_allocate_memory requests for nrpages 
> 8841, 1020, 16, 2160, 2160, 8192. Together they end up resulting in 
> more than 22K entries in PAT pages.

Okay, thanks for the confirmation.

Now, how to fix...

Firstly, it seems we can conclude that any expectancy of a short PAT 
list is simply destroyed by AGP. I believe the best thing migh be to 
look into "fixing" AGP rather than PAT for now?

In a sense the entire purpose of the AGP GART is collecting non 
contiguous pages but given that in practice it's generally still just 
one or at most a few regions, going to multi-page allocs sounds most 
appetising to me.

All in tree AGP drivers except sgi-agp use agp_generic_alloc_page(), ali 
via m1541_alloc_page and i460 via i460_alloc_page.

Rene.
