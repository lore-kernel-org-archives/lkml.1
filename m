Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbYEAGeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbYEAGeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 02:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYEAGdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 02:33:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43685 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbYEAGdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 02:33:51 -0400
Date: Thu, 1 May 2008 07:33:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       willy@debian.org, uclinux-dist-devel@blackfin.uclinux.org,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-ID: <20080501063339.GU5882@ZenIV.linux.org.uk>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com> <20080429135454.efebec8f.akpm@linux-foundation.org> <20080429222141.GD14976@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429222141.GD14976@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 04:21:42PM -0600, Matthew Wilcox wrote:
> On Tue, Apr 29, 2008 at 01:54:54PM -0700, Andrew Morton wrote:
> > I guess we should make the generic_setlease() heuristic smarter.
> > 
> > Of course the _reason_ for that heuristic is uncommented and lost in time. 
> > And one wonders what locking prevents it from being totally racy, and if
> > "none", what happens when the race hits.  Sigh.
> 
> It's hardly "lost in time" when you can ask the original author.
> 
> If there are multiple processes with this file open, you can't place a
> lease on it.

... except that it has nofsckingthing in common with the checks in
question.  Number of processes having a file open has has nothing to
do dentry or inode refcounts; indeed, if you have opened file once
it'd have only one struct file.  Moreover, e.g. stat(2) on its name
will bump dentry refcount just fine.  Moreover, if you have two threads
with common descriptor table, not even *file* refcount will help you.

BTW, ->fl_owner in those suckers is fairly useless - open files, take
leases, fork, have parent exit.  Voila - you've got a bunch of file_lock
with ->fl_owner pointing to freed files_struct.  Fortunately it's never
going to be dereferenced, but results of comparisons are unreliable as
hell.
