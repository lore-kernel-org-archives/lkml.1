Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbXGRVil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbXGRVil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758286AbXGRVic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:38:32 -0400
Received: from mail.tmr.com ([64.65.253.246]:38017 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096AbXGRVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:38:31 -0400
Message-ID: <469E8821.3070700@tmr.com>
Date: Wed, 18 Jul 2007 17:37:37 -0400
From: Bill Davidsen <davidsen@tmr.com>
Reply-To: davidsen@posidon.tmr.com
Organization: TMR Associates, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Ian Kent <raven@themaw.net>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 17 Jul 2007, Ingo Molnar wrote:
>   
>> * Ian Kent <raven@themaw.net> wrote:
>>     
>>> In several places I have code similar to:
>>>
>>> wait.tv_sec = time(NULL) + 1;
>>> wait.tv_nsec = 0;
>>>       
>
> Ok, that definitely should work.
>
> Does the patch below help?
>
>   
Spectacularly no! With this patch the "glitch1" script with multiple 
scrolling windows has all xterms and glxgears stop totally dead for 
~200ms once per second. I didn't properly test anything else after that. 
Since the automount issue doesn't seem to start until something kicks it 
off, I didn't see it but that doesn't mean it's fixed.
>> ah! It passes in a low-res time source into a high-res time interface 
>> (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
>> time(NULL) + 2, or change it to:
>>
>> 	gettimeofday(&wait, NULL);
>> 	wait.tv_sec++;
>>     
>
> This is wrong. It's wrong for two reasons:
>
>  - it really shouldn't be needed. I don't think "time()" has to be 
>    *exactly* in sync, but I don't think it can be off by a third of a 
>    second or whatever (as the "30% CPU load" would seem to imply)
>
>  - gettimeofday works on a timeval, pthread_cond_timedwait() works on a 
>    timespec.
>
> So if it actually makes a difference, it makes a difference for the 
> *wrong* reason: the time is still totally nonsensical in the tv_nsec field 
> (because it actually got filled in with msecs!), but now the tv_sec field 
> is in sync, so it hides the bug.
>
> Anyway, hopefully the patch below might help. But we probably should make 
> this whole thing a much more generic routine (ie we have our internal 
> "getnstimeofday()" that still is missing the second-overflow logic, and 
> that is quite possibly the one that triggers the "30% off" behaviour).
>
>   
Hope that info helps.

> Ingo, I'd suggest:
>  - ger rid of "timespec_add_ns()", or at least make it return a return 
>    value for when it overflows.
>  - make all the people who overflow into tv_sec call a "fix_up_seconds()" 
>    thing that does the xtime overflow handling.
>
> 		Linus
>   

