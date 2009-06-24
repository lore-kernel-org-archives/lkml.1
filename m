Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbZFXU3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbZFXU3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZFXU2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:28:53 -0400
Received: from smtp-out-036.synserver.de ([212.40.180.36]:1187 "HELO
	smtp-out-036.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750814AbZFXU2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:28:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 10698
Date: Wed, 24 Jun 2009 22:28:52 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build failure latest git. (acl related)
Message-ID: <20090624202852.GA31192@phenom2.trippelsdorf.de>
References: <20090624200941.GA30531@phenom2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624200941.GA30531@phenom2.trippelsdorf.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 10:09:41PM +0200, Markus Trippelsdorf wrote:
> The kernel does not build anymore (latest git):
> 
> In file included from include/linux/nfsacl.h:31,
>                  from include/linux/nfs_xdr.h:4,
>                  from include/linux/nfs_fs.h:58,
>                  from init/do_mounts.c:19:
> include/linux/posix_acl.h: In function `get_cached_acl':
> include/linux/posix_acl.h:91: error: `struct inode' has no member named `i_acl'
> include/linux/posix_acl.h:94: error: `struct inode' has no member named `i_default_acl'
> include/linux/posix_acl.h: In function `set_cached_acl':
> include/linux/posix_acl.h:118: error: `struct inode' has no member named `i_acl'
> include/linux/posix_acl.h:119: error: `struct inode' has no member named `i_acl'
> include/linux/posix_acl.h:122: error: `struct inode' has no member named `i_default_acl'
> include/linux/posix_acl.h:123: error: `struct inode' has no member named `i_default_acl'
> include/linux/posix_acl.h: In function `forget_cached_acl':
> include/linux/posix_acl.h:137: error: `struct inode' has no member named `i_acl'
> include/linux/posix_acl.h:138: error: `struct inode' has no member named `i_acl'
> include/linux/posix_acl.h:141: error: `struct inode' has no member named `i_default_acl'
> include/linux/posix_acl.h:142: error: `struct inode' has no member named `i_default_acl'
> make[1]: *** [init/do_mounts.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> 

This patch should fix it:


diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 0cdba01..c513466 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -83,6 +83,7 @@ extern int posix_acl_chmod_masq(struct posix_acl *, mode_t);
 extern struct posix_acl *get_posix_acl(struct inode *, int);
 extern int set_posix_acl(struct inode *, int, struct posix_acl *);
 
+#ifdef CONFIG_FS_POSIX_ACL
 static inline struct posix_acl *get_cached_acl(struct inode *inode, int type)
 {
 	struct posix_acl **p, *acl;
@@ -146,5 +147,5 @@ static inline void forget_cached_acl(struct inode *inode, int type)
 	if (old != ACL_NOT_CACHED)
 		posix_acl_release(old);
 }
-
+#endif
 #endif  /* __LINUX_POSIX_ACL_H */
-- 
Markus
