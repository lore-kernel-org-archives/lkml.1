Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZJGDiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZJGDiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZJGDiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:38:20 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54417 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbZJGDiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NpwqFk8vMtQ2HmY3aU1h91s1Sl4kJk1oYkxW/j7V3wewQeD+yx8GBY/4r+GJpSDm45
         8WgbBLP0zDUktYO1vPNxnbfuNi9hrYDPVxfKLsOJVOL6VlIhs5u84vmifhNpaDurw63w
         co8/1F/oalTioB26z1zObldrOQdbxO+oO1ywM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0910061226300.18309@gentwo.org>
References: <20091006112803.5FA5.A69D9226@jp.fujitsu.com>
	 <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.1.10.0910061226300.18309@gentwo.org>
Date: Wed, 7 Oct 2009 12:37:41 +0900
X-Google-Sender-Auth: f09ba07494baf459
Message-ID: <2f11576a0910062037r785da04bg5723a1779f40d45c@mail.gmail.com>
Subject: Re: [PATCH 2/2] mlock use lru_add_drain_all_async()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/7 Christoph Lameter <cl@linux-foundation.org>:
> On Tue, 6 Oct 2009, KOSAKI Motohiro wrote:
>
>>   Suppose you have 2 cpus, cpu1 is busy doing a SCHED_FIFO-99 while(1),
>>   cpu0 does mlock()->lru_add_drain_all(), which does
>>   schedule_on_each_cpu(), which then waits for all cpus to complete the
>>   work. Except that cpu1, which is busy with the RT task, will never run
>>   keventd until the RT load goes away.
>>
>>   This is not so much an actual deadlock as a serious starvation case.
>>
>> Actually, mlock() doesn't need to wait to finish lru_add_drain_all().
>> Thus, this patch replace it with lru_add_drain_all_async().
>
> Ok so this will queue up lots of events for the cpu doing a RT task. If
> the RT task is continuous then they will be queued there forever?

Yes. this patch solved very specific issue only.
In original bug-report case, the system has two cpuset and the RT task
own one cpuset as monopoly. Thus, your worried thing doesn't occur.

Perhaps, we need complete solution. but I don't think this patch have
bad side effect. then, I hope to push it into mainline.
