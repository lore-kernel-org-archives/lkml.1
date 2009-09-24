Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZIXMze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZIXMze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIXMzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:55:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:49575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbZIXMzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:55:33 -0400
Message-ID: <4ABB6C3A.8070109@kernel.org>
Date: Thu, 24 Sep 2009 21:55:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] percpu: make pcpu_build_alloc_info() clear static buffers
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 12:55:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_build_alloc_info() may be called multiple times when percpu is
falling back to different first chunk allocator.  Make it clear static
buffers so that they don't contain values from previous runs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
These three patches are scheduled for mainline and aim to work around
the cases where distance between the two farthest units is too large
compared to vmalloc area size.  This happens on sparc64 because
vmalloc area size is relatively small there and nodes can easily be
placed such that they are too far apart.

This patchset implements page mapping first chunk allocator for
sparc64 and make embedding allocator fallback to it when vmalloc area
doesn't seem large enough.  This should make percpu allocator more
robust on other archs which implement page mapping allocator (only x86
currently) and diagnosing problems easier on other archs.

Thanks.

 mm/percpu.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: work/mm/percpu.c
===================================================================
--- work.orig/mm/percpu.c
+++ work/mm/percpu.c
@@ -1347,6 +1347,10 @@ struct pcpu_alloc_info * __init pcpu_bui
 	struct pcpu_alloc_info *ai;
 	unsigned int *cpu_map;

+	/* this function may be called multiple times */
+	memset(group_map, 0, sizeof(group_map));
+	memset(group_cnt, 0, sizeof(group_map));
+
 	/*
 	 * Determine min_unit_size, alloc_size and max_upa such that
 	 * alloc_size is multiple of atom_size and is the smallest
