Return-Path: <linux-kernel-owner+w=401wt.eu-S965364AbXBOJSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364AbXBOJSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 04:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXBOJSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 04:18:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:31238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965364AbXBOJSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 04:18:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,173,1170662400"; 
   d="scan'208"; a="197047803:sNHT498422337"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Thu, 15 Feb 2007 12:16:23 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC83A809@mssmsx411>
In-Reply-To: <b040c32a0702101005q7ff4a679xd3586531aa8a99cc@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdNPhCje+AZGt65T76Cw7xbV0K8hgC9wNrg
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Ken Chen" <kenchen@google.com>
Cc: <suparna@in.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Chris Mason" <chris.mason@oracle.com>
X-OriginalArrivalTime: 15 Feb 2007 09:16:56.0169 (UTC) FILETIME=[09DD7D90:01C750E2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote
> It might shut up kernel
> panic by eliminate double calls to aio_complete(), but it will
> silently introduce data corruption.

I had got kernel panic after an hour of aiostress running.
After patching I have not got aiostress massage 
"verify error, file %s offset %Lu contents (offset:bad:good):\n"
during 5 hour aiostress running with 'verify' option.
Looking closely into aiostress.c 
ftp://ftp.suse.com/pub/people/mason/utils/aio-stress.c
we can see that this program may write in random mode THE SAME
contents to the same file offset asynchronously from different
buffers and do not cure about it. Does Ken consider that kernel
panic is the best way to prevent data corruption in such kind
of programs?

> So any error value returned from invalidate_inode_pages2_range() has
> to be taken seriously in the direct IO submit path instead of dropping
> it to the floor.
If invalidate_inode_pages2_range() will return EIOCBRETRY as the patch 
"aio: fix kernel bug when page is temporally busy"
sets then do_sync_read/write() will not drop IO submit but will retry
it:
for (;;) {
	ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
	if (ret != -EIOCBRETRY)
		break;
	wait_on_retry_sync_kiocb(&kiocb);
	}
And do_sync_read/write() will not return EIO if page is busy
as it does now, before patching.

Ken Chen wrote:
> I also think the original patch is wrong.
What do you mean saying 'also'?

Leonid

