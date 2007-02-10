Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXBJV5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXBJV5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXBJV5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:57:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:31850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXBJV5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:57:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,310,1167638400"; 
   d="scan'208"; a="45219571:sNHT19401516"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Sun, 11 Feb 2007 00:57:18 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC804B02@mssmsx411>
In-Reply-To: <b040c32a0702101005q7ff4a679xd3586531aa8a99cc@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdNPhCje+AZGt65T76Cw7xbV0K8hgAHeenw
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Ken Chen" <kenchen@google.com>
Cc: <suparna@in.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
X-OriginalArrivalTime: 10 Feb 2007 21:57:23.0929 (UTC) FILETIME=[72106490:01C74D5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen writes:
> So any error value returned from invalidate_inode_pages2_range() has
> to be taken seriously in the direct IO submit path instead of dropping
> it to the floor.

If invalidate_inode_pages2_range() will return EIOCBRETRY as the patch 
"aio: fix kernel bug when page is temporally busy"
serts then do_sync_read/write() will not drop IO submit but will retry
it:
        for (;;) {
                ret = filp->f_op->aio_read(&kiocb, &iov, 1,
kiocb.ki_pos);
                if (ret != -EIOCBRETRY)
                        break;
                wait_on_retry_sync_kiocb(&kiocb);
        }

And do_sync_read/write() will not return EIO if page is busy as it does
now, befor patching.
Curretly do_sync_read/write() tests for EIOCBRETRY. But EIOCBRETRY is
not set ever.

Leonid
