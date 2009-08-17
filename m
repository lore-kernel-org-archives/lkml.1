Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZHQSq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZHQSq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZHQSq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:46:58 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:34705 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZHQSq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:46:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
	<20090817071011.5913.69970.sendpatchset@localhost.localdomain>
	<1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>
Date: Tue, 18 Aug 2009 03:46:50 +0900
In-Reply-To: <1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil> (Stephen
	Smalley's message of "Mon, 17 Aug 2009 08:15:13 -0400")
Message-ID: <87prau5ld1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> writes:

> On Mon, 2009-08-17 at 03:07 -0400, Amerigo Wang wrote:
>> As suggested by OGAWA Hirofumi in thread: http://lkml.org/lkml/2009/8/7/132,
>> we should let selinux_inode_setattr() to match our ATTR_* rules.
>> ATTR_FORCE should not force things like ATTR_SIZE.

[...]

>
> This will only apply the setattr check if ATTR_FORCE was specified,
> which is not the current behavior nor what we want.
>
> NAK.

How about this? I tweaked Amerigo's patch, and it is based on the
original code is doing. This is only compile-test though.

[I'm still not sure what selinux want to do. normally inode_permission()
should check truncate() permission, and this FILE__SIZE checks something
again...? And we want to check FILE__WRITE for ATTR_[AMC]TIME?]

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[PATCH] selinux: adjust rules for ATTR_FORCE

From: Amerigo Wang <amwang@redhat.com>

As suggested by OGAWA Hirofumi in thread: http://lkml.org/lkml/2009/8/7/132,
we should let selinux_inode_setattr() to match our ATTR_* rules.
ATTR_FORCE should not force things like ATTR_SIZE.

Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
[tweaks]
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 security/selinux/hooks.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff -puN security/selinux/hooks.c~selinux-truncate-fix security/selinux/hooks.c
--- linux-2.6/security/selinux/hooks.c~selinux-truncate-fix	2009-08-18 01:01:13.000000000 +0900
+++ linux-2.6-hirofumi/security/selinux/hooks.c	2009-08-18 03:23:52.000000000 +0900
@@ -2710,16 +2710,28 @@ static int selinux_inode_permission(stru
 
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 {
-	const struct cred *cred = current_cred();
-
-	if (iattr->ia_valid & ATTR_FORCE)
-		return 0;
+#define SELINUX_F_SETATTR_MASK	(ATTR_MODE | ATTR_UID | ATTR_GID |	\
+				 ATTR_ATIME_SET | ATTR_MTIME_SET |	\
+				 ATTR_TIMES_SET)
+#define SELINUX_F_WRITE_MASK	(ATTR_CTIME | ATTR_MTIME | ATTR_ATIME | \
+				 ATTR_SIZE)
 
-	if (iattr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
-			       ATTR_ATIME_SET | ATTR_MTIME_SET))
-		return dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
+	const struct cred *cred = current_cred();
+	unsigned int ia_valid = iattr->ia_valid;
 
-	return dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
+	if (!(ia_valid & ATTR_FORCE) && (ia_valid & SELINUX_F_SETATTR_MASK)) {
+		int err = dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
+		if (err)
+			return err;
+		/* Assume timestamp was changed by attributes or utimes(). */
+		ia_valid &= ~(ATTR_CTIME | ATTR_MTIME | ATTR_ATIME);
+	}
+	if (ia_valid & SELINUX_F_WRITE_MASK) {
+		int err = dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
+		if (err)
+			return err;
+	}
+	return 0;
 }
 
 static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
_
