Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZA1DAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZA1DAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZA1C76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 21:59:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14152 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZA1C75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 21:59:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=vcLsh17I3moCtaajzS4+jM/Jmk3vI7UqUKj5FDHGYEPiORX+b5M7QQ30Op1gwUUqL
	vfkIN4QlDxB2wiXOu25yA==
Date: Tue, 27 Jan 2009 18:59:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] slub: fix per cpu kmem_cache_cpu array memory leak
Message-ID: <alpine.DEB.2.00.0901271859010.17612@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.81
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per cpu array of kmem_cache_cpu structures accomodates
NR_KMEM_CACHE_CPU such structs.

When this array overflows and a struct is allocated by kmalloc(), it may
have an address at the upper bound of this array.  If this happens, it
does not get freed and the per cpu kmem_cache_cpu_free pointer will be out
of bounds after kmem_cache_destroy() or cpu offlining.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1996,7 +1996,7 @@ static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
 static void free_kmem_cache_cpu(struct kmem_cache_cpu *c, int cpu)
 {
 	if (c < per_cpu(kmem_cache_cpu, cpu) ||
-			c > per_cpu(kmem_cache_cpu, cpu) + NR_KMEM_CACHE_CPU) {
+			c >= per_cpu(kmem_cache_cpu, cpu) + NR_KMEM_CACHE_CPU) {
 		kfree(c);
 		return;
 	}
