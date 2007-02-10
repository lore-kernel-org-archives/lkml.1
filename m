Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbXBJS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbXBJS1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 13:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXBJS1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 13:27:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:34033 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbXBJS1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 13:27:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,310,1167638400"; 
   d="scan'208"; a="180054181:sNHT23790998"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Sat, 10 Feb 2007 21:27:46 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC804AFE@mssmsx411>
In-Reply-To: <b040c32a0702101005q7ff4a679xd3586531aa8a99cc@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdNPhCje+AZGt65T76Cw7xbV0K8hgAAtgyA
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Ken Chen" <kenchen@google.com>
Cc: <suparna@in.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
X-OriginalArrivalTime: 10 Feb 2007 18:27:42.0087 (UTC) FILETIME=[26B3A970:01C74D41]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If invalidate_inode_pages2_range() says it can not invalidate pages,
> while dio to the same file offset range is in flight, something is
> really wrong there.

If invalidate_inode_pages2_range() says it can not invalidate pages
It means that soft_irq does completing now on other cpu.
Next retry() will see a IO well completed.
Leonid

-----Original Message-----
From: Ken Chen [mailto:kenchen@google.com] 
Sent: Saturday, February 10, 2007 9:05 PM
To: Ananiev, Leonid I
Cc: suparna@in.ibm.com; Andrew Morton; linux-kernel@vger.kernel.org;
linux-aio; Zach Brown; Chris Mason; Badari Pulavarty
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy

On 2/9/07, Ananiev, Leonid I <leonid.i.ananiev@intel.com> wrote:
> I have used EIOCBRETRY in the patch to minimize source code
modification
> only.
> [...]
> A lot of errno's have different meaning in different functions or
> contexts. EAGAIN could be used instated of EIOCBRETRY for irredundant
> set.

I also think the original patch is wrong.  It might shut up kernel
panic by eliminate double calls to aio_complete(), but it will
silently introduce data corruption.

If invalidate_inode_pages2_range() says it can not invalidate pages,
while dio to the same file offset range is in flight, something is
really wrong there.  In generic_file_direct_IO, the function
explicitly flushes all dirty pages and wait on them before submits
DIO.

So any error value returned from invalidate_inode_pages2_range() has
to be taken seriously in the direct IO submit path instead of dropping
it to the floor.

- Ken
