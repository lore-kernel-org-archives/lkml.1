Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbYLUR5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbYLUR5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 12:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYLUR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 12:57:21 -0500
Received: from www.tglx.de ([62.245.132.106]:49998 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbYLUR5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 12:57:20 -0500
To: Bastian Blank <bastian@waldi.eu.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net>
	<868wq9h905.fsf@johno-ibook.fn.ogness.net>
	<20081221154837.GA1940@wavehammer.waldi.eu.org>
Date: Sun, 21 Dec 2008 18:56:46 +0100
In-Reply-To: <20081221154837.GA1940@wavehammer.waldi.eu.org> (Bastian Blank's message of "Sun\, 21 Dec 2008 16\:48\:37 +0100")
Message-ID: <867i5ts97l.fsf@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-12-21, Bastian Blank <bastian@waldi.eu.org> wrote:
> There are several (okay, all) includes missing.

Indeed. I will fix this.

>> +static inline
>> +struct dazukofs_sb_info *GET_SB_INFO(struct super_block *upper_sb)
>
> Coding-style.

The functions were originally macros. The capitalization was inspired
by macros such as IS_ERR, PTR_ERR, MKDEV, etc. That is the
explanation, but it doesn't make it ok. I will change it.

>> +static inline void SET_LOWER_INODE(struct inode *upper_inode,
>> +				   struct inode *lower_inode)
>> +{
>> +	((struct dazukofs_inode_info *)
>> +	 container_of(upper_inode, struct dazukofs_inode_info,
>> +		      vfs_inode))->lower_inode = lower_inode;
>> +}
>
> Please make such cast cascades explicit:
>
> | struct dazukofs_inode_info *info = container_of(...);
> | info->lower_inode = lower_inode;
>
> There are other people which want to read the code.

Agreed.

>> +static int dazukofs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
>> +{
>> +	struct vfsmount *lower_mnt;
>> +	struct dentry *lower_dentry;
>> +	struct vfsmount *vfsmount_save;
>> +	struct dentry *dentry_save;
>> +	int valid;
>> +
>> +	valid = 1;
>> +
>> +	lower_dentry = GET_LOWER_DENTRY(dentry);
>> +
>> +	if (!lower_dentry->d_op || !lower_dentry->d_op->d_revalidate)
>> +		goto out;
>
> Why do you use goto instead of return?

I use a goto here so that only 1 exit point exists within the
function. However, that probably doesn't make much sense when such
basic sanity checks are performed at the beginning of the function. I
will change this.

>> +static int dazukofs_d_hash(struct dentry *dentry, struct qstr *name)
>> +{
>> +	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
>> +
>> +	if (!lower_dentry || !lower_dentry->d_op ||
>> +	    !lower_dentry->d_op->d_hash) {
>> +		return 0;
>> +	}
>
> You mix rather different coding styles through the whole code.

When I wrote the stacking code, it was the first time I started using
the Linux coding style. I will go back through and see what I can
clean up.

> Also why do you say that lower_dentry can be 0 in _hash, but not in
> _revalidate?

_hash doesn't need this check. I will remove it.

>> +static void dazukofs_d_release(struct dentry *dentry)
>> +{
>> +	if (GET_DENTRY_INFO(dentry)) {
>> +		dput(GET_LOWER_DENTRY(dentry));
>> +		mntput(GET_LOWER_MNT(dentry));
>
> Why do you push anything out in other functions while making it
> explicit would make it much easier readable?

For me, writing a stackable filesystem was quite complex.  Using the
all-caps functions for upper/lower layer translations helped me to
easily see what I was doing.  I agree that the all-caps thing is quite
ugly. I will change that, but I would prefer to keep the translation
functions as separate inline functions. (The same technique can be
seen in ecryptfs as well.)

John Ogness
