Return-Path: <linux-kernel-owner+w=401wt.eu-S934888AbYBUQya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbYBUQya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761870AbYBUQyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:54:19 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:4270 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYBUQyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:54:18 -0500
Message-Id: <47BD64D0.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 21 Feb 2008 09:47:28 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <rostedt@goodmis.org>, <kevin@hilman.org>, <tglx@linutronix.de>,
       <cminyard@mvista.com>, <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <gregkh@suse.de>, <npiggin@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH [RT] 11/14] optimize the !printk fastpath through
	the lock acquisition
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
 <20080221152722.4804.77478.stgit@novell1.haskins.net>
 <200802211736.26719.ak@suse.de>
In-Reply-To: <200802211736.26719.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Thu, Feb 21, 2008 at 11:36 AM, in message <200802211736.26719.ak@suse.de>,
Andi Kleen <ak@suse.de> wrote: 
> On Thursday 21 February 2008 16:27:22 Gregory Haskins wrote:
> 
>> @@ -660,12 +660,12 @@ rt_spin_lock_fastlock(struct rt_mutex *lock,
>>  		void fastcall (*slowfn)(struct rt_mutex *lock))
>>  {
>>  	/* Temporary HACK! */
>> -	if (!current->in_printk)
>> -		might_sleep();
>> -	else if (in_atomic() || irqs_disabled())
>> +	if (unlikely(current->in_printk) && (in_atomic() || irqs_disabled()))
> 
> I have my doubts that gcc will honor unlikelies that don't affect
> the complete condition of an if.
> 
> Also conditions guarding returns are by default predicted unlikely
> anyways AFAIK. 
> 
> The patch is likely a nop.
> 

Yeah, you are probably right.  We have found that the system is *extremely* touchy on how much overhead we have in the lock-acquisition path.  For instance, using a non-inline version of adaptive_wait() can cost 5-10% in disk-io throughput.  So we were trying to find places to shave anywhere we could.  That being said, I didn't record any difference from this patch, so you are probably exactly right.  It just seemed like "the right thing to do" so I left it in.

-Greg



