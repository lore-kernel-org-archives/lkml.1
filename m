Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230Ab0AHWFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0AHWFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209Ab0AHWFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:05:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab0AHWFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:05:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] NOMMU: Remove a superfluous check of vm_region::vm_usage
To: viro@ZenIV.linux.org.uk, vapier@gentoo.org, lethal@linux-sh.org
Cc: dhowells@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Jan 2010 22:05:28 +0000
Message-ID: <20100108220527.23489.91998.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100108220516.23489.11319.stgit@warthog.procyon.org.uk>
References: <20100108220516.23489.11319.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In split_vma(), there's no need to check if the VMA being split has a region
that's in use by more than one VMA because:

 (1) The preceding test prohibits splitting of non-anonymous VMAs and regions
     (eg: file or chardev backed VMAs).

 (2) Anonymous regions can't be mapped multiple times because there's no handle
     by which to refer to the already existing region.

 (3) If a VMA has previously been split, then the region backing it has also
     been split into two regions, each of usage 1.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index 5e39294..d6dd656 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1441,10 +1441,9 @@ int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	kenter("");
 
-	/* we're only permitted to split anonymous regions that have a single
-	 * owner */
-	if (vma->vm_file ||
-	    vma->vm_region->vm_usage != 1)
+	/* we're only permitted to split anonymous regions (these should have
+	 * only a single usage on the region) */
+	if (vma->vm_file)
 		return -ENOMEM;
 
 	if (mm->map_count >= sysctl_max_map_count)

