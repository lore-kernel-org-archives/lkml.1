Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbXKPODw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbXKPODw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbXKPODo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:03:44 -0500
Received: from mx1.suse.de ([195.135.220.2]:60689 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951AbXKPODn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:03:43 -0500
Date: Fri, 16 Nov 2007 15:03:41 +0100
From: Jan Blunck <jblunck@suse.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071116140341.GK25521@hasse.suse.de>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com> <20071114122939.7b4ee194.akpm@linux-foundation.org> <64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com> <20071115173627.GG25521@hasse.suse.de> <64bb37e0711151324k2a10e683k506c50126ad1978f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711151324k2a10e683k506c50126ad1978f@mail.gmail.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, Torsten Kaiser wrote:

> While the next bisect proved that these patches are innocent, I'm
> still blaming you for my problems. ;)

 :(

> The only thing that looks suspicious to me in that patch is the
> following change in nfs4_atomic_open(), nfs4_open_revalidate() and
> nfs4_proc_create()
> 
> -	struct path path = {
> -		.mnt = nd->mnt,
> -		.dentry = dentry,
> -	};
> +	struct path path = nd->path;
> 
> This changes the path.dentry from the explizit parameter 'dentry' to
> the embedded dentry from the parameter 'nd'.

Ouch! You are totally right. This really looks wrong and I even don't remember
how that went into the patch. Can you test if the following patch fixes the
problem? (BTW: thanks for the detailed analysis)

Thanks,
Jan

---

Subject: Embed a struct path into struct nameidata breakes NFSv4

I accidently break NFSv4. Here is the original report by Torsten Kaiser:

 > > Breaks nfsv4 in a rather funny way:
 > >
 > > treogen ~ # cd /usr/portage/x
 > > treogen x # touch bla
 > > touch: cannot touch `bla': File exists
 > > treogen x # mkdir bla
 > > treogen x # touch bla/bla
 > > touch: cannot touch `bla/bla': File exists
 > > treogen x # ls -lad *
 > > drwxr-xr-x 2 root root 6 Nov 14 20:03 bla
 > > treogen x # ls -la *
 > > total 0
 > > drwxr-xr-x 2 root root  6 Nov 14 20:03 .
 > > drwxr-xr-x 3 root root 16 Nov 14 20:03 ..
 > > treogen x #
                                  
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/nfs/nfs4proc.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: b/fs/nfs/nfs4proc.c
===================================================================
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1372,7 +1372,10 @@ out_close:
 struct dentry *
 nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
-	struct path path = nd->path;
+	struct path path = {
+		.mnt = nd->path.mnt,
+		.dentry = dentry,
+	};
 	struct iattr attr;
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
@@ -1411,7 +1414,10 @@ nfs4_atomic_open(struct inode *dir, stru
 int
 nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct nameidata *nd)
 {
-	struct path path = nd->path;
+	struct path path = {
+		.mnt = nd->path.mnt,
+		.dentry = dentry,
+	};
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
 
@@ -1860,7 +1866,10 @@ static int
 nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
                  int flags, struct nameidata *nd)
 {
-	struct path path = nd->path;
+	struct path path = {
+		.mnt = nd->path.mnt,
+		.dentry = dentry,
+	};
 	struct nfs4_state *state;
 	struct rpc_cred *cred;
 	int status = 0;
