Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZBWBk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZBWBk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 20:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZBWBkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 20:40:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21762 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZBWBkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 20:40:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=vd9X4x04h51rTE0/S/bCKtwj5qmJDq+tfClFRq8VEF8tDpOhR/5qCITQBiPzXoCpJ
	9D5B8Wly0hUPZEKDGCF0Q==
Date: Sun, 22 Feb 2009 17:40:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 2/2] slub: add min_partial sysfs tunable
In-Reply-To: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0902221712160.26165@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that a cache's min_partial has been moved to struct kmem_cache, it's
possible to easily tune it from userspace by adding a sysfs attribute.

It may not be desirable to keep a large number of partial slabs around if
a cache is used infrequently and memory, especially when constrained by a
cgroup, is scarce.  It's better to allow userspace to set the minimum
policy per cache instead of relying explicitly on kmem_cache_shrink().

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3839,6 +3839,26 @@ static ssize_t order_show(struct kmem_cache *s, char *buf)
 }
 SLAB_ATTR(order);
 
+static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%lu\n", s->min_partial);
+}
+
+static ssize_t min_partial_store(struct kmem_cache *s, const char *buf,
+				 size_t length)
+{
+	unsigned long min;
+	int err;
+
+	err = strict_strtoul(buf, 10, &min);
+	if (err)
+		return err;
+
+	calculate_min_partial(s, min);
+	return length;
+}
+SLAB_ATTR(min_partial);
+
 static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
 	if (s->ctor) {
@@ -4154,6 +4174,7 @@ static struct attribute *slab_attrs[] = {
 	&object_size_attr.attr,
 	&objs_per_slab_attr.attr,
 	&order_attr.attr,
+	&min_partial_attr.attr,
 	&objects_attr.attr,
 	&objects_partial_attr.attr,
 	&total_objects_attr.attr,
