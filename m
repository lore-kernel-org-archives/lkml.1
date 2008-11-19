Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYKSRWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYKSRWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYKSRVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:21:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:10846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYKSRVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:21:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=xSotNcI73rBhunSDXMeCSHmfdlDJsQP83TZs0oaTt5kA+mp00PHdq7Wo1FI8ioxlE
	wSIbC9i8Z4Pj6rZ+FWkMQ==
MIME-Version: 1.0
In-Reply-To: <1227113662.29743.46.camel@lappy.programming.kicks-ass.net>
References: <b040c32a0811182248s1174c82avf44c720ae2d14804@mail.gmail.com>
	 <1227113662.29743.46.camel@lappy.programming.kicks-ass.net>
Date: Wed, 19 Nov 2008 09:21:46 -0800
Message-ID: <b040c32a0811190921g557edc4dy4725fb86107c2c54@mail.gmail.com>
Subject: Re: [patch] sched: add locking when update the task_group's cfs_rq[] 
	array.
From: Ken Chen <kenchen@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 8:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2008-11-18 at 22:48 -0800, Ken Chen wrote:
>> add locking when update the task_group's cfs_rq[] array.  tg_shares_up()
>> can be potentially executed concurrently on multiple CPUs with overlaping
>> cpu mask depending on where task_cpu() was when a task got woken up.  Lack
>> of any locking while redistribute tg->shares over cfs_rq[] array opens up
>> a large window for conflict updates and utimately cause corruptions to the
>> integrity of per cpu cfs_rq shares. Add a tg_lock to protect the operations.
>
> I see why you want to do this, but introducing a global lock makes me
> sad :/

I wholly agree on the scalability.  The bigger the system, the more it
needs to protect the integrity of cfs_rq[]->shares that the sum still
adds up to tg->shares.  Otherwise, the share distributed on each CPU's
cfs_rq might go wildly and indirectly leads to fluctuation of
effective total tg->shares.  However, I have the same doubt that this
will scale on large CPU system.  Does CFS really have to iterate the
whole task_group tree?

- Ken
