Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYLSWXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYLSWXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYLSWWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:22:54 -0500
Received: from kumera.dghda.com ([80.68.90.171]:60934 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYLSWWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:22:53 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Fri, 19 Dec 2008 22:22:48 +0000
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Duane Griffin <duaneg@dghda.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH, v5] 9p: don't print IS_ERR strings
Message-ID: <20081219222248.GA7181@dastardly.home.dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com> <1229719638-6982-2-git-send-email-duaneg@dghda.com> <a4e6962a0812191407g40e14e8fw2e08f7e4e812389d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e6962a0812191407g40e14e8fw2e08f7e4e812389d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 04:07:53PM -0600, Eric Van Hensbergen wrote:
> NAK - the print is a debug to mark function entry when debugging is on
> -- it is not intended to show only success.  If an erroneous s will
> cause the print to break then perhaps it should be parameterized, but
> the entire print shouldn't be pushed inside the if statement.

If s is an error then I suppose it will BUG when the printk tries to
dereference it. So I think a fix is necessary. How about this?

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 8fddfe8..e10c27d 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1022,7 +1022,9 @@ v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
 {
 	char *s = nd_get_link(nd);
 
-	P9_DPRINTK(P9_DEBUG_VFS, " %s %s\n", dentry->d_name.name, s);
+	P9_DPRINTK(P9_DEBUG_VFS, " %s %s\n", dentry->d_name.name,
+			IS_ERR(s) ? "<error>" : s);
+
 	if (!IS_ERR(s))
 		__putname(s);
 }

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
