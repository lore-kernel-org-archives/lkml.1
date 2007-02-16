Return-Path: <linux-kernel-owner+w=401wt.eu-S1422752AbXBPABf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422752AbXBPABf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422761AbXBPABf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:01:35 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:33147 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422752AbXBPABe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:01:34 -0500
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC83AA05@mssmsx411>
References: <B41635854730A14CA71C92B36EC22AAC83AA05@mssmsx411>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E29B98FF-8DDE-4AA5-AD65-75112B3E0DD6@oracle.com>
Cc: "Ken Chen" <kenchen@google.com>, <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Chris Mason" <chris.mason@oracle.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Thu, 15 Feb 2007 16:01:06 -0800
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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
