Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822Ab0AUAUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0AUAUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444Ab0AUAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:20:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0AUAUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:20:31 -0500
Date: Wed, 20 Jan 2010 19:19:37 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 09/41] whiteout: Don't return information about whiteouts to userspace
Message-ID: <20100121001937.GB16090@shell>
References: <1256152779-10054-10-git-send-email-vaurora@redhat.com> <200911300253.nAU2rUFP007609@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300253.nAU2rUFP007609@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 09:53:30PM -0500, Erez Zadok wrote:
> In message <1256152779-10054-10-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > The userspace isn't ready for handling another filetype. Therefore this
> > patch lets readdir() and others skip over the whiteout directory entries
> > they might find.
> 
> The NFSD maintainers and MLs should be CC'ed on such patches which touch
> fs/nfsd/.  I'd also suggst you change the subject line of this patch to:
> 
> 	whiteout/NFSD: don't return ...

Thanks, I made these and your other suggested changes below.

-VAL

> This patch seems fairly straightforward: it returns 0 when d_type is DT_WHT.
> As long as there's no way to create such whiteout entries (not until UM is
> used), then there's no harm in pushing such patches upstream, no?
> 
> > Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/compat.c       |    9 +++++++++
> >  fs/nfsd/nfs3xdr.c |    5 +++++
> >  fs/nfsd/nfs4xdr.c |    2 +-
> >  fs/nfsd/nfsxdr.c  |    4 ++++
> >  fs/readdir.c      |    9 +++++++++
> >  5 files changed, 28 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/compat.c b/fs/compat.c
> > index 6d6f98f..43f6102 100644
> > --- a/fs/compat.c
> > +++ b/fs/compat.c
> > @@ -847,6 +847,9 @@ static int compat_fillonedir(void *__buf, const char *name, int namlen,
> >  	struct compat_old_linux_dirent __user *dirent;
> >  	compat_ulong_t d_ino;
> >  
> > +	if (d_type == DT_WHT)
> > +		return 0;
> > +
> >  	if (buf->result)
> >  		return -EINVAL;
> >  	d_ino = ino;
> > @@ -918,6 +921,9 @@ static int compat_filldir(void *__buf, const char *name, int namlen,
> >  	compat_ulong_t d_ino;
> >  	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(compat_long_t));
> >  
> > +	if (d_type == DT_WHT)
> > +		return 0;
> > +
> >  	buf->error = -EINVAL;	/* only used if we fail.. */
> >  	if (reclen > buf->count)
> >  		return -EINVAL;
> > @@ -1007,6 +1013,9 @@ static int compat_filldir64(void * __buf, const char * name, int namlen, loff_t
> >  	int reclen = ALIGN(jj + namlen + 1, sizeof(u64));
> >  	u64 off;
> >  
> > +	if (d_type == DT_WHT)
> > +		return 0;
> > +
> >  	buf->error = -EINVAL;	/* only used if we fail.. */
> >  	if (reclen > buf->count)
> >  		return -EINVAL;
> > diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
> > index 01d4ec1..59576d0 100644
> > --- a/fs/nfsd/nfs3xdr.c
> > +++ b/fs/nfsd/nfs3xdr.c
> > @@ -884,6 +884,11 @@ encode_entry(struct readdir_cd *ccd, const char *name, int namlen,
> >  	int		elen;		/* estimated entry length in words */
> >  	int		num_entry_words = 0;	/* actual number of words */
> >  
> > +	if (d_type == DT_WHT) {
> > +		cd->common.err = nfs_ok;
> > +		return 0;
> > +	}
> > +
> >  	if (cd->offset) {
> >  		u64 offset64 = offset;
> >  
> > diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> > index 2dcc7fe..8c25012 100644
> > --- a/fs/nfsd/nfs4xdr.c
> > +++ b/fs/nfsd/nfs4xdr.c
> > @@ -2263,7 +2263,7 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
> >  	__be32 nfserr = nfserr_toosmall;
> >  
> >  	/* In nfsv4, "." and ".." never make it onto the wire.. */
> > -	if (name && isdotent(name, namlen)) {
> > +	if (d_type == DT_WHT || (name && isdotent(name, namlen))) {
> 
> Optimization: I would swap the order of the two conditions separated by the
> '||': the right-hand-side condition is far more likely to occur than
> d_type==DT_WHT, so you can enter the body of the 'if' more quickly for the
> common case.
> 
> >  		cd->common.err = nfs_ok;
> >  		return 0;
> >  	}
> > diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
> > index afd08e2..a7d622c 100644
> > --- a/fs/nfsd/nfsxdr.c
> > +++ b/fs/nfsd/nfsxdr.c
> > @@ -513,6 +513,10 @@ nfssvc_encode_entry(void *ccdv, const char *name,
> >  			namlen, name, offset, ino);
> >  	 */
> >  
> > +	if (d_type == DT_WHT) {
> > +		cd->common.err = nfs_ok;
> > +		return 0;
> > +	}
> >  	if (offset > ~((u32) 0)) {
> >  		cd->common.err = nfserr_fbig;
> >  		return -EINVAL;
> > diff --git a/fs/readdir.c b/fs/readdir.c
> > index 7723401..3a48491 100644
> > --- a/fs/readdir.c
> > +++ b/fs/readdir.c
> > @@ -77,6 +77,9 @@ static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset
> >  	struct old_linux_dirent __user * dirent;
> >  	unsigned long d_ino;
> >  
> > +	if (d_type == DT_WHT)
> > +		return 0;
> > +
> >  	if (buf->result)
> >  		return -EINVAL;
> >  	d_ino = ino;
> > @@ -154,6 +157,9 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
> >  	unsigned long d_ino;
> >  	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
> >  
> > +	if (d_type == DT_WHT)
> > +		return 0;
> > +
> >  	buf->error = -EINVAL;	/* only used if we fail.. */
> >  	if (reclen > buf->count)
> >  		return -EINVAL;
> > @@ -239,6 +245,9 @@ static int filldir64(void * __buf, const char * name, int namlen, loff_t offset,
> >  	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
> >  	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
> >  
> > +	if (d_type == DT_WHT)
> > +		return 0;
> > +
> >  	buf->error = -EINVAL;	/* only used if we fail.. */
> >  	if (reclen > buf->count)
> >  		return -EINVAL;
> > -- 
> > 1.6.3.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Erez.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
