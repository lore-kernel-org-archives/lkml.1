Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZBBXLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZBBXLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZBBXLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:11:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40960 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZBBXLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:11:05 -0500
Date: Mon, 2 Feb 2009 17:14:28 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 3/6] integrity: IMA display
Message-ID: <20090202231428.GB18452@hallyn.com>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com> <d92bfa1d386febc0f56c80204203a43d63d42d02.1233262163.git.zohar@linux.vnet.ibm.com> <alpine.LRH.1.10.0901302013200.31987@tundra.namei.org> <1233321251.3602.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233321251.3602.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> On Fri, 2009-01-30 at 20:18 +1100, James Morris wrote:
> > On Thu, 29 Jan 2009, Mimi Zohar wrote:
> > 
> > > +int ima_fs_init(void)
> > > +{
> > > +	ima_dir = securityfs_create_dir("ima", NULL);
> > > +	if (!ima_dir || IS_ERR(ima_dir))
> > > +		return -1;
> > > +
> > > +	binary_runtime_measurements =
> > > +	    securityfs_create_file("binary_runtime_measurements",
> > > +				   S_IRUSR | S_IRGRP, ima_dir, NULL,
> > > +				   &ima_measurements_ops);
> > > +	if (!binary_runtime_measurements || IS_ERR(binary_runtime_measurements))
> > > +		goto out;
> > 
> > You should not be checking for NULL returns from securityfs_create_file(), 
> > because it does not return NULL (the documentation is wrong).
> > 
> > 
> > - James
> 
> Thanks!
> 
> Mimi

Wow, that's still the case??

>From dec581b116f16657db9b6f59b7e71f7a7026cd21 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Mon, 2 Feb 2009 15:07:33 -0800
Subject: [PATCH 1/1] securityfs: fix long-broken securityfs_create_file comment

If there is an error creating a file through securityfs_create_file,
NULL is not returned, rather the error is propagated.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/inode.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index efea5a6..ae243dd 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -205,12 +205,11 @@ static int create_by_name(const char *name, mode_t mode,
  * This function returns a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the securityfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here).  If an error occurs, %NULL is returned.
+ * you are responsible here).  If an error occurs, the function will return
+ * the erorr value (via ERR_PTR).
  *
  * If securityfs is not enabled in the kernel, the value %-ENODEV is
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * returned.
  */
 struct dentry *securityfs_create_file(const char *name, mode_t mode,
 				   struct dentry *parent, void *data,
-- 
1.5.4.3

