Return-Path: <linux-kernel-owner+w=401wt.eu-S1764732AbXKQS7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764732AbXKQS7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXKQS65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:58:57 -0500
Received: from pat.uio.no ([129.240.10.15]:34908 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbXKQS64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:58:56 -0500
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>
In-Reply-To: <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
References: <473DA608.1020804@linux.vnet.ibm.com>
	 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-JB8J0Rnqj+uhc3kuo5ga"
Date: Sat, 17 Nov 2007 13:58:40 -0500
Message-Id: <1195325920.7484.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.139)
X-UiO-Scanned: A14B50A7BF138B6FA69EB5739ED1DD1678E494D5
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 373 total 5195828 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JB8J0Rnqj+uhc3kuo5ga
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sat, 2007-11-17 at 18:53 +0100, Torsten Kaiser wrote:
> On Nov 16, 2007 3:15 PM, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > Hi Andrew,
> >
> > The kernel enters the xmon state while running the file system
> > stress on nfs v4 mounted partition.
> [snip]
> > 0:mon> t
> > [c0000000dbd4fb50] c000000000069768 .__wake_up+0x54/0x88
> > [c0000000dbd4fc00] d00000000086b890 .nfs_sb_deactive+0x44/0x58 [nfs]
> > [c0000000dbd4fc80] d000000000872658 .nfs_free_unlinkdata+0x2c/0x74 [nfs]
> > [c0000000dbd4fd10] d000000000598510 .rpc_release_calldata+0x50/0x74 [sunrpc]
> > [c0000000dbd4fda0] c00000000008d960 .run_workqueue+0x10c/0x1f4
> > [c0000000dbd4fe50] c00000000008ec70 .worker_thread+0x118/0x138
> > [c0000000dbd4ff00] c0000000000939f4 .kthread+0x78/0xc4
> > [c0000000dbd4ff90] c00000000002b060 .kernel_thread+0x4c/0x68

Could you try with the attached patch.

Cheers
  Trond

--=-JB8J0Rnqj+uhc3kuo5ga
Content-Disposition: inline; filename=linux-2.6.24-007-fix_nfs_free_unlinkdata.dif
Content-Type: message/rfc822; name=linux-2.6.24-007-fix_nfs_free_unlinkdata.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sat, 17 Nov 2007 13:52:36 -0500
Subject: NFS: Fix nfs_free_unlinkdata()
Message-Id: <1195325920.7484.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

We should really only be calling nfs_sb_deactive() at the end of an RPC
call, to balance the nfs_sb_active() call in nfs_do_call_unlink(). OTOH,
nfs_free_unlinkdata() can be called from a variety of other situations.

Fix is to move the call to nfs_sb_deactive() into
nfs_async_unlink_release().

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/unlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index b97d3bb..c90862a 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -31,7 +31,6 @@ struct nfs_unlinkdata {
 static void
 nfs_free_unlinkdata(struct nfs_unlinkdata *data)
 {
-	nfs_sb_deactive(NFS_SERVER(data->dir));
 	iput(data->dir);
 	put_rpccred(data->cred);
 	kfree(data->args.name.name);
@@ -116,6 +115,7 @@ static void nfs_async_unlink_release(void *calldata)
 	struct nfs_unlinkdata	*data = calldata;
 
 	nfs_dec_sillycount(data->dir);
+	nfs_sb_deactive(NFS_SERVER(data->dir));
 	nfs_free_unlinkdata(data);
 }
 

--=-JB8J0Rnqj+uhc3kuo5ga--

