Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbXCEUIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbXCEUIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXCEUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:08:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:16318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbXCEUIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:08:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,251,1170662400"; 
   d="scan'208"; a="190407243:sNHT24112515"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/3] aio: fix oops because of extra IO control block freeing.
Date: Mon, 5 Mar 2007 23:08:09 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC8CA23F@mssmsx411>
In-Reply-To: <Pine.LNX.4.44L0.0703051428150.3843-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/3] aio: fix oops because of extra IO control block freeing.
Thread-Index: AcdfXX92n01AS+1jRdyazElCPqZNBQAACwQg
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Mar 2007 20:08:28.0220 (UTC) FILETIME=[09FA97C0:01C75F62]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>Where is kiocbSetPgBusy() defined,
It is defined in include/linux/aio.h (introduced in [PATCH 1/3])
>  and where in the documentation is it explained?
I will add a comment for kiocbSetPgBusy()in aio.h.

> For that matter, what is the reason for changing the return value at
all?
EIORETRY is not IO return value at all. It is processing stage.
It conflicts with IO return value. That is why a flag in iocb is used.
It should be noted that loop but not EIOCBRETRY was used for vector IO
(mm/filemap.c)

Leonid
>-----Original Message-----
>From: Alan Stern [mailto:stern@rowland.harvard.edu]
>Sent: Monday, March 05, 2007 10:36 PM
>To: Ananiev, Leonid I
>Cc: Kernel development list
>Subject: Re: [PATCH 2/3] aio: fix oops because of extra IO control
block freeing.
>
>On Mon, 5 Mar 2007, Leonid Ananiev wrote:
>
>>  From Leonid Ananiev
>>
>> This patch finishes moving from using errno EIOCBRETRY to using flag
in
>> IO control block for aio retrying. After this change the process will
be
>> kicked for direct aio as it was for sync aio.
>>
>> Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
>>
>> The patch is applied to 2.6.20 or 2.6.21-rc2
>> diff -uprN -X linux-2.6.20-aio21/Documentation/dontdiff
>> linux-2.6.20-aio21/drivers/usb/gadget/inode.c
>> linux-2.6.20-aio22/drivers/usb/gadget/inode.c
>> --- linux-2.6.20-aio21/drivers/usb/gadget/inode.c	2007-03-04
>> 21:45:52.000000000 +0300
>> +++ linux-2.6.20-aio22/drivers/usb/gadget/inode.c	2007-03-05
>> 18:19:35.000000000 +0300
>> @@ -692,7 +692,10 @@ fail:
>>   		kfree(priv);
>>   		put_ep(epdata);
>>   	} else
>> -		value = (iv ? -EIOCBRETRY : -EIOCBQUEUED);
>> +		if (iv)
>> +			kiocbSetPgBusy(iocb);
>> +		else
>> +			value = -EIOCBQUEUED;
>>   	return value;
>>   }
>>
>> diff -uprN -X linux-2.6.20-aio21/Documentation/dontdiff
>> linux-2.6.20-aio21/fs/ocfs2/dlmglue.c
linux-2.6.20-aio22/fs/ocfs2/dlmglue.c
>> --- linux-2.6.20-aio21/fs/ocfs2/dlmglue.c	2007-03-04
21:45:52.000000000
>> +0300
>> +++ linux-2.6.20-aio22/fs/ocfs2/dlmglue.c	2007-03-04
22:57:50.000000000
>> +0300
>> @@ -1639,7 +1639,7 @@ int ocfs2_meta_lock_full(struct inode *i
>>
>>   	status = ocfs2_cluster_lock(osb, lockres, level, dlm_flags,
arg_flags);
>>   	if (status < 0) {
>> -		if (status != -EAGAIN && status != -EIOCBRETRY)
>> +		if (status != -EAGAIN)
>>   			mlog_errno(status);
>>   		goto bail;
>>   	}
>> diff -uprN -X linux-2.6.20-aio21/Documentation/dontdiff
>> linux-2.6.20-aio21/include/linux/aio.h
>> linux-2.6.20-aio22/include/linux/aio.h
>> --- linux-2.6.20-aio21/include/linux/aio.h	2007-03-04
21:46:45.000000000
>> +0300
>> +++ linux-2.6.20-aio22/include/linux/aio.h	2007-03-04
22:57:50.000000000
>> +0300
>> @@ -79,15 +79,6 @@ struct kioctx;
>>    * not ask the method again -- ki_retry must ensure forward
progress.
>>    * aio_complete() must be called once and only once in the future,
>> multiple
>>    * calls may result in undefined behaviour.
>> - *
>> - * If ki_retry returns -EIOCBRETRY it has made a promise that
kick_iocb()
>> - * will be called on the kiocb pointer in the future.  This may
happen
>> - * through generic helpers that associate kiocb->ki_wait with a wait
>> - * queue head that ki_retry uses via current->io_wait.  It can also
happen
>> - * with custom tracking and manual calls to kick_iocb(), though that
is
>> - * discouraged.  In either case, kick_iocb() must be called once and
only
>> - * once.  ki_retry must ensure forward progress, the AIO core will
wait
>> - * indefinitely for kick_iocb() to be called.
>>    */
>>   struct kiocb {
>>   	struct list_head	ki_run_list;
>> diff -uprN -X linux-2.6.20-aio21/Documentation/dontdiff
>> linux-2.6.20-aio21/include/linux/errno.h
>> linux-2.6.20-aio22/include/linux/errno.h
>> --- linux-2.6.20-aio21/include/linux/errno.h	2007-03-04
>> 21:45:51.000000000 +0300
>> +++ linux-2.6.20-aio22/include/linux/errno.h	2007-03-04
>> 22:57:50.000000000 +0300
>> @@ -22,7 +22,6 @@
>>   #define EBADTYPE	527	/* Type not supported by server */
>>   #define EJUKEBOX	528	/* Request initiated, but will not
complete
>> before timeout */
>>   #define EIOCBQUEUED	529	/* iocb queued, will get
completion event */
>> -#define EIOCBRETRY	530	/* iocb queued, will trigger a retry */
>>
>>   #endif
>
>Where is kiocbSetPgBusy() defined, and where in the documentation is it
>explained?  For that matter, what is the reason for changing the return
>value at all?
>
>And if you are going to change, why not make the return value something
>more logical?  For instance, return 0 to indicate the iocb is complete
and
>-EINPROGRESS to indicate another kick will occur.
>
>Alan Stern
