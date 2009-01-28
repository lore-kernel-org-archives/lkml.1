Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZA1D6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZA1D6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZA1D6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:58:34 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:28396 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZA1D6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:58:33 -0500
Date: Tue, 27 Jan 2009 19:55:47 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: [PATCH 1/2] configfs: Silence lockdep on mkdir() and rmdir()
Message-ID: <20090128035547.GE7244@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <20081218111536.GR19128@hawkmoon.kerlabs.com> <1229623218-8056-2-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229623218-8056-2-git-send-email-louis.rilling@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.497FD772.0059:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 07:00:17PM +0100, Louis Rilling wrote:
> >From inside configfs it is not possible to serialize those recursive
> locking with a top-level one, because mkdir() and rmdir() are already
> called with inodes locked by the VFS. So using some
> mutex_lock_nest_lock() is not an option.
> 
> I am proposing two solutions:
> 1) one that wraps recursive mutex_lock()s with
>    lockdep_off()/lockdep_on().
> 2) (as suggested earlier by Peter Zijlstra) one that puts the
>    i_mutexes recursively locked in different classes based on their
>    depth from the top-level config_group created. This
>    induces an arbitrary limit (MAX_LOCK_DEPTH - 2 == 46) on the
>    nesting of configfs default groups whenever lockdep is activated
>    but this limit looks reasonably high. Unfortunately, this also
>    isolates VFS operations on configfs default groups from the others
>    and thus lowers the chances to detect locking issues.
> 
> Nobody likes solution 1), what I can understand.

	Me too :-P

> This patch implements solution 2). However lockdep is still not happy with
> configfs_depend_item(). Next patch reworks the locking of
> configfs_depend_item() and finally makes lockdep happy.

<snip>

>  #define CONFIGFS_ROOT		0x0001
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index 8e93341..f21be74 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -94,6 +94,9 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * pare
>  	INIT_LIST_HEAD(&sd->s_links);
>  	INIT_LIST_HEAD(&sd->s_children);
>  	sd->s_element = element;
> +#ifdef CONFIG_LOCKDEP
> +	sd->s_depth = -1;
> +#endif
>  	spin_lock(&configfs_dirent_lock);
>  	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
>  		spin_unlock(&configfs_dirent_lock);
> @@ -176,6 +179,17 @@ static int init_symlink(struct inode * inode)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_LOCKDEP
> +static void configfs_set_dir_dirent_depth(struct configfs_dirent *parent_sd,
> +					  struct configfs_dirent *sd)
> +{
> +	int parent_depth = parent_sd->s_depth;
> +
> +	if (parent_depth >= 0)
> +		sd->s_depth = parent_depth + 1;
> +}
> +#endif
> +
>  static int create_dir(struct config_item * k, struct dentry * p,
>  		      struct dentry * d)
>  {
> @@ -187,6 +201,9 @@ static int create_dir(struct config_item * k, struct dentry * p,
>  		error = configfs_make_dirent(p->d_fsdata, d, k, mode,
>  					     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
>  	if (!error) {
> +#ifdef CONFIG_LOCKDEP
> +		configfs_set_dir_dirent_depth(p->d_fsdata, d->d_fsdata);
> +#endif
>  		error = configfs_create(d, mode, init_dir);
>  		if (!error) {
>  			inc_nlink(p->d_inode);

	Can you change this to provide non-lockdep versions of
functions?  We don't want "#ifdef CONFIG_LOCKDEP" everywhere.  What we
want is the code to call functions unconditionally, and the functions to
do nothing if lockdep is not enabled.  Like:

#ifdef CONFIG_LOCKDEP
static inline void configfs_init_dir_dirent_depth(dirent)
{
    dirent->s_depth = -1;
}

static void configfs_set_dir_dirent_depth(struct configfs_dirent *parent_sd,
					  struct configfs_dirent *sd)
{
	int parent_depth = parent_sd->s_depth;

	if (parent_depth >= 0)
		sd->s_depth = parent_depth + 1;
}
#else
static inline void configfs_init_dir_dirent_depth(dirent)
{
}

static void configfs_set_dir_dirent_depth(struct configfs_dirent *parent_sd,
					  struct configfs_dirent *sd)
{
}
#endif

	This makes the callsites much nicer to read:

@@ -94,6 +94,9 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * pare
 	INIT_LIST_HEAD(&sd->s_links);
 	INIT_LIST_HEAD(&sd->s_children);
 	sd->s_element = element;
+	configfs_init_dir_dirent_depth(sd);
 	spin_lock(&configfs_dirent_lock);
 	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
 		spin_unlock(&configfs_dirent_lock);
@@ -187,6 +201,7 @@ static int create_dir(struct config_item * k, struct dentry * p,
 		error = configfs_make_dirent(p->d_fsdata, d, k, mode,
 					     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
 	if (!error) {
+		configfs_set_dir_dirent_depth(p->d_fsdata, d->d_fsdata);
 		error = configfs_create(d, mode, init_dir);
 		if (!error) {
 			inc_nlink(p->d_inode);

	Otherwise, this patch seems pretty straightforward.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
