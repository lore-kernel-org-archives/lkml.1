Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYCBU3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYCBU3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYCBU24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:28:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:63167 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYCBU2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=wlo/ZQGWAKlYrRw6tagGUu4UM7jnmUjDcAJGW4HTk4+x1L5vh8jpQn6ZnT6uwgS7T2O5/Wqwz4li8vkzneQDqeUJ54d6K4YmuAJ5J6UsllvNvXDwjGM9fHHIj40RzNixObtdgt9n37ClMISeVAz29rrj1pisQGVug/czY6DTrqM=
Date: Sun, 2 Mar 2008 23:28:24 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] slub: fix possible NULL pointer dereference
Message-ID: <20080302202824.GA9032@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix possible NULL pointer dereference if kzalloc
failed. To be able to return proper error code the function
return type is changed to ssize_t (according to callees and
sysfs definitions).

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/mm/slub.c
===================================================================
--- linux-2.6.git.orig/mm/slub.c	2008-03-02 22:53:27.000000000 +0300
+++ linux-2.6.git/mm/slub.c	2008-03-02 23:02:27.000000000 +0300
@@ -3591,8 +3591,8 @@ enum slab_stat_type {
 #define SO_CPU		(1 << SL_CPU)
 #define SO_OBJECTS	(1 << SL_OBJECTS)
 
-static unsigned long slab_objects(struct kmem_cache *s,
-			char *buf, unsigned long flags)
+static ssize_t slab_objects(struct kmem_cache *s,
+			    char *buf, unsigned long flags)
 {
 	unsigned long total = 0;
 	int cpu;
@@ -3602,6 +3602,8 @@ static unsigned long slab_objects(struct
 	unsigned long *per_cpu;
 
 	nodes = kzalloc(2 * sizeof(unsigned long) * nr_node_ids, GFP_KERNEL);
+	if (!nodes)
+		return -ENOMEM;
 	per_cpu = nodes + nr_node_ids;
 
 	for_each_possible_cpu(cpu) {
