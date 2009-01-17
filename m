Return-Path: <linux-kernel-owner+w=401wt.eu-S1763972AbZAQQmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763972AbZAQQmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbZAQQmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:42:33 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55614 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbZAQQmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:42:31 -0500
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a
 question
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: hooanon05@yahoo.co.jp
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <7210.1232172192@jrobl>
References: <7471.1231827621@jrobl>
	 <1231852628.6954.4.camel@norville.austin.ibm.com>
	 <496FAFE2.8020102@linux.vnet.ibm.com> <9829.1232091366@jrobl>
	 <1232125169.15209.19.camel@norville.austin.ibm.com> <7210.1232172192@jrobl>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 10:42:26 -0600
Message-Id: <1232210546.7015.8.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 15:03 +0900, hooanon05@yahoo.co.jp wrote:
> Dave Kleikamp:
> > I think you're hitting on something here.  I never understood  the need
> > for the d_drop()s, but taking them out broke things.  They probably are
> > just papering over bugs where the ecryptfs inode is not being properly
> > updated after changes are made to the lower inode.
> 
> As long as cifs_hardlink() calls d_drop() for the target dentry (as the
> old version of NFS did), ecryptfs may have to call d_drop() too. But I
> believe the d_drop() for the source dentry is unnecessary, as long as
> the inode attributes are maintained correctly.
> Additionally, when the lower filesystem does NOT call d_drop(), ecryptfs
> has no necessary to call it. I'd like to suggest ecryptfs_link() to
> check it by d_unhashed().

Does this function make sense (un-compiled, un-tested)?

void ecryptfs_update_inode_from_lower(struct dentry *dentry)
{
	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);

	if (d_unhashed(lower_dentry))
		d_drop(dentry);
	else {
		struct inode *inode = dentry->d_inode;
		struct inode *lower_inode = lower_dentry->d_inode;

		inode->i_nlink = lower_inode->i_nlink;
		inode->i_ctime = lower_inode->i_ctime;
		/* Should anything else go here ? */
	}
}
		
-- 
David Kleikamp
IBM Linux Technology Center

