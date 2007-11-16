Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbXKPDxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbXKPDxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbXKPDx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:53:29 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:49926 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072AbXKPDx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:53:28 -0500
Message-ID: <473D131A.5000200@cosmosbay.com>
Date: Fri, 16 Nov 2007 04:48:42 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net
Subject: Re: [NET]: rt_check_expire() can take a long time, add a cond_resched()
References: <200711150401.lAF41mSs021898@hera.kernel.org> <20071115193802.4ec64eef@laptopd505.fenrus.org>
In-Reply-To: <20071115193802.4ec64eef@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 16 Nov 2007 04:48:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven a écrit :
> On Thu, 15 Nov 2007 04:01:48 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
>> Gitweb:
>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d90bf5a976793edfa88d3bb2393f0231eb8ce1e5
>> Commit:     d90bf5a976793edfa88d3bb2393f0231eb8ce1e5 Parent:
>> 66ba886254edbbd9442d30f1eef6f6fb0145027d Author:     Eric Dumazet
>> <dada1@cosmosbay.com> AuthorDate: Wed Nov 14 16:14:05 2007 -0800
>> Committer:  David S. Miller <davem@davemloft.net>
>> CommitDate: Wed Nov 14 16:14:05 2007 -0800
>>
>>     [NET]: rt_check_expire() can take a long time, add a
>> cond_resched() 
>>     On commit 39c90ece7565f5c47110c2fa77409d7a9478bd5b:
> 
>>     When the IP route cache is big, rt_check_expire() can take a long
>> time to run.  (default settings : 20% of the hash table is scanned at
>> each invocation)
>>     
>>     Adding cond_resched() helps giving cpu to higher priority tasks if
>>     necessary.
>>     
>>     Using a "if (need_resched())" test before calling
>> "cond_resched();" is necessary to avoid spending too much time doing
>> the resched check. 
> 
> int __sched cond_resched(void)
> {
>         if (need_resched() &&  .....
> 
> somehow I wonder why the second if() is useful at all; it's another
> spot for a branch predictor to miss... and a void function call is
> really really cheap... 

Its not that cheap. The ChangeLog included my own numbers, on a Pentium M 
machine. (i686, 1.6 GHz, 1.5 GB ram)

Without "if (need_resched())" (so calling need_resched() X.XXX.XXX times), 
each run takes 88ms

With the extra check (and *much* less function calls), each run takes 25ms


