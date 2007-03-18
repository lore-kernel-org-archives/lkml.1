Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXCRUNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXCRUNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXCRUNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:13:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50593 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbXCRUNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:13:23 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 18 Mar 2007 13:11:10 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 1/13] signal/timer/event fds v6 - anonymous inode source
 ...
In-Reply-To: <200703172158.46252.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0703181303440.5482@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.9367.1174004535.1>
 <200703172158.46252.arnd@arndb.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2007, Arnd Bergmann wrote:

> On Friday 16 March 2007 01:22:15 Davide Libenzi wrote:
> 
> > +
> > +static int ainofs_delete_dentry(struct dentry *dentry);
> > +static struct inode *aino_getinode(void);
> > +static struct inode *aino_mkinode(void);
> > +static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
> > +			 const char *dev_name, void *data, struct vfsmount *mnt);
> > +
> 
> In general, it would be good if you could just reorder your functions
> so that you don't need any forward declarations like these. It makes
> reviewing from bottom to top a little easier and it becomes obvious
> that there are no recursions in the code.

I personally prefer to have them always on top so I don't have to figure 
out where to place a new function, or to re-arrange the order of the 
functions if the implementation changes. Plus I like to keep all the data 
declarations on top, and this would still require some of the 
static functions declarations to preceed it in any case. I really don't 
want to waste time with counter-argouments that are most definitely a
personal taste, so if lots of ppl feel raw about that, and it goes in the 
coding standard, I'll be happily change it.



> > +static struct vfsmount *aino_mnt __read_mostly;
> > +static struct inode *aino_inode;
> > +static struct file_operations aino_fops = { };
> 
> Iirc, file_operations should be const.

Ack! It should, yes.


> > +int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
> > +	       char const *name, const struct file_operations *fops, void *priv)
> > +{
> 
> Since this is meant to be a generic interface that can be used
> from other subsystems, a kerneldoc style comment would be nice

Done!



> > +static int __init aino_init(void)
> > +{
> > +
> > +	if (register_filesystem(&aino_fs_type))
> > +		goto epanic;
> > +
> > +	aino_mnt = kern_mount(&aino_fs_type);
> > +	if (IS_ERR(aino_mnt))
> > +		goto epanic;
> > +
> > +	aino_inode = aino_mkinode();
> > +	if (IS_ERR(aino_inode))
> > +		goto epanic;
> > +
> > +	return 0;
> > +
> > +epanic:
> > +	panic("aino_init() failed\n");
> > +}
> 
> panic() is a little harsh from a loadable module. If you mean
> the aino support to be used as a module, this should probably
> just return an error.
> 
> > +static void __exit aino_exit(void)
> > +{
> > +	iput(aino_inode);
> > +	unregister_filesystem(&aino_fs_type);
> > +	mntput(aino_mnt);
> > +}
> 
> but since the Makefile always has it as built-in, maybe you should
> instead just kill the exit function and use fs_initcall instead
> of init_module().

Indeed, it can't be a module, so no exit function and fs_initcall.
Thx!



- Davide


