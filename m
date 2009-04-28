Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbZD1O3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbZD1O3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbZD1O3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:29:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55474 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZD1O3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:29:40 -0400
Subject: Re: [PATCH 12/12] inotify: reimplement inotify using fsnotify
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org, akpm@linux-foundation.org
In-Reply-To: <20090428095916.GA14452@infradead.org>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
	 <20090427215406.14161.88864.stgit@paris.rdu.redhat.com>
	 <20090428095916.GA14452@infradead.org>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 10:28:01 -0400
Message-Id: <1240928881.3484.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 05:59 -0400, Christoph Hellwig wrote:
> Btw, one thing I noticed is that this adds tons of code despite making
> dnotify and inotify use command infrastructure.  Do you already add
> features not actually used by inotify and dnotify?

No new unused features.

inotify.c (933 lines) and some other inotify code can be considered dead
when the next series converts audit and will then be marked for removal,
so that would make the stats look a bit better.

The infrastructure code duplicates everything dnotify did and everything
inotify did.  So now they both have to handle each other's proclivities.
It also means things like dnotify get the benefits of the dentry flag
inotify used.  That plus the finer grained event type checking before
locking should actually make this a performance win.

If you see something that isn't needed let me know.  I think I succeeded
in separating all of the infrastructure stuff that was originally
written for fanotify and some of those vestiges into later unsent
patches, "there's history in them-thar patches."

 MAINTAINERS                          |    4 
 fs/inode.c                           |   10 
 fs/notify/Kconfig                    |   13 
 fs/notify/Makefile                   |    4 
 fs/notify/dnotify/Kconfig            |    1 
 fs/notify/dnotify/dnotify.c          |  470 +++++++++++++++----
 fs/notify/fsnotify.c                 |  196 ++++++++
 fs/notify/fsnotify.h                 |   34 +
 fs/notify/group.c                    |  256 ++++++++++
 fs/notify/inode_mark.c               |  425 +++++++++++++++++
 fs/notify/inotify/Kconfig            |   20 
 fs/notify/inotify/Makefile           |    2 
 fs/notify/inotify/inotify.c          |   20 
 fs/notify/inotify/inotify.h          |   21 
 fs/notify/inotify/inotify_fsnotify.c |  147 ++++++
 fs/notify/inotify/inotify_user.c     |  829 ++++++++++++++++-------------------
 fs/notify/notification.c             |  424 +++++++++++++++++
 include/linux/dcache.h               |    3 
 include/linux/dnotify.h              |   29 -
 include/linux/fs.h                   |   10 
 include/linux/fsnotify.h             |  302 +++++++-----
 include/linux/fsnotify_backend.h     |  404 ++++++++++++++++-
 include/linux/mutex.h                |   23 
 init/Kconfig                         |    3 
 24 files changed, 2915 insertions(+), 735 deletions(-)


