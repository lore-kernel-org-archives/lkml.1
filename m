Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZA1EQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZA1EQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZA1EPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:15:51 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:35582 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZA1EPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:15:50 -0500
Date: Tue, 27 Jan 2009 20:13:53 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: [PATCH 2/2] configfs: Rework configfs_depend_item() locking
	and make lockdep happy
Message-ID: <20090128041353.GF7244@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <20081218111536.GR19128@hawkmoon.kerlabs.com> <1229623218-8056-3-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229623218-8056-3-git-send-email-louis.rilling@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.497FDBD3.00B8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 07:00:18PM +0100, Louis Rilling wrote:
> configfs_depend_item() recursively locks all inodes mutex from configfs root to
> the target item, which makes lockdep unhappy. The purpose of this recursive
> locking is to ensure that the item tree can be safely parsed and that the target
> item, if found, is not about to leave.
> 
> This patch reworks configfs_depend_item() locking using configfs_dirent_lock.
> Since configfs_dirent_lock protects all changes to the configfs_dirent tree, and
> protects tagging of items to be removed, this lock can be used instead of the
> inodes mutex lock chain.
> This needs that the check for dependents be done atomically with
> CONFIGFS_USET_DROPPING tagging.
> 
> Now lockdep looks happy with configfs.

	This looks almost, but not quite right.
	In the create path, we do configfs_new_dirent() before we set
sd->s_type.  But configfs_new_dirent() attaches sd->s_sibling.  So, in
aonther thread, configfs_depend_prep() can traverse this s_sibling
without CONFIGFS_USET_CREATING being set.  This turns out to be safe
because CONFIGFS_DIR is also not set - but boy I'd like a comment about
that.
	What if we're in mkdir(2) in one thread and another thread is  
trying to pin the parent directory?  That is, we are inside
configfs_mkdir(parent, new_dentry, mode).  The other thread is doing
configfs_depend_item(subsys, parent).  With this patch, the other thread
will not take parent->i_mutex.  It will happily determine that
parent is part of the tree and bump its s_dependent with no locking.  Is
this OK?
	If it is - isn't this patch good without any other reason?  That
is, aside from the issues of lockdep, isn't it better for
configfs_depend_item() to never have to worry about the VFS locks other
than the configfs root?

Joel


-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
