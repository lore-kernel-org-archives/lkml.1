Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZIYKG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZIYKG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZIYKGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:06:54 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:42188 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIYKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:06:53 -0400
X-Greylist: delayed 2972 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2009 06:06:52 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MBA0fRAXwoM4+DOZzXIr2kuzTxVc9KLs/NNyiTe12g2D8U3v3pDgJLojdbVcFw2B40
         LCTHQiFPxgDz+RWB4e0TvpHKf+k+IR4ua8Nm+pOgiybhqheRTk9GB7JFZiF8WzbQbvgz
         c8Hl1S9arwh+ZkfnXYqsE/uzZMOTfyhWppfe8=
Date: Fri, 25 Sep 2009 10:06:30 +0000
From: Andy Spencer <andy753421@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Privilege dropping security module
Message-ID: <20090925100630.GD10098@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
 <20090923213109.GA936@c.hsd1.tn.comcast.net>
 <4ABB9D6D.8000607@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-11152-1253873214-0001-2"
Content-Disposition: inline
In-Reply-To: <4ABB9D6D.8000607@schaufler-ca.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-11152-1253873214-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> I think I saw this mentioned elsewhere, but you can't put a
> 4k buffer on the stack.
> ...
> "//" comments are not used in the kernel
> ...
> Why use a value other than PATH_MAX? If it's arbitrary,
> go with the "standard" arbitrary.
> ...=20
> Stick with your namespace.

Fixed as suggested, thanks.


> The term "privilege" is generally applied to a broader scope
> than discretionary access controls. You might want to consider
> using a name that is more precisely descriptive of the feature.
> It probably isn't that important, but I for one would be happier.
>=20
> You're not dropping privilege, that would imply restricting
> root and/or capability access. You're masking file permissions.

I have no objections to changing the name if you have a better
suggestion. However, I would like to avoid the term "discretionary
access control" since DACs deal with passing permissions between
subjects, while in dpriv, the only subject involved is the current
subject (well, and its children). Also, as pointed out in another
thread, dpriv will eventually need to support more than just file
permissions if it wants to be secure.


> > +#define pr_fmt(fmt) "%s: " fmt, __func__
>=20
> You have defined this in multiple places, which isn't good,
> and it's a bit of code that obfuscates what's going on. It
> may seem like a good idea, but you'll be better off if you
> go ahead and put the code in where you're using it.

Defining pr_fmt seems to be fairly common in the rest of the kernel, a
quick grep shows 98 occurrences. If these are all deprecated, I don't
mind changing it, but it seem worth the bit of obfuscation to me.


> > +u16 flags_to_mode(unsigned int flags)
> > +int str_to_perm(const char *str)
> > +void perm_to_str(u16 perm, char *str)
>=20
> Definitely namespace. Could this be static?

I added the namespace, but they're used in a couple other files so they
can't be static. There are a couple other function in policy.[ch] that
could be static but I'm leaving them in the header for now in case they
end up being needed later.


> > +#define dpriv_cur_task   ((struct dpriv_task *)current_security())
> > +#define dpriv_cur_stage  ((struct dpriv_policy *)&dpriv_cur_task->stag=
e)
> > +#define dpriv_cur_policy ((struct dpriv_policy *)&dpriv_cur_task->poli=
cy)
>=20
> You may get other feedback, but I think that using macros
> to hide indirections make code harder to understand.

I think I'd like to keep these as well, although it might be good to
change them to either `dpriv_current_*()' or `current_dpriv_*()' to
follow the conventions used in <linux/cred.h>.


> > +/* Mode conversion functions */
> > +#define deny(perm, request) \
> > +	unlikely(perm >=3D 0 && ~perm & request)
>=20
> Keep to your namespace and use static inline functions.

I changed these to static inline functions, but the one thing I don't
like about doing so is that I don't think the compiler can't optimize
the `unlikely()' macro as well. For the time being, I moved the unlikely
macros to where deny (now dpriv_denied) gets called.


> Function macros are discouraged. If you really want code duplication
> use static inline functions. And stick with your namespace, use
> dpriv_strfwd() instead of strfwd().
> ...
> String parsing in the kernel is considered harmful.
> Simplify this.

I reworked much of the string parsing. I think /some/ parsing is going
to be necessary no matter what, but hopefully the new way of doing it is
easier to understand and less likely to contains bugs. As a result those
macros are no longer needed at all. (Note that this depends on a
separate patch to sscanf). I've included the new dpriv_stage_write()
below.

(I can include another full diff against either the previous patch or
the mainline kernel if anyone would like it.)

=20
static ssize_t dpriv_stage_write(struct file *filp, const char *ubuffer,
		size_t length, loff_t *off)
{
	struct file *file;
	int err, rval, perm;
	char *kbuffer, *perm_str, *path_str;
	int perm_start, perm_end, path_start;

	if (!(kbuffer =3D kzalloc(length+1, GFP_KERNEL)))
		return -ENOMEM;

	if (copy_from_user(kbuffer, ubuffer, length))
		goto fail_fault;

	/* Parse input */
	path_start =3D -1;
	sscanf(kbuffer, " %n%*s%n %n", &perm_start, &perm_end, &path_start);
	if (path_start =3D=3D -1)
		goto fail_inval;
	perm_str =3D kbuffer+perm_start;
	kbuffer[perm_end] =3D '\0';
	path_str =3D kbuffer+path_start;

	/* Check and convert perm */
	if (perm_str[0] =3D=3D '\0')
		goto fail_inval;
	if ((perm =3D dpriv_str_to_perm(perm_str)) < 0)
		goto fail_inval;

	/* Check and open path */
	if (path_str[0] =3D=3D '\0')
		goto fail_inval;
	if (IS_ERR(file =3D filp_open(path_str, 0, 0))) {
		/* file not found, try trimming trailing spaces */
		strstrip(path_str);
		if (path_str[0] =3D=3D '\0')
			goto fail_inval;
		if (IS_ERR(file =3D filp_open(path_str, 0, 0)))
			goto fail_noent;
	}

	path_str =3D kstrdup(path_str, GFP_KERNEL);
	if (!path_str)
		goto fail_nomem;

	if ((err =3D dpriv_policy_set_perm(dpriv_cur_stage,
			file->f_dentry->d_inode, path_str, perm))) {
		kfree(path_str);
		rval =3D err;
		goto out;
	}

	pr_debug("dpriv_task=3D%p pid=3D%d perm=3D%o[%s] path=3D%p[%s]\n",
		dpriv_cur_task, current->pid, perm, perm_str, file, path_str);

	rval =3D length;
	goto out; /* Success */

fail_inval: rval =3D -EINVAL; goto out;
fail_nomem: rval =3D -ENOMEM; goto out;
fail_fault: rval =3D -EFAULT; goto out;
fail_noent: rval =3D -ENOENT; goto out;
out:
	kfree(kbuffer);
	/* if (rval < 0) abort task ? */
	return rval;
}

--=_c-11152-1253873214-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq8lj4ACgkQz1OYJ/s1XTBpfgCgjePleYUBbRnuTqb0liWMuUt3
TE0AoIOquoYBU7a55QtXNcTeNNIW93Yz
=FCVk
-----END PGP SIGNATURE-----

--=_c-11152-1253873214-0001-2--
