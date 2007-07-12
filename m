Return-Path: <linux-kernel-owner+w=401wt.eu-S935495AbXGLQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495AbXGLQll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbXGLQlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:41:32 -0400
Received: from mailhost.ics.forth.gr ([139.91.157.55]:38371 "EHLO
	mailhost.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278AbXGLQlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:41:31 -0400
X-Greylist: delayed 9605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 12:41:30 EDT
X-AuditID: 7f000001-a90cabb000001a55-0f-469659b8b292 
Message-ID: <46965A3B.1050503@ics.forth.gr>
Date: Thu, 12 Jul 2007 19:43:39 +0300
From: Thanos Makatos <mcatos@ics.forth.gr>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Full buffer cache not working as expected
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I run several times the following test and what I've seen is that when
the buffer cache becomes full, unneeded dirty buffer heads are not evicted
and no other memory allocation can happen (including reading a block
from the disk to the buffer cache). Should this happen?
Here's the code that reproduces this issue:

for(i = 0; i < get_capacity(bdev->bd_disk)/8; i++) {
        bh = __bread(bdev, i, PAGE_SIZE);
        lock_buffer(bh);
        memset(bh->b_data, 0, PAGE_SIZE);
        set_buffer_dirty(bh);
        unlock_buffer(bh);
        __brelse(bh);
}

I added some printks printing the buffer head's reference counter: after
the '__bread' ref count is 2, after '__brelse' ref count is 1. Shouldn't
these
numbers be 1 and 0 respectively? I added an extra 'put_bh' before (or
after) the '__brelse' but I get a BUG().

