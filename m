Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbZEMNUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbZEMNUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZEMNUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:20:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZEMNUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:20:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1242168913.6711.9.camel@poy>
References: <1242168913.6711.9.camel@poy> <20090509143742.GA27663@kroah.com> <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil> <20090511175626.GA4758@kroah.com> <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil> <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> <1242132344.31807.48.camel@localhost.localdomain> <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com> <1242142528.31807.80.camel@localhost.localdomain> <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com> 
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [patch 00/13] devtmpfs patches
Date: Wed, 13 May 2009 14:20:10 +0100
Message-ID: <10761.1242220810@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> wrote:

> +static struct cred *kern_cred;

Can I suggest that you call your cred pointer dev_cred rather than kern_cred
so that the naming is consistent with the other globals variables?

> +	kern_cred = prepare_kernel_cred(NULL);

If you have no intention of altering the credentials you create, you might
want to use &init_cred instead of kern_cred.  That said, you might want to
allocate it and let the security module alter it before you use it.

Also, Stephen is right, you should probably wrap all your accesses to the VFS
in your devtmpfs credentials.  For instance, devtmpfs_create_node() calls
vfs_mkdir() with the process's credentials via create_path() and directly with
the kern_cred.

What you probably want is:

	int devtmpfs_create_node(struct device *dev)
	{
		const struct cred *curr_cred;
		const char *tmp = NULL;
		const char *nodename;
		mode_t mode;
		struct nameidata nd;
		struct dentry *dentry;
		int err;

		if (!dev_mnt)
			return 0;

		nodename = device_get_nodename(dev, &tmp);
		if (!nodename)
			return -ENOMEM;

		curr_cred = override_creds(kern_cred);

		if (is_blockdev(dev))
			mode = S_IFBLK|0600;
		else
			mode = S_IFCHR|0600;

		err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
				      nodename, LOOKUP_PARENT, &nd);
		if (err == -ENOENT) {
			/* create missing parent directories */
			create_path(nodename);
			err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
					      nodename, LOOKUP_PARENT, &nd);
			if (err)
				goto out_name;
		}

		dentry = lookup_create(&nd, 0);
		if (!IS_ERR(dentry)) {
			err = vfs_mknod(nd.path.dentry->d_inode,
					dentry, mode, dev->devt);
			/* mark as kernel created inode */
			if (!err)
				dentry->d_inode->i_private = &dev_mnt;
			dput(dentry);
		} else {
			err = PTR_ERR(dentry);
		}
		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);

		path_put(&nd.path);
	out_name:
		revert_creds(curr_cred);
		kfree(tmp);
		return err;
	}

David
