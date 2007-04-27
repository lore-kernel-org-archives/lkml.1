Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbXD0VRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbXD0VRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbXD0VRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:17:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15812 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbXD0VRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:17:38 -0400
Date: Fri, 27 Apr 2007 14:19:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Tim Hockin" <thockin@google.com>
Cc: ak@muc.de, vojtech@suse.cz, linux-kernel@vger.kernel.org, akpm@google.com
Subject: Re: [PATCH] x86_64: dynamic MCE poll interval
Message-Id: <20070427141908.114bfe5a.randy.dunlap@oracle.com>
In-Reply-To: <cc96a5040704271351jd25cfe0md72b64d49906d796@mail.gmail.com>
References: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com>
	<cc96a5040704271128t60120aedvd439630b3b80b03@mail.gmail.com>
	<cc96a5040704271351jd25cfe0md72b64d49906d796@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 13:51:28 -0700 Tim Hockin wrote:

> This is the third version of this patch.  The only change from the prior
> version is to use time_after_eq().
> 
> diff -pruN linux-2.6.20/arch/x86_64/kernel/mce.c
> linux-2.6.20+th/arch/x86_64/kernel/mce.c
> --- linux-2.6.20/arch/x86_64/kernel/mce.c	2007-04-27 10:01:02.000000000 -0700
> +++ linux-2.6.20+th/arch/x86_64/kernel/mce.c	2007-04-27 10:41:02.000000000 -0700
> @@ -349,17 +351,30 @@ static void mcheck_timer(struct work_str
>  	 * writes.
>  	 */
>  	if (notify_user && console_logged) {
> +		static unsigned long last_print = 0;

Don't need to init statics to 0...

> +		unsigned long now = jiffies;
> +
> +		/* if we logged an MCE, reduce the polling interval */
> +		next_interval = max(next_interval/2, HZ/100);
>  		notify_user = 0;
>  		clear_bit(0, &console_logged);
> -		printk(KERN_INFO "Machine check events logged\n");
> +		if (time_after_eq(now, last_print + (check_interval*HZ))) {
> +			last_print = now;
> +			printk(KERN_INFO "Machine check events logged\n");
> +		}
> +	} else {
> +		next_interval = min(next_interval*2, check_interval*HZ);
>  	}
> +
> +	schedule_delayed_work(&mcheck_work, next_interval);
>  }


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
