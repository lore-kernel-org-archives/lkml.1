Return-Path: <linux-kernel-owner+w=401wt.eu-S1765246AbXGQQbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765246AbXGQQbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbXGQQb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:31:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbXGQQb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:31:27 -0400
Message-ID: <469CEEAE.7070308@redhat.com>
Date: Tue, 17 Jul 2007 12:30:38 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Kent <raven@themaw.net>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] CFS scheduler, -v19
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu>
In-Reply-To: <20070717074537.GA13539@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 03:45 AM, Ingo Molnar wrote:
> * Ian Kent <raven@themaw.net> wrote:
> 
>> Yes it does and I have two reported bugs so far.
>>
>> In several places I have code similar to:
>>
>> wait.tv_sec = time(NULL) + 1;
>> wait.tv_nsec = 0;
>>
>> signaled = 0;
>> while (!signaled) {
>>         status = pthread_cond_timedwait(&cond, &mutex, &wait);
>>        if (status) {
>>              if (status == ETIMEDOUT)
>>                   break;
>>              fatal(status);
>>       }
>> }
> 
> ah! It passes in a low-res time source into a high-res time interface 
> (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
> time(NULL) + 2, or change it to:
> 
> 	gettimeofday(&wait, NULL);
> 	wait.tv_sec++;
> 
> does this solve the spinning?
> 
> i'm wondering how widespread this is. If automount is the only app doing 
> this then _maybe_ we could get away with it by changing automount?

Odds are there's at least one other app doing that somewhere.

Would reverting the CFS changes to time.c fix this problem?
That optimization just got merged in 2.6.22 mainline...
