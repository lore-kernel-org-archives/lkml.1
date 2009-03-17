Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZCQIRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZCQIRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZCQIRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:17:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36608 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZCQIRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:17:32 -0400
Date: Tue, 17 Mar 2009 04:17:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, adilger@sun.com
Subject: Re: [PATCH] vfs: make real_lookup do dentry revalidation with
	i_mutex held
Message-ID: <20090317081730.GA20213@infradead.org>
References: <Pine.LNX.4.64.0903091118210.2773@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903091118210.2773@cobra.newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping i_mutes over do_revalidate seem fine from a first glance, but
can you please do it without rearranging the whole code?

Something like the tiny untested patch below should archive the same
thing:


Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2009-03-17 09:15:53.430978739 +0100
+++ linux-2.6/fs/namei.c	2009-03-17 09:16:19.553981306 +0100
@@ -512,12 +512,12 @@ out_unlock:
 	 * Uhhuh! Nasty case: the cache was re-populated while
 	 * we waited on the semaphore. Need to revalidate.
 	 */
-	mutex_unlock(&dir->i_mutex);
 	if (result->d_op && result->d_op->d_revalidate) {
 		result = do_revalidate(result, nd);
 		if (!result)
 			result = ERR_PTR(-ENOENT);
 	}
+	mutex_unlock(&dir->i_mutex);
 	return result;
 }
 
