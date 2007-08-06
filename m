Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbXHFF5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbXHFF5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 01:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXHFF5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 01:57:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46597 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbXHFF53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 01:57:29 -0400
Date: Mon, 6 Aug 2007 11:27:18 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 16/26] union-mount: Introduce union_mount structure
Message-ID: <20070806055718.GA7489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.628215686@weierstrass.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730161324.628215686@weierstrass.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 06:13:39PM +0200, Jan Blunck wrote:
> +
> +int append_to_union(struct vfsmount *mnt, struct dentry *dentry,
> +		    struct vfsmount *dest_mnt, struct dentry *dest_dentry)
> +{
> +	struct union_mount *this, *um;
> +
> +	BUG_ON(!IS_MNT_UNION(mnt));
> +
> +	this = union_alloc(dentry, mnt, dest_dentry, dest_mnt);
> +	if (!this)
> +		return -ENOMEM;
> +
> +	spin_lock(&union_lock);
> +	um = union_lookup(dentry, mnt);
> +	if (um) {
> +		BUG_ON((um->u_next.dentry != dest_dentry) ||
> +		       (um->u_next.mnt != dest_mnt));
> +		spin_unlock(&union_lock);
> +		union_put(this);
> +		return 0;
> +	}
> +	__union_hash(this);
> +	spin_unlock(&union_lock);
> +	return 0;
> +}

This breaks if we append to union stack from outside of the union.
A particular case I hit is with a 3 layer union with a subdir union
between topmost and bottom layer. Now if you create the same-named
directory in the middle layer from outside of this union, you hit the
above BUG_ON. The below patch fixes this and it applies on top of all of
your patches.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Direct additions to union stack from outside of the union is resulting in
BUG_ON. But this is a valid case and hence needs to be supported. Modify
append_to_union() to correctly handle this case.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/namei.c            |    8 +++++---
 fs/union.c            |   32 ++++++++++++++++++++++++--------
 include/linux/union.h |    4 ++--
 3 files changed, 31 insertions(+), 13 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -512,7 +512,7 @@ static int __cache_lookup_union(struct n
 		}
 
 		/* now we know we found something "real"  */
-		append_to_union(last.mnt, last.dentry, nd->mnt, dentry);
+		append_to_union(last.mnt, last.dentry, nd->mnt, dentry, 1);
 
 		if (last.dentry != path->dentry)
 			pathput(&last);
@@ -789,7 +789,8 @@ static int __real_lookup_union(struct na
 		}
 
 		/* now we know we found something "real" */
-		append_to_union(last.mnt, last.dentry, next.mnt, next.dentry);
+		append_to_union(last.mnt, last.dentry,
+				next.mnt, next.dentry, 1);
 
 		if (last.dentry != path->dentry)
 			pathput(&last);
@@ -1775,7 +1776,8 @@ static int __hash_lookup_union(struct na
 		}
 
 		/* now we know we found something "real" */
-		append_to_union(last.mnt, last.dentry, next.mnt, next.dentry);
+		append_to_union(last.mnt, last.dentry,
+				next.mnt, next.dentry, 1);
 
 		if (last.dentry != path->dentry)
 			pathput(&last);
--- a/fs/union.c
+++ b/fs/union.c
@@ -248,7 +248,8 @@ int is_unionized(struct dentry *dentry, 
 }
 
 int append_to_union(struct vfsmount *mnt, struct dentry *dentry,
-		    struct vfsmount *dest_mnt, struct dentry *dest_dentry)
+		    struct vfsmount *dest_mnt, struct dentry *dest_dentry,
+		    int from_lookup)
 {
 	struct union_mount *this, *um;
 
@@ -264,11 +265,26 @@ int append_to_union(struct vfsmount *mnt
 	spin_lock(&union_lock);
 	um = union_lookup(dentry, mnt);
 	if (um) {
-		BUG_ON((um->u_next.dentry != dest_dentry) ||
-		       (um->u_next.mnt != dest_mnt));
-		spin_unlock(&union_lock);
-		union_put(this);
-		return 0;
+		if (um->u_next.dentry == dest_dentry &&
+				um->u_next.mnt == dest_mnt) {
+			spin_unlock(&union_lock);
+			union_put(this);
+			return 0;
+		}
+		if (from_lookup) {
+			__union_unhash(um);
+			list_del(&um->u_list);
+			list_del(&um->u_unions);
+			um->u_next.dentry->d_unionized--;
+			spin_unlock(&union_lock);
+			union_put(um);
+			spin_lock(&union_lock);
+		} else {
+			BUG();
+			spin_unlock(&union_lock);
+			union_put(this);
+			return 0;
+		}
 	}
 	list_add(&this->u_list, &mnt->mnt_unions);
 	list_add(&this->u_unions, &dentry->d_unions);
@@ -451,7 +467,7 @@ int attach_mnt_union(struct vfsmount *mn
 	if (!IS_MNT_UNION(mnt))
 		return 0;
 
-	return append_to_union(mnt, mnt->mnt_root, dest_mnt, dest_dentry);
+	return append_to_union(mnt, mnt->mnt_root, dest_mnt, dest_dentry, 0);
 }
 
 void detach_mnt_union(struct vfsmount *mnt)
@@ -941,7 +957,7 @@ struct dentry *union_create_topmost(stru
 		UM_DEBUG_DENTRY(dentry);
 
 		res = append_to_union(nd->mnt, dentry, path->mnt,
-				      path->dentry);
+				      path->dentry, 0);
 		if (res) {
 			dput(dentry);
 			dentry = ERR_PTR(res);
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -44,7 +44,7 @@ struct union_mount {
 
 extern int is_unionized(struct dentry *, struct vfsmount *);
 extern int append_to_union(struct vfsmount *, struct dentry *,
-			   struct vfsmount *, struct dentry *);
+			   struct vfsmount *, struct dentry *, int);
 extern int follow_union_down(struct vfsmount **, struct dentry **);
 extern int follow_union_mount(struct vfsmount **, struct dentry **);
 extern void __d_drop_unions(struct dentry *);
@@ -65,7 +65,7 @@ extern int union_copyup(struct nameidata
 #define IS_UNION(x)			(0)
 #define IS_MNT_UNION(x)			(0)
 #define is_unionized(x, y)		(0)
-#define append_to_union(x1, y1, x2, y2)	({ BUG(); (0); })
+#define append_to_union(x1, y1, x2, y2, z)	({ BUG(); (0); })
 #define follow_union_down(x, y)		({ (0); })
 #define follow_union_mount(x, y)	({ (0); })
 #define __d_drop_unions(x)		do { } while (0)
