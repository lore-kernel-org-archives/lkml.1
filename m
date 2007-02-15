Return-Path: <linux-kernel-owner+w=401wt.eu-S1161286AbXBOVGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161286AbXBOVGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161288AbXBOVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:06:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:17588 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161286AbXBOVGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:06:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,177,1170662400"; 
   d="scan'208"; a="182473949:sNHT35976206"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Fri, 16 Feb 2007 00:06:31 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC83A9FF@mssmsx411>
In-Reply-To: <7B7DC266-39EB-40AB-B797-A92329120FEE@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdRNtTzHxA3v/KzTHm5YEQjk5Ay4wADQ/Vg
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Zach Brown" <zach.brown@oracle.com>
Cc: "Ken Chen" <kenchen@google.com>, <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Chris Mason" <chris.mason@oracle.com>
X-OriginalArrivalTime: 15 Feb 2007 21:06:32.0651 (UTC) FILETIME=[2B6D11B0:01C75145]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



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
