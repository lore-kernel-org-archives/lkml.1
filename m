Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXC0Q4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXC0Q4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXC0Q4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:56:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbXC0Q4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:56:18 -0400
Message-ID: <46094CA2.1050400@redhat.com>
Date: Tue, 27 Mar 2007 12:56:02 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clalance@redhat.com, mingo@redhat.com, davej@redhat.com,
       Thilo.Cestonaro.external@fujitsu-siemens.com
Subject: Re: [PATCH]: Fix bogus softlockup warning with sysrq-t
References: <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com> <4608AF01.4060804@goop.org> <460902CF.1030202@redhat.com> <46094A70.9080901@goop.org>
In-Reply-To: <46094A70.9080901@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
> Prarit Bhargava wrote:
>   
>> I think that's a good idea -- I'll propose an add on patch to fix the
>> sysrq-t case ...
>>     
>
> I'm working on this patch at the moment.  I'm just wondering what
> happens if you do a global re-enable while a CPU is locally disabled.  I
> think it won't matter; it will end up in the "enabled but need to update
> timestamp" state, and the next time it gets a timer tick, it will simply
> update the timestamp and carry on.
>
> (This is relative to the other two softlockup patches, but modified
> since I posted them.)
>
>     J
>
> diff -r 4c81d8cafb67 drivers/char/sysrq.c
> --- a/drivers/char/sysrq.c	Tue Mar 27 01:16:07 2007 -0700
> +++ b/drivers/char/sysrq.c	Tue Mar 27 01:18:05 2007 -0700
> @@ -408,6 +408,8 @@ void __handle_sysrq(int key, struct tty_
>  	int i;
>  	unsigned long flags;
>  
> +	softlockup_global_disable();
> +
>  	spin_lock_irqsave(&sysrq_key_table_lock, flags);
>  	orig_log_level = console_loglevel;
>  	console_loglevel = 7;
> @@ -445,6 +447,8 @@ void __handle_sysrq(int key, struct tty_
>  		console_loglevel = orig_log_level;
>  	}
>  	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
> +
> +	softlockup_global_enable();
>   

I think that works -- I'll test it out on a big honkin' ia64 box ;)

Shouldn't you also do softlockup_disable/softlockup_enable instead of 
touch_softlockup_watchdog?  Why do we have both?  I can't see why we 
would have two exported methods to stop/reset the softlockup timer...

P.
