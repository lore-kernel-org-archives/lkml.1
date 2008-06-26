Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYFZCNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYFZCNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYFZCNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:13:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47741 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYFZCNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:13:00 -0400
Date: Wed, 25 Jun 2008 19:12:09 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: configfs: Q: item leak in a failing configfs_attach_group()?
Message-ID: <20080626021208.GA21801@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080624141649.GH7621@hawkmoon.kerlabs.com> <20080624171051.GD4184@ca-server1.us.oracle.com> <20080624180456.GA32036@hawkmoon.kerlabs.com> <20080624213439.GB2785@mail.oracle.com> <20080625095527.GB32036@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625095527.GB32036@hawkmoon.kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 11:55:27AM +0200, Louis Rilling wrote:
> Back to the two solutions that I've suggested (copy-pasted below), which one
> would you prefer?

	God, this is all ugly.  You've found so many ugly cases :-(

> If I'm right, two kinds of solutions for issue 1 (new item created while
> attaching a default group hierarchy):
> i/ tag new directories with CONFIGFS_USET_NEW before calling d_instantiate, and
> validate the whole group+default groups hierarchy in a second pass by clearing
> CONFIGFS_USET_NEW

	I think this is the right way.  We can't d_instantiate() later,
because lower callers use dentry->d_inode, and trying to work around
that would be even uglier!
	But can't we just propagate CONFIGFS_USET_MKDIR?  That's what's
happening actually.  Just set it down in the paths.  Then, change like
so:

	if (group)
        	ret = configfs_attach_group(parent_item, item, dentry);
	else
        	ret = configfs_attach_item(parent_item, item, dentry);
 
	spin_lock(&configfs_dirent_lock);
	sd->s_type &= ~CONFIGFS_USET_IN_MKDIR;
+	if (!ret)
+		configfs_clear_mkdir_flag(dentry);
	spin_unlock(&configfs_dirent_lock);

Right?

> For issue 2/ (detach_item() called without locking the detached item's inode),
> locking the inode before calling detach_item() (as is done from
> configfs_rmdir()), plus a solution for 1/ should be sufficient.

	Make sure you lock/unlock in the right place (mirror the
teardown path).

Joel

-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
