Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZECJP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZECJP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZECJPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:15:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58477 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZECJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:15:08 -0400
Date: Sun, 3 May 2009 10:15:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       David <david@unsolicited.net>
Subject: Re: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
Message-ID: <20090503091507.GU8633@ZenIV.linux.org.uk>
References: <49FB1F20.8040400@suse.com> <20090503085236.GT8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503085236.GT8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 09:52:36AM +0100, Al Viro wrote:
> On Fri, May 01, 2009 at 12:11:12PM -0400, Jeff Mahoney wrote:
> >  2.6.30-rc3 introduced some sanity checks in the VFS code to avoid NFS
> >  bugs by ensuring that lookup_one_len is always called under i_mutex.
> > 
> >  This patch expands the i_mutex locking to enclose lookup_one_len. This was
> >  always required, but not not enforced in the reiserfs code since it
> >  does locking around the xattr interactions with the xattr_sem.
> > 
> >  This is obvious enough, but it survived an overnight 50 thread ACL test.
> 
> It's not enough, unfortunately ;-/  It deals with the warning, but it
> leaves an actual hole in there.
> 
> Look: what happens if we mount it r/o without that directory and then
> remount r/w?  We get dentry for privroot, hash it (negative at that point),
> then do actual mkdir, unlock root and modify the ->d_compare() of root
> to reject lookups on that sucker.  Too late - in the meanwhile lookups
> might very well come and find privroot in dcache.
> 
> BTW, the way ->d_compare() is done in there is rather dumb -
> 	if (q1 == &priv_root->d_name)
> 		return -ENOENT;
> 	...
> would do just as well.  Why don't we do that lookup *once* (on ->get_sb(),
> before anything can come and race with us), and then just keep negative
> dentry if the directory hadn't been around?  And set d_compare() for root
> immediately after that lookup...
> 
> I've applied your patch as-is, and unless you have objections to the
> variant above I'll do that as incremental.  Comments?

BTW, what in the name of everything unholy is ->xattr_root?  Never
assigned a non-NULL value...
