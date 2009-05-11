Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbZEKMSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbZEKMSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZEKMQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:16:47 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:56007 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757827AbZEKMQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:16:45 -0400
Subject: Re: NFS write OOPS with 2.6.29.2
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0905110919490.27423@praktifix.dwd.de>
References: <Pine.LNX.4.64.0905031552340.1774@praktifix.dwd.de>
	 <20090504231426.2e5a51b0.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0905091913010.3181@praktifix.dwd.de>
	 <1241929074.5149.1.camel@heimdal.trondhjem.org>
	 <Pine.LNX.4.64.0905110919490.27423@praktifix.dwd.de>
Content-Type: text/plain
Date: Mon, 11 May 2009 08:16:41 -0400
Message-Id: <1242044201.6691.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 2 total rcpts 252 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=_BLID_, uiouri=_URIID_)
X-UiO-Scanned: F8A7FF10209542C9AD462E33187A1904BF7ED939
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 257 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 09:24 +0000, Holger Kiehl wrote:
> On Sun, 10 May 2009, Trond Myklebust wrote:
> 
> > On Sat, 2009-05-09 at 19:16 +0000, Holger Kiehl wrote:
> >> On Mon, 4 May 2009, Andrew Morton wrote:
> >>
> >>>
> >>> (cc linux-nfs)
> >>>
> >>> On Sun, 3 May 2009 16:03:38 +0000 (GMT) Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
> >>>
> >>>> Hello
> >>>>
> >>>> With plain kernel 2.6.29.2 I get the following OOPS (several of them) when
> >>>> writing lots of small files on the client system:
> >>>>
> >>>>     May  3 18:48:34 obelix kernel: ------------[ cut here ]------------
> >>>>     May  3 18:48:34 obelix kernel: kernel BUG at fs/nfs/write.c:252!
> >>>
> >>> I think this is a well-know bug, and fixes should be available in 2.6.29.3?
> >>>
> >> Thanks for this information. I just tried 2.6.29.3 and it still oopses.
> >> Are there any patches I can try?
> >
> > The attached backports against 2.6.29 are untested, but they are known
> > to compile at least. Could you give them a try?
> >
> Thanks. They do compile but when there is a mmap on the NFS drive the
> program gets a SIGBUS:
> 
>     unlink("/home/afdbench/afd2/fifodir/AFD_ACTIVE") = 0
>     close(3)                                = 0
>     open("/home/afdbench/afd2/fifodir/AFD_ACTIVE", O_RDWR|O_CREAT|O_TRUNC|O_CLOEXEC, 0600) = 3
>     lseek(3, 78, SEEK_SET)                  = 78
>     write(3, "\377"..., 1)                  = 1
>     mmap(NULL, 78, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0x7f8045cdb000
>     --- SIGBUS (Bus error) @ 0 (0) ---
> 
> This was with 2.6.29.3 plus the patches you send me.
> 
> Holger

Oh, duh... You need this little patchlet too.

Sorry...

Cheers
  Trond
------------------------------------------------------------------
>From 2b2ec7554cf7ec5e4412f89a5af6abe8ce950700 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 7 Apr 2009 14:02:53 -0700
Subject: [PATCH] NFS: Fix the return value in nfs_page_mkwrite()

Commit c2ec175c39f62949438354f603f4aa170846aabb ("mm: page_mkwrite
change prototype to match fault") exposed a bug in the NFS
implementation of page_mkwrite.  We should be returning 0 on success...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
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



