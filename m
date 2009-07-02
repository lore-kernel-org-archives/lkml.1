Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZGBIJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZGBIJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZGBIJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:09:08 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:52203 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZGBIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:09:05 -0400
Date: Thu, 2 Jul 2009 10:09:03 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] [RFC] Support named cgroups hierarchies
Message-ID: <20090702080902.GB4305@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com> <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-20249-1246522119-0001-2"
Content-Disposition: inline
In-Reply-To: <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-20249-1246522119-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 01, 2009 at 07:10:58PM -0700, Paul Menage wrote:
> [RFC] Support named cgroups hierarchies
>=20
> To simplify referring to cgroup hierarchies in mount statements, and
> to allow disambiguation in the presence of empty hierarchies and
> multiply-bindable subsystems (see later patches in series) this patch
> adds support for naming a new cgroup hierarchy via the "name=3D" mount
> option
>=20
> A pre-existing hierarchy may be specified by either name or by
> subsystems; a hierarchy's name cannot be changed by a remount
> operation.
>=20
> Example usage:
>=20
> # To create a hierarchy called "foo" containing the "cpu" subsystem
> mount -t cgroup -oname=3Dfoo,cpu cgroup /mnt/cgroup1
>=20
> # To mount the "foo" hierarchy on a second location
> mount -t cgroup -oname=3Dfoo cgroup /mnt/cgroup2
>=20
> Open issues:
>=20
> - should the specification be via a name=3D option as in this patch, or
>   should we simply use the "device name" as passed to the mount()
>   system call?  Using the device name is more conceptually clean and
>   consistent with the filesystem API; however, given that the device
>   name is currently ignored by cgroups, this would lead to a
>   user-visible behaviour change.

I did not see anything preventing two hierarchies from having the same
(non empty) name. I guess that in such a case trying to mount a named
hierarchy on a second location is unspecified. Could we just check for
unique (non empty) names?

Thanks,

Louis

>=20
> Signed-off-by: Paul Menage <menage@google.com>
>=20
> ---
>=20
>  kernel/cgroup.c |  136 ++++++++++++++++++++++++++++++++++++-------------=
------
>  1 files changed, 88 insertions(+), 48 deletions(-)
>=20
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index ea255fe..940f28d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -59,6 +59,8 @@ static struct cgroup_subsys *subsys[] =3D {
>  #include <linux/cgroup_subsys.h>
>  };
> =20
> +#define MAX_CGROUP_ROOT_NAMELEN 64
> +
>  /*
>   * A cgroupfs_root represents the root of a cgroup hierarchy,
>   * and may be associated with a superblock to form an active
> @@ -93,6 +95,9 @@ struct cgroupfs_root {
> =20
>  	/* The path to use for release notifications. */
>  	char release_agent_path[PATH_MAX];
> +
> +	/* The name for this hierarchy - may be empty */
> +	char name[MAX_CGROUP_ROOT_NAMELEN];
>  };
> =20
>  /*
> @@ -828,6 +833,8 @@ static int cgroup_show_options(struct seq_file *seq, =
struct vfsmount *vfs)
>  		seq_puts(seq, ",noprefix");
>  	if (strlen(root->release_agent_path))
>  		seq_printf(seq, ",release_agent=3D%s", root->release_agent_path);
> +	if (strlen(root->name))
> +		seq_printf(seq, ",name=3D%s", root->name);
>  	mutex_unlock(&cgroup_mutex);
>  	return 0;
>  }
> @@ -836,12 +843,15 @@ struct cgroup_sb_opts {
>  	unsigned long subsys_bits;
>  	unsigned long flags;
>  	char *release_agent;
> +	char *name;
> +	/* A flag indicating that a root was created from this options block */
> +	bool created_root;
>  };
> =20
>  /* Convert a hierarchy specifier into a bitmask of subsystems and
>   * flags. */
>  static int parse_cgroupfs_options(char *data,
> -				     struct cgroup_sb_opts *opts)
> +				  struct cgroup_sb_opts *opts)
>  {
>  	char *token, *o =3D data ?: "all";
>  	unsigned long mask =3D (unsigned long)-1;
> @@ -850,9 +860,7 @@ static int parse_cgroupfs_options(char *data,
>  	mask =3D ~(1UL << cpuset_subsys_id);
>  #endif
> =20
> -	opts->subsys_bits =3D 0;
> -	opts->flags =3D 0;
> -	opts->release_agent =3D NULL;
> +	memset(opts, 0, sizeof(*opts));
> =20
>  	while ((token =3D strsep(&o, ",")) !=3D NULL) {
>  		if (!*token)
> @@ -872,11 +880,19 @@ static int parse_cgroupfs_options(char *data,
>  			/* Specifying two release agents is forbidden */
>  			if (opts->release_agent)
>  				return -EINVAL;
> -			opts->release_agent =3D kzalloc(PATH_MAX, GFP_KERNEL);
> +			opts->release_agent =3D
> +				kstrndup(token + 14, PATH_MAX, GFP_KERNEL);
>  			if (!opts->release_agent)
>  				return -ENOMEM;
> -			strncpy(opts->release_agent, token + 14, PATH_MAX - 1);
> -			opts->release_agent[PATH_MAX - 1] =3D 0;
> +		} else if (!strncmp(token, "name=3D", 5)) {
> +			/* Specifying two names is forbidden */
> +			if (opts->name)
> +				return -EINVAL;
> +			opts->name =3D kstrndup(token + 5,
> +					      MAX_CGROUP_ROOT_NAMELEN,
> +					      GFP_KERNEL);
> +			if (!opts->name)
> +				return -ENOMEM;
>  		} else {
>  			struct cgroup_subsys *ss;
>  			int i;
> @@ -903,7 +919,7 @@ static int parse_cgroupfs_options(char *data,
>  		return -EINVAL;
> =20
>  	/* We can't have an empty hierarchy */
> -	if (!opts->subsys_bits)
> +	if (!opts->subsys_bits && !opts->name)
>  		return -EINVAL;
> =20
>  	return 0;
> @@ -931,6 +947,12 @@ static int cgroup_remount(struct super_block *sb, in=
t *flags, char *data)
>  		goto out_unlock;
>  	}
> =20
> +	/* Don't allow name to change at remount */
> +	if (opts.name && strcmp(opts.name, root->name)) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
>  	ret =3D rebind_subsystems(root, opts.subsys_bits);
>  	if (ret)
>  		goto out_unlock;
> @@ -942,6 +964,7 @@ static int cgroup_remount(struct super_block *sb, int=
 *flags, char *data)
>  		strcpy(root->release_agent_path, opts.release_agent);
>   out_unlock:
>  	kfree(opts.release_agent);
> +	kfree(opts.name);
>  	mutex_unlock(&cgroup_mutex);
>  	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
>  	unlock_kernel();
> @@ -963,6 +986,7 @@ static void init_cgroup_housekeeping(struct cgroup *c=
grp)
>  	INIT_LIST_HEAD(&cgrp->release_list);
>  	init_rwsem(&cgrp->pids_mutex);
>  }
> +
>  static void init_cgroup_root(struct cgroupfs_root *root)
>  {
>  	struct cgroup *cgrp =3D &root->top_cgroup;
> @@ -976,28 +1000,56 @@ static void init_cgroup_root(struct cgroupfs_root =
*root)
> =20
>  static int cgroup_test_super(struct super_block *sb, void *data)
>  {
> -	struct cgroupfs_root *new =3D data;
> +	struct cgroup_sb_opts *new =3D data;
>  	struct cgroupfs_root *root =3D sb->s_fs_info;
> =20
> -	/* First check subsystems */
> -	if (new->subsys_bits !=3D root->subsys_bits)
> -	    return 0;
> +	/* If we asked for a name then it must match */
> +	if (new->name && strcmp(new->name, root->name))
> +		return 0;
> =20
> -	/* Next check flags */
> -	if (new->flags !=3D root->flags)
> +	/* If we asked for subsystems then they must match */
> +	if (new->subsys_bits && new->subsys_bits !=3D root->subsys_bits)
>  		return 0;
> =20
>  	return 1;
>  }
> =20
> +static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts=
 *opts)
> +{
> +	struct cgroupfs_root *root;
> +
> +	if (!opts->subsys_bits)
> +		return ERR_PTR(-EINVAL);
> +
> +	root =3D kzalloc(sizeof(*root), GFP_KERNEL);
> +	if (!root)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init_cgroup_root(root);
> +	root->subsys_bits =3D opts->subsys_bits;
> +	root->flags =3D opts->flags;
> +	if (opts->release_agent)
> +		strcpy(root->release_agent_path, opts->release_agent);
> +	if (opts->name)
> +		strcpy(root->name, opts->name);
> +	opts->created_root =3D true;
> +	return root;
> +}
> +
>  static int cgroup_set_super(struct super_block *sb, void *data)
>  {
>  	int ret;
> -	struct cgroupfs_root *root =3D data;
> +	struct cgroup_sb_opts *opts =3D data;
> +	struct cgroupfs_root *root;
> =20
> +	root =3D cgroup_root_from_opts(opts);
> +	if (IS_ERR(root))
> +		return PTR_ERR(root);
>  	ret =3D set_anon_super(sb, NULL);
> -	if (ret)
> +	if (ret) {
> +		kfree(root);
>  		return ret;
> +	}
> =20
>  	sb->s_fs_info =3D root;
>  	root->sb =3D sb;
> @@ -1039,44 +1091,23 @@ static int cgroup_get_sb(struct file_system_type =
*fs_type,
>  	struct cgroup_sb_opts opts;
>  	int ret =3D 0;
>  	struct super_block *sb;
> -	struct cgroupfs_root *root;
> -	struct list_head tmp_cg_links;
> =20
>  	/* First find the desired set of subsystems */
>  	ret =3D parse_cgroupfs_options(data, &opts);
> -	if (ret) {
> -		kfree(opts.release_agent);
> -		return ret;
> -	}
> -
> -	root =3D kzalloc(sizeof(*root), GFP_KERNEL);
> -	if (!root) {
> -		kfree(opts.release_agent);
> -		return -ENOMEM;
> -	}
> -
> -	init_cgroup_root(root);
> -	root->subsys_bits =3D opts.subsys_bits;
> -	root->flags =3D opts.flags;
> -	if (opts.release_agent) {
> -		strcpy(root->release_agent_path, opts.release_agent);
> -		kfree(opts.release_agent);
> -	}
> +	if (ret)
> +		goto out_err;
> =20
> -	sb =3D sget(fs_type, cgroup_test_super, cgroup_set_super, root);
> +	sb =3D sget(fs_type, cgroup_test_super, cgroup_set_super, &opts);
> =20
>  	if (IS_ERR(sb)) {
> -		kfree(root);
> -		return PTR_ERR(sb);
> +		ret =3D PTR_ERR(sb);
> +		goto out_err;
>  	}
> =20
> -	if (sb->s_fs_info !=3D root) {
> -		/* Reusing an existing superblock */
> -		BUG_ON(sb->s_root =3D=3D NULL);
> -		kfree(root);
> -		root =3D NULL;
> -	} else {
> +	if (opts.created_root) {
>  		/* New superblock */
> +		struct cgroupfs_root *root =3D sb->s_fs_info;
> +		struct list_head tmp_cg_links;
>  		struct cgroup *root_cgrp =3D &root->top_cgroup;
>  		struct inode *inode;
>  		int i;
> @@ -1109,7 +1140,8 @@ static int cgroup_get_sb(struct file_system_type *f=
s_type,
>  		if (ret =3D=3D -EBUSY) {
>  			mutex_unlock(&cgroup_mutex);
>  			mutex_unlock(&inode->i_mutex);
> -			goto free_cg_links;
> +			free_cg_links(&tmp_cg_links);
> +			goto drop_new_super;
>  		}
> =20
>  		/* EBUSY should be the only error here */
> @@ -1146,12 +1178,17 @@ static int cgroup_get_sb(struct file_system_type =
*fs_type,
>  	}
> =20
>  	simple_set_mnt(mnt, sb);
> +	kfree(opts.release_agent);
> +	kfree(opts.name);
>  	return 0;
> =20
> - free_cg_links:
> -	free_cg_links(&tmp_cg_links);
>   drop_new_super:
>  	deactivate_locked_super(sb);
> +
> + out_err:
> +	kfree(opts.release_agent);
> +	kfree(opts.name);
> +
>  	return ret;
>  }
> =20
> @@ -2923,6 +2960,9 @@ static int proc_cgroup_show(struct seq_file *m, voi=
d *v)
>  		seq_printf(m, "%lu:", root->subsys_bits);
>  		for_each_subsys(root, ss)
>  			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
> +		if (strlen(root->name))
> +			seq_printf(m, "%sname=3D%s",
> +				   count ? "," : "", root->name);
>  		seq_putc(m, ':');
>  		get_first_subsys(&root->top_cgroup, NULL, &subsys_id);
>  		cgrp =3D task_cgroup(tsk, subsys_id);
>=20
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-20249-1246522119-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpMax4ACgkQVKcRuvQ9Q1RcYwCeIDAavvg8C1tClqmV4QsZlbhO
0V0AoKAdI9RV6skdgifjozbKFERWl4Dq
=GOZ0
-----END PGP SIGNATURE-----

--=_bohort-20249-1246522119-0001-2--
