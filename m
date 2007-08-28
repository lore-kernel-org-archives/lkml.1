Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXH1S7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXH1S7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbXH1S7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:59:05 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:47633 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751108AbXH1S7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:59:03 -0400
X-YMail-OSG: ztMWluUVM1kKg0KfxLZner0FFiWjCUxcMqBpcXnGRIXfjc.6tv8Rpb9rrZnk36lHG1W3osdhsmi62eSHIHUPJijLvwAXF8twBzyYbwt99tTu3iRsflY-
X-RocketYMMF: rancidfat
Date: Tue, 28 Aug 2007 11:59:01 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version2 Smack: Simplified Mandatory Access Control Kernel
To: Thomas Bleher <ThomasBleher@gmx.de>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070827215954.GA5979@thorium2.jmh.mhn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <740651.452.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Thomas Bleher <ThomasBleher@gmx.de> wrote:

> * Casey Schaufler <casey@schaufler-ca.com> [2007-08-27 22:51]:
> > 
> > Smack is the Simplified Mandatory Access Control Kernel.
> > 
> > Smack implements mandatory access control (MAC) using labels
> > attached to tasks and data containers, including files, SVIPC,
> > and other tasks. Smack is a kernel based scheme that requires
> > an absolute minimum of application support and a very small
> > amount of configuration data.
> > 
> > Smack is implemented as a clean LSM. It requires no external
> > code changes and the patch modifies only the Kconfig and Makefile
> > in the security directory. Smack uses extended attributes and
> > provides a set of general mount options, borrowing technics used
> > elsewhere. Smack uses netlabel for CIPSO labeling. Smack provides
> > a pseudo-filesystem smackfs that is used for manipulation of
> > system Smack attributes.
> > 
> > The patch, patches for ls and sshd, a README, a startup script,
> > and x86 binaries for ls and sshd are also available on
> > 
> >     http:/www.schaufler-ca.com
> 
> I like the general idea of this LSM.

Thank you.

> One question about your security model, though:
> If I understand your LSM correctly, MAC override is based on
> capabilities, specifically on CAP_LINUX_IMMUTABLE. So any root process
> which doesn't explicitly give up this capability is effectively
> unconfined, right?

That is correct. This is consistant with the traditional and current
linux mainstream model.

> If so, this is a serious limitation that should be mentioned in the
> docs.

The superuser has been an issue since the first Security Expert
looked at the Unix kernel in the 1970's. I am not out to solve
that issue as Linux has the capability mechanism in place to do
that, and active development (as you point out) is in progress
to make that mechanism useful.

> File capabilities should alleviate this problem, but they first
> need to be configured correctly...

They need to get upstream, too.

Yes, program capability setting is an issue. I have done it before
on a Unix system and while it is a pain in the bum it's not actually
that hard when you have an audit trail and the source. It's the same
technic that the SELinux folks use with audit2allow, but directed at
a smaller set of choices.

> Some other comments below:
> 
> > --- linux-2.6.22-base/security/smack/Kconfig	1969-12-31 16:00:00.000000000
> -0800
> > +++ linux-2.6.22-smack/security/smack/Kconfig	2007-08-22 02:18:55.000000000
> -0700
> > @@ -0,0 +1,10 @@
> > +config SECURITY_SMACK
> > +	bool "Simplified Mandatory Access Control Kernel Support"
> > +	depends on NETLABEL && SECURITY_NETWORK
> > +	default n
> > +	help
> > +	  This selects the Simplified Mandatory Access Control Kernel.
> > +	  Smack is useful for sensitivity, integrity, and a variety
> > +	  of other mandatory security schemes.
> > +	  If you are unsure how to answer this question, answer N.
> 
> I think a link to further documentation would be nice.
> Maybe you could include the README from your site in Documentation/?

An idea with merit. I'll do it.

> BTW: Some documentation missing there:
> * the various mount options
> * how to enable cipso

I'll add those

> (Do I have to enable it explicitly? Most people
>   won't even know what cipso is)

Nope. CIPSO is native to Smack. The touchy bit is turning it off
when talking off the box. So far it looks like most of the world
is sufficiently ignorant of CIPSO that it gets ignored enough for
communication to occur at the ambient label.

> > +/**
> > + * smack_syslog - Smack approval on syslog
> > + * @type: message type
> > + *
> > + * Require that the task has the floor label
> > + *
> > + * Returns 0 on success, error code otherwise.
> > + */
> > +static int smack_syslog(int type)
> > +{
> > +	int rc;
> > +	smack_t *sp = current->security;
> > +
> > +	rc = cap_syslog(type);
> > +	if (rc == 0)
> > +		 if (*sp != SMK_FLOOR)
> > +			rc = -EACCES;
> > +
> > +	return rc;
> > +}
> 
> Can you explain why you limit syslog that way?

Indeed I can. In the end the syslog data is going to get put into
a file and may get displayed on consoles. You can argue that the
right thing to do is make the Smack label on those files and devices
hat ("^") and allow anyone (Smackwise) write to the syslog. That
disallows casual viewing of the syslog, and everyone would hate that.

It would make sense to allow this if the caller has appropriate
privilege. I think that I will make that change.
 
> > +/**
> > + * smackfs_follow_link - follow a smackfs symlink
>               ^^^^^^^^^^^ should be put_link

Whoops.

> > + * @dentry: unused
> > + * @nd: name entry
> > + * @ptr: unused
> > + *
> > + * free the buffer used in following the link.
> > + */
> > +static void smackfs_put_link(struct dentry *dentry, struct nameidata *nd,
> void *ptr)
> > +{
> > +	kfree(nd_get_link(nd));
> > +}
> 
> 
> > +       for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
> > +               if (*++cp == '\0')
> > +                       break;
> > +               if (sscanf(cp, "%14s %30s\n", name, target) != 2) {
> > +                       printk("%s:%d bad scan\n",
> > +                               __func__, __LINE__);
> 
> Leftover debugging printk? Otherwise, a level would be nice.

Nuts, I thought I'd gotten all of those.

> > +                       break;
> > +               }
> > +               smk_add_symlink(name, target);
> > +               printk("%s:%d add %s -> %s\n",
> > +                       __func__, __LINE__, name, target);
> 
> Ditto.

Ditto.

> > +       }
> 
> 
> > +/**
> > + * smackfs_follow_link - follow a smackfs symlink
> > + * @dentry: name cache entry
> > + * @nd: name entry
> > + *
> > + * A symlink on smackfs has unusual semantics.
> > + *
> > + * The Smack value of the task is appended to the link string.
> > + * Thus, if a task labeled "Gentoo" does chdir("/smack/tmp")
> > + * it will use "/moldy/Gentoo".
> > + *
> > + * The expected usage is the /tmp is a symlink to /smack/tmp
> > + * which is itself a symlink to /moldy. /moldy should have a
> > + * directory for each label in use to accomodate the value
> > + * appended on the redirection.
> > + *
> > + * An interesting addition would be a file system that automatically
> > + * creates directories as needed, at the appropriate label.
> > + */
> 
> I'm not very versed in the VFS, so I don't think I understand the code
> fully there, but shouldn't the above read /smack/links?

It does.
 
> > +	static struct tree_descr smack_files[] = {
> > +		[SMK_LOAD]	= {"load", &smk_load_ops, S_IRUGO|S_IWUSR},
> > +		[SMK_LINKS]	= {"links", &smk_links_ops, S_IRUGO|S_IWUSR},
> 
> I really don't understand your symlink code

It's ... unconventional.

> (not because it's bad, I just
> don't know this area), so this is just a question:
> Wouldn't S_IRUGO be enough for the links entry?

Nope. 
 
> > +		[SMK_CIPSO]	= {"cipso", &smk_cipso_ops, S_IRUGO|S_IWUSR},
> > +		[SMK_DOI]	= {"doi", &smk_doi_ops, S_IRUGO|S_IWUSR},
> > +		[SMK_DIRECT]	= {"direct", &smk_direct_ops, S_IRUGO|S_IWUSR},
> > +		[SMK_AMBIENT]	= {"ambient", &smk_ambient_ops,S_IRUGO|S_IWUSR},
> > +		[SMK_NLTYPE]	= {"nltype", &smk_nltype_ops, S_IRUGO|S_IWUSR},
> > +		/* last one */ {""}
> > +	};
> > +
> > +	/*
> > +	 * There will be only one smackfs. Casey says so.
> > +	 */
> > +	smk_sb = sb;
> > +
> > +	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);
> > +	if (rc != 0) {
> > +		printk(KERN_ERR "%s failed %d while creating inodes\n",
> > +			__func__, rc);
> > +		return rc;
> > +	}
> > +
> > +	root_inode = sb->s_root->d_inode;
> > +	root_inode->i_security = new_inode_smack(&smack_known_floor.smk_known);
> > +
> > +	/*
> > +	 * Create a directory for /smack/tmp
> > +	 */
> > +	smk_add_symlink("tmp", SMK_TMPPATH_ROOT);
> 
> Ah, so you dynamically add symlinks here. Can the user do this, too? If
> so, how? A little documentation might be nice.

The addition of symlinks in /smack is limited to root. Since the
content of smackfs is volitile making it user writeable could add
some opportunities for abuse.

More documentation wouldn't hurt.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
