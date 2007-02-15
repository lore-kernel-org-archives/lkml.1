Return-Path: <linux-kernel-owner+w=401wt.eu-S1030439AbXBOSZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030439AbXBOSZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030460AbXBOSZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:25:51 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:47257 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030439AbXBOSZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:25:50 -0500
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC83A809@mssmsx411>
References: <B41635854730A14CA71C92B36EC22AAC83A809@mssmsx411>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <909AD75B-3A4F-49BA-BF47-D143D2B01B71@oracle.com>
Cc: "Ken Chen" <kenchen@google.com>, <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Chris Mason" <chris.mason@oracle.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Thu, 15 Feb 2007 10:25:16 -0800
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
