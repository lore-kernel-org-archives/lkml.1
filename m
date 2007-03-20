Return-Path: <linux-kernel-owner+w=401wt.eu-S966059AbXCTBkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966059AbXCTBkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXCTBkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:40:03 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51048 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966059AbXCTBkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:40:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 19 Mar 2007 18:38:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 1/13] signal/timer/event fds v7 - anonymous inode source
 ...
In-Reply-To: <1174352866.13341.758.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703191836230.3733@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.15249.1174348071.1>
 <1174352866.13341.758.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Thomas Gleixner wrote:

> > +	error = -ENFILE;
> > +	file = get_empty_filp();
> > +	if (!file)
> > +		goto eexit_1;
> 
> make this "return -ENFILE;" please

Done


> > +	inode = aino_getinode();
> > +	if (IS_ERR(inode)) {
> > +		error = PTR_ERR(inode);
> > +		goto eexit_2;
> 
> Can you please use a bit more descriptive labels ?
> 
> e.g:
> 	goto out_filp;

Done


> > +static int ainofs_delete_dentry(struct dentry *dentry)
> > +{
> > +	/*
> > +	 * We faked vfs to believe the dentry was hashed when we created it.
> > +	 * Now we restore the flag so that dput() will work correctly.
> > +	 */
> > +	dentry->d_flags |= DCACHE_UNHASHED;
> > +	return 1;
> > +}
> 
> Please put either "struct ainofs_dentry_operations ..." below the next
> function or move ainofs_delete_dentry() above "struct
> ainofs_dentry_operations ..."
> 
> It's annoying to lookup the protoypes and implemenation back and forth.

I prefer to have all data declarations at the beginning. but if you can 
manage to have that requirement in the Coding Style, I'll change it ;)



> > +static struct inode *aino_getinode(void)
> > +{
> > +	return igrab(aino_inode);
> > +}
> 
> Please use "igrab(aino_inode);" directly in this one single place above.
> That saves us a prototype and an useless static function with no value.

Done



> > +/*
> > + * A single inode exist for all aino files. On the contrary of pipes,
> > + * aino inodes has no per-instance data associated, so we can avoid
> > + * the allocation of multiple of them.
> > + */
> > +static struct inode *aino_mkinode(void)
> > +{
> > +	int error = -ENOMEM;
> > +	struct inode *inode = new_inode(aino_mnt->mnt_sb);
> > +
> > +	if (!inode)
> > +		goto eexit_1;
> 
> 	return ERR_PTR(-ENOMEM);

Done


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
> 
> Panic ? It's not life critical - is it ? 
> 
> A printk(KERN_ERR...) and a return -Exx would be sufficient.

Done.




- Davide


