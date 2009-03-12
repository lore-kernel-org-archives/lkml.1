Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZCLT0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZCLT0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZCLT0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:26:32 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50733 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZCLT0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:26:31 -0400
Message-ID: <49B960DE.6000406@cosmosbay.com>
Date: Thu, 12 Mar 2009 20:22:06 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@redhat.com>,
       linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com, bcrl@kvack.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] fs: fput() can be called from interrupt context
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>	<49B54143.1010607@redhat.com>	<x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>	<49B57CB0.5020300@cosmosbay.com>	<49B875F7.3030305@cosmosbay.com>	<49B87CFE.4000701@cosmosbay.com>	<49B89B22.7080303@cosmosbay.com>	<20090311224712.fb8db075.akpm@linux-foundation.org>	<49B8A75E.6040409@cosmosbay.com> <20090311233903.f036027a.akpm@linux-foundation.org>
In-Reply-To: <20090311233903.f036027a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 12 Mar 2009 20:22:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Thu, 12 Mar 2009 07:10:38 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>>> Did you reproduce the bug, and confirm that the patch fixes it?
>> take Davide program : http://www.xmailserver.org/eventfd-aio-test.c
>>
>> and add at line 318 :
>> close(afd);
>>
>> It should produce the kernel bug...
> 
> "should"?

Sorry I had to run this morning, so I was a litle bit lazy...

Maybe some kind of O_DIRECT / NFS / blockdev setup or something calling 
aio_complete() from interrupt context ? I am not familiar of this part,
but considering spin_lock_irq()/spin_unlock_irq() calls in fs/aio.c,
there must be a reason for this ?

> 
>>> Are there simpler ways of fixing it?  Maybe sneak a call to
>>> wait_for_all_aios() into the right place?  I doubt if it's performance
>>> critical, as nobody seems to have ever hit the bug.
>> Take the time to check how fs/aio.c handle the fput(req->ki_filp) case
>> (or read my 2nd patch, it should spot the thing)
> 
> Well yes, a kludge like that seems a bit safer.
> 
> It's somewhat encouraging that we're apparently already doing fput()
> from within keventd (although how frequently?).  There might be
> problems with file locking, security code, etc from doing fput() from
> an unexpected thread.  And then there are all the usual weird problem
> with using the keventd queues which take a long time to get discovered.
> 

Hum... Do you mean "if (in_interrupt())" is not the right test to
perform ? 

> 
>> If you want to add another kludge to properly fput(req->ki_eventfd),
>> be my guest :-(
>>
>>> Bear in mind that if the bug _is_ real then it's now out there, and
>>> we would like a fix which is usable by 2.6.<two-years-worth>.
> 
> The patches are large and scary and it would be a real problem to merge
> them into 2.6.29 at this stage, let alone 2.6.25, etc.
> 
> Especially as the code which you sent out appears to be untested:
> 

I actually tested it and got a working kernel before sending patch,
please trust me...

Oh yes, my dev machine always called the slow path then, this is
why I didnt noticed.

Thank you for spotting this inverted test.

>>  void fput(struct file *file)
>>  {
>> -	if (atomic_long_dec_and_test(&file->f_count))
>> -		__fput(file);
>> +	if (atomic_long_dec_and_test(&file->f_count)) {
>> +		if (unlikely(!in_interrupt()))
> 
>                              ^
> 
>> +			fd_defer_queue(NULL, file);
>> +		else
>> +			__fput(file);
>> +	}
>>  }
> 

