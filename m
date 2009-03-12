Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZCLDLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZCLDLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZCLDLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:11:34 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:45546 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZCLDLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:11:34 -0400
Message-ID: <49B87CFE.4000701@cosmosbay.com>
Date: Thu, 12 Mar 2009 04:09:50 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@redhat.com>,
       linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com, bcrl@kvack.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit
 to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>	<49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com>
In-Reply-To: <49B875F7.3030305@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 12 Mar 2009 04:09:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Eric Dumazet a écrit :
>> Jeff Moyer a écrit :
>>> Avi Kivity <avi@redhat.com> writes:
>>>
>>>> Jeff Moyer wrote:
>>>>> Hi,
>>>>>
>>>>> Believe it or not, I get numerous questions from customers about the
>>>>> suggested tuning value of aio-max-nr.  aio-max-nr limits the total
>>>>> number of io events that can be reserved, system wide, for aio
>>>>> completions.  Each time io_setup is called, a ring buffer is allocated
>>>>> that can hold nr_events I/O completions.  That ring buffer is then
>>>>> mapped into the process' address space, and the pages are pinned in
>>>>> memory.  So, the reason for this upper limit (I believe) is to keep a
>>>>> malicious user from pinning all of kernel memory.  Now, this sounds like
>>>>> a much better job for the memlock rlimit to me, hence the following
>>>>> patch.
>>>>>   
>>>> Is it not possible to get rid of the pinning entirely?  Pinning
>>>> interferes with page migration which is important for NUMA, among
>>>> other issues.
>>> aio_complete is called from interrupt handlers, so can't block faulting
>>> in a page.  Zach mentions there is a possibility of handing completions
>>> off to a kernel thread, with all of the performance worries and extra
>>> bookkeeping that go along with such a scheme (to help frame my concerns,
>>> I often get lambasted over .5% performance regressions).
>> This aio_completion from interrupt handlers keep us from using SLAB_DESTROY_BY_RCU
>> instead of call_rcu() for "struct file" freeing.
>>
>> http://lkml.org/lkml/2008/12/17/364
>>
>> I would love if we could get rid of this mess...
> 
> Speaking of that, I tried to take a look at this aio stuff and have one question.
> 
> Assuming that __fput() cannot be called from interrupt context.
> -> fput() should not be called from interrupt context as well.
> 
> How comes we call fput(req->ki_eventfd) from really_put_req()
> from interrupt context ?
> 
> If user program closes eventfd, then inflight AIO requests can trigger
> a bug.
> 

Path could be :

1) fput() changes so that calling it from interrupt context is possible
   (Using a working queue to make sure __fput() is called from process context)

2) Changes aio to use fput() as is (and zap its internal work_queue and aio_fput_routine() stuff)

3) Once atomic_long_dec_and_test(&filp->f_count) only performed in fput(),
   SLAB_DESTROY_BY_RCU for "struct file" get back :)


