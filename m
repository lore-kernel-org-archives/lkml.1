Return-Path: <linux-kernel-owner+w=401wt.eu-S937009AbXHHQoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937009AbXHHQoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935276AbXHHQno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:43:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39903 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935078AbXHHQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:43:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 20/25] sysfs: Rename Support multiple superblocks
References: <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com>
	<20070808093505.GL13674@htj.dyndns.org>
	<m1643qdo7e.fsf@ebiederm.dsl.xmission.com>
	<46B9E660.6030702@gmail.com>
Date: Wed, 08 Aug 2007 10:35:38 -0600
In-Reply-To: <46B9E660.6030702@gmail.com> (Tejun Heo's message of "Thu, 09 Aug
	2007 00:50:56 +0900")
Message-ID: <m1lkcmc7c5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Yeah, I think using -ENOENT is better; otherwise, my little head feels
> like exploding.  :-)  

Ok.  I think I know the feeling.

> More importantly, sysfs_get_dentry() seems like it
> would deference ERR_PTR() value.  No?

I'm confused where you are referring to but I will try answer
this.

__sysfs_get_dentry always returns a dentry or NULL if it can't
find the dentry.


I have quoted my final version of sysfs_get_dentry below for discussion.

> struct dentry *sysfs_get_dentry(struct super_block *sb, struct sysfs_dirent *sd)
> {
> 	struct sysfs_dirent *cur;
> 	struct dentry *parent_dentry, *dentry;
> 
> 	/* Bail if this sd won't show up in this superblock */
> 	if (sd->s_parent && sd->s_parent->s_flags & SYSFS_FLAG_TAGGED) {
> 		const void *tag;
> 		tag = sysfs_lookup_tag(sd->s_parent, sb);
> 		if (sd->s_tag.tag != tag)
> 			return NULL;
> 	}

This is the only location where could return NULL the early check
if this operation is possible.

> 	/* Find the first parent which has valid dentry.
> 	 */
> 	dentry = NULL;
> 	cur = sd;
> 	while (!(dentry = __sysfs_get_dentry(sb, cur))) {
> 		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
> 			dentry = ERR_PTR(-ENOENT);
> 			break;
> 		}
> 		cur = cur->s_parent;
> 	}

Here we depend on the fact that sysfs_root is pointed to
by sb->s_root so we know it will always have a dentry.

> 	/* from the found dentry, look up depth times */
> 	while (dentry->d_fsdata != sd) {
> 		/* Find the first ancestor I have not looked up */
> 		cur = sd;
> 		while (cur->s_parent != dentry->d_fsdata)
> 			cur = cur->s_parent;
> 
> 		/* look it up */
> 		parent_dentry = dentry;
> 		dentry = sysfs_add_dentry(parent_dentry, cur);
> 		dput(parent_dentry);
> 
> 		if (IS_ERR(dentry))
> 			break;
> 	}
> 	return dentry;
> }

Eric
