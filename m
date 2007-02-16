Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbXBPMUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbXBPMUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXBPMUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:20:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:36742 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbXBPMUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:20:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,180,1170662400"; 
   d="scan'208"; a="182767511:sNHT28185661"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Fri, 16 Feb 2007 15:18:58 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC83ABB0@mssmsx411>
In-Reply-To: <E29B98FF-8DDE-4AA5-AD65-75112B3E0DD6@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdRXZqGu9gfzMOsQO+pXJoiZBnCTAAVRuUA
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Zach Brown" <zach.brown@oracle.com>
Cc: "Ken Chen" <kenchen@google.com>, <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Chris Mason" <chris.mason@oracle.com>
X-OriginalArrivalTime: 16 Feb 2007 12:19:58.0454 (UTC) FILETIME=[C63AF160:01C751C4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
> It will not return until kiocbSetKicked() is called,  
> and that is only called from kick_iocb().
There is no test or wait of Kicked in considered
for (;;) aio_write() loop.

Zach Brown wrote:
>> The proposed patch does not crate this bug if any.
> Right, and I said that in the mail you're quoting.
...
> You're introducing other bugs with the patch.
Could you list other introduced bugs?

>> It is interesting that I've not seen any EIOCBQUEUED returned
>> to aio_run_iocb() during 5 hours aiostress running.
> What arguments are you running aio-stress with?  -EIOCBQUEUED is only

> used for O_DIRECT
I wrote in the vary first mail that the panic is appearing in
random write O_DIRECT aio-stress running. Other aio-stress modes
where tested after patching as well.

> and then only in certain circumstances.
Looking closely into sources we can see that
EIOCBQUEUED never may be returned to aio_run_iocb().

include/linux/aio.h says
* If ki_retry returns -EIOCBRETRY ...
Could you point source line which "returns -EIOCBRETRY"?

Leonid
-----Original Message-----
From: Zach Brown [mailto:zach.brown@oracle.com] 
Sent: Friday, February 16, 2007 3:01 AM
To: Ananiev, Leonid I
Cc: Ken Chen; suparna@in.ibm.com; Andrew Morton;
linux-kernel@vger.kernel.org; linux-aio; Chris Mason
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy


On Feb 15, 2007, at 3:32 PM, Ananiev, Leonid I wrote:

>>> If EIOCBRETRY then generic_file_aio_write() will be recalled for the
>>> same iocb.
>> Only if kick_iocb() is called.  It won't be called if i_i_p2_r() was
>> the only thing to return -EIOCBRETRY.
> It is not need to call kick_iocb()
> for generic_file_aio_write() calling.
> It is recalled without any wakeup waiting:
>         for (;;) {
>                 ret = filp->f_op->aio_write(&kiocb, &iov, 1,
> kiocb.ki_pos);
>                 if (ret != -EIOCBRETRY)
>                         break;
>                 wait_on_retry_sync_kiocb(&kiocb);
>         }
> Note: wait_on_retry_sync_kiocb() does not wait.

Yes it does.  It will not return until kiocbSetKicked() is called,  
and that is only called from kick_iocb().

>>> It overwrites -EIOCBQUEUED
> Do you mean that there is one more kernel bug which
> overwrites -EIOCBQUEUED by any errno or number of bytes and this
> new value is returned to caller as an IO result
> while IO is not finished yet.
>
> The proposed patch does not crate this bug if any.

Right, and I said that in the mail you're quoting.

> It actually fixes a kernel panic bag when iocb.users count becomes
> incorrect. The bag " Kernel BUG at fs/aio.c:509" is there because
> aio_run_iocb() have not a chance to differ real EIO and
> EIO which is actually means EAGAYN or EIOCBRETRY.

Yes, I understand the bug you're trying to fix.  You're introducing  
other bugs with the patch.  It will not be merged.

> It is interesting that I've not seen any EIOCBQUEUED returned
> to aio_run_iocb() during 5 hours aiostress running.

What arguments are you running aio-stress with?  -EIOCBQUEUED is only  
used for O_DIRECT, and then only in certain circumstances.

- z
