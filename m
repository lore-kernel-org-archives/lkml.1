Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbXEJTXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbXEJTXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbXEJTX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:23:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755309AbXEJTX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:23:27 -0400
Date: Thu, 10 May 2007 12:22:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Cc: linux-kernel@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: Re: 2.6.21-mm2
Message-Id: <20070510122241.0b28c18a.akpm@linux-foundation.org>
In-Reply-To: <200705101811.43635.marc.dietrich@ap.physik.uni-giessen.de>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<200705101811.43635.marc.dietrich@ap.physik.uni-giessen.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 18:11:35 +0200 Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de> wrote:

> 
> Hi,
> 
> Am Wednesday 09 May 2007 10:23 schrieb Andrew Morton:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21
> >-mm2/
> >
> >
> > - git-acpi was temporarily dropped due to git conflicts which I didn't feel
> >   like fixing.
> >
> > - So was git-kvm
> >
> > - A handful of IDE patches were dropped due to compilation failures.  Bart
> >   may have fixed this since I last downloaded his tree..
> >
> > - The adaptive readahead patches were dropped.  We're expecting a new, much
> >   simpler version of these.
> 
> since -mm1 I cannot create files on nfs4 shares. 
> 
> #me@localhost:/home: touch t
> touch: setting times of `t': Input/output error
> #me@localhost:/home: dmesg|tail -n1
> decode_attr_group: reply buffer overflowed in line 2676.
> 
> This problem was reported before in a different thread, but no reaction....
> 
> http://marc.info/?l=linux-kernel&m=117837974628893&w=2
> 

We had one regression there which was fixed by the below patch.

That fix is now in Linus's git tree but it was not present in 2.6.21-mm2.

So can you please retest either current -linus, or 2.6.21-mm2 with this patch?

commit 6ce7dc940701cf3fde3c6e826a696b333092cbb1
Author: Chuck Lever <chuck.lever@oracle.com>
Date:   Tue May 8 18:23:28 2007 -0400

    NFS: NFS client underestimates how large an NFSv4 SETATTR reply can be
    
    The maximum size of an NFSv4 SETATTR compound reply should include the
    GETATTR operation that we send.
    
    Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index b8c28f2..f1e2b8c 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -224,7 +224,8 @@ #define NFS4_enc_setattr_sz     (compoun
                                 encode_getattr_maxsz)
 #define NFS4_dec_setattr_sz     (compound_decode_hdr_maxsz + \
                                 decode_putfh_maxsz + \
-                                op_decode_hdr_maxsz + 3)
+                                op_decode_hdr_maxsz + 3 + \
+                                nfs4_fattr_maxsz)
 #define NFS4_enc_fsinfo_sz	(compound_encode_hdr_maxsz + \
 				encode_putfh_maxsz + \
 				encode_fsinfo_maxsz)

