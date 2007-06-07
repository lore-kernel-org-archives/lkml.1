Return-Path: <linux-kernel-owner+w=401wt.eu-S965799AbXFGAXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965799AbXFGAXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXFGAXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:23:45 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:7162 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbXFGAXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lrbPKwg5YoJHx7Mel2Zheb0Dpw+6RX686X4HIq10/6zSGF2vntoGy99CcUOXhKPsA6nxPO8N/qnYv7wXglnnLKKE+/FOfQaw/gBK0SGre2ILlCS89wuBSIGXYsFn+e4Qv/EfiqqKilVLlu0DJevIGF+n1VhAJylMyohU+5LTXtM=
Message-ID: <524f69650706061723i3e065d0y83739e50d986a06f@mail.gmail.com>
Date: Wed, 6 Jun 2007 19:23:43 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Matt Keenan" <matt@opcode-solutions.com>
Subject: Re: [PATCH] CIFS should honour umask
Cc: "Steve French" <sfrench@samba.org>, "Jeremy Allison" <jra@samba.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-cifs-client@lists.samba.org
In-Reply-To: <466705F5.9000702@opcode-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466705F5.9000702@opcode-solutions.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks - it looks almost right but you missed mknod case and your
patch had some whitespace/formatting problems.

Could you try the following and make sure it works for you?  If so will merge.

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f085db9..8e86aac 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -208,7 +208,8 @@ cifs_create(struct inode *inode, struct
                /* If Open reported that we actually created a file
                then we now have to set the mode if possible */
                if ((cifs_sb->tcon->ses->capabilities & CAP_UNIX) &&
-                       (oplock & CIFS_CREATE_ACTION))
+                       (oplock & CIFS_CREATE_ACTION)) {
+                       mode &= ~current->fs->umask;
                        if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
                                CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
                                        (__u64)current->fsuid,
@@ -226,7 +227,7 @@ cifs_create(struct inode *inode, struct
                                        cifs_sb->mnt_cifs_flags &
                                                CIFS_MOUNT_MAP_SPECIAL_CHR);
                        }
-               else {
+               } else {
                        /* BB implement mode setting via Windows security
                           descriptors e.g. */
                        /* CIFSSMBWinSetPerms(xid,pTcon,path,mode,-1,-1,nls);*/
@@ -336,6 +337,7 @@ int cifs_mknod(struct inode *inode, stru
        if (full_path == NULL)
                rc = -ENOMEM;
        else if (pTcon->ses->capabilities & CAP_UNIX) {
+               mode &= ~current->fs->umask;
                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
                        rc = CIFSSMBUnixSetPerms(xid, pTcon, full_path,
                                mode, (__u64)current->fsuid,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3e87dad..f0ff12b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -986,7 +986,8 @@ mkdir_get_info:
                  * failed to get it from the server or was set bogus */
                if ((direntry->d_inode) && (direntry->d_inode->i_nlink < 2))
                                direntry->d_inode->i_nlink = 2;
-               if (cifs_sb->tcon->ses->capabilities & CAP_UNIX)
+               if (cifs_sb->tcon->ses->capabilities & CAP_UNIX) {
+                       mode &= ~current->fs->umask;
                        if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
                                CIFSSMBUnixSetPerms(xid, pTcon, full_path,
                                                    mode,
@@ -1004,7 +1005,7 @@ mkdir_get_info:
                                                    cifs_sb->mnt_cifs_flags &
                                                    CIFS_MOUNT_MAP_SPECIAL_CHR);
                        }
-               else {
+               } else {
                        /* BB to be implemented via Windows secrty descriptors
                           eg CIFSSMBWinSetPerms(xid, pTcon, full_path, mode,
                                                 -1, -1, local_nls); */


On 6/6/07, Matt Keenan <matt@opcode-solutions.com> wrote:
> This patch makes CIFS honour a process' umask like other filesystems.
> Of course the server is still free to munge the permissions if it wants
> to; but the client will send the "right" permissions to begin with.
>
> A few caveats;
>
> 1) It only applies to filesystems that have CAP_UNIX (aka support unix
> extensions)
> 2) It applies the correct mode to the follow up CIFSSMBUnixSetPerms()
> after remote creation (I can write a new patch if you want with the
> "right" mode at actual creation time; however the "right" perms will
> still need to be given to the follow up CIFSSMBUnixSetPerms() anyway).
> 3) It will probably work best with Samba 3.0.25a or newer (ie with this
> patch applied
> http://lists.samba.org/archive/linux-cifs-client/2007-January/001697.html)
> 4) It has been compiled, and tested on 2.6.22-rc4 / Samba 3.0.25a
> (Ubuntu Dapper with a few custom backports), and with a bit of testing
> seems to work just fine. (it also incidentally side steps bugs in
> thunderbird and openoffice (the apps don't check the permissions on
> files they create, they assume they will open() the way that have asked
> them to be created xref open(O_WRONLY|O_CREAT) => valid fd then
> mmap(fd,PROT_READ) => EFAULT).
>
> I am going to give this patch a more thorough test tomorrow with ltp.
> Comments, corrections, et al are welcome.
>
>
> Matt
>
> --
> Matt Keenan
> OpCode Solutions
>
>
>
> Signed-off-by: Matt Keenan <matt@opcode-solutions.com>
>
> --
> diff -urN linux-2.6.22-rc4/fs/cifs/dir.c linux-2.6.22-rc4.cifs-umask-fix/fs/cifs/dir.c
> --- linux-2.6.22-rc4/fs/cifs/dir.c      2007-06-06 08:34:03.000000000 +0100
> +++ linux-2.6.22-rc4.cifs-umask-fix/fs/cifs/dir.c       2007-06-06 19:27:00.000000000 +0100
> @@ -206,7 +206,11 @@
>                 /* If Open reported that we actually created a file
>                 then we now have to set the mode if possible */
>                 if ((cifs_sb->tcon->ses->capabilities & CAP_UNIX) &&
> -                       (oplock & CIFS_CREATE_ACTION))
> +                       (oplock & CIFS_CREATE_ACTION)) {
> +                       /* respect umask settings like other filesystems;
> +                        * if the server wants to munge the bits let it, but the client
> +                        * should "Do The Right Thing" (tm) */
> +                       mode &= ~current->fs->umask;
>                         if(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
>                                 CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
>                                         (__u64)current->fsuid,
> @@ -224,7 +228,7 @@
>                                         cifs_sb->mnt_cifs_flags &
>                                                 CIFS_MOUNT_MAP_SPECIAL_CHR);
>                         }
> -               else {
> +               } else {
>                         /* BB implement mode setting via Windows security descriptors */
>                         /* eg CIFSSMBWinSetPerms(xid,pTcon,full_path,mode,-1,-1,local_nls);*/
>                         /* could set r/o dos attribute if mode & 0222 == 0 */
> diff -urN linux-2.6.22-rc4/fs/cifs/inode.c linux-2.6.22-rc4.cifs-umask-fix/fs/cifs/inode.c
> --- linux-2.6.22-rc4/fs/cifs/inode.c    2007-06-06 08:34:03.000000000 +0100
> +++ linux-2.6.22-rc4.cifs-umask-fix/fs/cifs/inode.c     2007-06-06 19:26:26.000000000 +0100
> @@ -987,6 +987,11 @@
>                 if ((direntry->d_inode) && (direntry->d_inode->i_nlink < 2))
>                                 direntry->d_inode->i_nlink = 2;
>                 if (cifs_sb->tcon->ses->capabilities & CAP_UNIX)
> +               {
> +                       /* respect umask settings like other filesystems;
> +                        * if the server wants to munge the bits let it, but the client
> +                        * should "Do The Right Thing" (tm) */
> +                       mode &= ~current->fs->umask;
>                         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
>                                 CIFSSMBUnixSetPerms(xid, pTcon, full_path,
>                                                     mode,
> @@ -1004,7 +1009,7 @@
>                                                     cifs_sb->mnt_cifs_flags &
>                                                     CIFS_MOUNT_MAP_SPECIAL_CHR);
>                         }
> -               else {
> +               } else {
>                         /* BB to be implemented via Windows secrty descriptors
>                            eg CIFSSMBWinSetPerms(xid, pTcon, full_path, mode,
>                                                  -1, -1, local_nls); */
>
>


-- 
Thanks,

Steve
