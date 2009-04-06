Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZDFX7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZDFX7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZDFX7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:59:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47371 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZDFX7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:59:40 -0400
X-IronPort-AV: E=Sophos;i="4.39,333,1235980800"; 
   d="scan'208";a="151078788"
Subject: Re: [2 regressions] Current git cannot find root device on x86-64
 (HP nx6325), NFS broken
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>
In-Reply-To: <200904070047.56172.rjw@sisk.pl>
References: <200904070047.56172.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 06 Apr 2009 16:46:06 -0700
Message-Id: <1239061566.6196.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 06 Apr 2009 23:59:37.0007 (UTC) FILETIME=[BD9ACBF0:01C9B713]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 00:47 +0200, Rafael J. Wysocki wrote:
> Also, mounting directories over NFS doesn't work (I think it oopses, but
> didn't have the time to look at it more closely).

There is a known double free issue that affects the 'proto=' mount
option (we call kfree(string) twice). Please could you check that the
following patch fixes it for you?

Cheers
  Trond

--------------------------------------------------------------------
>From a3e6cc62dce11c75249f01423eb9b41531759d36 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Mon, 6 Apr 2009 16:41:35 -0700
Subject: [PATCH] NFS: Fix a double free in nfs_parse_mount_options()

Due to an apparent typo, commit a67d18f89f5782806135aad4ee012ff78d45aae7
(NFS: load the rpc/rdma transport module automatically) lead to the
'proto=' mount option doing a double free, while Opt_mountproto leaks a
string.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 82eaadb..6717200 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1228,7 +1228,6 @@ static int nfs_parse_mount_options(char *raw,
 				goto out_nomem;
 			token = match_token(string,
 					    nfs_xprt_protocol_tokens, args);
-			kfree(string);
 
 			switch (token) {
 			case Opt_xprt_udp:
@@ -1258,6 +1257,7 @@ static int nfs_parse_mount_options(char *raw,
 				goto out_nomem;
 			token = match_token(string,
 					    nfs_xprt_protocol_tokens, args);
+			kfree(string);
 
 			switch (token) {
 			case Opt_xprt_udp:
-- 
1.6.0.4



-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
