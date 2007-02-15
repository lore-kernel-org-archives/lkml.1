Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXBOXcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXBOXcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXBOXcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:32:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:36429 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbXBOXcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:32:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,178,1170662400"; 
   d="scan'208"; a="47012973:sNHT25182693"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Fri, 16 Feb 2007 02:32:11 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC83AA05@mssmsx411>
In-Reply-To: <7B7DC266-39EB-40AB-B797-A92329120FEE@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdRNtTzHxA3v/KzTHm5YEQjk5Ay4wAGbiaA
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Zach Brown" <zach.brown@oracle.com>
Cc: "Ken Chen" <kenchen@google.com>, <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Chris Mason" <chris.mason@oracle.com>
X-OriginalArrivalTime: 15 Feb 2007 23:32:08.0906 (UTC) FILETIME=[82A3CAA0:01C75159]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> If EIOCBRETRY then generic_file_aio_write() will be recalled for the
>> same iocb.
> Only if kick_iocb() is called.  It won't be called if i_i_p2_r() was  
> the only thing to return -EIOCBRETRY.
It is not need to call kick_iocb()
for generic_file_aio_write() calling.
It is recalled without any wakeup waiting:
        for (;;) {
                ret = filp->f_op->aio_write(&kiocb, &iov, 1,
kiocb.ki_pos);
                if (ret != -EIOCBRETRY)
                        break;
                wait_on_retry_sync_kiocb(&kiocb);
        }
Note: wait_on_retry_sync_kiocb() does not wait.
That is for dio. For aio iocb generic_file_aio_write() call
is required from ki_run_list while next io_submit or
read_events() is called.
So when an IO hang may happen?

>> It overwrites -EIOCBQUEUED
Do you mean that there is one more kernel bug which
overwrites -EIOCBQUEUED by any errno or number of bytes and this
new value is returned to caller as an IO result
while IO is not finished yet.

The proposed patch does not crate this bug if any.
It actually fixes a kernel panic bag when iocb.users count becomes
incorrect. The bag " Kernel BUG at fs/aio.c:509" is there because
aio_run_iocb() have not a chance to differ real EIO and
EIO which is actually means EAGAYN or EIOCBRETRY.
I'me sure the patch changes source code in correct direction:
to differentiate that two kinds of EIOs.

> Have you read the giant comment over the definition of struct kiocb  
> in include/linux/aio.h?
I have read. But compiler has not: it did not create an object code for
* If ki_retry returns -EIOCBRETRY ...

>>> This can lead to reference count confusion.
>> But just reference count confusion was deleted by patch. Isn't it?
>Sorry, I don't understand what you're trying to ask here.
One of reference count iocb.users confusion is deleted by the patch.
I'm not sure that there is other bag.

At least I have not see IO hang while testing.
It is interesting that I've not seen any EIOCBQUEUED returned
to aio_run_iocb() during 5 hours aiostress running.
Does it mean that EIOCBQUEUED is always reset and never returned?

Leonid

-----Original Message-----
From: Zach Brown [mailto:zach.brown@oracle.com] 
Sent: Thursday, February 15, 2007 10:23 PM
To: Ananiev, Leonid I
Cc: Ken Chen; suparna@in.ibm.com; Andrew Morton;
linux-kernel@vger.kernel.org; linux-aio; Chris Mason
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy


On Feb 15, 2007, at 11:11 AM, Ananiev, Leonid I wrote:

>> It returns -EIOCBRETRY without guaranteeing that kick_iocb() will be
>> called.  This can lead to operations hanging
>
> If EIOCBRETRY then generic_file_aio_write() will be recalled for the
> same iocb.

Only if kick_iocb() is called.  It won't be called if i_i_p2_r() was  
the only thing to return -EIOCBRETRY.

>
>> It overwrites -EIOCBQUEUED, leading to an aio_complete() while a
>> retry is happening.
>
> EIOCBQUEUED or EIOCBRETRY does not lead to aio_complete() call:

Not by fs/aio.c, but *by the place that originated -EIOCBQUEUED*.   
Later.  After IO has completed.  see fs/direct-io.c:dio_bio_end_aio().

This is what -EIOCBQUEUED means!  It's a promise to call aio_complete 
() in the future.

Have you read the giant comment over the definition of struct kiocb  
in include/linux/aio.h?

>> This can lead to reference count confusion.
> But just reference count confusion was deleted by patch. Isn't it?

Sorry, I don't understand what you're trying to ask here.

- z
