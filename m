Return-Path: <linux-kernel-owner+w=401wt.eu-S936061AbXEUUBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936061AbXEUUBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935884AbXEUT4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:56:39 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:40511 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935748AbXEUT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:56:38 -0400
Message-ID: <4651F93C.2020806@cosmosbay.com>
Date: Mon, 21 May 2007 21:55:40 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: second, bigger problem with private futexes
References: <4651D628.1070206@redhat.com> <4651E1D4.6010705@cosmosbay.com> <4651E44A.9070301@redhat.com> <4651E992.9080205@cosmosbay.com> <4651F261.2040903@cosmosbay.com> <4651F653.9060802@redhat.com>
In-Reply-To: <4651F653.9060802@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 21 May 2007 21:55:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Dumazet wrote:
>> 3) if condvar is PRIVATE and mutex is SHARED, a FUTEX_WAKE_PRIVATE
>> should be done. (and loose the REQUEUE optim)
>> Yes we could add a special futex primitive for this special case. But I
>> cannot see how a program could use such a construct.
> 
> Very easily: mutexes are often created independently from the condvars
> and they are used for many things.  Maybe a program is even creating all
> mutexes as shared to be ready for all situations.  Normally doing this
> is no big problem, the performance penalties are minimal.
> 
> 
>> 4) if condvar is SHARED and mutex is private, we have a *problem*,
>> because the process doing the broadcast() can be in another mm. So a
>> requeue is not possible at all.
> 
> It is if we can specify the owner of the mutex.  I.e., the PID.

well, then we have a refcounting issue on pid , or problem in pid reuse.

> 
> But yes, this case is extremely ugly.
> 
> 
> The problem is that all these cases worked nice so far.  They all had
> the same good performance.  Now we are severely penalizing code which
> mismatches condvar and mutex shared attributes.  There is a good reason
> why we introduced FUTEX_CMP_REQUEUE, the benefits in certain programs is
> huge.

This analysis seems unfair to me, after a quick reading of glibc code.

Right now, glibc cannot use FUTEX_CMP_REQUEUE if condvar is pshared.

/* Do not use requeue for pshared condvars.  */
if (cond->__data.__mutex == (void *) ~0l)
	goto wake_all;

So how introducing private futexes is penalizing this case ?

Fact is that if condvar is pshared, we *cannot* use CMP_REQUEUE since threads 
doing the broadcast() can be in a separate process and virtual address of 
mutex of waiting threads could point to unrelated memory.

Thanks

