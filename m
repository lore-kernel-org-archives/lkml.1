Return-Path: <linux-kernel-owner+w=401wt.eu-S1422783AbXBUSe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422783AbXBUSe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422785AbXBUSe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:34:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53389 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422783AbXBUSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:34:54 -0500
In-Reply-To: <20070221141318.GA8199@in.ibm.com>
References: <20070219213830.4032.71308.sendpatchset@tetsuo.zabbo.net> <20070219213835.4032.87439.sendpatchset@tetsuo.zabbo.net> <20070221141318.GA8199@in.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CE218419-352C-4D22-BACF-12D389EA9B19@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Leonid Ananiev <leonid.i.ananiev@intel.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Wed, 21 Feb 2007 10:34:28 -0800
To: suparna@in.ibm.com
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is an interesting trick, but I'd like to consider hard whether  
> the added
> complexity is worth it. Could you list the various other cases you  
> have in mind
> which would want to use it ?

I'm happy to report that the sync case and the  
invalidate_inode_pages2_range() case are the only two which try to  
rewrite 'ret'.  I audited all the call paths between aio_{read,write}  
and -EIOCBQUUEUED.

So, sure, maybe we can shuffle the house of cards a little in the  
direction away from having a fs/aio.c helper for the situation by  
simply removing the few current instances of the problem.  It won't  
scale as people add problems without knowing about the rule to not  
overwrite -EIOCBQUEUED, but hopefully that won't be a rule for much  
longer :) :).

For the O_SYNC case we could add another magical test to the is_async  
assignment which won't perform AIO on O_SYNC descriptors.

> For the invalidate_inode_pages2_range() case, I wonder if the right
> place to issue this is after the direct IO write has completed and  
> before
> aio_complete() is issued (somewhat like the way we do  
> bio_check_pages_dirty
> for DIO reads), rather than after submission when the IO may still  
> not have
> hit the disk. This would also make the behaviour uniform for  
> synchronous and
> async cases.

Hmm, I think I like that.  It solves the problem for the current sole  
user of -EIOCBQUEUED without too much disruption.

> BTW, am I right in interpreting that with your change aio_complete 
> () may
> trigger an io_getevents() wakeup, before the corresponding event is  
> placed
> on the ring buffer ?

Hmm, yeah, it looks like I goofed that.

I'll roll a patch which does the invalidation down in fs/direct-io.c.

- z
