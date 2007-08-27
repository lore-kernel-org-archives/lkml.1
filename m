Return-Path: <linux-kernel-owner+w=401wt.eu-S965220AbXH0WAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbXH0WAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbXH0WAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:00:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:50881 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965648AbXH0V77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:59:59 -0400
X-Authenticated: #2253541
X-Provags-ID: V01U2FsdGVkX18yeosX65Uytpi0B7JsvkYJC1MYi1smBTYBpWAJ4w
	ilj2tsdhmZILjj
Date: Mon, 27 Aug 2007 23:59:54 +0200
From: Thomas Bleher <ThomasBleher@gmx.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version2 Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070827215954.GA5979@thorium2.jmh.mhn.de>
Mail-Followup-To: Casey Schaufler <casey@schaufler-ca.com>,
	torvalds@osdl.org, akpm@osdl.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <46D0FF17.4020103@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <46D0FF17.4020103@schaufler-ca.com>
X-Accept-Language: de, en
X-Operating-System: Linux 2.6.20-16-generic i686
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Casey Schaufler <casey@schaufler-ca.com> [2007-08-27 22:51]:
>=20
> Smack is the Simplified Mandatory Access Control Kernel.
>=20
> Smack implements mandatory access control (MAC) using labels
> attached to tasks and data containers, including files, SVIPC,
> and other tasks. Smack is a kernel based scheme that requires
> an absolute minimum of application support and a very small
> amount of configuration data.
>=20
> Smack is implemented as a clean LSM. It requires no external
> code changes and the patch modifies only the Kconfig and Makefile
> in the security directory. Smack uses extended attributes and
> provides a set of general mount options, borrowing technics used
> elsewhere. Smack uses netlabel for CIPSO labeling. Smack provides
> a pseudo-filesystem smackfs that is used for manipulation of
> system Smack attributes.
>=20
> The patch, patches for ls and sshd, a README, a startup script,
> and x86 binaries for ls and sshd are also available on
>=20
>     http:/www.schaufler-ca.com

I like the general idea of this LSM.
One question about your security model, though:
If I understand your LSM correctly, MAC override is based on
capabilities, specifically on CAP_LINUX_IMMUTABLE. So any root process
which doesn't explicitly give up this capability is effectively
unconfined, right?

If so, this is a serious limitation that should be mentioned in the
docs. File capabilities should alleviate this problem, but they first
need to be configured correctly...

Some other comments below:

> --- linux-2.6.22-base/security/smack/Kconfig	1969-12-31 16:00:00.00000000=
0 -0800
> +++ linux-2.6.22-smack/security/smack/Kconfig	2007-08-22 02:18:55.0000000=
00 -0700
> @@ -0,0 +1,10 @@
> +config SECURITY_SMACK
> +	bool "Simplified Mandatory Access Control Kernel Support"
> +	depends on NETLABEL && SECURITY_NETWORK
> +	default n
> +	help
> +	  This selects the Simplified Mandatory Access Control Kernel.
> +	  Smack is useful for sensitivity, integrity, and a variety
> +	  of other mandatory security schemes.
> +	  If you are unsure how to answer this question, answer N.

I think a link to further documentation would be nice.
Maybe you could include the README from your site in Documentation/?

BTW: Some documentation missing there:
* the various mount options
* how to enable cipso (Do I have to enable it explicitly? Most people
  won't even know what cipso is)


> +/**
> + * smack_syslog - Smack approval on syslog
> + * @type: message type
> + *
> + * Require that the task has the floor label
> + *
> + * Returns 0 on success, error code otherwise.
> + */
> +static int smack_syslog(int type)
> +{
> +	int rc;
> +	smack_t *sp =3D current->security;
> +
> +	rc =3D cap_syslog(type);
> +	if (rc =3D=3D 0)
> +		 if (*sp !=3D SMK_FLOOR)
> +			rc =3D -EACCES;
> +
> +	return rc;
> +}

Can you explain why you limit syslog that way?

> +/**
> + * smackfs_follow_link - follow a smackfs symlink
              ^^^^^^^^^^^ should be put_link
> + * @dentry: unused
> + * @nd: name entry
> + * @ptr: unused
> + *
> + * free the buffer used in following the link.
> + */
> +static void smackfs_put_link(struct dentry *dentry, struct nameidata *nd=
, void *ptr)
> +{
> +	kfree(nd_get_link(nd));
> +}


> +       for (cp =3D data - 1; cp !=3D NULL; cp =3D strchr(cp + 1, '\n')) {
> +               if (*++cp =3D=3D '\0')
> +                       break;
> +               if (sscanf(cp, "%14s %30s\n", name, target) !=3D 2) {
> +                       printk("%s:%d bad scan\n",
> +                               __func__, __LINE__);

Leftover debugging printk? Otherwise, a level would be nice.

> +                       break;
> +               }
> +               smk_add_symlink(name, target);
> +               printk("%s:%d add %s -> %s\n",
> +                       __func__, __LINE__, name, target);

Ditto.

> +       }


> +/**
> + * smackfs_follow_link - follow a smackfs symlink
> + * @dentry: name cache entry
> + * @nd: name entry
> + *
> + * A symlink on smackfs has unusual semantics.
> + *
> + * The Smack value of the task is appended to the link string.
> + * Thus, if a task labeled "Gentoo" does chdir("/smack/tmp")
> + * it will use "/moldy/Gentoo".
> + *
> + * The expected usage is the /tmp is a symlink to /smack/tmp
> + * which is itself a symlink to /moldy. /moldy should have a
> + * directory for each label in use to accomodate the value
> + * appended on the redirection.
> + *
> + * An interesting addition would be a file system that automatically
> + * creates directories as needed, at the appropriate label.
> + */

I'm not very versed in the VFS, so I don't think I understand the code
fully there, but shouldn't the above read /smack/links?


> +	static struct tree_descr smack_files[] =3D {
> +		[SMK_LOAD]	=3D {"load", &smk_load_ops, S_IRUGO|S_IWUSR},
> +		[SMK_LINKS]	=3D {"links", &smk_links_ops, S_IRUGO|S_IWUSR},

I really don't understand your symlink code (not because it's bad, I just
don't know this area), so this is just a question:
Wouldn't S_IRUGO be enough for the links entry?

> +		[SMK_CIPSO]	=3D {"cipso", &smk_cipso_ops, S_IRUGO|S_IWUSR},
> +		[SMK_DOI]	=3D {"doi", &smk_doi_ops, S_IRUGO|S_IWUSR},
> +		[SMK_DIRECT]	=3D {"direct", &smk_direct_ops, S_IRUGO|S_IWUSR},
> +		[SMK_AMBIENT]	=3D {"ambient", &smk_ambient_ops,S_IRUGO|S_IWUSR},
> +		[SMK_NLTYPE]	=3D {"nltype", &smk_nltype_ops, S_IRUGO|S_IWUSR},
> +		/* last one */ {""}
> +	};
> +
> +	/*
> +	 * There will be only one smackfs. Casey says so.
> +	 */
> +	smk_sb =3D sb;
> +
> +	rc =3D simple_fill_super(sb, SMACK_MAGIC, smack_files);
> +	if (rc !=3D 0) {
> +		printk(KERN_ERR "%s failed %d while creating inodes\n",
> +			__func__, rc);
> +		return rc;
> +	}
> +
> +	root_inode =3D sb->s_root->d_inode;
> +	root_inode->i_security =3D new_inode_smack(&smack_known_floor.smk_known=
);
> +
> +	/*
> +	 * Create a directory for /smack/tmp
> +	 */
> +	smk_add_symlink("tmp", SMK_TMPPATH_ROOT);

Ah, so you dynamically add symlinks here. Can the user do this, too? If
so, how? A little documentation might be nice.

Thomas


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG00laD9qpeVMU938RAmhUAJ4/hxzd1kULF9qrk8DtXLwMYkKkxQCfa5ZX
HocBuIW/BUdUWORN5yb0Ss0=
=cLzD
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
