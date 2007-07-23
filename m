Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbXGWFOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbXGWFOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 01:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXGWFOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 01:14:37 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:43016 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbXGWFOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 01:14:36 -0400
Message-ID: <46A43935.6040000@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2007 10:44:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: nagar@watson.ibm.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Optimize struct task_delay_info
References: <1184138034.3068.51.camel@ymzhang>
In-Reply-To: <1184138034.3068.51.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
> struct task_delay_info is used by per process block I/O delay statistics
> feature which is useful in kernel. This struct is not optimized.
> 
> My patch against kernel 2.6.22 shrinks it a half.
> 
> 1) Delete blkio_start and blkio_end. As the collection happens in
> io_schedule and io_schedule_timeout, we use local variables to
> replace them;

I am not sure if it's a good idea to push items on the stack.
Remember we are moving to 4K stacks.

> 2) Delete lock. The change to the protected data has no nested cases.
> In addition, the result is for performance data collection, so it’s
> unnecessary to add such lock. 

This is a cause of concern, we cannot afford to have incorrect data
collected. Incorrect/unreliable data which is worthless.

> 3) Delete flags. It just has one value. Use the most significant bit of
> blkio_delay (64 bits) to mark it..
> 

Yes, thats true right now, but I am not sure if we should go optimize
that so early. We could end up adding other accounting/extending the
framework, we'll need to add the flags back then.



> -static inline void delayacct_clear_flag(int flag)
> +static inline void delayacct_clear_swapin(void)
>  {
>  	if (current->delays)
> -		current->delays->flags &= ~flag;
> +		current->delays->blkio_delay |= DELAYACCT_PF_SWAPIN;

BTW, you should be clearing the flag here.


Overall, the lock removal is not acceptable. I don't like the bit
hacking for flags and moving counters to the stack either.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
