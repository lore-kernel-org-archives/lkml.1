Return-Path: <linux-kernel-owner+w=401wt.eu-S937002AbYEBW0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937002AbYEBW0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbYEBW03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:26:29 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52732 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbYEBW02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:26:28 -0400
Date: Fri, 2 May 2008 18:26:24 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, willy@debian.org,
       uclinux-dist-devel@blackfin.uclinux.org, richterd@citi.umich.edu
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-ID: <20080502222624.GR21918@fieldses.org>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com> <20080429135454.efebec8f.akpm@linux-foundation.org> <20080429222141.GD14976@parisc-linux.org> <20080501063339.GU5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501063339.GU5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 07:33:39AM +0100, Al Viro wrote:
> On Tue, Apr 29, 2008 at 04:21:42PM -0600, Matthew Wilcox wrote:
> > On Tue, Apr 29, 2008 at 01:54:54PM -0700, Andrew Morton wrote:
> > > I guess we should make the generic_setlease() heuristic smarter.
> > > 
> > > Of course the _reason_ for that heuristic is uncommented and lost in time. 
> > > And one wonders what locking prevents it from being totally racy, and if
> > > "none", what happens when the race hits.  Sigh.
> > 
> > It's hardly "lost in time" when you can ask the original author.
> > 
> > If there are multiple processes with this file open, you can't place a
> > lease on it.
> 
> ... except that it has nofsckingthing in common with the checks in
> question.  Number of processes having a file open has has nothing to
> do dentry or inode refcounts; indeed, if you have opened file once
> it'd have only one struct file.  Moreover, e.g. stat(2) on its name
> will bump dentry refcount just fine.  Moreover, if you have two threads
> with common descriptor table, not even *file* refcount will help you.

Your point about unclear requirements is taken, but I doubt anyone needs
exclusion between leases and threads that share the file descriptor on
which the lease was taken.

--b.

> BTW, ->fl_owner in those suckers is fairly useless - open files, take
> leases, fork, have parent exit.  Voila - you've got a bunch of file_lock
> with ->fl_owner pointing to freed files_struct.  Fortunately it's never
> going to be dereferenced, but results of comparisons are unreliable as
> hell.
