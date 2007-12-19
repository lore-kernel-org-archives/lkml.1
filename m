Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbXLSUXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbXLSUXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXLSUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:23:35 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41990 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbXLSUXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:23:32 -0500
Date: Wed, 19 Dec 2007 22:23:30 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: serge@hallyn.com, alan@redhat.com, viro@zeniv.linux.org.uk,
       hch@infradead.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/8] revoke: inode revoke lock V7
In-Reply-To: <20071219153056.GA7574@sergelap.austin.ibm.com>
Message-ID: <Pine.LNX.4.64.0712192215170.10326@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0712141715440.28689@sbz-30.cs.Helsinki.FI>
 <20071217222850.GA10076@vino.hallyn.com> <Pine.LNX.4.64.0712180923450.32179@sbz-30.cs.Helsinki.FI>
 <20071219153056.GA7574@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 19 Dec 2007, Serge E. Hallyn wrote:
> > I assume you mean S_REVOKE_LOCK and not ->i_mutex, right?
> 
> No I did mean the i_mutex since you take the i_mutex when you set
> S_REVOKE_LOCK.  So between that and the comment above do_lookup(),
> I assumed you were trying to lock out concurrent do_lookups() returning
> an inode whose revoke is starting at the same time.

No, I only use ->i_mutex for synchronizing the write to ->i_flags.

On Wed, 19 Dec 2007, Serge E. Hallyn wrote:
> > The caller is supposed to block open(2) with chmod(2)/chattr(2) so while 
> > revoke is in progress, you can get references to the _revoked inode_, 
> > which is fine (operations on it will fail with EBADFS). The 
> > ->i_revoke_wait bits are there to make sure that while we revoke, you 
> > can't get a _new reference_ to the inode until we're done.
> 
> And a new reference means through iget(), so if revoke starts
> between the IS_REVOKE_LOCKED() check in do_lookup and its return,
> it's ok bc we'll get a reference later on?

Yes, as soon as we unhash the dentries and the inode, do_lookup() will try 
to find a new inode with iget() but we need to wait before writeback on 
the revoked inode is finished.

On Wed, 19 Dec 2007, Serge E. Hallyn wrote:
> I'm a little confused but i'll keep looking.

I don't blame you. The patch is missing the following "minor detail" which 
is needed to avoid fs corruption...

			Pekka

Index: 2.6/fs/revoke.c
===================================================================
--- 2.6.orig/fs/revoke.c	2007-12-16 19:57:40.000000000 +0200
+++ 2.6/fs/revoke.c	2007-12-19 18:03:13.000000000 +0200
@@ -426,6 +426,8 @@ 	int err = 0;
 	make_revoked_inode(inode);
 	remove_inode_hash(inode);
 	revoke_aliases(inode);
+
+	err = write_inode_now(inode, 1);
 failed:
 	revoke_unlock(inode);
 	wake_up(&inode->i_revoke_wait);
