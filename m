Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYJHWLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYJHWLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbYJHWK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:10:56 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:7671 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYJHWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=XiGl5ubI2I3kEu1hmASe/g0t90HG1wvhxcw0EPDNLXSN9fN5c8IU1tDaquvB4CPS2H
         O4OdN22Brga/IVAqYEvQcxGU/1wjVoNBjxvP17nEI9YvAYlH4akMeuAmDcI4/Ivl7rRl
         0vQHBLdbbo4CIBz15IgiXKR5i+GK2OV2xUpB0=
Message-ID: <f158dc670810081510t3b5be588v8298aa20a26039c5@mail.gmail.com>
Date: Wed, 8 Oct 2008 16:10:54 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [V9fs-developer] [PATCH 04/10] 9p: move dirread to fs layer
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
In-Reply-To: <1223500147-19654-5-git-send-email-ericvh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223500147-19654-5-git-send-email-ericvh@gmail.com>
X-Google-Sender-Auth: 3a4b95dc3f910ac7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea of the client implementation is to be able to use it not only
from the vfs layer, but also without it. For example, creating a
device that connect to a remote 9P file server.

Thanks,
    Lucho

On Wed, Oct 8, 2008 at 3:09 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> Currently reading a directory is implemented in the client code.
> This function is not actually a wire operation, but a meta operation
> which calls read operations and processes the results.
>
> This patch moves this functionality to the fs layer and calls component
> wire operations instead of constructing their packets.  This provides a
> cleaner separation and will help when we reorganize the client functions
> and protocol processing methods.
>
> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> ---
>  fs/9p/vfs_dir.c         |   54 +++++++++++++++++-------
>  include/net/9p/client.h |    5 --
>  net/9p/client.c         |  103 -----------------------------------------------
>  3 files changed, 38 insertions(+), 124 deletions(-)
>
> diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
> index e298fe1..d7d0ac5 100644
> --- a/fs/9p/vfs_dir.c
> +++ b/fs/9p/vfs_dir.c
> @@ -69,32 +69,54 @@ static inline int dt_type(struct p9_stat *mistat)
>  static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
>  {
>        int over;
> +       struct p9_stat st;
> +       int err;
>        struct p9_fid *fid;
> -       struct v9fs_session_info *v9ses;
> -       struct inode *inode;
> -       struct p9_stat *st;
> +       int buflen;
> +       char *statbuf;
> +       int n, i = 0;
>
>        P9_DPRINTK(P9_DEBUG_VFS, "name %s\n", filp->f_path.dentry->d_name.name);
> -       inode = filp->f_path.dentry->d_inode;
> -       v9ses = v9fs_inode2v9ses(inode);
>        fid = filp->private_data;
> -       while ((st = p9_client_dirread(fid, filp->f_pos)) != NULL) {
> -               if (IS_ERR(st))
> -                       return PTR_ERR(st);
>
> -               over = filldir(dirent, st->name.str, st->name.len, filp->f_pos,
> -                       v9fs_qid2ino(&st->qid), dt_type(st));
> +       buflen = fid->clnt->msize - P9_IOHDRSZ;
> +       statbuf = kmalloc(buflen, GFP_KERNEL);
> +       if (!statbuf)
> +               return -ENOMEM;
>
> -               if (over)
> +       while (1) {
> +               err = v9fs_file_readn(filp, statbuf, NULL, fid->rdir_fpos,
> +                                                                       buflen);
> +               if (err <= 0)
>                        break;
>
> -               filp->f_pos += st->size;
> -               kfree(st);
> -               st = NULL;
> +               n = err;
> +               while (i < n) {
> +                       err = p9_deserialize_stat(statbuf + i, buflen-i, &st,
> +                                                       fid->clnt->dotu);
> +                       if (!err) {
> +                               err = -EIO;
> +                               goto free_and_exit;
> +                       }
> +
> +                       i += err;
> +                       fid->rdir_fpos += err;
> +
> +                       over = filldir(dirent, st.name.str, st.name.len,
> +                           filp->f_pos, v9fs_qid2ino(&st.qid), dt_type(&st));
> +
> +                       filp->f_pos += st.size;
> +
> +                       if (over) {
> +                               err = 0;
> +                               goto free_and_exit;
> +                       }
> +               }
>        }
>
> -       kfree(st);
> -       return 0;
> +free_and_exit:
> +       kfree(statbuf);
> +       return err;
>  }
>
>
> diff --git a/include/net/9p/client.h b/include/net/9p/client.h
> index bb8b0ed..eeb7d92 100644
> --- a/include/net/9p/client.h
> +++ b/include/net/9p/client.h
> @@ -163,8 +163,6 @@ struct p9_client {
>  * @uid: the numeric uid of the local user who owns this handle
>  * @aux: transport specific information (unused?)
>  * @rdir_fpos: tracks offset of file position when reading directory contents
> - * @rdir_pos: (unused?)
> - * @rdir_fcall: holds response of last directory read request
>  * @flist: per-client-instance fid tracking
>  * @dlist: per-dentry fid tracking
>  *
> @@ -181,8 +179,6 @@ struct p9_fid {
>        void *aux;
>
>        int rdir_fpos;
> -       int rdir_pos;
> -       struct p9_fcall *rdir_fcall;
>        struct list_head flist;
>        struct list_head dlist; /* list of all fids attached to a dentry */
>  };
> @@ -207,7 +203,6 @@ int p9_client_write(struct p9_fid *fid, char *data, const char __user *udata,
>                                                        u64 offset, u32 count);
>  struct p9_stat *p9_client_stat(struct p9_fid *fid);
>  int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst);
> -struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset);
>
>  struct p9_req_t *p9_tag_lookup(struct p9_client *, u16);
>  void p9_client_cb(struct p9_client *c, struct p9_req_t *req);
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 89f877f..aa71ff3 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -559,8 +559,6 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
>        memset(&fid->qid, 0, sizeof(struct p9_qid));
>        fid->mode = -1;
>        fid->rdir_fpos = 0;
> -       fid->rdir_pos = 0;
> -       fid->rdir_fcall = NULL;
>        fid->uid = current->fsuid;
>        fid->clnt = clnt;
>        fid->aux = NULL;
> @@ -586,7 +584,6 @@ static void p9_fid_destroy(struct p9_fid *fid)
>        spin_lock(&clnt->lock);
>        list_del(&fid->flist);
>        spin_unlock(&clnt->lock);
> -       kfree(fid->rdir_fcall);
>        kfree(fid);
>  }
>
> @@ -1261,103 +1258,3 @@ done:
>        return err;
>  }
>  EXPORT_SYMBOL(p9_client_wstat);
> -
> -struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset)
> -{
> -       int err, n, m;
> -       struct p9_fcall *tc, *rc;
> -       struct p9_client *clnt;
> -       struct p9_stat st, *ret;
> -
> -       P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %llu\n", fid->fid,
> -                                               (long long unsigned) offset);
> -       err = 0;
> -       tc = NULL;
> -       rc = NULL;
> -       ret = NULL;
> -       clnt = fid->clnt;
> -
> -       /* if the offset is below or above the current response, free it */
> -       if (offset < fid->rdir_fpos || (fid->rdir_fcall &&
> -               offset >= fid->rdir_fpos+fid->rdir_fcall->params.rread.count)) {
> -               fid->rdir_pos = 0;
> -               if (fid->rdir_fcall)
> -                       fid->rdir_fpos += fid->rdir_fcall->params.rread.count;
> -
> -               kfree(fid->rdir_fcall);
> -               fid->rdir_fcall = NULL;
> -               if (offset < fid->rdir_fpos)
> -                       fid->rdir_fpos = 0;
> -       }
> -
> -       if (!fid->rdir_fcall) {
> -               n = fid->iounit;
> -               if (!n || n > clnt->msize-P9_IOHDRSZ)
> -                       n = clnt->msize - P9_IOHDRSZ;
> -
> -               while (1) {
> -                       if (fid->rdir_fcall) {
> -                               fid->rdir_fpos +=
> -                                       fid->rdir_fcall->params.rread.count;
> -                               kfree(fid->rdir_fcall);
> -                               fid->rdir_fcall = NULL;
> -                       }
> -
> -                       tc = p9_create_tread(fid->fid, fid->rdir_fpos, n);
> -                       if (IS_ERR(tc)) {
> -                               err = PTR_ERR(tc);
> -                               tc = NULL;
> -                               goto error;
> -                       }
> -
> -                       err = p9_client_rpc(clnt, tc, &rc);
> -                       if (err)
> -                               goto error;
> -
> -                       n = rc->params.rread.count;
> -                       if (n == 0)
> -                               goto done;
> -
> -                       fid->rdir_fcall = rc;
> -                       rc = NULL;
> -                       if (offset >= fid->rdir_fpos &&
> -                                               offset < fid->rdir_fpos+n)
> -                               break;
> -               }
> -
> -               fid->rdir_pos = 0;
> -       }
> -
> -       m = offset - fid->rdir_fpos;
> -       if (m < 0)
> -               goto done;
> -
> -       n = p9_deserialize_stat(fid->rdir_fcall->params.rread.data + m,
> -               fid->rdir_fcall->params.rread.count - m, &st, clnt->dotu);
> -
> -       if (!n) {
> -               err = -EIO;
> -               goto error;
> -       }
> -
> -       fid->rdir_pos += n;
> -       st.size = n;
> -       ret = p9_clone_stat(&st, clnt->dotu);
> -       if (IS_ERR(ret)) {
> -               err = PTR_ERR(ret);
> -               ret = NULL;
> -               goto error;
> -       }
> -
> -done:
> -       kfree(tc);
> -       kfree(rc);
> -       return ret;
> -
> -error:
> -       kfree(tc);
> -       kfree(rc);
> -       kfree(ret);
> -       return ERR_PTR(err);
> -}
> -EXPORT_SYMBOL(p9_client_dirread);
> --
> 1.5.4.3
>
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>
