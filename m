Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZLULzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZLULzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZLULzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:55:06 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:53525 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbZLULzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:55:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Fjlt4tErSjDh0h093/W8JDZ31yypeLy/LRZTH05eaMdasxkX3ob7vvsJ5FGq3tEAAT
         QUCGzRjgi/RqGNZl4eqfIZXbWsRweohSk6JUR3hYk5KQGBnprtV6MiVHl8zw4IhkjwQo
         KtX7RHbtEdy1yJljFgMYIlkOamiXK0XoV17B0=
Message-ID: <4B2F62D3.6020309@gmail.com>
Date: Mon, 21 Dec 2009 19:58:11 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, strongzgy@gmail.com, onlyflyer@gmail.com
Subject: [PATCHv2 06/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/generic_acl.c b/fs/generic_acl.c
index 5545803..5d88218 100644
--- a/fs/generic_acl.c
+++ b/fs/generic_acl.c
@@ -68,6 +68,7 @@ generic_acl_set(struct dentry *dentry, const char
*name, const void *value,
struct inode *inode = dentry->d_inode;
struct posix_acl *acl = NULL;
int error;
+ mode_t mode;

if (strcmp(name, "") != 0)
return -EINVAL;
@@ -80,32 +81,31 @@ generic_acl_set(struct dentry *dentry, const char
*name, const void *value,
if (IS_ERR(acl))
return PTR_ERR(acl);
}
- if (acl) {
- mode_t mode;

- error = posix_acl_valid(acl);
- if (error)
+ error = posix_acl_valid(acl);
+ if (error)
+ goto failed;
+
+ switch (type) {
+ case ACL_TYPE_ACCESS:
+ mode = inode->i_mode;
+ error = posix_acl_equiv_mode(acl, &mode);
+ if (error < 0)
goto failed;
- switch (type) {
- case ACL_TYPE_ACCESS:
- mode = inode->i_mode;
- error = posix_acl_equiv_mode(acl, &mode);
- if (error < 0)
- goto failed;
- inode->i_mode = mode;
- if (error == 0) {
- posix_acl_release(acl);
- acl = NULL;
- }
- break;
- case ACL_TYPE_DEFAULT:
- if (!S_ISDIR(inode->i_mode)) {
- error = -EINVAL;
- goto failed;
- }
- break;
+ inode->i_mode = mode;
+ if (error == 0) {
+ posix_acl_release(acl);
+ acl = NULL;
}
+ break;
+ case ACL_TYPE_DEFAULT:
+ if (!S_ISDIR(inode->i_mode)) {
+ error = -EINVAL;
+ goto failed;
+ }
+ break;
}
+
set_cached_acl(inode, type, acl);
error = 0;
failed:

-- 
Best Regards,
Liuwenyi

