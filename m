Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZCSPh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZCSPh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZCSPhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:37:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42615 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZCSPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:37:07 -0400
Date: Thu, 19 Mar 2009 09:37:04 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Q: NFSD readdir in linux-2.6.28
Message-ID: <20090319153704.GZ14127@parisc-linux.org>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237475837.16359.106.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 03:17:17PM +0000, David Woodhouse wrote:
> > In 2.6.27, when nfs3svc_encode_entry_plus() calls lookup_one_len(), the
> > i_mutex lock was acquired by vfs_readdir() and it was not a problem.
> > 
> > After the commit (above), nfsd_readdir/nfsd_buffered_readdir/vfs_readdir
> > calls nfsd_buffered_filldir(), and nfs3svc_encode_entry_plus() is called
> > later.
> > In this sequence, lookup_one_len() is called without i_mutex held.
> > 
> > Isn't it a problem?
> 
> Yes, well spotted. It didn't matter when the buffered readdir() was
> purely internal to XFS, because it didn't matter there that we called
> ->lookup() without i_mutex set. But now we're exposing arbitrary file
> systems to it, we need to make sure we follow the locking rules. 
> 
> I _think_ it's sufficient to make the affected callers of
> lookup_one_len() lock the parent's i_mutex for themselves before calling
> it. I'll take a closer look...

Should we also add this?

---

Ensure inode is locked in lookup_one_len()

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/fs/namei.c b/fs/namei.c
index bbc15c2..476b1d0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1244,6 +1244,7 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 	int err;
 	struct qstr this;
 
+	BUG_ON(!mutex_is_locked(&base->d_inode->i_mutex));
 	err = __lookup_one_len(name, &this, base, len);
 	if (err)
 		return ERR_PTR(err);

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
