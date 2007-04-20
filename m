Return-Path: <linux-kernel-owner+w=401wt.eu-S1161186AbXDTFSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161186AbXDTFSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161039AbXDTFSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:18:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59034 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422692AbXDTFSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:18:21 -0400
Date: Thu, 19 Apr 2007 22:18:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: <17960.16739.870487.497750@notabene.brown>
Message-ID: <Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
References: <17960.16739.870487.497750@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Neil Brown wrote:

> Not sure how best to fix this one.... kmem_cache_destroy currently
> doesn't know which alias is being destroyed.

The aliases are there for decorative purposes when running without
debugging. If one switches on debugging then it matters but then the
symlinks are not created since there will be no aliases.

I guess we can ignore the problem?


Index: linux-2.6.21-rc6/mm/slub.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slub.c	2007-04-19 22:13:28.000000000 -0700
+++ linux-2.6.21-rc6/mm/slub.c	2007-04-19 22:15:31.000000000 -0700
@@ -3351,9 +3351,19 @@ static int sysfs_slab_alias(struct kmem_
 {
 	struct saved_alias *al;
 
-	if (slab_state == SYSFS)
-		return sysfs_create_link(&slab_subsys.kset.kobj,
+	if (slab_state == SYSFS) {
+		int rc;
+
+		/*
+		 * Aliases are there mainly for decorative purposes
+		 * and we have no way of removing them properly.
+		 * Creating a link may fail due to the symlink remaining.
+		 * f.e. module unloading and loading.
+		 */
+		rc = sysfs_create_link(&slab_subsys.kset.kobj,
 						&s->kobj, name);
+		return 0;
+	}
 
 	al = kmalloc(sizeof(struct saved_alias), GFP_KERNEL);
 	if (!al)
