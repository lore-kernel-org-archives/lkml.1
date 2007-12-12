Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbXLLHwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbXLLHwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 02:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbXLLHwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 02:52:21 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:46994 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbXLLHwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 02:52:20 -0500
Message-Id: <6.0.0.20.2.20071212132928.00388ac0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Wed, 12 Dec 2007 16:51:24 +0900
To: Zach Brown <zach.brown@oracle.com>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] dio: falling through to buffered I/O when
  invalidationof a page fails
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <475F32B0.20107@oracle.com>
References: <6.0.0.20.2.20071210164242.03915ca8@172.19.0.2>
 <475F32B0.20107@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 >
 >>
 >> Past discussion about this issue is as follows.
 >> http://marc.info/?t=119343431200004&r=1&w=2
 >> http://marc.info/?t=112656762800002&r=1&w=2
 >>
 >> 2, invalidate_inode_pages2_range() sets ret=-EIO when
 >> invalidate_complete_page2()
 >> fails, but this ret is cleared if do_launder_page() succeed on a page of
 >> next index.
 >
 >Oops.  That's too bad.  So maybe we should fix it by not stomping on
 >that return code?
 >
 >	ret2 = do_launder()
 >	if (ret2 == 0)
 >		ret2 = invalidate()
 >	if (ret == 0)
 >		ret = ret2
 >
 >I'd be surprised if we ever wanted to mask an -EIO when later pages
 >laundered successfully.

This can preserve ret of -EIO. But it cannot be distinguished between
the error of invalidation and other error only by this fix.


 >> I solved problems above by introducing invalidate_inode_pages3_range()
 >> and falling
 >> through to buffered I/O when invalidation of a page failed.
 >
 >Well, I like the idea of more intelligently dealing with the known
 >problem between dio and ext3.  I'm not sure that falling back to
 >buffered is right.

In the past discussion above, it was said that dio was a sort of best
effort function. So dio falls back to buffered IO when writing to hall, I think.
My idea is that this notion applies to this issue.

 >
 >> We can distinguish between failure of page invalidation and other errors
 >> with the return value of invalidate_inode_pages3_range().
 >
 >I'm not sure duplicating the invalidation loop into a new function is
 >the right thing.  Maybe we'd just tweak inode_pages2 to indicate to the
 >caller the specific failing circumstances somehow.  Maybe.

It will be better that adding one parameter to invalidate_inode_pages2_range so
that caller can deal with a number of cases.

