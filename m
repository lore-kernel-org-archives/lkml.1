Return-Path: <linux-kernel-owner+w=401wt.eu-S1030731AbXBOTXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030731AbXBOTXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030743AbXBOTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:23:38 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:24255 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030731AbXBOTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:23:37 -0500
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC83A9F1@mssmsx411>
References: <B41635854730A14CA71C92B36EC22AAC83A9F1@mssmsx411>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7B7DC266-39EB-40AB-B797-A92329120FEE@oracle.com>
Cc: "Ken Chen" <kenchen@google.com>, <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Chris Mason" <chris.mason@oracle.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Thu, 15 Feb 2007 11:22:58 -0800
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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
