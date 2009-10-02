Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZJBO2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZJBO2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZJBO2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:28:52 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:36600 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbZJBO2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r3rNQVXDdWIhdEZFtemjpiyNpkfjYPjAniliApw/nLhhvbthFa1w4bSk9f3Ecd5jJ3
         2hqneBrYkJe10kYOCTgyupgFlxqQUCAgEKbiJIUUHmL8sFwxRXRcnfbCeIlaGBC3PXEl
         d5gDKSs0pPO2LEiNKvvYYYyVgQ464aYKgI9A0=
MIME-Version: 1.0
In-Reply-To: <1254384558-1018-20-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
	 <1254384558-1018-20-git-send-email-tj@kernel.org>
Date: Fri, 2 Oct 2009 16:28:54 +0200
Message-ID: <c62985530910020728tf2cb581t5d7b7ef99f35395c@mail.gmail.com>
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed workqueue
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/1 Tejun Heo <tj@kernel.org>:
> Currently each workqueue has its own dedicated worker pool.  This
> causes the following problems.
>
> * Works which are dependent on each other can cause a deadlock by
>  depending on the same execution resource.  This is bad because this
>  type of dependency is quite difficult to find.
>
> * Works which may sleep and take long time to finish need to have
>  separate workqueues so that it doesn't block other works.  Similarly
>  works which want to be executed in timely manner often need to
>  create it custom workqueue too to avoid being blocked by long
>  running ones.  This leads to large number of workqueues and thus
>  many workers.
>
> * The static one-per-cpu worker isn't good enough for jobs which
>  require higher level of concurrency necessiating other worker pool
>  mechanism.  slow-work and async are good examples and there are also
>  some custom implementations buried in subsystems.
>
> * Combined, the above factors lead to many workqueues with large
>  number of dedicated and mostly unused workers.  This also makes work
>  processing less optimal as the dedicated workers end up switching
>  among themselves costing scheduleing overhead and wasting cache
>  footprint for their stacks and as the system gets busy, these
>  workers end up competing with each other.
>
> To solve the above issues, this patch implements concurrency-managed
> workqueue.
>
> There is single global cpu workqueue (gcwq) for each cpu which serves
> all the workqueues.  gcwq maintains single pool of workers which is
> shared by all cwqs on the cpu.
>
> gcwq keeps the number of concurrent active workers to minimum but no
> less.  As long as there's one or more running workers on the cpu, no
> new worker is scheduled so that works can be processed in batch as
> much as possible but when the last running worker blocks, gcwq
> immediately schedules new worker so that the cpu doesn't sit idle
> while there are works to be processed.



That's really a cool thing.
So once such new workers are created, what's the state/event that triggers their
destruction?

Is it the following, propagated recursively?

    Worker A blocks.
    B is created.
    B has just finished a worklet and A has been woken up
    Then destroy B
