Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbZCTWnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbZCTWnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZCTWnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:43:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:12724 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbZCTWnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bGIzAsBca7nOycMXPB7Wa+dQ5+aXcnJb5uCQdx4HnCz0mAgnim0LC+j+L9xQrYvcNy
         5XNvqolDY6UTd6T2nNL6e8o18CCfX00GR9fN9EuO7MYLkutvBUEbqE05NNuTilF2nfkJ
         F7B78znrqlJM+CQ5bZ7gcDDK8WhVtlgD1lQzs=
MIME-Version: 1.0
In-Reply-To: <20090320072355.GA11823@boomer>
References: <20090320072355.GA11823@boomer>
Date: Fri, 20 Mar 2009 17:43:06 -0500
X-Google-Sender-Auth: 5f808161c4c68fa8
Message-ID: <d9c105ea0903201543j245079caga476119501f6a919@mail.gmail.com>
Subject: Re: [PATCH] eCryptfs: NULL crypt_stat dereference during lookup
From: Dustin Kirkland <kirkland@canonical.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dan Carpenter <error27@gmail.com>, Serge Hallyn <serue@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 2:23 AM, Tyler Hicks <tyhicks@linux.vnet.ibm.com> wrote:
> If ecryptfs_encrypted_view or ecryptfs_xattr_metadata were being
> specified as mount options, a NULL pointer dereference of crypt_stat
> was possible during lookup.
>
> This patch moves the crypt_stat assignment into
> ecryptfs_lookup_and_interpose_lower(), ensuring that crypt_stat
> will not be NULL before we attempt to dereference it.
>
> Thanks to Dan Carpenter and his static analysis tool, smatch, for
> finding this bug.
>
> Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

Acked-by: Dustin Kirkland <kirkland@canonical.com>

> ---
>  fs/ecryptfs/crypto.c          |   10 ++++++----
>  fs/ecryptfs/ecryptfs_kernel.h |    1 -
>  fs/ecryptfs/inode.c           |   32 ++++++++++++--------------------
>  3 files changed, 18 insertions(+), 25 deletions(-)
>
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index 75bee99..8b65f28 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -2221,17 +2221,19 @@ int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
>                                         struct dentry *ecryptfs_dir_dentry,
>                                         const char *name, size_t name_size)
>  {
> +       struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
> +               &ecryptfs_superblock_to_private(
> +                       ecryptfs_dir_dentry->d_sb)->mount_crypt_stat;
>        char *decoded_name;
>        size_t decoded_name_size;
>        size_t packet_size;
>        int rc = 0;
>
> -       if ((name_size > ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE)
> +       if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
> +           && !(mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
> +           && (name_size > ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE)
>            && (strncmp(name, ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX,
>                        ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE) == 0)) {
> -               struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
> -                       &ecryptfs_superblock_to_private(
> -                               ecryptfs_dir_dentry->d_sb)->mount_crypt_stat;
>                const char *orig_name = name;
>                size_t orig_name_size = name_size;
>
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index eb2267e..ac749d4 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -620,7 +620,6 @@ int ecryptfs_interpose(struct dentry *hidden_dentry,
>                       u32 flags);
>  int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
>                                        struct dentry *lower_dentry,
> -                                       struct ecryptfs_crypt_stat *crypt_stat,
>                                        struct inode *ecryptfs_dir_inode,
>                                        struct nameidata *ecryptfs_nd);
>  int ecryptfs_decode_and_decrypt_filename(char **decrypted_name,
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 5697899..55b3145 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -246,7 +246,6 @@ out:
>  */
>  int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
>                                        struct dentry *lower_dentry,
> -                                       struct ecryptfs_crypt_stat *crypt_stat,
>                                        struct inode *ecryptfs_dir_inode,
>                                        struct nameidata *ecryptfs_nd)
>  {
> @@ -254,6 +253,7 @@ int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
>        struct vfsmount *lower_mnt;
>        struct inode *lower_inode;
>        struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
> +       struct ecryptfs_crypt_stat *crypt_stat;
>        char *page_virt = NULL;
>        u64 file_size;
>        int rc = 0;
> @@ -314,6 +314,11 @@ int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
>                        goto out_free_kmem;
>                }
>        }
> +       crypt_stat = &ecryptfs_inode_to_private(
> +                                       ecryptfs_dentry->d_inode)->crypt_stat;
> +       /* TODO: lock for crypt_stat comparison */
> +       if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
> +                       ecryptfs_set_default_sizes(crypt_stat);
>        rc = ecryptfs_read_and_validate_header_region(page_virt,
>                                                      ecryptfs_dentry->d_inode);
>        if (rc) {
> @@ -362,9 +367,7 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
>  {
>        char *encrypted_and_encoded_name = NULL;
>        size_t encrypted_and_encoded_name_size;
> -       struct ecryptfs_crypt_stat *crypt_stat = NULL;
>        struct ecryptfs_mount_crypt_stat *mount_crypt_stat = NULL;
> -       struct ecryptfs_inode_info *inode_info;
>        struct dentry *lower_dir_dentry, *lower_dentry;
>        int rc = 0;
>
> @@ -388,26 +391,15 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
>        }
>        if (lower_dentry->d_inode)
>                goto lookup_and_interpose;
> -       inode_info =  ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
> -       if (inode_info) {
> -               crypt_stat = &inode_info->crypt_stat;
> -               /* TODO: lock for crypt_stat comparison */
> -               if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
> -                       ecryptfs_set_default_sizes(crypt_stat);
> -       }
> -       if (crypt_stat)
> -               mount_crypt_stat = crypt_stat->mount_crypt_stat;
> -       else
> -               mount_crypt_stat = &ecryptfs_superblock_to_private(
> -                       ecryptfs_dentry->d_sb)->mount_crypt_stat;
> -       if (!(crypt_stat && (crypt_stat->flags & ECRYPTFS_ENCRYPT_FILENAMES))
> -           && !(mount_crypt_stat && (mount_crypt_stat->flags
> -                                    & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)))
> +       mount_crypt_stat = &ecryptfs_superblock_to_private(
> +                               ecryptfs_dentry->d_sb)->mount_crypt_stat;
> +       if (!(mount_crypt_stat
> +           && (mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)))
>                goto lookup_and_interpose;
>        dput(lower_dentry);
>        rc = ecryptfs_encrypt_and_encode_filename(
>                &encrypted_and_encoded_name, &encrypted_and_encoded_name_size,
> -               crypt_stat, mount_crypt_stat, ecryptfs_dentry->d_name.name,
> +               NULL, mount_crypt_stat, ecryptfs_dentry->d_name.name,
>                ecryptfs_dentry->d_name.len);
>        if (rc) {
>                printk(KERN_ERR "%s: Error attempting to encrypt and encode "
> @@ -426,7 +418,7 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
>        }
>  lookup_and_interpose:
>        rc = ecryptfs_lookup_and_interpose_lower(ecryptfs_dentry, lower_dentry,
> -                                                crypt_stat, ecryptfs_dir_inode,
> +                                                ecryptfs_dir_inode,
>                                                 ecryptfs_nd);
>        goto out;
>  out_d_drop:
> --
> 1.5.3.7
>
>



-- 
:-Dustin
