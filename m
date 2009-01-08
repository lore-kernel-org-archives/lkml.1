Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZAHM5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZAHM5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbZAHM4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:56:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40765 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664AbZAHM4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:56:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/10] NOMMU: Teach kobjsize() about VMA regions. [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:54:32 +0000
Message-ID: <20090108125432.28454.98069.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

Now that we no longer use compound pages for all large allocations,
kobjsize() actively breaks things like binfmt_flat by always handing
back PAGE_SIZE for mmap'ed regions. Fix this up by looking up the
VMA region for non-compounds.

Ideally binfmt_flat wants to get rid of kobjsize() completely, but
this is an incremental step.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Mike Frysinger <vapier.adi@gmail.com>
---

 mm/nommu.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index a6e8ccf..60ed837 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -149,6 +149,20 @@ unsigned int kobjsize(const void *objp)
 		return ksize(objp);
 
 	/*
+	 * If it's not a compound page, see if we have a matching VMA
+	 * region. This test is intentionally done in reverse order,
+	 * so if there's no VMA, we still fall through and hand back
+	 * PAGE_SIZE for 0-order pages.
+	 */
+	if (!PageCompound(page)) {
+		struct vm_area_struct *vma;
+
+		vma = find_vma(current->mm, (unsigned long)objp);
+		if (vma)
+			return vma->vm_end - vma->vm_start;
+	}
+
+	/*
 	 * The ksize() function is only guaranteed to work for pointers
 	 * returned by kmalloc(). So handle arbitrary pointers here.
 	 */

