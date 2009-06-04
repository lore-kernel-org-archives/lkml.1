Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZFDU40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZFDU40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZFDU4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:56:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61799 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZFDU4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:56:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=r5+aiSdc8N86yvzWZnEZYmiy/W2iyGoF0FJi9RWoKTc8t8zFIaXtSVvl+ruHbnbSA
	dSOwnVq3cy/3NUZLAQ7ig==
MIME-Version: 1.0
In-Reply-To: <20090604135050.ceb6bf18.akpm@linux-foundation.org>
References: <alpine.DEB.1.00.0906041330170.32557@bumblebee1.mtv.corp.google.com>
	 <20090604135050.ceb6bf18.akpm@linux-foundation.org>
Date: Thu, 4 Jun 2009 13:56:14 -0700
Message-ID: <4352991a0906041356u13ecb4dwce2c42c44b339231@mail.gmail.com>
Subject: Re: A bug in read operation for /dev/zero and a proposed fix.
From: Salman Qazi <sqazi@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 1:50 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 4 Jun 2009 13:32:55 -0700 (PDT)
> Salman Qazi <sqazi@google.com> wrote:
>
>> While running 20 parallel instances of dd as follows:
>>
>> #!/bin/bash
>>
>> for i in `seq 1 20`; do
>>          dd if=/dev/zero of=/export/hda3/dd_$i bs=1073741824 count=1 &
>> done
>> wait
>>
>> on a 16G machine, we noticed that rather than just killing the
>> processes, the entire kernel went down.  Stracing dd reveals that it first
>> does an mmap2, which makes 1GB worth of zero page mappings.  Then it
>> performs
>> a read on those pages from /dev/zero, and finally it performs a write.
>> The
>> machine died during the reads.  Looking at the code, it was noticed that
>> /dev/zero's read operation had been changed at some point from giving
>> zero page mappings to actually zeroing the page.  The zeroing of the
>> pages causes physical pages to be allocated to the process.
>
> erk, Nick broke dd(1):
>
>  commit 557ed1fa2620dc119adb86b34c614e152a629a80
>  Author: Nick Piggin <npiggin@suse.de>
>  Date:   Tue Oct 16 01:24:40 2007 -0700
>
>      remove ZERO_PAGE
>
>
> This is the first report I've seen of problems arising from that
> change.
>
>>  But, when
>> the process exhausts all the memory that it can, the kernel cannot kill
>> it, as it is still in the kernel mode allocating more memory.
>> Consequently,
>> the kernel eventually crashes.
>>
>> To fix this, I propose that when a fatal signal is pending during
>> /dev/zero read operation, we simply return and let the user process die.
>> Here is a patch that does that.
>>
>> Signed-off-by: Salman Qazi <sqazi@google.com>
>> ---
>> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
>> index 8f05c38..2ffa36e 100644
>> --- a/drivers/char/mem.c
>> +++ b/drivers/char/mem.c
>> @@ -696,6 +696,11 @@ static ssize_t read_zero(struct file * file, char __user * buf,
>>                       break;
>>               buf += chunk;
>>               count -= chunk;
>> +             /* The exit code here doesn't actually matter, as userland
>> +              * will never see it.
>> +              */
>> +             if (fatal_signal_pending(current))
>> +                     return -ENOMEM;
>>               cond_resched();
>>       }
>>       return written ? written : -EFAULT;
>
> OK.  I think.
>
> It's presumptuous to return -ENOMEM: we don't _know_ that this signal
> came from the oom-killer.  It would be better to return -EINTR here.

agreed.

>
