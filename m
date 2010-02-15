Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0BOVne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:43:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0BOVnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:43:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=YPjn7c1faKEC09MwTMokMfqlr/CTiD/s6zXrwZjNPmBws7mCF/zG0wk782lpIpFR6
	/sJZUsRn58dPEhvwMN7jg==
Date: Mon, 15 Feb 2010 13:43:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/3] x86: fix numa emulation calculation of big nodes
Message-ID: <alpine.DEB.2.00.1002151342230.26927@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numa=fake=N uses split_nodes_interleave() to partition the system into N
fake nodes.  Each node size must have be a multiple of
FAKE_NODE_MIN_SIZE, otherwise it is possible to get strange alignments.
Because of this, the remaining memory from each node when rounded to
FAKE_NODE_MIN_SIZE is consolidated into a number of "big nodes" that are
bigger than the rest.

The calculation of the number of big nodes is incorrect since it is using
a logical AND operator when it should be multiplying the rounded-off
portion of each node with N.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/numa_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -427,7 +427,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 	 * Calculate the number of big nodes that can be allocated as a result
 	 * of consolidating the remainder.
 	 */
-	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) & nr_nodes) /
+	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * nr_nodes) /
 		FAKE_NODE_MIN_SIZE;
 
 	size &= FAKE_NODE_MIN_HASH_MASK;
