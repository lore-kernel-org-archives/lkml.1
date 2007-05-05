Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbXEEVs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbXEEVs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933929AbXEEVs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:48:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:21734 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbXEEVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:48:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=PmlGEkJuyYMwAMPpPjRSMJdEbtAE4dAW8as252Y9W+0tL+lu++R/NI/d9tjG8c867T0mwQoYPwyeWQS9QwSKgcpYtOrz5AWs94SVuJKp+iVfClEIDOzGbgbeUEYqwHk7xJDt4FInI0NCPzAvbzmxqHCy1+xZvhmBFqmMIj0hGUE=
Date: Sat, 5 May 2007 23:47:52 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] do_revoke error handling (was Re: 2.6.21-mm1)
Message-ID: <20070505214752.GA29299@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070505211318.GA28912@slug> <Pine.LNX.4.64.0705060017320.21257@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705060017320.21257@sbz-30.cs.Helsinki.FI>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 12:23:15AM +0300, Pekka J Enberg wrote:
> On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > > 
> > fs/revoke.c: In function 'do_revoke':
> > fs/revoke.c:563: warning: 'details.fset' may be used uninitialized in this function
> > fs/revoke.c:563: warning: 'details.restore_start' may be used uninitialized in this function
> 
> On Sat, 5 May 2007, Frederik Deweerdt wrote:
> > It seems that we should goto 'out_free_table' if an error happens in
> > the mainloop. Otherwise 'details' is passed to restore_files() without
> > being initialized.
> 
> Good catch. The patch is wrong, though. Wwe must restore the file 
> descriptors in case revoke fails; otherwise we'll leave non-revoked files 
> hanging. The proper fix is to move initialization before the 
> do_each_thread() bit. Care to make a new patch, Frederik?
>
OK, thanks for the explanation. Here it is.
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/fs/revoke.c b/fs/revoke.c
index 1f2e3ef..86a2842 100644
--- a/fs/revoke.c
+++ b/fs/revoke.c
@@ -597,6 +597,9 @@ static int do_revoke(struct inode *inode, struct file *to_exclude)
 		goto retry;
 	}
 
+	details.fset = fset;
+	details.restore_start = 0;
+
 	/*
 	 * First revoke the descriptors. After we are done, no one can start
 	 * new operations on them.
@@ -625,9 +628,6 @@ static int do_revoke(struct inode *inode, struct file *to_exclude)
 	if (err)
 		goto out_restore;
 
-	details.fset = fset;
-	details.restore_start = 0;
-
 	/*
 	 * Now, revoke the files for good.
 	 */
