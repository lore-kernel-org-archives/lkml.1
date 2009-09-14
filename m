Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbZINFLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbZINFLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZINFLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:11:13 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:49766 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZINFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=fP/CjYoN34qH9iN+MqdFRa4gVMPkY9kMoCXjD5TYOXuBnRvK+oir2UuL8soVbQn7rD
         VqT0ph+Zu7hAFUfgrfNR1mUZM7Nkiqn33VFFDvdyuSU+tFT/Rp4McPxUg70guXhSiwYv
         sb1qqL1hxN8oYI3B2i4nTgn+0byEX2JF057GY=
MIME-Version: 1.0
Date: Mon, 14 Sep 2009 17:11:15 +1200
Message-ID: <202cde0e0909132211q3766c7daq4349b97dd8864438@mail.gmail.com>
Subject: [PATCH 0/3]Huge pages mapping for device drivers. (Take 3)
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>, Eric Munson <linux-mm@mgebm.net>,
       Alexey Korolev <akorolev@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch set listed below provides device drivers with the ability to
map memory regions to user space using HTLB interfaces.

The patches are applicable over Eric's patches for ANON_HUGETLB.

Why do we need this feature for drivers?
Device drivers often need to map memory regions to a user-space to
allow efficient data handling in user mode. Involving hugetlb mapping
may bring a performance gain if the mapped regions are relatively
large. Our tests showed that it is possible to gain up to 10%
performance if hugetlb mapping is enabled. In my case involving
hugetlb starts to make sense if the buffer is greater than or equal to
the size of one huge page. Since typically, the device throughput
increases over time there are more and more reasons to remap large
regions using hugetlb.

For example hugetlb remapping could be important for performance of
data acquisition systems (logic analyzers, DSO), network monitoring
systems (packet capture), HD video capture/frame buffer and probably
other.

How it is implemented?

Implementation and approach is very close to what is already done in
ipc/shm.c. We create a file on hugetlbfs vfs mount point using
standard procedures. Then we associate hugetlbfs file mapping with the
file mapping we want to access. A helper returns the page at a given
offset within a hugetlbfs file for population before the page has been
faulted. Allocation process is fully based on standard htlb
procedures, so accounting is not touched.

The typical procedure for mapping of huge pages to userspace by drivers is:
1 Create file on vfs mount of hugetlbfs
2 Replace file mapping with the hugetlbfs file mapping
3 Get huge page for configuring DMA or for something else.
...................
4 Remove hugetlbfs file

A detailed description is given in the following messages.

This implementation is based on the idea of Mel Gorman.
The patches do not contain changes for having GFP alloc mask per
inode. I made patch, but changes are not very small and not so
critical for us. I can post it if someone ask.

Thanks,
Alexey

P/S: Sorry for delay in posting - was much busy with other tasks.
