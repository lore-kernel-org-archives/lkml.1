Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYJMN70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYJMN70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYJMN7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:59:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46884 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYJMN7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:59:15 -0400
To: nickpiggin@yahoo.com.au
CC: hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       cl@linux-foundation.org, akpm@linux-foundation.org
In-reply-to: <200810132354.30789.nickpiggin@yahoo.com.au> (message from Nick
	Piggin on Mon, 13 Oct 2008 23:54:30 +1100)
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site> <200810132354.30789.nickpiggin@yahoo.com.au>
Message-Id: <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 13 Oct 2008 15:59:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Nick Piggin wrote:
> In many cases, yes it seems to. And some of the approaches even if
> they work now seem like they *might* cause problematic constraints
> in the design... Have Al and Christoph reviewed the dentry and inode
> patches?

This d_invalidate() looks suspicious to me:

+/*
+ * Slab has dropped all the locks. Get rid of the refcount obtained
+ * earlier and also free the object.
+ */
+static void kick_dentries(struct kmem_cache *s,
+                               int nr, void **v, void *private)
+{
+       struct dentry *dentry;
+       int i;
+
+       /*
+        * First invalidate the dentries without holding the dcache lock
+        */
+       for (i = 0; i < nr; i++) {
+               dentry = v[i];
+
+               if (dentry)
+                       d_invalidate(dentry);
+       }

I think it's wrong to unhash dentries while they are possibly still
being used.  You can do the shrink_dcache_parent() here, but should
leave the unhashing to be done by prune_one_dentry(), after it's been
checked that there are no other users of the dentry.

Miklos
