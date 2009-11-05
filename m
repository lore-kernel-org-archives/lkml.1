Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZKERpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZKERpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZKERpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:45:06 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:44636 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZKERpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:45:05 -0500
Subject: Re: regression, bisected: getcwd() ENOENT on NFS4...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <6278d2220911040136m4cadc0f5sb71b8306bf02fc5b@mail.gmail.com>
References: <6278d2220910251631j40caec00lf2dee6159947d983@mail.gmail.com>
	 <1256563190.3742.4.camel@heimdal.trondhjem.org>
	 <6278d2220911010447v5889b9bbt33f685ef7669cc45@mail.gmail.com>
	 <6278d2220911040136m4cadc0f5sb71b8306bf02fc5b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Nov 2009 09:45:05 -0800
Message-Id: <1257443105.3114.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 1802 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 5C51A8B6060F38D58651E8F2B0B6C8B861E21E86
X-UiO-SPAM-Test: remote_host: 198.95.226.240 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 8 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 09:36 +0000, Daniel J Blueman wrote:
> On Sun, Nov 1, 2009 at 12:47 PM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
> > Hi Trond,
> >
> > On Mon, Oct 26, 2009 at 1:19 PM, Trond Myklebust
> > <Trond.Myklebust@netapp.com> wrote:
> >> On Sun, 2009-10-25 at 23:31 +0000, Daniel J Blueman wrote:
> >>> Since 2.6.30-rc, I've been experiencing various issues relating to
> >>> getcwd() returning ENOENT on NFS4 clients. I used an over-complicated
> >>> but reliable reproducer [1] (on Karmic RC against a 2.6.32-rc5 NFS4
> >>> server) to bisect [2].
> >>>
> >>> The impact of this regression is moderate (side-effects range from
> >>> benign to failure), so we should get a fix into 2.6.32 if at all
> >>> possible and strongly consider a 2.6.31 stable update.
> >>>
> >>> Thanks,
> >>>   Daniel
> >>>
> >>> --- [1]
> >>>
> >>> $ apt-get source apt
> >>> $ cd apt-*
> >>> $ ./configure && make
> >>> [snip]
> >>> sh: getcwd() failed: No such file or directory
> >>>
> >>> --- [2]
> >>>
> >>> a65318bf3afc93ce49227e849d213799b072c5fd is first bad commit
> >>> commit a65318bf3afc93ce49227e849d213799b072c5fd
> >>> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> >>> Date:   Wed Mar 11 14:10:28 2009 -0400
> >>>
> >>>     NFSv4: Simplify some cache consistency post-op GETATTRs
> >>
> >> I'm having a lot of trouble seeing how this patch could result in
> >> ENOENT. All it should be doing is reducing the frequency with which we
> >> update some of the inode metadata.
> >>
> >> Have you ever been able to capture one of these errors using strace?
> >
> > Backing this patch out by hand against stock 2.6.32-rc5 (w/ 2.6.32-rc5
> > on server) corrects the behaviour. It's readily reproducible [1];
> > using 2.6.30, the issue is not seen, thus is a regression.
> >
> > To observe the change to user-level behaviour (after the reproducer commands):
> > # make clean
> > # strace -ffe getcwd make -n >list
> > [pid  3829] getcwd(0x7fffa269a380, 4096) = -1 ENOENT (No such file or directory)
> > make: getcwd: No such file or directory
> >
> > Would this help for me to log this via a bugzilla.kernel.org ticket?
> >
> > Thanks,
> >  Daniel
> >
> > --- [1]
> >
> > booting eg:
> > http://mira.sunsite.utk.edu/ubuntu-releases/karmic/ubuntu-9.10-desktop-amd64.iso
> >
> > $ sudo bash
> > # apt-get install build-essential
> > # apt-get build-dep apt
> > # mount server:/ /mnt -tnfs4 && cd /mnt
> > # apt-get source apt
> > # cd apt-0.7.23.1ubuntu2
> > # ./configure && make
> >  -> "getcwd: No such file or directory" messages observed with cited
> > patch and not without
> 
> For continuity with the mailing list thread, I've created a bug report
> of this at:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14541

I just committed the following patch into the above bugzilla entry. I
hope it suffices to fix the bug.

Cheers
  Trond
-------------------------------------------------------------------
NFSv4: Fix a cache validation bug which causes getcwd() to return ENOENT
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Changeset a65318bf3afc93ce49227e849d213799b072c5fd (NFSv4: Simplify some
cache consistency post-op GETATTRs) incorrectly changed the getattr
bitmap for readdir().
This causes the readdir() function to fail to return a
fileid/inode number, which again exposed a bug in the NFS readdir code that
causes spurious ENOENT errors to appear in applications (see
http://bugzilla.kernel.org/show_bug.cgi?id=14541).

The immediate band aid is to revert the incorrect bitmap change, but more
long term, we should change the NFS readdir code to cope with the
fact that NFSv4 servers are not required to support fileids/inode numbers.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/nfs4proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ff37454..741a562 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2767,7 +2767,7 @@ static int _nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 		.pages = &page,
 		.pgbase = 0,
 		.count = count,
-		.bitmask = NFS_SERVER(dentry->d_inode)->cache_consistency_bitmask,
+		.bitmask = NFS_SERVER(dentry->d_inode)->attr_bitmask,
 	};
 	struct nfs4_readdir_res res;
 	struct rpc_message msg = {


