Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZDZLq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZDZLq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZDZLqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:46:16 -0400
Received: from thunk.org ([69.25.196.29]:36918 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZDZLqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:46:15 -0400
Date: Sun, 26 Apr 2009 07:46:08 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 3/5] ext4: ext4_mark_recovery_complete() doesn't need
	to use lock_super
Message-ID: <20090426114608.GC10248@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <1240717765-16572-3-git-send-email-tytso@mit.edu> <1240717765-16572-4-git-send-email-tytso@mit.edu> <20090426070713.GA17022@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426070713.GA17022@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 03:07:14AM -0400, Christoph Hellwig wrote:
> On Sat, Apr 25, 2009 at 11:49:23PM -0400, Theodore Ts'o wrote:
> > The function ext4_mark_recovery_complete() is called from two call
> > paths: either (a) while mounting the filesystem, in which case there's
> > no danger of any other CPU calling write_super() until the mount is
> > completed, and (b) while remounting the filesystem read-write, in
> > which case the fs core has already locked the superblock, and in any
> > case write_super() wouldn't be called until the filesystem is
> > successfully changed from being mounted read-only to read-write.
> 
> Currently ext4_remount releases/reqacquires lock_super around
> ext4_mark_recovery_complete, and unfortunately currently ->write_super
> can be called on a r/o filesystem (that's why we have the MS_RDONLY
> checks in all instance, I plan to clean that mess up).

That's true, but the patch also takes out the release/reacquire in in
ext4_remount (which was particularly ugly, belch).  So even if
write_super gets called on an r/o filesystem (why?!?), we should be
safe because remount will hold lock_super() throughout the entire
remount operation.

We could delay this cleanup until you clean the mess with write_super,
but I don't think it would be harmful in removing the
lock_super()/unlock_super() pair in ext4_mark_recovery_complete(), and
the unlock_super()/lock_super() pair in ext4_remount before then.  Am
I missing something?

						- Ted
