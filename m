Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXFESN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXFESN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXFESNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:13:16 -0400
Received: from pat.uio.no ([129.240.10.15]:37218 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbXFESNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:13:15 -0400
Subject: Re: [NFS] [PATCH 2/2] nfs4: on a O_EXCL OPEN make sure the SETATTR
	sets the fields holding the verifier
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: nfsv4@linux-nfs.org, nfs@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070605135659.8f9c2715.jlayton@redhat.com>
References: <20070605135659.8f9c2715.jlayton@redhat.com>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 14:13:02 -0400
Message-Id: <1181067182.7033.25.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.091)
X-UiO-Scanned: 0DEB7E5A86F7C44C1D1ECE506D9DCF5BEEE93540
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 384 total 2189270 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 13:56 -0400, Jeff Layton wrote:
> The Linux NFS4 client simply skips over the bitmask in an O_EXCL open
> call and so it doesn't bother to reset any fields that may be holding
> the verifier. This patch has us save the first two words of the bitmask
> (which is all the current client has #defines for). The client then
> later checks this bitmask and turns on the appropriate flags in the
> sattr->ia_verify field for the following SETATTR call.
> 
> This patch only currently checks to see if the server used the atime
> and mtime slots for the verifier (which is what the Linux server uses
> for this). I'm not sure of what other fields the server could
> reasonably use, but adding checks for others should be trivial.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index 8e46e3e..34ddd66 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -955,6 +955,22 @@ static struct nfs4_state *nfs4_open_delegated(struct inode *inode, int flags, st
>  }
>  
>  /*
> + * on an EXCLUSIVE create, the server should send back a bitmask with FATTR4-*
> + * fields corresponding to attributes that were used to store the verifier.
> + * Make sure we clobber those fields in the later setattr call
> + */
> +static inline void nfs4_exclusive_attrset (struct nfs4_opendata *opendata, struct iattr *sattr)
> +{
> +	if ((opendata->o_res.attrset[1] & FATTR4_WORD1_TIME_ACCESS) &&
> +	    !(sattr->ia_valid & ATTR_ATIME_SET))
> +		sattr->ia_valid |= ATTR_ATIME;
> +
> +	if ((opendata->o_res.attrset[1] & FATTR4_WORD1_TIME_MODIFY) &&
> +	    !(sattr->ia_valid & ATTR_MTIME_SET))
> +		sattr->ia_valid |= ATTR_MTIME;
> +}
> +
> +/*
>   * Returns a referenced nfs4_state
>   */
>  static int _nfs4_do_open(struct inode *dir, struct dentry *dentry, int flags, struct iattr *sattr, struct rpc_cred *cred, struct nfs4_state **res)
> @@ -985,6 +1001,9 @@ static int _nfs4_do_open(struct inode *dir, struct dentry *dentry, int flags, st
>  	if (status != 0)
>  		goto err_opendata_free;
>  
> +	if (opendata->o_arg.open_flags & O_EXCL)
> +		nfs4_exclusive_attrset(opendata, sattr);
> +
>  	status = -ENOMEM;
>  	state = nfs4_opendata_to_nfs4_state(opendata);
>  	if (state == NULL)
> @@ -1787,6 +1806,7 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>  		status = nfs4_do_setattr(state->inode, &fattr, sattr, state);
>  		if (status == 0)
>  			nfs_setattr_update_inode(state->inode, sattr);
> +		nfs_refresh_inode(state->inode, &fattr);
                  ^^^^ should be nfs_post_op_update_inode() to ensure
that the attribute cache gets invalidated if the server fails to return
the post-op attributes.

>  	}
>  	if (status == 0 && nd != NULL && (nd->flags & LOOKUP_OPEN))
>  		status = nfs4_intent_set_file(nd, dentry, state);
> diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
> index 4eb8a59..b281c83 100644
> --- a/fs/nfs/nfs4xdr.c
> +++ b/fs/nfs/nfs4xdr.c
> @@ -3313,7 +3313,7 @@ static int decode_delegation(struct xdr_stream *xdr, struct nfs_openres *res)
>  static int decode_open(struct xdr_stream *xdr, struct nfs_openres *res)
>  {
>          __be32 *p;
> -        uint32_t bmlen;
> +        uint32_t savewords, bmlen, i;
>          int status;
>  
>          status = decode_op_hdr(xdr, OP_OPEN);
> @@ -3331,7 +3331,15 @@ static int decode_open(struct xdr_stream *xdr, struct nfs_openres *res)
>                  goto xdr_error;
>  
>          READ_BUF(bmlen << 2);
> -        p += bmlen;
> +
> +	savewords = bmlen > NFS_OPENRES_ATTRSET_WORDS ?
> +			NFS_OPENRES_ATTRSET_WORDS : bmlen;
                      ^^^^ min_t(bmlen, NFS_OPENRES_ATTRSET_WORDS, uint32_t);
> +
> +	for (i = 0; i < savewords; ++i) 
> +		READ32(res->attrset[i]);
> +
> +	p += (bmlen - savewords);
> +
>  	return decode_delegation(xdr, res);
>  xdr_error:
>  	dprintk("%s: Bitmap too large! Length = %u\n", __FUNCTION__, bmlen);
> diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
> index f8c55e5..f050a27 100644
> --- a/include/linux/nfs_xdr.h
> +++ b/include/linux/nfs_xdr.h
> @@ -133,6 +133,7 @@ struct nfs_openargs {
>  	__u32			claim;
>  };
>  
> +#define NFS_OPENRES_ATTRSET_WORDS	2

   Could you rename this to NFS4_BITMAP_SIZE and put it into
include/linux/nfs4.h, please.

>  struct nfs_openres {
>  	nfs4_stateid            stateid;
>  	struct nfs_fh           fh;
> @@ -145,6 +146,7 @@ struct nfs_openres {
>  	nfs4_stateid		delegation;
>  	__u32			do_recall;
>  	__u64			maxsize;
> +	__u32			attrset[NFS_OPENRES_ATTRSET_WORDS];
>  };
>  
>  /*
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by DB2 Express
> Download DB2 Express C - the FREE version of DB2 express and take
> control of your XML. No limits. Just data. Click to get it now.
> http://sourceforge.net/powerbar/db2/
> _______________________________________________
> NFS maillist  -  NFS@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/nfs

