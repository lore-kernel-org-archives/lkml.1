Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXEEVOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXEEVOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXEEVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:14:22 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:28548 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbXEEVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=Q50IOYwM8HZpp5JWKXKqpfg5gU2hHd5vFUKEUg3S/f8976v+b69e7N8xzciwNL+GV861GsaMO7BPdJ0BgVtyO2IOFiy8rvVhKUasH4e1D3gdDW6wmhbdSO4DGoLrEuNL4pksKlPncsSvGMlRKsGyy4SGvM82ewoE2Es85leOKRo=
Date: Sat, 5 May 2007 23:13:18 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi
Subject: [-mm patch] do_revoke error handling (was Re: 2.6.21-mm1)
Message-ID: <20070505211318.GA28912@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
fs/revoke.c: In function 'do_revoke':
fs/revoke.c:563: warning: 'details.fset' may be used uninitialized in this function
fs/revoke.c:563: warning: 'details.restore_start' may be used uninitialized in this function

It seems that we should goto 'out_free_table' if an error happens in
the mainloop. Otherwise 'details' is passed to restore_files() without
being initialized.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
diff --git a/fs/revoke.c b/fs/revoke.c
index 1f2e3ef..6ab5223 100644
--- a/fs/revoke.c
+++ b/fs/revoke.c
@@ -611,7 +611,7 @@ static int do_revoke(struct inode *inode, struct file *to_exclude)
 	read_unlock(&tasklist_lock);
 
 	if (err)
-		goto out_restore;
+		goto out_free_table;
 
 	/*
 	 * Take down shared memory mappings.
@@ -623,7 +623,7 @@ static int do_revoke(struct inode *inode, struct file *to_exclude)
  	 */
 	err = revoke_break_cow(fset, inode, to_exclude);
 	if (err)
-		goto out_restore;
+		goto out_free_table;
 
 	details.fset = fset;
 	details.restore_start = 0;
