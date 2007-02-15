Return-Path: <linux-kernel-owner+w=401wt.eu-S1030695AbXBOTLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030695AbXBOTLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXBOTLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:11:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:47280 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030696AbXBOTL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:11:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,176,1170662400"; 
   d="scan'208"; a="197235739:sNHT353180912"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Thu, 15 Feb 2007 22:11:15 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC83A9F1@mssmsx411>
In-Reply-To: <909AD75B-3A4F-49BA-BF47-D143D2B01B71@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdRLsDbmq3FeVHNT+Ktvm573E0FjwAAV4DA
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Zach Brown" <zach.brown@oracle.com>
Cc: "Ken Chen" <kenchen@google.com>, <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Chris Mason" <chris.mason@oracle.com>
X-OriginalArrivalTime: 15 Feb 2007 19:11:25.0412 (UTC) FILETIME=[16640A40:01C75135]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It returns -EIOCBRETRY without guaranteeing that kick_iocb() will be  
> called.  This can lead to operations hanging

If EIOCBRETRY then generic_file_aio_write() will be recalled for the
same iocb.

> It overwrites -EIOCBQUEUED, leading to an aio_complete() while a  
> retry is happening.

EIOCBQUEUED or EIOCBRETRY does not lead to aio_complete() call:
        if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
                aio_complete(iocb, ret, 0);

> This can lead to reference count confusion.
But just reference count confusion was deleted by patch. Isn't it?

Leonid

-----Original Message-----
From: Zach Brown [mailto:zach.brown@oracle.com] 
Sent: Thursday, February 15, 2007 9:25 PM
To: Ananiev, Leonid I
Cc: Ken Chen; suparna@in.ibm.com; Andrew Morton;
linux-kernel@vger.kernel.org; linux-aio; Chris Mason
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy

> If invalidate_inode_pages2_range() will return EIOCBRETRY as the patch
> "aio: fix kernel bug when page is temporally busy"

Sorry Leonid, this patch is not safe.

It returns -EIOCBRETRY without guaranteeing that kick_iocb() will be  
called.  This can lead to operations hanging, both AIO and calls that  
come through do_sync_{read,write}.

It overwrites -EIOCBQUEUED, leading to an aio_complete() while a  
retry is happening.  This can lead to reference count confusion.   
Double-frees, referencing freed memory, that kind of thing.  This  
isn't a new problem.  The current code that overwrites with -EIO has  
this problem.  But moving to -EIOCBRETRY does introduce new behaviour  
of aio_complete() and the retry path racing.

I'll have a candidate patch to address the problem of EIO being  
raised on the way back up from a path which has returned -EIOCBQUEUED.

- z
