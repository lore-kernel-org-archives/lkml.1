Return-Path: <linux-kernel-owner+w=401wt.eu-S2992435AbXBIRDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992435AbXBIRDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992436AbXBIRDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:03:32 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:61008 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992435AbXBIRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:03:31 -0500
In-Reply-To: <20070209110555.GA11232@in.ibm.com>
References: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411> <Pine.LNX.4.64.0702091042330.25686@twin.jikos.cz> <20070209021444.2213deb6.akpm@linux-foundation.org> <Pine.LNX.4.64.0702091137530.25686@twin.jikos.cz> <20070209110555.GA11232@in.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5C55DFF2-6593-41FD-A161-D99331E419E3@oracle.com>
Cc: Jiri Kosina <jikos@jikos.cz>, Andrew Morton <akpm@linux-foundation.org>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       linux-kernel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
       Chris Mason <chris.mason@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: fix kernel bug when page is  temporally busy
Date: Fri, 9 Feb 2007 12:02:08 -0500
To: suparna@in.ibm.com
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9, 2007, at 6:05 AM, Suparna Bhattacharya wrote:

> On Fri, Feb 09, 2007 at 11:40:27AM +0100, Jiri Kosina wrote:
>> On Fri, 9 Feb 2007, Andrew Morton wrote:
>>
>>>> @@ -1204,7 +1204,7 @@ generic_file_aio_read(struct kiocb *iocb,  
>>>> const struct iovec *iov,
>>>>  			do_generic_file_read(filp,ppos,&desc,file_read_actor);
>>>>  			retval += desc.written;
>>>>  			if (desc.error) {
>>>> -				retval = retval ?: desc.error;
>>>> +				retval = desc.error;

I was worried about this too.

> blocking. The high level AIO code (see aio_rw_vect_rety) has the  
> ability
> to handle this.

I had missed this, and yeah, that's some level of comfort.

But I'm not convinced we can guarantee that's safe.  The positive  
return code that aio_rw_vect_retry() sees is telling it that some IO  
has completed and, arguably, that no more IO is in flight.  If we  
return partial progress from generic_file_aio_read() while we have an  
iocb in a wait queue then we are adding yet another invariant.  That  
while an iocb is pending from a previous call down the call chain, we  
can't return a non-aio negative error.  Doing so would cause fs/aio.c  
to complete while there is still an iocb on a wait queue from a  
previous retry attempt.  Right?

I also noticed something just now while poking around these paths to  
see if I could get the start of generic_file_aio_read() to fail when  
it had previously succeeded.  What's to stop another task from racing  
to set O_DIRECT between retries?

That sounds like a pretty hilarious way to get a read retry to fail  
due to buffer misalignment while a previously buffered instance of it  
is still in flight.  Hi-larious.

In thinking about this a discussing it with Chris a bit, I wonder if  
the right fix isn't to refuse changing O_DIRECT via setfl() once any  
IO paths have started on the filp.  Something like:

	filp->frozen_flags |= O_DIRECT

at the start of paths and check it in setfl()?

Are we similarly worried about O_APPEND?

- z
