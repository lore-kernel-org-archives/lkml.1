Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbYJGVU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbYJGVU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbYJGVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:19:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35687 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861AbYJGVTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:19:48 -0400
Subject: Re: [PATCH 1/3] sysfs:  Remove lock ordering violation in
	sysfs_chmod_file.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <m11vys7k92.fsf_-_@frodo.ebiederm.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	 <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	 <20081003101331.GH28946@ZenIV.linux.org.uk>
	 <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	 <m163o47kc5.fsf_-_@frodo.ebiederm.org>
	 <m11vys7k92.fsf_-_@frodo.ebiederm.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 14:19:41 -0700
Message-Id: <1223414381.31401.15.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 03:49 -0700, Eric W. Biederman wrote:
> It is a wee bit subtle but sysfs_get_dentry grabs inode->i_mutex.
> of potentially all of the parents of sd.  So I can not hold
> the inode mutex of the directory while it is called.

Hi Eric,

This patch looks good to me.  In my quest to parse exactly what was
going on, I rewrote a description of the patch.  Could you look over
this and see if I'm on target?

--

Before this patch, inode->i_mutex is held in order to keep the inode's
mode and ctime from changing out underneath us.  If we didn't do this,
you could potentially get garbage when reading them out of the old
inode.  We calculated these new permissions once since it is redundant
to do it several times.

We also need to perform a sysfs_get_dentry() operation on the
sysfs_dirent in order to find all the dentries on each sb.  This needs
to be performed once for each sb in which the inode appears.  "[B]ut
sysfs_get_dentry grabs inode->i_mutex. of potentially all of the parents
of sd.  So I can not hold the inode mutex of the directory while it is
called."

This patch drops the inode->i_mutex over the entire "for each
sysfs_dirent" loop.  It, instead, reacquires and drops it each time we
need to calculate the new mode/ctime for the target dentries.  It does
this away from the sysfs_get_dentry() call now.


-- Dave

