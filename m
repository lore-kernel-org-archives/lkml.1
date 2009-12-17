Return-Path: <linux-kernel-owner+w=401wt.eu-S1764983AbZLQRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764983AbZLQRM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764962AbZLQRM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:12:27 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5292 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764419AbZLQRM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:12:27 -0500
Message-ID: <4B2A65C6.7080009@caviumnetworks.com>
Date: Thu, 17 Dec 2009 09:09:26 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org>
In-Reply-To: <20091217150120.GD24967@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Dec 2009 17:09:28.0478 (UTC) FILETIME=[B11D83E0:01CA7F3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Uwe Kleine-König wrote:
>> Use the new unreachable() macro instead of for(;;);
>>  	*(int *)0 = 0;
>>  
>>  	/* Avoid "noreturn function does return" */
>> -	for (;;);
>> +	unreachable();
> 
> Will GCC-4.5 remove ("optimise away") the *(int *)0 = 0 because it
> knows the branch of the code leading to unreachable can never be reached?
> 

I don't know the definitive answer, so I am sending to gcc@...

FYI: #define unreachable() __builtin_unreachable()


> If GCC-4.5 does not, are you sure a future version of GCC will never
> remove it?  In other words, is __builtin_unreachable() _defined_ in
> such a way that it cannot remove the previous assignment?
> 
> We have seen problems with GCC optimising away important tests for
> NULL pointers in the kernel, due to similar propagation of "impossible
> to occur" conditions, so it's worth checking with GCC people what the
> effect of this one would be.
> 
> In C, there is a general theoretical problem with back-propagation of
> optimisations from code with undefined behaviour.  In the case of
> __builtin_unreachable(), it would depend on all sorts of unclearly
> defined semantics whether it can remove a preceding *(int *)0 = 0.
> 
> I'd strongly suggest asking on the GCC list.  (I'd have mentioned this
> earlier, if I'd known about the patch for other architectures).
> 
> The documentation for __builtin_unreachable() only says the program is
> undefined if control flow reaches it.  In other words, it does not say
> what effect it can have on previous instructions, and I think it's
> quite likely that it has not been analysed in a case like this.
> 
> One thing that would give me a lot more confidence, because the GCC
> documentation does mention asm(), is this:
> 
>>       *(int *)0 = 0;
>>       /* Ensure unreachableness optimisations cannot propagate back. *I/
>>       __asm__ volatile("");
>>       /* Avoid "noreturn function does return" */
>>       unreachable();
> 
> -- Jamie

