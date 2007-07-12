Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbXGMB6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbXGMB6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 21:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXGMB6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 21:58:34 -0400
Received: from mailhost.ics.forth.gr ([139.91.157.55]:48506 "EHLO
	mailhost.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbXGMB6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 21:58:34 -0400
X-AuditID: 7f000001-a54c4bb000001a55-2f-469634335934 
Message-ID: <469634B6.1070901@ics.forth.gr>
Date: Thu, 12 Jul 2007 17:03:34 +0300
From: Thanos Makatos <mcatos@ics.forth.gr>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Full buffer cache not working properly
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
