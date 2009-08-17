Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZHQWYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZHQWYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZHQWYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:24:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:38918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZHQWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:24:13 -0400
Date: Mon, 17 Aug 2009 23:24:09 +0100 (BST)
From: Alexey Korolev <akorolev@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3]HTLB mapping for drivers (take 2)
Message-ID: <alpine.LFD.2.00.0908172317470.32114@casper.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <akorolev@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch set listed below provides device drivers with the ability to
map memory regions to user space via HTLB interfaces.

Why we need it? 
Device drivers often need to map memory regions to user-space to allow
efficient data handling in user mode. Involving hugetlb mapping may
bring performance gain if mapped regions are relatively large. Our tests
showed that it is possible to gain up to 7% performance if hugetlb
mapping is enabled. In my case involving hugetlb starts to make sense if
buffer is more or equal to 4MB. Since typically, device throughput
increase over time there are more and more reasons to involve huge pages
to remap large regions.
For example hugetlb remapping could be important for performance of Data
acquisition systems (logic analyzers, DSO), Network monitoring systems
(packet capture), HD video capture/frame buffer  and probably other. 

How it is implemented?
Implementation and idea is very close to what is already done in
ipc/shm.c. 
We create file on hugetlbfs vfsmount point and populate file with pages
we want to mmap. Then we associate hugetlbfs file mapping with file
mapping we want to access. 

So typical procedure for mapping of huge pages to userspace by drivers
should be:
1 Allocate some huge pages
2 Create file on vfs mount of hugetlbfs
3 Add pages to page cache of mapping associated with hugetlbfs file 
4 Replace file's mapping with the hugetlbfs file mapping
..............
5 Remove pages from page cache
6 Remove hugetlbfs file
7 Free pages
(Please find example in following messages)

Detailed description is given in the following messages.
Thanks a lot to Mel Gorman who gave good advice and code prototype and
Stephen Donnelly for assistance in description composing.

Alexey

