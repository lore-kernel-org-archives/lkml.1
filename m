Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbXESDni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbXESDni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 23:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbXESDnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 23:43:31 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:40475 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754561AbXESDna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 23:43:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Hj5jy7LHdX8cyRgoomBvyxEFSeVHFBb3YV0baRnOBTke0fNAcYPSyrCRx582QPMYNPWzpw/pOP1BN/iFGjzLE+5tF+w89mp/J+Vektmp3witzRQlei/gNYLfDD8hh+Auur4t0dksnxD9rrdlmFvHRcwL6z/qJS+KJ2bTo2PPihQ=  ;
X-YMail-OSG: dlpd4AYVM1lMzHlgJ1xaWVtds5U_UCZoNiacItHsJ389wTx6wbD9dzYLgu._3QPaJ6hVFHBwoQ--
Message-ID: <464E7254.60406@yahoo.com.au>
Date: Sat, 19 May 2007 13:43:16 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Phillip Susi <psusi@cfl.rr.com>,
       Alex Volkov <avcp-lkmail@usa.net>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: aio is unlikely
References: <20070509151831.f5956b66.akpm@linux-foundation.org>	<058f01c7998e$1406e370$650df7cd@MUMBA>	<20070518140624.1a4db517.akpm@linux-foundation.org>	<464E2098.8020900@cfl.rr.com> <20070518151259.319e09da.akpm@linux-foundation.org> <464E2AA6.3080402@garzik.org>
In-Reply-To: <464E2AA6.3080402@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Andrew Morton wrote:
> 
>> On Fri, 18 May 2007 17:54:32 -0400
>> Phillip Susi <psusi@cfl.rr.com> wrote:

>>> But as Jeff said, that's not what unlikely is for.  It should only be 
>>> used when it is unlikely for everybody, all the time, because when it 
>>> is right, it helps rather little, but when it is wrong, it hurts a lot.
>>
>>
>> It does?  Tell us more.
> 
> 
> It is difficult to quantify either way.  The details are both 
> CPU-specific and compiler-specific.  The best information can be culled 
> from the gcc list archives, which is where I obtained my knowledge on 
> the subject (which is now ~2 years old).
> 
> Under the hood, likely() and unlikely() are implemented as percentage 
> predictions.  likely() is implemented in the kernel as a 99-100% chance 
> of success, and unlikely() is implemented as a 0-1% chance of success.
> 
> As such, for our purposes, likely() and unlikely() should only be used 
> when a situation is [likely | unlikely] across all runtime 
> configurations.  So if you mark a branch unlikely() when it is hit often 
> by 1% of your users, that is an incorrect usage.
> 
> The effects are probably most dramatic on older CPUs.  Repeatedly 
> hitting an unlikely() can cause a pipeline stall on every single access. 
>  Branch delay slots are filled improperly, with obvious implications.
> 
> But on modern hardware, I would /guess/ that the effect of repeatedly 
> hitting an unlikely() would be mitigated by smarter branch prediction.
> 
> We really need a GCC expert to answer this question in any more detail.

Aside from using branch constructs or hints that help the predictor
guess the right way... I think gcc will move unlikely paths right past
the end of the "likely" fastpath, so it can increase code size and be
somewhat suboptimal in terms of icache usage.

I don't know particularly why it would hurt a lot more when it goes
wrong than it helps when it goes right, though.

Also, I don't think I agree that it should be used where it is correct
for all users. We make rt_task unlikely in the scheduler, and I measured
that a very long time ago was IIRC good for nearly 5% pipe based context
switching peformance. Systems running a lot of rt tasks aren't going to
like it, but bugger them :)

-- 
SUSE Labs, Novell Inc.
