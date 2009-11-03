Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZKCVbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZKCVbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZKCVbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:31:38 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:42916 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZKCVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:31:37 -0500
Date: Tue, 3 Nov 2009 15:31:29 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 01/13] sysfs: Update sysfs_setxattr so it updates
	secdata under the sysfs_mutex
Message-ID: <20091103213129.GA13555@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-1-git-send-email-ebiederm@xmission.com> <20091103134823.GB31981@us.ibm.com> <m1ocnj9uz5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ocnj9uz5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> From: Eric W. Biederman <ebiederm@aristanetworks.com>
> >> 
> >> The sysfs_mutex is required to ensure updates are and will remain
> >> atomic with respect to other inode iattr updates, that do not happen
> >> through the filesystem.
> >> 
> >> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> >> ---
> >>  fs/sysfs/inode.c |   41 +++++++++++++++++++++++++++++------------
> >>  1 files changed, 29 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> >> index e28cecf..8a08250 100644
> >> --- a/fs/sysfs/inode.c
> >> +++ b/fs/sysfs/inode.c
> >> @@ -122,23 +122,39 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
> >>  	return error;
> >>  }
> >> 
> >> +static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata, u32 *secdata_len)
> >> +{
> >> +	struct sysfs_inode_attrs *iattrs;
> >> +	void *old_secdata;
> >> +	size_t old_secdata_len;
> >> +
> >> +	iattrs = sd->s_iattr;
> >> +	if (!iattrs)
> >> +		iattrs = sysfs_init_inode_attrs(sd);
> >> +	if (!iattrs)
> >> +		return -ENOMEM;
> >> +
> >> +	old_secdata = iattrs->ia_secdata;
> >> +	old_secdata_len = iattrs->ia_secdata_len;
> >> +
> >> +	iattrs->ia_secdata = *secdata;
> >> +	iattrs->ia_secdata_len = *secdata_len;
> >> +
> >> +	*secdata = old_secdata;
> >> +	*secdata_len = old_secdata_len;
> >> +	return 0;
> >> +}
> >> +
> >>  int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
> >>  		size_t size, int flags)
> >>  {
> >>  	struct sysfs_dirent *sd = dentry->d_fsdata;
> >> -	struct sysfs_inode_attrs *iattrs;
> >>  	void *secdata;
> >>  	int error;
> >>  	u32 secdata_len = 0;
> >> 
> >>  	if (!sd)
> >>  		return -EINVAL;
> >> -	if (!sd->s_iattr)
> >> -		sd->s_iattr = sysfs_init_inode_attrs(sd);
> >> -	if (!sd->s_iattr)
> >> -		return -ENOMEM;
> >> -
> >> -	iattrs = sd->s_iattr;
> >> 
> >>  	if (!strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
> >>  		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
> >> @@ -150,12 +166,13 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
> >>  						&secdata, &secdata_len);
> >>  		if (error)
> >>  			goto out;
> >> -		if (iattrs->ia_secdata)
> >> -			security_release_secctx(iattrs->ia_secdata,
> >> -						iattrs->ia_secdata_len);
> >> -		iattrs->ia_secdata = secdata;
> >> -		iattrs->ia_secdata_len = secdata_len;
> >> 
> >> +		mutex_lock(&sysfs_mutex);
> >> +		error = sysfs_sd_setsecdata(sd, &secdata, &secdata_len);
> >
> > You're ignoring the potential -ENOMEM return value here?
> >
> > Worse, if -ENOMEM, then secdata was never set, so you call
> > security_release_secctx() on a random value left on the stack...
> 
> No.  It is more elegant than that.
> If sysfs_sd_setsecdata fails secdata holds the freshly allocated secdata value.
> If sysfs_sd_setsecdata succeeds secdata holds the old value of secdata.

Gah, sorry.

Acked-by: Serge Hallyn <serue@us.ibm.com>

(as an aside, I can't see any reason to not just return if strncmp(name,
XATTR_SECURITY_PREFIX,) above to avoid a level of indent and needless gotos)

thanks,
-serge
