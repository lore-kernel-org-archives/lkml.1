Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZDDQ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZDDQ2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZDDQ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:28:26 -0400
Received: from mx2.netapp.com ([216.240.18.37]:24828 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZDDQ2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:28:25 -0400
X-IronPort-AV: E=Sophos;i="4.39,324,1235980800"; 
   d="scan'208";a="150104236"
Subject: Re: bus errors on nfs writes in latest git
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1238861949.8114.3.camel@heimdal.trondhjem.org>
References: <20090404161447.GE495@fieldses.org>
	 <1238861949.8114.3.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Sat, 04 Apr 2009 12:27:50 -0400
Message-Id: <1238862470.8114.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 04 Apr 2009 16:28:23.0532 (UTC) FILETIME=[5FBADAC0:01C9B542]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 12:19 -0400, Trond Myklebust wrote:
> On Sat, 2009-04-04 at 12:14 -0400, J. Bruce Fields wrote:
> > My regular connecthon tests are reporting bus errors on the "write/read
> > 30 MB file" on recent upstream kernels.  I'm travelling and haven't had
> > a chance to do anything beyond kick off a dumb git-bisect, which pointed
> > the blame at the following commit.  Any ideas?

The following patch should fix it.

Cheers
 Trond
---------------------------------------------------------------
>From b7a178f4fab331821b8cff384e1954e62aa63e52 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sat, 4 Apr 2009 12:22:57 -0400
Subject: [PATCH] NFS: Fix the return value in nfs_page_mkwrite()

Commit c2ec175c39f62949438354f603f4aa170846aabb (mm: page_mkwrite change
prototype to match fault) exposed a bug in the NFS implementation of
page_mkwrite. We should be returning 0 on success...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/file.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 3523b89..5a97bcf 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -516,8 +516,6 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto out_unlock;
 
 	ret = nfs_updatepage(filp, page, 0, pagelen);
-	if (ret == 0)
-		ret = pagelen;
 out_unlock:
 	unlock_page(page);
 	if (ret)
-- 
1.6.0.4


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
