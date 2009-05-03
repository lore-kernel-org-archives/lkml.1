Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZECCjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZECCjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 22:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZECCjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 22:39:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:51657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZECCjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 22:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TQYqPNBFR8l2/1Vki24jkgpDOANwkFLk0dLQHRo0yxiiNSVDx2XjQpq3LV4E+D7Z0H
         o2z/ixyHJ5Efh/aFiwhAO7LCXH0cVFBGkntriZXJSSBxbvf9BDiB2gVwBXW2JKpvnkef
         zCv7y32vkZW8Se5doX4d6v0t8Rh73dY09ajbk=
Message-ID: <49FD040B.4040705@gmail.com>
Date: Sun, 03 May 2009 11:40:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] Fix dirty page accounting in	redirty_page_for_writepage()
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu>
In-Reply-To: <20090430062140.GA9559@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
>> And thanks for the review! This excercise only convinced me that 
>> the kernel memory accounting works as expected. All this gave me 
>> the chance to have a good look at the memory accounting code. We 
>> could probably benefit of Christoph Lameter's cpu ops (using 
>> segment registers to address per-cpu variables with atomic 
>> inc/dec) in there. Or at least removing interrupt disabling by 
>> using preempt disable and local_t variables for the per-cpu 
>> counters could bring some benefit.
> 
> Note, optimized per cpu ops are already implemented upstream, by 
> Tejun Heo's percpu patches in .30:
> 
>  #define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
>  #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
>  #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
>  #define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
>  #define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
>  #define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
>  #define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
> 
> See:
> 
>   6dbde35: percpu: add optimized generic percpu accessors

One problem I have with the above api is that those take the variable
symbol not pointer to it, so they can't be used with dynamic
variables.  The api needs major revisions anyway regarding atomicity
and I was planning on getting back to it once the all archs have been
converted and hoping that it wouldn't be used widely before that,
but then again it's not like changing percpu api and its users is
difficult thing to do and there are a lot of benefits in testing how
things work as soon as possible.

Thanks.

-- 
tejun
