Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbXERUj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbXERUj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXERUjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:39:19 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58217 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbXERUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:39:18 -0400
Date: Fri, 18 May 2007 22:34:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: clameter@sgi.com
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 08/10] shmem: inode defragmentation support
In-Reply-To: <20070518181120.477184338@sgi.com>
Message-ID: <Pine.LNX.4.61.0705182233120.9015@yvahk01.tjqt.qr>
References: <20070518181040.465335396@sgi.com> <20070518181120.477184338@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 11:10, clameter@sgi.com wrote:
>
>Index: slub/mm/shmem.c
>===================================================================
>--- slub.orig/mm/shmem.c	2007-05-18 00:54:30.000000000 -0700
>+++ slub/mm/shmem.c	2007-05-18 01:02:26.000000000 -0700

Do we need *this*? (compare procfs)

I believe that shmfs's inodes remain "more" in memory than those of
procfs. That is, procfs ones can find their way out (we can regenerate
it), while shmfs/tmpfs/ramfs/etc. should not do that (we'd lose the
file).

>@@ -2337,11 +2337,22 @@ static void init_once(void *foo, struct 
> #endif
> }
> 
>+static void *shmem_get_inodes(struct kmem_cache *s, int nr, void **v)
>+{
>+	return fs_get_inodes(s, nr, v,
>+			offsetof(struct shmem_inode_info, vfs_inode));
>+}
>+
>+static struct kmem_cache_ops shmem_kmem_cache_ops = {
>+	.get = shmem_get_inodes,
>+	.kick = kick_inodes
>+};
>+
> static int init_inodecache(void)
> {
> 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
> 				sizeof(struct shmem_inode_info),
>-				0, 0, init_once, NULL);
>+				0, 0, init_once, &shmem_kmem_cache_ops);
> 	if (shmem_inode_cachep == NULL)
> 		return -ENOMEM;
> 	return 0;
>
>-- 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

	Jan
-- 
