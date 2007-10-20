Return-Path: <linux-kernel-owner+w=401wt.eu-S1764253AbXJTRMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764253AbXJTRMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 13:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbXJTRMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 13:12:30 -0400
Received: from pat.uio.no ([129.240.10.15]:55368 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbXJTRM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 13:12:29 -0400
Subject: Re: nfsv2 ref leak in 2.6.24?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: bfields@fieldses.org, nfs@lists.sourceforge.net, neilb@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710200233.l9K2X5qx015844@agora.fsl.cs.sunysb.edu>
References: <200710200233.l9K2X5qx015844@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 13:12:31 -0400
Message-Id: <1192900351.7440.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.133)
X-UiO-Scanned: 4672E5A95DD24F58AC2B59BF6A5D2D48436AE6F0
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 79 total 4611649 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 22:33 -0400, Erez Zadok wrote:
> Trond, good news.  I was able to narrow down the problem to purely the
> client-side, probably dcache/readdir related, and I have a shell script that
> deterministically triggers the problem each time for me (this is a FC6 image
> under Vmware 6.0.1).  Here's a short shell script which reliably triggers
> the "lost files" problem -- I create a file via nfs2 on the client side, and
> sometimes it doesn't show up in readdir, but it is there if you stat it
> directly.

Ah... I got confused as to what you were measuring and where. Looking at
nfs_proc_create(), there is indeed a missing call to
nfs_mark_for_revalidate(). The reason why you need such a call being the
usual one: NFSv2 doesn't provide post-op attributes for the directory.

The patch below ought to fix the problem.

Cheers
  Trond
---------------------- CUT HERE -----------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sat, 20 Oct 2007 13:07:21 -0400
NFSv2: Ensure that the directory metadata gets revalidated on file create

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/proc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 97669ed..4f80d88 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -211,6 +211,7 @@ nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	nfs_fattr_init(&fattr);
 	dprintk("NFS call  create %s\n", dentry->d_name.name);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	nfs_mark_for_revalidate(dir);
 	if (status == 0)
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
 	dprintk("NFS reply create: %d\n", status);


