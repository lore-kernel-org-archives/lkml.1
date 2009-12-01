Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZLANLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZLANLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZLANLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:11:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:43024 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752426AbZLANLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:11:09 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX180ZGd9+WM08D9lONKHdSnQOanOWj4oXulVZ9zx60
	K7kZv1yYmjOADf
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: FS-Cache: Handle pages pending storage that get evicted under OOM conditions
Date: Tue, 1 Dec 2009 14:11:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc8-sidux-amd64; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       v9fs-developer@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200911302259.nAUMx9Ij031249@hera.kernel.org>
In-Reply-To: <200911302259.nAUMx9Ij031249@hera.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011411.12570.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tuesday 01 December 2009, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/201a15428bd54f83eccec8b7c64a04b8f9431204
> Commit:     201a15428bd54f83eccec8b7c64a04b8f9431204
> Parent:     e3d4d28b1c8cc7c26536a50b43d86ccd39878550
> Author:     David Howells <dhowells@redhat.com>
> AuthorDate: Thu Nov 19 18:11:35 2009 +0000
> Committer:  David Howells <dhowells@redhat.com>
> CommitDate: Thu Nov 19 18:11:35 2009 +0000
> 
>     FS-Cache: Handle pages pending storage that get evicted under OOM conditions
>     
>     Handle netfs pages that the vmscan algorithm wants to evict from the pagecache
>     under OOM conditions, but that are waiting for write to the cache.  Under these
>     conditions, vmscan calls the releasepage() function of the netfs, asking if a
>     page can be discarded.
[...]

This commit breaks compiling 9p in 2.6.32-rc8-git2:

  CC [M]  fs/9p/cache.o
fs/9p/cache.c: In function '__v9fs_fscache_release_page':
fs/9p/cache.c:346: error: 'vnode' undeclared (first use in this function)
fs/9p/cache.c:346: error: (Each undeclared identifier is reported only once
fs/9p/cache.c:346: error: for each function it appears in.)
make[2]: *** [fs/9p/cache.o] Error 1

> diff --git a/fs/9p/cache.c b/fs/9p/cache.c
> index 51c94e2..bcc5357 100644
> --- a/fs/9p/cache.c
> +++ b/fs/9p/cache.c
> @@ -343,18 +343,7 @@ int __v9fs_fscache_release_page(struct page *page, gfp_t gfp)
>  
>  	BUG_ON(!vcookie->fscache);
>  
> -	if (PageFsCache(page)) {
> -		if (fscache_check_page_write(vcookie->fscache, page)) {
> -			if (!(gfp & __GFP_WAIT))
> -				return 0;
> -			fscache_wait_on_page_write(vcookie->fscache, page);
> -		}
> -
> -		fscache_uncache_page(vcookie->fscache, page);
> -		ClearPageFsCache(page);
> -	}
> -
> -	return 1;
> +	return fscache_maybe_release_page(vnode->cache, page, gfp);
>  }
>  
[...]

Regards
	Stefan Lippers-Hollmann



9p: fix build failure introduced by 201a15428bd54f83eccec8b7c64a04b8f9431204

  CC [M]  fs/9p/cache.o
fs/9p/cache.c: In function '__v9fs_fscache_release_page':
fs/9p/cache.c:346: error: 'vnode' undeclared (first use in this function)
fs/9p/cache.c:346: error: (Each undeclared identifier is reported only once
fs/9p/cache.c:346: error: for each function it appears in.)
make[2]: *** [fs/9p/cache.o] Error 1

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
build tested only.

 fs/9p/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index bcc5357..e777961 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -343,7 +343,7 @@ int __v9fs_fscache_release_page(struct page *page, gfp_t gfp)
 
 	BUG_ON(!vcookie->fscache);
 
-	return fscache_maybe_release_page(vnode->cache, page, gfp);
+	return fscache_maybe_release_page(vcookie->fscache, page, gfp);
 }
 
 void __v9fs_fscache_invalidate_page(struct page *page)
