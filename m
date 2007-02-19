Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXBSSb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXBSSb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbXBSSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:31:27 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49097 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbXBSSb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:31:26 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 0/7] [RFC] hugetlb: pagetable_operations API
Date: Mon, 19 Feb 2007 10:31:23 -0800
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, agl@us.ibm.com
Message-Id: <20070219183123.27318.27319.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The page tables for hugetlb mappings are handled differently than page tables
for normal pages.  Rather than integrating multiple page size support into the
main VM (which would tremendously complicate the code) some hooks were created.
This allows hugetlb special cases to be handled "out of line" by a separate
interface.

Hugetlbfs was the huge page interface chosen.  At the time, large database
users were the only big users of huge pages and the hugetlbfs design meets
their needs pretty well.  Over time, hugetlbfs has been expanded to enable new
uses of huge page memory with varied results.  As features are added, the
semantics become a permanent part of the Linux API.  This makes maintenance of
hugetlbfs an increasingly difficult task and inhibits the addition of features
and functionality in support of ever-changing hardware.

To remedy the situation, I propose an API (currently called
pagetable_operations).  All of the current hugetlbfs-specific hooks are moved
into an operations struct that is attached to VMAs.  The end result is a more
explicit and IMO a cleaner interface between hugetlbfs and the core VM.  We are
then free to add other hugetlb interfaces (such as a /dev/zero-styled character
device) that can operate either in concert with or independent of hugetlbfs.

There should be no measurable performance impact for normal page users (we're
checking if pagetable_ops != NULL instead of checking for vm_flags &
VM_HUGETLB).  Of course we do increase the VMA size by one pointer.  For huge
pages, there is an added indirection for pt_op() calls.  This patch series does
not change the logic of the the hugetlbfs operations, just moves them into the
pagetable_operations struct.

Comments?  Do you think it's as good of an idea as I do?
