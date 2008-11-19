Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYKSIWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYKSIWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYKSIW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:22:27 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYKSIW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:22:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=En66sRJrnwy4SIK2DTDJPF2x2OUyJ6VWBIxpcvuLF3XFf6KOIjkvSvnY+zVd1Umry
	g4FI9/R3iCi6WrLhZN2jg==
MIME-Version: 1.0
In-Reply-To: <20081119075319.GA1078@elte.hu>
References: <b040c32a0811182248s1174c82avf44c720ae2d14804@mail.gmail.com>
	 <20081119075319.GA1078@elte.hu>
Date: Wed, 19 Nov 2008 00:22:22 -0800
Message-ID: <b040c32a0811190022g521eeff4sa19d2966c4ac732f@mail.gmail.com>
Subject: Re: [patch] sched: add locking when update the task_group's cfs_rq[] 
	array.
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 11:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ken Chen <kenchen@google.com> wrote:
>
>> @@ -1513,8 +1513,12 @@ static int tg_shares_up
>>       unsigned long weight, rq_weight = 0;
>>       unsigned long shares = 0;
>>       struct sched_domain *sd = data;
>> +     unsigned long flags;
>>       int i;
>>
>> +     if (!spin_trylock_irqsave(&tg->tg_lock, flags))
>> +             return 0;
>
> hm, why trylock?

I'm paranoid about potential lock contention.  Considering calls to
tg_shares_up() are more or less sample based, I opt to skip updating
if there is a lock contention.  Though kernel only walks tg tree every
sysctl_sched_shares_ratelimit.  Maybe chances of running into lock
contention isn't that high anyway, in which case trylock will mostly
able to get the lock.

- Ken
